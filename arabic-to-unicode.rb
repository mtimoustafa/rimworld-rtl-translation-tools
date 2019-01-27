#! /usr/bin/env ruby
require 'nokogiri'

### Methods
def parse_directory(directory_path)
  Dir["#{directory_path.chomp('/')}/**/*.xml"].each { |file_path| parse_file(file_path) }
end

def parse_file(file_path)
  return puts "[WARN] #{file_path} is not an XML file; skipping." unless file_path.match(/\.xml$/)

  doc = File.open(file_path) { |file| Nokogiri::XML(file) }

  # Valid translation files have specific root nodes
  return puts "[WARN] #{file_path} contains no expected nodes; skipping." if doc.xpath('//LanguageInfo', '//LanguageData').length <= 0

  # Search all leaf nodes since that's where all the translation strings are
  doc.xpath('//*[not(*)]').each do |node|
    node = convert_to_unicode(node)
  end

  File.write(file_path, doc.to_xml)
  puts "[INFO] #{file_path} parsed and strings reversed!"
end

def convert_to_unicode(node)
  if node.content.match(/(\p{Arabic})|(\p{Hebrew})/) then
    words = node.content.split
    words = words.map { |word|
      word.chars.each_with_index.map { |letter, idx|
        letter = convert_letter(letter, (idx > 0 ? words[idx - 1] : nil), (idx < words.length - 1 ? words[idx + 1] : nil))
      }.join
    }
    node.content = words.join(' ')
    return node
  end
end

def convert_letter(letter, prev_letter, next_letter)
  letter_code = contextual_connecting_letter(letter, prev_letter, next_letter) if is_connecting_letter?(letter)
  letter_code = contextual_non_connecting_letter(letter, prev_letter, next_letter) if is_non_connecting_letter?(letter)

  if letter_code.nil?
    puts "[ERROR] Couldn't convert letter: #{letter.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join}"
    return letter
  end
  return letter_code
end

def is_connecting_letter?(letter)
  return 'بتثجحخسشصضطظعغفقكلمنهي'.include?(letter)
end

def is_non_connecting_letter?(letter)
  return 'اأإﺁدذرزوةى'.include?(letter)
end

def contextual_connecting_letter(letter, prev_letter, next_letter)
  return letter
end

def contextual_non_connecting_letter(letter, prev_letter, next_letter)
  return letter
end
###

### Run script
if ARGV.length != 1 then
  puts "Usage:"\
       "xml-string-reverser [file-path|directory-path]"
  exit
end

path = ARGV[0]

if File.directory?(path) then
  parse_directory(path)
elsif File.file?(path) then
  parse_file(path)
else
  puts "[EROR] Unknown file or directory path: #{path}"
  exit
end

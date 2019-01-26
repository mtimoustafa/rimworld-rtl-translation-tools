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
    node.content = node.content.reverse if node.content.match(/(\p{Arabic})|(\p{Hebrew})/)
  end

  File.write(file_path, doc.to_xml)
  puts "[INFO] #{file_path} parsed and strings reversed!"
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

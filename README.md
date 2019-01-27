# rimworld-rtl-translation-tools
A set of tools for processing Rimworld translation directories for right-to-left (RTL) languages.

Rimworld is built on the Unity engine, which has poor support for RTL text. Because of that, the translation directories have to be put through some transformations in order for the text to appear correctly.

Current RTL translation projects:
* [Ludeon/Rimworld-ar](https://github.com/Ludeon/RimWorld-ar)
* [Ludeon/Rimworld-Hebrew](https://github.com/Ludeon/RimWorld-Hebrew)

## Installation
1. Install [Ruby](https://www.ruby-lang.org/en/downloads/).
2. Install [Nokogiri](https://nokogiri.org/#installation).
3. Run the script using `<path_to_script>/xml-string-reverser.rb`! Accepts a file or directory path as an argument.

## reverse_rtl_text.rb
Takes an XML file (or a directory of files) and reverses all Arabic and Hebrew strings in the leaf nodes.

Unity's text renderer does not set the text direction properly, so in order to show the characters in the correct order, we just reverse all the words in the translation files.

This fix is enough for Hebrew to display correctly in the game.

## contextualize_arabic_letters.rb
Arabic is a cursive language by default, and its letters connect together according to certain rules. However, Unity's text renderer doesn't handle that correctly, either, and doesn't display the correct context (e.g. a letter should end with a stem to connect to the next letter, _etc._).

This script converts all Arabic letters in a file or a directory of files and contextualizes them using the Unicode tables so they connect correctly.
Combined with `reverse_rtl_text.rb`, this causes Arabic to display correctly in-game.

*`reverse_rtl_text.rb` must be run on the translation files _first_ before running `contextualize_arabic_letters.rb`*

## build_arabic.sh
Makes a new copy of an Arabic translation, then runs the required scripts to make a corrected translation directory for use in-game.

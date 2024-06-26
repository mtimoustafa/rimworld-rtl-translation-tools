#!/bin/sh

set -e

if [ $# -eq 0 ] || [ $# -gt 2 ]; then
  printf "Usage: build_arabic.sh <translation_directory_path> [<destination_path>]\n"
  exit 1
fi

trans_dir=$1
dest_dir=$2

if ! [ -d $trans_dir ]; then
  printf "Invalid translation directory path.\n"
  exit 1
fi
if [ $# -eq 1 ]; then
  printf "No destination path provided; creating corrected translation directory in current directory.\n"
  dest_dir="./Arabic"
fi

if [ -d $dest_dir ]; then
  printf "Destination directory $dest_dir already exists. Overwrite it?(Y/N) "
  read in
  if [ "$in" != "Y" ] && [ "$in" != "y" ] && [ "$in" != "YES" ] && [ "$in" != "yes" ]; then
    exit 0
  fi
fi

printf "Copying over Arabic translation..."
if [ -d $dest_dir ]; then rm -rf $dest_dir; fi
cp -r $trans_dir $dest_dir
printf "done!\n"

printf "\nRunning reverse_rtl_text.rb...\n"
bundle exec ruby ./reverse_rtl_text.rb $dest_dir
printf "done!\n"

printf "\nRunning contextualize_arabic_letters.rb...\n"
bundle exec ruby ./contextualize_arabic_letters.rb $dest_dir
printf "done!\n"

printf "Correction complete."

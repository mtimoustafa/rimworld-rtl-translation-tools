#!/bin/sh
echo 'Copying over Arabic translation...'
rm -rf /d/Rimworld-ar/build
mkdir /d/Rimworld-ar/build
cp -r /d/Rimworld-ar/Arabic /d/Rimworld-ar/build/Arabic
echo 'done!'

echo 'Running reverse_rtl_text.rb...'
rimworld-rtl-translation-tools/reverse_rtl_text.rb /d/Rimworld-ar/build/Arabic
echo 'Running contextualize_arabic_letters.rb...'
rimworld-rtl-translation-tools/contextualize_arabic_letters.rb /d/Rimworld-ar/build/Arabic

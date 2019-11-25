
echo "Generating strings"
./genstrings.swift ../../../Keanu | awk '{print "/* No comment */\n"  $0 "\n"}' > /tmp/Localizable.strings
./genstrings.swift .. | awk '{print "/* No comment */\n"  $0 "\n"}' > /tmp/Localizable2.strings

echo "Running stringtool"
./stringtool.sh "../Zom 2/Base.lproj/Localizable.strings" /tmp/Localizable.strings -union /tmp/Localizable2.strings -union > /tmp/Localizable.strings.utf8

echo "Copying back"
iconv -f utf-8 -t utf-16 /tmp/Localizable.strings.utf8 > "../Zom 2/Base.lproj/Localizable.strings"


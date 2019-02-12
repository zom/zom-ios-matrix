#find ../ -not -path "*Submodules*" -and -not -path "*Pods*" -and -not -path "*DerivedData*" -and -not -path "*Carthage*"  -and \( -name "*.swift" -or -name "*.h" -or -name "*.m" \) -print0 | xargs -0 genstrings -o /tmp/

my_dir="$(dirname "$0")"

echo "Generating strings"
./genstrings.swift ../../../Keanu | awk '{print "/* No comment */\n"  $0 "\n"}' | sed 's/\r$//' > /tmp/Localizable.strings

echo "Strings file:"
cat /tmp/Localizable.strings

#. "$my_dir/stringtool.sh" "../Zom 2/Base.lproj/Localizable.strings" /tmp/Localizable.strings -union ../../ChatSecure/OTRResources/Localizations/Base.lproj/Localizable.strings -union > /tmp/Localizable.strings.utf8

echo "Running stringtool"
./stringtool.sh "../Zom 2/Base.lproj/Localizable.strings" /tmp/Localizable.strings -union > /tmp/Localizable.strings.utf8

echo "Copying back"
iconv -f utf-8 -t utf-16 /tmp/Localizable.strings.utf8 > "../Zom 2/Base.lproj/Localizable.strings"



# Assuming you have Zom-Android and Keanu-Android installed in right locations, this is what you want to run: #
# Note! First use ./genstrings.sh to gather all strings from code ".localized()" calls!!!
#

# For base Keanu translations
./translate.sh -d ../Zom\ 2 -p ../Pods/Pods.xcodeproj -l bo -l zh-Hans -l zh-Hant -i ../../../Keanu-Android/app/src/main/res/values/strings.xml -i ../../../Keanu-Android/keanuCore/src/main/res/values/strings.xml -i ../../../Zom-Android/app/src/main/res/values/zomstrings.xml -i ../../../Zom-Android/app/src/main/res/values/strings.xml

# For Zom translations
./translate.sh -d ../Zom\ 2 -p ../Zom\ 2.xcodeproj -l bo -l zh-Hans -l zh-Hant -i ../../../Keanu-Android/app/src/main/res/values/strings.xml -i ../../../Keanu-Android/keanuCore/src/main/res/values/strings.xml -i ../../../Zom-Android/app/src/main/res/values/zomstrings.xml -i ../../../Zom-Android/app/src/main/res/values/strings.xml

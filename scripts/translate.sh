#!/bin/bash

#######
# A Script to use Android strings in iOS projects
# Created 2017 by N-Pex
#
# The process is the following:
#
# - Find out what languages we have (by enumerating all *.lproj directories)
# - Parse all iOS base file(s) (.strings and .storyboard) to get iOS id <-> English string mapping
# - Parse Android base file(s) to get Android id <-> English string mapping
# - For each language:
#     parse iOS file
#     parse corresponding Android file(s)
#     use above mapping to update strings in the language .strings files
#
#
project_dir=""
project_file=""
android_resource_base=""
android_input_files=()
languages=()
languages_index=0

function addAndroidInputFile {
    local count=0
    while [ "x${android_input_files[count]}" != "x" ]
    do
	((count++))
    done
    android_input_files[count]="$1"
}

function showUsageAndExit {
    echo "Usage: $0 -d <project_dir> -p <project_file> [-l <ios_language_code>] -i <android_strings_file> [-i <android_strings_file>...]";
    echo
    echo "example: $0 -d ../Zom -p ../Zom.xcodeproj -l bo -l zh-Hant -i ../../../Zom-Android/app/src/main/res/values/zomstrings.xml -i ../../../Zom-Android/app/src/main/res/values/strings.xml"
    echo
    exit
}


# Parse indata
#
while [[ $# > 0 ]]
do
    key="$1"
    case $key in
	-h|--help)
	    showUsageAndExit
	    ;;
	-d|--dir)
	    project_dir="$2"
	    shift
	    ;;
	-p|--project)
	    project_file="$2"
	    shift # past argument
	    ;;
	-l|--lang)
	    languages[languages_index]="${2}"
	    ((languages_index++))
	    shift # past argument
	    ;;
	-i|--input)
	    addAndroidInputFile "$2"
	    shift # past argument
	    ;;
    esac
    shift # past argument or value
done

echo
echo "Checking indata..."
echo

# Check that project dir exists
if [ ! -d "$project_dir" ]; then
    echo "project dir not found!"
    echo
    showUsageAndExit
fi
echo "Project dir $project_dir found"

# Check that project file exists
if [ ! -d "$project_file" ]; then
    echo "project file not found!"
    echo
    showUsageAndExit
fi
echo "Project file $project_file found"

# Check Android input files
android_count=0
while [ "x${android_input_files[android_count]}" != "x" ]
do
    thisfile="${android_input_files[android_count]}"
    if [ ! -f "$thisfile" ]; then
	echo "Input file $thisfile not found!"
	echo
	showUsageAndExit
    fi
    echo "Android input file $thisfile found"
    ((android_count++))
done

echo
echo "Indata ok"
echo

# Import string util functions
# 
my_dir="$(dirname "$0")"
. "$my_dir/stringtool.sh" -library


# Helper to translate from iOS language codes into corresponding Android language codes
ios_language_codes=("Base" "en" "da-DK" "fa-IR" "nb-NO" "nl-NL" "pt-BR" "pt-PT" "ro-RO" "sl-SI" "zh-Hans-CN" "zh-Hant-TW")
android_language_codes=("" "" "-da" "-fa" "-nb" "-nl" "-pt-rBR" "-pt" "-ro" "-sl-rSI" "-zh-rCN" "-zh-rTW")

function getAndroidLanguageCodeFromiOSLanguageCode {
    local id="$1"
    local count=0
    while [ "x${ios_language_codes[count]}" != "x" ]
    do
	thisid="${ios_language_codes[count]}"
	if [ "$thisid" == "$id" ]; then
	    echo "${android_language_codes[count]}"
	    return 1
	fi
	((count++))
    done
    echo "-$id"
}

function getiOSLanguageCodeFromAndroidLanguageCode {
    local id="$1"
    local count=0
    while [ "x${android_language_codes[count]}" != "x" ]
    do
	thisid="${android_language_codes[count]}"
	if [ "$thisid" == "$id" ]; then
	    echo "${ios_language_codes[count]}"
	    return 1
	fi
	((count++))
    done
    echo "$id"
}

# Get languages
#
#
ios_files=()
base_dir_ios="$project_dir/"
echo "Base dir is $base_dir_ios"

if [ "$languages_index" == "0" ]; then
    echo "No languages given, use existing iOS res directories"
    while read languageDir; do
	language="${languageDir%%.lproj}" # strip .lproj
	language="${language##*/}" # strip everything to the last path character.lproj
	if [[ "$language" == "Base" ]]
	then
	    continue
	fi
	languages[languages_index]="${language}"
	((languages_index++))
    done <<<"$(find "$project_dir" -depth 1 -name "*.lproj" -print)"
    
    # Make sure corresponding Android strings file exists
    #
    #
    languages_index=0
    while [ "x${languages[languages_index]}" != "x" ]
    do
	language="${languages[languages_index]}"
	language=$(getAndroidLanguageCodeFromiOSLanguageCode "$language")
	((languages_index++))
	android_path="${2/values/values$language}"
	if [ ! -f $android_path ]; then
	    echo "Warning: no matching strings file found at: $android_path!"
	fi
    done
else
    # Languages given. Make sure we have directories for those and copy over base files as needed
    echo "Languages given:"
fi

languages_index=0
while [ "x${languages[languages_index]}" != "x" ]
do
    language="${languages[languages_index]}"
    ((languages_index++))
    echo "Language: $language"
done

#exit

base_keys=()
base_values=()

android_keys=()
android_values=()

function addBaseMapping {
    local count=0
    if [ "$1" != "" ] && [ "$2" != "" ]; then
	while [ "x${base_keys[count]}" != "x" ] && [ "x${base_keys[count]}" != "x$1" ]
	do
	    ((count++))
	done
	if [ "x${base_keys[count]}" == "x$1" ]; then
	    #>&2 echo "Update base mapping for ${base_keys[count]} to $2"
	    base_values[count]="$2"
	else
	    #>&2 echo "Set base mapping $1 -> $2"
	    base_keys[count]="$1"
	    base_values[count]="$2"
	fi
    else
	>&2 echo "Called addBaseMapping with empty key or value, ignoring"
    fi
}

function addAndroidMapping {
    local count=0
    while [ "x${android_keys[count]}" != "x" ]
    do
	((count++))
    done
    android_keys[count]="$1"
    android_values[count]="$2"
}

function findAndroidTranslation {
    local id="$1"
    local count=0
    #>&2 echo "FIND TRANSLATION FOR ID ##$id##"
    while [ "x${android_keys[count]}" != "x" ]
    do
	thisid="${android_keys[count]}"
	if [ "$thisid" == "$id" ]; then
	    echo "${android_values[count]}"
	    return
	fi
	((count++))
    done
}

function findBaseKey {
    local id="$1"
    local count=0
    while [ "x${base_values[count]}" != "x" ]
    do
	this="${base_values[count]}"
	#>&2 echo "FIND TRANSLATION FOR ID ##$id## $this?"
	if [ "$this" == "$id" ]; then
	    echo "${base_keys[count]}"
	    return
	fi
	((count++))
    done
}

function parseBaseAndroidStringsFile {
    local filePath=$1
    while read -r line ; do
	key=$(echo $line | cut -d \  -f 1)
	val=$(echo $line | cut -d \  -f 2-)
        # Replace slash ' with '	
	replace=\'
        val="${val//\\\'/$replace}"
        # We need to handle different formats for ios and android. So translate %s to %
        val="${val/\%s/%}"
	# echo "Add android mapping $key <--> $val"
	addBaseMapping "$key" "$val"
    done < <(awk -F'name="|">|</' '{ if (NF == 4) print $2,$3}' "$filePath")
}

function parseAndroidStringsFile {
    local filePath=$1
    while read -r line ; do
	key=$(echo $line | cut -d \  -f 1)
	val=$(echo $line | cut -d \  -f 2-)
        # Replace slash ' with '	
	replace=\'
        val="${val//\\\'/$replace}"
        # We need to handle different formats for ios and android. So translate %s to %
        val="${val/\%s/%}"
	# echo "Add android mapping $key <--> $val"
	addAndroidMapping "$key" "$val"
    done < <(awk -F'name="|">|</' '{ if (NF == 4) print $2,$3}' "$filePath")
}

# Extract strings from base android strings file, split into key-value pairs.
#
#
android_count=0
while [ "x${android_input_files[android_count]}" != "x" ]
do
    thisfile="${android_input_files[android_count]}"
    echo "Parse base: $thisfile"
    parseBaseAndroidStringsFile "$thisfile"
    ((android_count++))
done


# Match translated strings iOS<->Android. If they match, store the id mapping between them.
#
#
#i_translation=0
#while [ "x${base_translations[i_translation]}" != "x" ]
#do
#    term="${base_translations[i_translation]}"

#    id=""
#    count=0
#    while [ "x${android_values[count]}" != "x" ] 
#    do
#	if [ "${android_values[count]}" == "$term" ]; then
#	    id="${android_keys[count]}"
#	fi
#	((count++))
#    done
    
#    if [ "$id" == "" ]; then
#	#echo "Could not find Android string id for $term"
#	#exit 1
#	android_base_keys[i_translation]=""
 #   else
#	#echo "Lookup for $term is --$id--"
#	android_base_keys[i_translation]="$id"
 #   fi
 #   ((i_translation++))
#done

# Go through the iOS strings files, get the corresponding Android strings file and use the id mapping built in previous step to update the strings.
#
#
languages_index=0
while [ "x${languages[languages_index]}" != "x" ]
do
    language="${languages[languages_index]}"
    echo "Processing language: $language"
    ((languages_index++))
    language_suffix=$(getAndroidLanguageCodeFromiOSLanguageCode "$language")
    
    android_keys=()
    android_values=()
    android_count=0
    while [ "x${android_input_files[android_count]}" != "x" ]
    do
	thisfile="${android_input_files[android_count]}"
	android_file="${thisfile/values/values$language_suffix}"
	if [ -f $android_file ]; then
	    parseAndroidStringsFile "$android_file"
	fi
	((android_count++))
    done

    # Export XLIFF
    rm -rf "/tmp/trans"
    xcodebuild -exportLocalizations -localizationPath /tmp/trans -project "$project_file" -exportLanguage $language

    # Translate to format "id###source###optional_target" lines
    cat "/tmp/trans/${language}.xcloc/Localized Contents/${language}.xliff" | tr '\n' '\f' | perl -0777 -ne 'print "$1###$3###$5\n" while /<trans-unit.*?id="(.*?)".*?>(.*?)<source>(.*?)<\/source>[^<]*(<target>(.*?)<\/target>)?/smg' > /tmp/trans/parsed_xliff.txt

    while read -r line; do
	#echo "Line $line"
	delimiter="###"

	# Split by delimiter, see https://www.tutorialkart.com/bash-shell-scripting/bash-split-string/
	s=$line$delimiter
	components=();
	while [[ $s ]]; do
	    components+=( "${s%%"$delimiter"*}" );
	    s=${s#*"$delimiter"};
	done;

	id="${components[0]}"
	source="${components[1]}"

	# Ignore bundle names
	if [[ $id == *"CFBundle"* ]]; then
	    continue
	fi
	
        # Get android id of key
	android_key=$(findBaseKey "$source")
	#>&2 echo "Android key is $android_key"
	if [ "$android_key" != "" ]; then
	    translation=$(findAndroidTranslation "$android_key")
	    if [ ! "$translation" == "" ]; then
		>&2 echo "Translation for $android_key is $translation"

		perl -i -0pe "s/<trans-unit id=\"$id\".*?>(.*?)<source>(.*?)<\/source>[^<]*(<target>(.*?)<\/target>)?[^<]*/<trans-unit id=\"$id\" xml:space=\"preserve\">\1<source>\2<\/source><target>$translation<\/target>/smg" "/tmp/trans/${language}.xcloc/Localized Contents/${language}.xliff"
	#	ios_values[count]="$translation"
		#else
		#    >&2 echo "Language $language: missing translation for id $android_key."
	    fi
	    #else
	    #echo "Failed to find Android key for: $key (value is ${ios_values[count]})"
	fi


	
    done < /tmp/trans/parsed_xliff.txt

    # Import back!
    xcodebuild -importLocalizations -localizationPath "/tmp/trans/${languages}.xcloc" -project "$project_file"
done


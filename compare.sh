#!/bin/bash

urldecode(){
	echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x/g;')"
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]
then
	printf "Usage: `basename %s` {first directory} {second directory} [-d]\n" $0
	printf "Compares the screenshots in the first directory to those in "
	printf "the second.\n"
	printf "-d flag will delete the original dir images after comparison.\n"
	exit 1
fi

first="$1"
second="$2"
delete="$3"

if [ ! -d "$first" ]; then
	printf "'%s' does not exist\n" $first
	exit 1
fi

if [ ! -d "$second" ]; then
	printf "'%s' does not exist\n" $second
	exit 1
fi

first=$(cd -P -- "$1" && printf "%s\n" "$(pwd -P)")
second=$(cd -P -- "$2" && printf "%s\n" "$(pwd -P)")

differences=$(printf "%s/%s-vs-%s" "$(dirname -- "$first")" \
	"$(basename -- "$first")" "$(basename -- "$second")")

if [ ! -d "$differences" ]; then
	printf "Creating '%s' to store difference images\n" $differences
	mkdir $differences
fi

for filename in $first/*.png ; do
	filename=`sed "s|^$first/||" <<< $filename`

	url=`sed "s/.png$//" <<< $filename`
	url=`sed "s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" <<< $url`

	firstsize=$(identify -ping -format '%w%h' "$first/$filename")
	secondsize=$(identify -ping -format '%w%h' "$second/$filename")

	if [ "$firstsize" -eq "$secondsize" ];
	then
		compare "$first/$filename" "$second/$filename" -metric AE "$differences/$filename"  > /dev/null 2>&1

		if [ $? -eq 0 ]; then
				# printf "Removing %s\n" "$differences/$filename"
				rm "$differences/$filename"
			else
				echo "$url does not match"
		fi
	else
		convert "$first/$filename" "$second/$filename" +append "$differences/$filename"
		echo "$url is a different height"
	fi

	if [ -f "$first/$filename" ] && [ -f "$second/$filename" ] && [ "$delete" = "-d" ]
		then
			rm "$first/$filename"
			rm "$second/$filename"
	fi
done

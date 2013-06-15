#!/bin/bash

urls=$1

if [ ! -f "$urls" ]; then
	printf "'%s' does not exist. Usage: %s <file containing urls>\n" $urls $0
	exit 1
fi

while read url ;do
	response=$(curl --write-out %{http_code} --silent --output /dev/null $url)
	
	if [ $response -eq 404 ]; then
		printf "%s\n" $url
	fi
done < $urls

exit 0

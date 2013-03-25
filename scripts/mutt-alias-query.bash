#!/bin/bash

echo 'Using custom query command'

# expected format: email\tlong name\tdescription
query=$(echo -n "$1" | awk '{ printf "%s", tolower($0) }')
awk -- '
	/^[[:space:]]*$/ { next } # skip empty lines
	/^#/ { sub(/^#[[:space:]]*/, "", $0); group = $0; next } # capture text after "#" in group variable
	tolower($0) ~ /'$query'/ {
		printf "%s\t", $NF
		for (i = 3; i < NF; i += 1) printf "%s%s", (i == 3) ? "" : " ", $i
		printf "\t%s\n", group
	}
' ~/.mutt-alias | sort

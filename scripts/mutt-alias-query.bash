#!/bin/bash

echo 'Using custom query command'

# mutt expects format: email\tlong name\tdescription
query=$(echo -n "$1" | awk '{ printf "%s", tolower($0) }')
awk -- '
	/^[[:space:]]*$/ { next } # skip empty lines
	/^#/ { sub(/^#[[:space:]]*/, "", $0); group = $0; next } # capture text after "#" in group variable
	tolower($0) ~ /'$query'/ {
		long_name=""
		email=""
		for (i = 1; i <= NF; i += 1) {
			if (index($i, "@") > 0) {
				email = $i
				break
			}
			long_name = long_name (i == 1 ? "" : " ") $i
		}
		printf "%s\t%s\t%s\n", email, long_name, group
	}
' ~/.mutt-alias | sort

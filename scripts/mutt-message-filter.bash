#!/bin/bash

message=$(cat)
echo "$message"

OLDIFS="$IFS"
IFS=','
for from in $(echo "$message" | grep '^From: ' | sed -e 's/^From: //g' ); do
	# "hello world" <email@address> -> hello,world,email@address
	from=$(echo "$from" | sed -e 's/["<> ]\{1,\}/,/g' | sed -e 's/^,*//g' | sed -e 's/,*$//g')
	# Hello,world,email@address -> hello.world and email@address -> email
	name=$(echo "$from" | awk 'BEGIN{FS=",";ORS="."} {$0=tolower($0); if (NF == 1) print substr($1, 0, index($1, "@") - 1); else for (i = 1; i < NF; i += 1) print $i;}' | sed -e 's/.$//')
	# hello,world,email@address -> hello world <email@address>
	fullName=$(echo "$from" | sed -e 's/\(.*\),\(.*\)/\1 <\2>/' | sed -e 's/,/ /g')
	if [ "$(grep --count --fixed-strings -e "alias ${name}" ~/.mutt-alias)" -eq "0" ]; then
		echo "alias ${name} ${fullName}" >> ~/.mutt-alias
	fi
done;
IFS="$OLDIFS"

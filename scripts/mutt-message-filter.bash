#!/bin/bash

message=$(cat)
echo "$message"

OLDIFS="$IFS"
IFS=','
for from in $(echo "$message" | head -n 10 | grep '^From: ' | sed -e 's/^From: //g' ); do
	# "hello world" <email@address> -> hello,world,email@address
	from=$(echo "$from" | sed -e 's/["<> ]\{1,\}/,/g' | sed -e 's/^,*//g' | sed -e 's/,*$//g')
	# Hello,world,email@address -> hello.world and email@address -> email
	name=$(echo "$from" | awk 'BEGIN{FS=",";ORS="."} {$0=tolower($0); if (NF == 1) print substr($1, 0, index($1, "@") - 1); else for (i = 1; i < NF; i += 1) print $i;}' | sed -e 's/.$//')
	# alias,hello,world,email@address -> alias hello world <email@address>
	# alias,email,email@address -> alias email <email@address>
	aliasName=$(echo "alias,${name},$from" | sed -e 's/\(.*\),\(.*\)/\1 <\2>/' | sed -e 's/,/ /g')
	# ignore aliases with certain characters (do not need to escape '[')
	[ "$(echo "$aliasName" | grep --count -e '[:/[]')" -ne "0" ] && continue
	# writer alias if it does not exist
	[ "$(grep -i --count --fixed-strings -e "$aliasName" ~/.mutt-alias)" -eq "0" ] && echo "$aliasName" >> ~/.mutt-alias
done;
IFS="$OLDIFS"

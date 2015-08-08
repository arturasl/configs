#!/bin/bash -xe

sudo apt-get -y install firefox
mkdir -p ~/Tmp/firefoxaddons && cd ~/Tmp/firefoxaddons

for addon in \
	$(`# Security addons`) \
	$(`## Addblock plus`) "latest/1865/addon-1865-latest.xpi" \
	$(`## Ghostery`) "latest/9609/addon-9609-latest.xpi" \
	$(`## NoScript`) "latest/722/addon-722-latest.xpi" \
	$(`## Duckdukgo search engine`) "latest/252586/addon-252586-latest.xml" \
	$(`# Development addons`) \
	$(`## Firebug`) "latest/1843/addon-1843-latest.xpi" \
	$(`## firepicker (allows to nicelly select colors in firebug)`) "latest/15032/addon-15032-latest.xpi" \
	$(`## JSONView (format application/json documents)`) "latest/10869/addon-10869-latest.xpi" \
	$(`## Tamper Data (intercept http requests)`) "latest/966/addon-966-latest.xpi" \
	$(`## MeasureIt`) "latest/539/addon-539-latest.xpi" \
	$(`# Dictionaries`) \
	$(`## Dictionary popup`) "latest/406852/addon-406852-latest.xpi" \
	$(`## Lithuanian dictionary`) "latest/3716/addon-3716-latest.xpi" \
	$(`## LanguageToolFx – Style and Grammar Checker`) "latest/407110/addon-407110-latest.xpi" \
	$(`# Usability`) \
	$(`## Vimperator`) "file/298890/vimperator-3.9-fx.xpi" \
	$(`## iMacros`) "latest/3863/addon-3863-latest.xpi" \
	$(`## Greasemonkey`) "latest/748/addon-748-latest.xpi" \
	$(`# Other`) \
	$(`## Update Scanner`) "latest/3362/addon-3362-latest.xpi" \
	$(`## Download Helper`) "latest/3006/addon-3006-latest.xpi" \
; do
	wget "https://addons.mozilla.org/firefox/downloads/${addon}"
done

firefox *.xpi

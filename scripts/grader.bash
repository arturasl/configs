#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2013 ArtÅ«ras Lapinskas
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# FOR MAC USERS:
#  * install gnu-time: brew install gnu-time


onExit () {
	[ -n "$TMP_DIR" ] && rm -rf "$TMP_DIR"
}
trap onExit EXIT

# COLORS
COLOR_TEXTGREEN=$'\e[0;32m'
COLOR_TEXTRESET=$'\e[0m'
COLOR_TEXTRED=$'\e[0;31m'
COLOR_TEXTBLUE=$'\e[0;34m'

# CONSTANTS
TIME_EXECUTABLE='time'
which gtime &>/dev/null && TIME_EXECUTABLE='gtime'
TMP_DIR="/tmp/${0}" && mkdir -p "$TMP_DIR"

# ARGUMENTS
argTestsFile='tests.in'
argTestsDirectory='tests'
argTestsToRun='*' # possible values '*', '{2,3,8}', 3 (will be used in bash expansion)
argExecutable=''
argCWD='.'
argTLE='10'
argMLE='1024'

while [ "$#" -ne '0' ]; do
	case "$1" in
		--help)
echo "$0 [parameters]"
cat <<EOF
\`--help\`
:	shows this help information.

\`--executable\` *file name*
:	file to test (realative to current working directory). If non
	given first executable will be used.

\`--tests-file\` *file name* default \`tests.in\`
:	tests file wich will be used to create individual tests

\`--tests-directory\` *directory name* default \`tests\`
:	directory from/to which individual test files will be read/written

\`--tests-to-run\` *path expansion* default \`*\`
:	indicates which tests will be run (supports bash wildcards)

\`--cwd\` *path* default \`.\`
:	current working directory

\`--tle\` *seconds* default \`10.0\`
:	sets maximum number of seconds application is able to run

\`--mle\` *kilobytes* default \`1024.0\`
:	sets maximum number of memory application is allowed to use
	in kylobytes
EOF
			exit 0
			;;
		--executable)
			argExecutable="$2" && shift 2
			;;
		--tests-file)
			argTestsFile="$2" && shift 2
			;;
		--tests-directory)
			argTestsDirectory="$2" && shift 2
			;;
		--tests-to-run)
			argTestsToRun="$2" && shift 2
			;;
		--cwd)
			argCWD="$2" && shift 2
			;;
		--tle)
			argTLE="${2}" && shift 2
			;;
		*)
			echo "Unknown parameter $1" 1>&2
			exit 1
			;;
	esac
done

cd "$argCWD"

# expand tests.in file to tests directory
if [ -f "$argTestsFile" ]; then
	echo "${COLOR_TEXTBLUE}# Recreating tests directory${COLOR_TEXTRESET}"
	# recreate tests directory
	mkdir -p "$argTestsDirectory"
	rm -rf "${argTestsDirectory}/"*.{sol,in}
	awk -- '
	function output() {
		if (inContents) print inContents > "'"$argTestsDirectory"'/"test".in"
		if (solContents) print solContents > "'"$argTestsDirectory"'/"test".sol"
		inContents = solContents = ""
	}
	{
		changed = 0
		output()
		if ($0 ~ /^# in/) { inBlock = 1; solBlock = 0; test += 1; next }
		else if ($0 ~ /^# sol/) { inBlock = 0; solBlock = 1; next }
	}
	inBlock { inContents = inContents$0 }
	solBlock { solContents = solContents$0 }
	END { output() }
' "$argTestsFile"
fi

# find executable
[ -z "$argExecutable" ] && argExecutable="$(find . -perm +0111 -type f | head -n 1)"
echo "${COLOR_TEXTBLUE}# Running ${argExecutable}${COLOR_TEXTRESET}"
[ ! -x "$argExecutable" ] && echo "${COLOR_TEXTRED}\"$argExecutable\" is not an executable file${COLOR_TEXTRESET}" 1>&2 && exit 1

# go through needed tests
outputFp="${TMP_DIR}/$(basename "$0").out"
outputTimeFp="${TMP_DIR}/$(basename "$0").time"
TLEWithEpsilon=$(echo "$argTLE" | awk '{printf("%d\n",$1 + 1.5)}')
for testFp in "${argTestsDirectory}/"$argTestsToRun'.in'; do
	[ ! -f "$testFp" ] && echo "${COLOR_TEXTRED}Could not find test files${COLOR_TEXTRESET}" 1>&2 && exit 1

	testFpBaseName="$(basename "$testFp")"
	testFpBaseName="${testFpBaseName::$((${#testFpBaseName} - 3))}"

	"$TIME_EXECUTABLE" "--format=%e %K" "--output=${outputTimeFp}" perl -e 'alarm shift; exec @ARGV' "$TLEWithEpsilon" "$argExecutable" < "$testFp" > "$outputFp"

	runningTime=$(tail -n 1 "$outputTimeFp" | cut -d' ' -f1)
	runningMemory=$(tail -n 1 "$outputTimeFp" | cut -d' ' -f2)

	echo -n "Testing ${testFpBaseName}: "
	if diff --ignore-blank-lines --ignore-all-space "${argTestsDirectory}/${testFpBaseName}.sol" "$outputFp" &>/dev/null; then
		echo -n "${COLOR_TEXTGREEN}OK${COLOR_TEXTRESET}"
	else
		echo -n "${COLOR_TEXTRED}FAIL${COLOR_TEXTRESET}"
	fi

	echo -n " ellapsed: "
	[ "$(echo "${runningTime} > ${argTLE}" | bc -l)" -eq "1" ] && echo -n "$COLOR_TEXTRED"
	echo -n "${runningTime}s${COLOR_TEXTRESET}"

	[ "$(echo "${runningMemory} > ${argMLE}" | bc -l)" -eq "1" ] && echo -n "$COLOR_TEXTRED"
	echo -n " ${runningMemory}KB${COLOR_TEXTRESET}"
	echo ''
done

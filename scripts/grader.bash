#!/bin/bash

TESTS_FILE='tests.in'
TESTS_DIRECTORY='tests'
TESTS_TO_MAKE='*' # possible values '*', '{2,3,8}', 3 (will be used in bash expansion)
TMP_DIR='/tmp'
EXECUTABLE=''
CWD='.'
TLE='10'
MLE='1024'
TIMEEXECUTABLE='time'
which gtime &>/dev/null && TIMEEXECUTABLE='gtime'

# COLORS
COLOR_TEXTGREEN='\e[0;32m'
COLOR_TEXTRESET='\e[0m'
COLOR_TEXTRED='\e[0;31m'
COLOR_TEXTBLUE='\e[0;34m'

# For mac users:
#  * install gnu-time: brew install gnu-time

# read arguments
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
			EXECUTABLE="$2" && shift 2
			;;
		--tests-file)
			TESTS_FILE="$2" && shift 2
			;;
		--tests-directory)
			TESTS_DIRECTORY="$2" && shift 2
			;;
		--tests-to-run)
			TESTS_TO_MAKE="$2" && shift 2
			;;
		--cwd)
			CWD="$2" && shift 2
			;;
		--tle)
			TLE="${2}" && shift 2
			;;
		*)
			echo "Unknown parameter $1" 1>&2
			exit 1
			;;
	esac
done

cd "$CWD"

# expand tests.in file to tests directory
if [ -f "$TESTS_FILE" ]; then
	echo -e "${COLOR_TEXTBLUE}# Recreating tests directory${COLOR_TEXTRESET}"
	# recreate tests directory
	mkdir -p "$TESTS_DIRECTORY"
	rm -rf "${TESTS_DIRECTORY}/"*.{sol,in}
	awk -- '
	function output() {
		if (inContents) print inContents > "'"$TESTS_DIRECTORY"'/"test".in"
		if (solContents) print solContents > "'"$TESTS_DIRECTORY"'/"test".sol"
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
' "$TESTS_FILE"
fi

# find executable
[ -z "$EXECUTABLE" ] && EXECUTABLE="$(find . -perm +0111 -type f | head -n 1)"
echo -e "${COLOR_TEXTBLUE}# Running ${EXECUTABLE}${COLOR_TEXTRESET}"
[ ! -x "$EXECUTABLE" ] && echo -e "${COLOR_TEXTRED}\"$EXECUTABLE\" is not an executable file${COLOR_TEXTRESET}" 1>&2 && exit 1

# go through needed tests
outputFp="${TMP_DIR}/$(basename "$0").out"
outputTimeFp="${TMP_DIR}/$(basename "$0").time"
TLEWithEpsilon=$(echo "$TLE" | awk '{printf("%d\n",$1 + 1.5)}')
for testFp in "${TESTS_DIRECTORY}/"$TESTS_TO_MAKE'.in'; do
	[ ! -f "$testFp" ] && echo -e "${COLOR_TEXTRED}Could not find test files${COLOR_TEXTRESET}" 1>&2 && exit 1

	testFpBaseName="$(basename "$testFp")"
	testFpBaseName="${testFpBaseName::$((${#testFpBaseName} - 3))}"

	"$TIMEEXECUTABLE" "--format=%e %K" "--output=${outputTimeFp}" perl -e 'alarm shift; exec @ARGV' "$TLEWithEpsilon" "$EXECUTABLE" < "$testFp" > "$outputFp"

	runningTime=$(tail -n 1 "$outputTimeFp" | cut -d' ' -f1)
	runningMemory=$(tail -n 1 "$outputTimeFp" | cut -d' ' -f2)

	echo -n -e "Testing ${testFpBaseName}: "
	if diff --ignore-blank-lines --ignore-all-space "${TESTS_DIRECTORY}/${testFpBaseName}.sol" "$outputFp" &>/dev/null; then
		echo -n -e "${COLOR_TEXTGREEN}OK${COLOR_TEXTRESET}"
	else
		echo -n -e "${COLOR_TEXTRED}FAIL${COLOR_TEXTRESET}"
	fi

	echo -n " ellapsed: "
	[ "$(echo "${runningTime} > ${TLE}" | bc -l)" -eq "1" ] && echo -n -e "$COLOR_TEXTRED"
	echo -n -e "${runningTime}s${COLOR_TEXTRESET}"

	[ "$(echo "${runningMemory} > ${MLE}" | bc -l)" -eq "1" ] && echo -n -e "$COLOR_TEXTRED"
	echo -n -e " ${runningMemory}KB${COLOR_TEXTRESET}"
	echo ''
done

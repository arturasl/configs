#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2013 Artūras Lapinskas
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
    [[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}
trap onExit EXIT

# COLORS
if [[ -t 1 ]]; then
    COLOR_TEXT_GREEN=$'\e[0;32m'
    COLOR_TEXT_RESET=$'\e[0m'
    COLOR_TEXT_RED=$'\e[0;31m'
    COLOR_TEXT_BLUE=$'\e[0;34m'
else
    COLOR_TEXT_GREEN=''
    COLOR_TEXT_RESET=''
    COLOR_TEXT_RED=''
    COLOR_TEXT_BLUE=''
fi

# CONSTANTS
TIME_EXECUTABLE='/usr/bin/time'
which gtime &>/dev/null && TIME_EXECUTABLE='gtime'
TMP_DIR="/tmp/${0}" && mkdir -p "$TMP_DIR"

# ARGUMENTS
argTestsFile='tests.in'
argTestsDirectory='tests'
argCopyInput=''
argCopyOutput=''
argTestsToRun='*' # possible values '*', '{2,3,8}', 3 (will be used in bash expansion)
argExecutable=''
argCWD='.'
argTLE='2'
argMLE='1000'
argShowIOOnError=0
argOutputFile=''
argInputFile=''
argExternalGrader=''

while [[ "$#" -ne '0' ]]; do
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

\`--copy-input\` *directory name* default \`\`
:	directory from which will get input files

\`--copy-output\` *directory name* default \`\`
:	directory from which will get output files

\`--tests-to-run\` *path expansion* default \`*\`
:	indicates which tests will be run (supports bash wildcards)

\`--cwd\` *path* default \`.\`
:	current working directory

\`--tle\` *seconds* default \`2.0\`
:	sets maximum number of seconds application is able to run

\`--mle\` *megabytes* default \`1000\`
:	sets maximum number of memory application is allowed to use
	in megabytes

\`--show-io-on-error\` *0 or 1* default \`0\`
:	indicates whatever it is needed to show input/output information
	if error occured

\`--output-file\` *name of file* default \`\`
:	indicates file to which program will put its results. Empty string
	is used as an alias for standart output

\`--input-file\` *name of file* default \`\`
:	indicates file from which program will read its data. Empty string
	is used as an alias for standart input

\`--external-grader\` *name of executable* default \`\`
:	indicates external grader which will be used to test programs output.
	This grader should take 3 parameters: input file, correct file,
	programs output and return 0 if everything is ok (anything else will
	indicate error).
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
        --copy-input)
            argCopyInput="$2" && shift 2
            ;;
        --copy-output)
            argCopyOutput="$2" && shift 2
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
        --mle)
            argMLE="${2}" && shift 2
            ;;
        --show-io-on-error)
            argShowIOOnError="${2}" && shift 2
            ;;
        --output-file)
            argOutputFile="${2}" && shift 2
            ;;
        --input-file)
            argInputFile="${2}" && shift 2
            ;;
        --external-grader)
            argExternalGrader="${2}" && shift 2
            ;;
        *)
            echo "Unknown parameter $1" 1>&2
            exit 1
            ;;
    esac
done

# find executable
if [[ $argExecutable == *.cpp ]]; then
    output="${argExecutable%.*}"
    echo "Building ${argExecutable}"
    ( set -x;  g++ -std=c++23 -O3 -DTEST "$argExecutable" -o "$output" )
    argExecutable="$output"
fi
[[ -z "$argExecutable" ]] && argExecutable="$(find . -perm +0111 -type f | head -n 1)"
echo "${COLOR_TEXT_BLUE}# Running ${argExecutable}${COLOR_TEXT_RESET}"
[[ ! -x "$argExecutable" ]] && echo "${COLOR_TEXT_RED}\"$argExecutable\" is not an executable file${COLOR_TEXT_RESET}" 1>&2 && exit 1

diffGrader () {
    if diff --ignore-blank-lines --ignore-all-space "$2" "$3" &>/dev/null; then
        echo '1'
    else
        echo '0'
    fi
}

# keep all paths absolute
cd "$argCWD" && argCWD="$(pwd)"
argTestsFile="${argCWD}/${argTestsFile}"
argTestsDirectory="${argCWD}/${argTestsDirectory}"
argExecutable="${argCWD}/${argExecutable}"
[[ -n "$argCopyInput" ]] && argCopyInput="${argCWD}/${argCopyInput}"
[[ -n "$argCopyOutput" ]] && argCopyOutput="${argCWD}/${argCopyOutput}"
if [[ -n "$argExternalGrader" ]]; then
    argExternalGrader="${argCWD}/${argExternalGrader}"
else
    argExternalGrader="diffGrader"
fi

# recreate tests directory
mkdir -p "$argTestsDirectory"

# expand tests.in file to tests directory
if [[ -f "${argTestsFile}" ]]; then
    echo "${COLOR_TEXT_BLUE}# Recreating tests directory${COLOR_TEXT_RESET}"
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

if [[ -n "$argCopyInput" && -d "$argCopyInput" && -n "$argCopyOutput" && -d "$argCopyOutput" ]]; then
    rm -f "${argTestsDirectory}/"*.{sol,in}

    # copy files from copy input directory to tests directory
    while IFS= read -d $'\0' -r input; do
        ln -s "$input" "${argTestsDirectory}/$(basename "${input%.*}" | sed -e 's/[^0-9]//g').in"
    done < <(find "$argCopyInput" -type f -name '*' -print0)

    # copy files from copy output directory to tests directory
    while IFS= read -d $'\0' -r input; do
        ln -s "$input" "${argTestsDirectory}/$(basename "${input%.*}" | sed -e 's/[^0-9]//g').sol"
    done < <(find "$argCopyOutput" -type f -name '*' -print0)
fi

# go through needed tests
outputFp="${TMP_DIR}/$(basename "$0").out"
outputTimeFp="${TMP_DIR}/$(basename "$0").time"
TLEWithEpsilon=$(echo "$argTLE" | awk '{printf("%d\n",$1 + 1.5)}')
totalFailures=0
totalTests=0

argMLE="$(( "$argMLE * 1000 * 1000" ))"

for testFp in "${argTestsDirectory}/"$argTestsToRun'.in'; do
    [[ ! -f "$testFp" ]] && echo "${COLOR_TEXT_RED}Could not find test file ${testFp}${COLOR_TEXT_RESET}" 1>&2 && exit 1

    testFpBaseName="$(basename "$testFp")"
    testFpBaseName="${testFpBaseName::$((${#testFpBaseName} - 3))}"
    solutionFp="${argTestsDirectory}/${testFpBaseName}.sol"

    (
        cd "$TMP_DIR" || exit 1
        [[ -n "$argInputFile" ]] && cat "$testFp" > "$argInputFile"
        systemd-run --scope --user --quiet \
            "--property=MemoryMax=${argMLE}" \
            "--property=RuntimeMaxSec=${TLEWithEpsilon}" \
            -- \
            "$TIME_EXECUTABLE" "--format=%e %M" "--output=${outputTimeFp}" \
            "$argExecutable" < "$testFp" > "$outputFp"
        [[ -n "$argOutputFile" ]] && cat "$argOutputFile" > "$outputFp"
    )

    wrongOutput=0

    echo -n "Testing ${testFpBaseName}: "
    grader_output="$("$argExternalGrader" "$testFp" "$solutionFp" "$outputFp" 2>/dev/null)"
    if [[ "$grader_output" =~ 1(\.0+)? ]]; then
        echo -n "${COLOR_TEXT_GREEN}OK${COLOR_TEXT_RESET}"
    else
        echo -n "${COLOR_TEXT_RED}FAIL${COLOR_TEXT_RESET}"
        wrongOutput=1
        totalFailures=$((totalFailures + 1))
    fi
    totalTests=$((totalTests +1))

    # get time and memory usage
    runningTime=$(tail -n 1 "$outputTimeFp" | cut -d' ' -f1)
    runningMemory=$(tail -n 1 "$outputTimeFp" | cut -d' ' -f2)

    [[ "$(echo "${runningTime} > ${argTLE}" | bc -l)" -eq 1 ]] && echo -n "$COLOR_TEXT_RED"
    echo -n " ${runningTime}s${COLOR_TEXT_RESET}"

    [[ "$(echo "${runningMemory} * 1000 > ${argMLE}" | bc -l)" -eq 1 ]] && echo -n "$COLOR_TEXT_RED"
    echo -n " $(( "${runningMemory}" / 1000 ))MB${COLOR_TEXT_RESET}"

    # finished running this program
    echo ''

    if [[ "$wrongOutput" -eq 1 && "$argShowIOOnError" -eq 1 ]]; then
        echo "${COLOR_TEXT_BLUE}Input file${COLOR_TEXT_RESET}"
        cat "$testFp"
        echo "${COLOR_TEXT_BLUE}Programs output${COLOR_TEXT_RESET}"
        cat "$outputFp"
        echo "${COLOR_TEXT_BLUE}Correct output${COLOR_TEXT_RESET}"
        cat "$solutionFp"
    fi
done

echo -n 'ok/errors/all: '
echo -n "${COLOR_TEXT_GREEN}$((totalTests - totalFailures))${COLOR_TEXT_RESET}"
echo -n '/'
[[ "${totalFailures}" -ne 0 ]] && echo -n "${COLOR_TEXT_RED}"
echo -n "${totalFailures}"
[[ "${totalFailures}" -ne 0 ]] && echo -n "${COLOR_TEXT_RESET}"
echo -n "/${totalTests}"
echo ''

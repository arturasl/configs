#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

main() {
    local files_to_resolve
    files_to_resolve="$(jj resolve --list | awk '{print $1}')"
    if [[ -z "$files_to_resolve" ]]; then
        echo "Nothing to resolve"
        exit 1
    fi

    local picked
    picked="$(echo "$files_to_resolve" | fzf)"

    echo "Will be resolving: ${picked}"

    "$EDITOR" -c ':JJDiffConflicts' "$picked"
}

main "$@"

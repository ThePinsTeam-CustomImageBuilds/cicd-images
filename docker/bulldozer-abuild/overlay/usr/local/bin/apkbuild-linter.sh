#!/bin/sh

BLUE="\e[34m"
MAGENTA="\e[35m"
RESET="\e[0m"

readonly BASEBRANCH=$CI_MERGE_REQUEST_TARGET_BRANCH_NAME

verbose() {
    echo "> " "$@"
    # shellcheck disable=SC2068
    $@
}

debugging() {
    [ -n "$CI_DEBUG_BUILD" ]
}

debug() {
    if debugging; then
        verbose "$@"
    fi
}

if debugging; then
    merge_base=$(git merge-base "$BASEBRANCH" HEAD)
    echo "$merge_base"
    git --version
    git config -l
    git tag merge-base "$merge_base" || { echo "Could not determine merge-base"; exit 50; }
    git log --oneline --graph --decorate --all
fi

has_problems=0

while read -r PKG; do
    printf "$BLUE==>$RESET Linting $PKG\n"

    (
        cd "$PKG"

        repo=$(basename $(dirname $PKG));

        if [ "$repo" = "main" ]; then
            export SKIP_AL1=1
            export SKIP_AL13=1
        fi

        printf "\n\n"
        printf "$BLUE"
        printf '======================================================\n'
        printf "                abuild sanitycheck:\n"
        printf '======================================================'
        printf "$RESET\n\n"
        abuild sanitycheck || has_problems=1

        printf "\n\n"
        printf "$BLUE"
        printf '======================================================\n'
        printf "                apkbuild-shellcheck:\n"
        printf '======================================================'
        printf "$RESET\n"
        apkbuild-shellcheck || has_problems=1

        printf "\n\n"
        printf "$BLUE"
        printf '======================================================\n'
        printf "                  apkbuild-lint:\n"
        printf '======================================================'
        printf "$RESET\n\n"
        apkbuild-lint APKBUILD || has_problems=1

        return $has_problems
    ) || has_problems=1

    echo
done

exit $has_problems

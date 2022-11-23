#!/bin/bash

#
COMPONENTS='kvtree
axl
spath
shuffile
redset
er
rankstr
lwgrp
dtcmp
scr'

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 [components]"
    echo ""
    echo "Valid components are:"
    echo "$COMPONENTS"
    exit
fi

if [[ ! -d ./spack ]]; then
    echo "ERROR"
    echo "Ensure local spack directory exists: make spack"
    echo "OR Use symlink for a directory located elsewhere"
    exit
fi

BRANCHNAME=scr-release-$(date "+%Y%m%d")

cd spack || exit
if ! git ls-remote --exit-code ecp-veloc &> /dev/null; then
    echo "Adding ecp-veloc remote to spack repo"
    git remote add ecp-veloc git@github.com:ecp-veloc/spack
fi
git checkout develop
git pull origin develop
git checkout -b "$BRANCHNAME"

echo -e "\nUpdating: $*\n"

for c in "$@"; do
    if [[ ! "$COMPONENTS" == *"$c"* ]]; then
        echo "$c is not a valid component"
        echo "Valid components are:"
        echo "$COMPONENTS"
        exit
    fi

    echo "*** Getting checksum for latest $c release ***"
    bin/spack versions --new "$c" | tail -n +2
    verhash=$(bin/spack checksum --latest "$c" | tail -r -n 2 | tail -n 1)       # mac
    #verhash=$(bin/spack checksum --latest "$c" | tac | head -n 2 | tail -n 1)    # linux
    echo "$verhash"
    pkgfile=$(bin/spack location -p "$c")/package.py
    awk -v newver="$verhash" '/version\('\"'main/ {print; print newver; next} {print;}' "$pkgfile" >> "tmp-$c-package.py"
    mv "tmp-$c-package.py" "$pkgfile"

    if [[ $c == "scr" ]]; then
        echo "==> script failure, manually edit SCR package"
    fi

    echo -e "\n*** Verifying spack fetch ***"
    bin/spack fetch "$c"

    echo -e "\n*** Git Operations ***"
    # ASSUME local user is configured with access to ecp-veloc remote
    git diff
    git commit -am "new release for $c"
done

git push ecp-veloc "$BRANCHNAME"
echo -e "\n*** Spack versions hash updates complete ***"

echo -e "\n*** Script complete. Don't forget to: ***"
echo "- run spack style"
echo "- update the depends_on versions for component dependencies"
echo "- create spack PR: https://github.com/ecp-veloc/spack"

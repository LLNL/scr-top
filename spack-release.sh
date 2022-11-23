#!/bin/bash

#
COMPONENTS="kvtree  \
           axl      \
           spath    \
           shuffile \
           redset   \
           er       \
           rankstr  \
           lwgrp    \
           dtcmp    \
           scr"

if [[ ! -d ./spack ]]; then
    echo ERROR
    echo "Ensure local spack directory exists"
    echo "Use symlink for a directory located elsewhere"
    exit
fi
cd spack
if ! git ls-remote --exit-code ecpv &> /dev/null; then
    echo "Adding ecp-veloc remote to spack repo"
    git remote add ecp-veloc git@github.com:ecp-veloc/spack
fi
git checkout develop
git pull origin develop
git checkout -b scr-release-`date "+%Y%m%d"`

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 [components]"
    echo "Valid components are:"
    echo $COMPONENTS
    exit
fi

echo -e "\nUpdating: $@\n"

for c in $@; do
    if [[ ! "$COMPONENTS" == *"$c"* ]]; then
        echo "$c is not a valid component"
        echo "Valid components are:"
        echo $COMPONENTS
        exit
    fi

    echo "*** Getting checksum for latest $c release ***"
    echo `bin/spack versions --new $c | tail -n +2`
    verhash=`bin/spack checksum --latest $c | tail -r -n 2 | tail -n 1`       # mac
    #verhash=`bin/spack checksum --latest $c | tac | head -n 2 | tail -n 1`    # linux
    echo $verhash
    pkgfile="$(bin/spack location -p $c)/package.py"
    awk -v newver="$verhash" '/version\('\"'main/ {print; print newver; next} {print;}' $pkgfile >> tmp-$c-package.py
    mv tmp-$c-package.py $pkgfile

    if [[ $c == "scr" ]]; then
        echo "==> script failure, manually edit SCR package"
    fi

    echo -e "\n*** Verifying spack fetch ***"
    bin/spack fetch $c

    echo -e "\n*** Git Operations ***"
    # ASSUME local user is configured with access to ecpv remote
    git diff
    git commit -am "new release for $c"
done

git push ecp-veloc scr-release-`date "+%Y%m%d"`
echo -e "\n*** Spack versnios hash updates complete ***"
echo -e "\nDon't forget to update the versions for dependencies"
echo "Don't forget to create spack PR: https://github.com/ecp-veloc/spack"

COMPONENTS=kvtree \
           axl    \
           spath  \
           filo   \
           shuffile \
           redset \
           er     \
           rankstr \
           lwgrp \
           dtcmp \
           scr

all:
	echo "Possible targets:"
	echo "dist: one tarball of latest TAGGED VERSIONS"
	echo "dev:  git clone each repo"
	echo "package: tar of all sources"

dist: dl pack

dl: clone
	# a) hard code tarball path
	# b) use git to checkout last release? and tar up

clone:
	./git-all clone

pack:
	tar -czf scr-top.tgz $COMPONENTS
	# make magic to list comp.tgz 
	
dev: clone
	mkdir build install

pckage: clone
	tar -czf scr-top.tgz $COMPONENTS
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

TGZ = $(COMPONENTS:=.tgz)

all:
	@echo "Possible targets:"
	@echo "dist: one tarball of latest TAGGED VERSIONS"
	@echo "dev:  git clone each repo"
	@echo "pack: tar of all sources"

dist: clone
	./git-all archive

clone:
	@if [ ! -d scr ]; then \
	./git-all clone;\
	fi

pack: clone
	@tar -czf scr-top-dev.tgz $(COMPONENTS) $(shell git ls-files)

dev: clone
	mkdir build install

clean:
	rm *.tar.gz

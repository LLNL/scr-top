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
	@echo ""
	@echo "dist: one tarball of latest TAGGED VERSIONS"
	@echo ""
	@echo "dev:   git clone each repo and setup for build"
	@echo "pack:  tar up all repos"
	@echo ""
	@echo "clean: remove .tar.gz files"

clone:
	@if [ ! -d scr ]; then \
	./git-all clone;\
	fi

dist: clone
	./git-all archive

pack: clone
	@tar -czf scr-top-dev.tgz $(COMPONENTS) $(shell git ls-files)

dev: clone
	@if [ ! -d build ]; then \
	mkdir build install;\
	fi
	@echo "Run 'cmake ../ && make' from build directory"

clean:
	rm *.tar.gz

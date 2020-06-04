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
	@echo "clone:   download all git repositories"
	@echo "dist:    create a single tarball of latest TAGGED VERSIONS"
	@echo "dist-build: build from distribution"
	@echo "build:   print build command (must be run manually)"
	@echo "pack:    tar up all repos"
	@echo "clean:   remove .tar.gz files"

clone:
	@if [ ! -d scr ]; then \
	./git-all clone \
	else \
	echo "ERROR: can't clone: source directories already exist" \
	exit;\
	fi

dist: clone
	./git-all archive

dist-build: $(COMPONENTS)
	@$(MAKE) build

$(COMPONENTS):
	@if [ -d scr ]; then \
	echo "ERROR: source directories already exist"\
	exit;\
	fi
	@mkdir $@
	@tar -xzf $@-*.tar.gz -C $@

pack: clone
	@tar -czf scr-top-dev.tgz $(COMPONENTS) $(shell git ls-files)

.PHONY: build clean

build:
	@if [ ! -d build ]; then \
	mkdir build install;\
	fi
	@echo "Run 'cmake ../ && make' from build directory"
	@echo ""
	@echo "By default, everything is installed to ./install"
	@echo "change install directory using:"
	@echo "     cmake ../ -DCMAKE_INSTALL_PREFIX=/path/ && make"

clean:
	rm *.tar.gz

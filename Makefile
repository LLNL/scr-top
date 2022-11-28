COMPONENTS=kvtree \
           axl    \
           spath  \
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
	@echo "clone:      download all git repositories"
	@echo "spack:      download a spack instance"
	@echo ""
	@echo "dist:       create a single tarball of latest TAGGED VERSIONS"
	@echo "pack:       tar up all repos"
	@echo "pack-lite:  tar up all repos without git files"
	@echo "unpack:     untar components"
	@echo ""
	@echo "build:      print build command (must be run manually)"

clone:
	@if [ ! -d scr ]; then \
	./git-all clone \
	else \
	echo "ERROR: can't clone: source directories already exist" \
	exit;\
	fi

spack:
	@if [ ! -d spack ]; then \
	git clone https://github.com/spack/spack; \
	fi

dist: clone
	./git-all archive

pack: clone
	@tar -czf scr-top-dev.tgz $(COMPONENTS) $(shell git ls-files)

pack-lite: clone
	./git-all packlite

unpack: $(COMPONENTS)

$(COMPONENTS):
	@if [ -d scr ]; then \
	echo "ERROR: source directories already exist"\
	exit;\
	fi
	@echo "Unpacking $@"
	@tar -xzf archive/$@-*.tar.gz

.PHONY: build

build:
	@if [ ! -d build ]; then \
	mkdir build install;\
	fi
	@echo "Run 'cmake ../ && make' from build directory"
	@echo ""
	@echo "By default, everything is installed to ./install"
	@echo "change install directory using:"
	@echo "     cmake ../ -DCMAKE_INSTALL_PREFIX=/path/ && make"

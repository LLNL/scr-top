# SCR and Components

See the main [SCR repository](https://github.com/llnl/scr).

## Usage

The project uses a combination of Makefiles and CMake to build SCR and all its components.
From the top-level directory, users have the following `make` options:

```
clone:   download all git repositories
dist:    create a single tarball of latest TAGGED VERSIONS
dist-build: build from distribution
build:   print build command (must be run manually)
pack:    tar up all repos
clean:   remove .tar.gz files
```

Building all the components can be done with:
```
make clone
make build
cd build/
cmake ../
make
```

By default, everything is installed to ./install.
Change install directory using:
```
cmake ../ -DCMAKE_INSTALL_PREFIX=/path/
make
```

## Release

Copyright (c) 2018, Lawrence Livermore National Security, LLC. Produced at Lawrence Livermore National Laboratory.

For release details and restrictions, please read the [LICENSE](./LICENSE) and [NOTICE](./NOTICE) files.

`LLNL-CODE-751725` `OCEC-18-060`

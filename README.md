# SCR and Components

See the main [SCR repository](https://github.com/llnl/scr).

## Usage

The project uses a combination of Makefiles and CMake to build SCR and all its components.
From the top-level directory, users have the following `make` options:

```
clone:      download all git repositories

dist:       create a single tarball of latest TAGGED VERSIONS
pack:       tar up all repos
pack-lite:  tar up all repos without git files
unpack:     untar components

build:      print build command (must be run manually)
```

### Building

Building all the components can be done with:
```
make clone
make build
cd build/
cmake ../
make
```

If you building from one of the packaged scr-top tarballs (from `dist`, `pack`, `pack-lite`), after you untar the scr-top-xxx.tgz you can build with:
```
make unpack
make build
cd build
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

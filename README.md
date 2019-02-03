# Make dependency generator

`Ali2dep` generates make dependencies from an ALI file generated by GNAT. When
called on an `.ali` file, the dependencies are generated in a `.d` file with
the same base name. The `.d` files can be included in a Makefile to facilitate
rebuild when dependencies change and `gprbuild` or `gnatmake` are not used.

As no path information is conatained within ALI files, search paths must be
passed to `ali2dep` before the actual `.ali` file on the command line. The
program exits with an error in case a source file could not be found in any of
the search paths.

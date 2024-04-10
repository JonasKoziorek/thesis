# DDS - discrete dynamical systems

This folder contains the source code used in the thesis.

## How to run

1. install Julia
2. clone this repository
3. enter this repository in the command line
4. run `julia`
5. install dependencies using:
```
import Pkg
Pkg.instantiate()
Pkg.precompile()
```
Note that dependencies are specified in `Project.toml` file.

6. repository can be opened for example in VS Code and run there (you need to install VS Code Julia plugin) or you can run the code in the command line (run with `julia some_file.jl`)

## Structure

* `/src` contains the source code of algorithms described in the thesis
* `/plots` contains scripts to generate the plots and figures
* `/examples` contains scripts that showcase the algorithms defined in `/src`
* `/studied_maps` contains predefined discrete dynamical systems
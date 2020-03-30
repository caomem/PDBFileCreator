# PdbFileCreator
 A very simple Julia algorithm to convert a three dimensions list of coordinates to a pdb file.

## Basic usage

In the Julia REPL, browse to the folder containing `pdbCreate.jl` file and loading the code using the `include()` method:

```julia-repl
julia> include("pdbCreate.jl")
```

> *Hint: Use the `cd()` function in the Julia REPL to browse into directories. You can know your current directory using the `pwd()` function.*


For generate a pdb file you will need a input file containing the three dimensional list of coordinates. To do it, follow the format of the files in the examples folder.

Finaly, use the `pdbCreate()` method, with the relative path of the input file as parameter (and, opcionaly, the output file name), for create the pdb file.

For example:

```julia-repl
julia> pdbCreate("\\examples\\10.txt", "10.pdb")
```

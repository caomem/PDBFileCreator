# loading basic packages
using DelimitedFiles

# main function to convert a file with three dimensions coordinates in a pdb type file
"""
``` 
pdbCreate(inputFile::AbstractString, outputFile::AbstractString)

```
This is the main function in the program. To run this function, you need a file with a matrix (n, 3) of n real coordinates [x, y, z] of each atom.
    in inputFile parameter you must to inform the name of the file, in pwd() dir, that contains this matrix and, in outputFile, um can inform the name of generated pdb file.

## Example 

```julia-repl
julia> pdbCreate("\\examples\\10.txt", "10.pdb")
```
as return a pdb file is provided, named as default "<name_of_inputFile>.pdb".
"""
function pdbCreate(inputFile::AbstractString, outputFile::AbstractString = "")
    inputFile = string(pwd(),inputFile)
    if (isdir(inputFile))
        println("Invalid File Path")
        usage()
        return 0
    else
        realizations = readdlm(inputFile)
        open(outputFile == "" ? basename(string(splitext(inputFile)[1],".pdb")) : outputFile, "w") do f
            write(f, "test\n")
        end
    end    
end	

# main function to run the solver and related problem
"""
``` 
conformation(NMRdata,cs::ConformationSetup)

```
This is the main function in order to get the conformation of a molecule. To run this function, we need to setup a NMR file and then define some options using the ConformationSetup type. 

## Example 

```julia-repl
julia> options = ConformationSetup(0.001,classicBP,true)

julia> conformation(NMRdata,options)
```
as return a ConformationOutput type is provided.
"""
function usage()
    print("usage:")    
end
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

# function for define the usage of pdbCreate main function
"""
``` 
usage()

```
This is a very simple function to inform the correct utilization of pdbCreate function

## Example 

```julia-repl
julia> pdbCreate("")
usage: pdbCreate("<your_file_of_coordinates>", "<name_of_pdb_output_file>")
```
"""
function usage()
    print("usage: pdbCreate(\"<your_file_of_coordinates>\", \"<name_of_pdb_output_file>\")\n")    
end
# loading basic packages
using DelimitedFiles, Printf

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
        println(typeof(realizations))
        open(outputFile == "" ? basename(string(splitext(inputFile)[1],".pdb")) : outputFile, "w") do f
            (m,n) = size(realizations)
            write(f, "HEADER    LAVOR-INSTANCES                         28-MAR-20   0000              \n")
            write(f, @sprintf "TITLE     THE THREE-DIMENSIONAL LAVOR INSTANCE OF LENGHT %9d             \n" m)
            write(f, "MODEL        1                                                                  \n")
            for i in 1:m
                    s = @sprintf "this is a %s %15.1f" "test" 34.567;
                    write(f, @sprintf "ATOM      1  H   MET A   1     %8.3f %8.3f %8.3f  1.00  0.00           H  \n" realizations[i,1] realizations[i,2] realizations[i,3])
            end
            write(f, "ENDMDL                                                                          \n")
            write(f, @sprintf "MASTER        0    0    0    0    0    0    0 %5d    0    0    0              \n" m)
            write(f, "END                                                                             \n")
        end
        size(realizations)
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
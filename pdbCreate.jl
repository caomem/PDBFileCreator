# loading basic packages
using DelimitedFiles, Printf, LinearAlgebra, Random

# main function to convert a file with three dimensions coordinates in a pdb type file
"""
``` 
pdbCreate(inputFile::AbstractString, outputFile::AbstractString = "")

```
This is the main function in the program. To run this function, you need a file with a matrix (n, 3) of n real coordinates [x, y, z] of each atom.
    in inputFile parameter you must to inform the name of the file, in pwd() dir, that contains this matrix and, in outputFile, um can inform the name of generated pdb file.

## Example 

```julia-repl
julia> pdbCreate("\\examples\\10.txt", "10.pdb")
```
if successful, a pdb file is provided in current directory, named as default "<name_of_inputFile>.pdb".
"""
function pdbCreate(inputFileName::AbstractString, outputFileName::AbstractString = "")
    inputFileName = string(pwd(),inputFileName)
    if (isdir(inputFileName))
        println("Invalid File Path")
        usage()
        return
    else
        realizations = readdlm(inputFileName)
        open(outputFileName == "" ? basename(splitext(inputFileName)[1]*".pdb") : outputFileName, "w") do f
            (m,n) = size(realizations)
            write(f, "HEADER    LAVOR-INSTANCES                         28-MAR-20   0000              \n")
            write(f, @sprintf "TITLE     THE THREE-DIMENSIONAL LAVOR INSTANCE OF LENGHT %9d             \n" m)
            write(f, "MODEL        1                                                                  \n")
            for i in 1:m
                    s = @sprintf "this is a %s %15.1f" "test" 34.567;
                    write(f, @sprintf "ATOM  %5d  H   MET A   1     %7.3f %7.3f %7.3f  1.00  0.00           H  \n" i realizations[i,1] realizations[i,2] realizations[i,3])
            end
            write(f, "ENDMDL                                                                          \n")
            write(f, @sprintf "MASTER        0    0    0    0    0    0    0 %5d    0    0    0              \n" m)
            write(f, "END                                                                             \n")
        end
        size(realizations)
    end
end	

# function to create a file with a random instance
"""
``` 
randomInstanceCreate(n::Integer, outputFileName::AbstractString = "")

```
This function generate a proteic instance with `n` atoms randomly from a physical model that is close to reality, based on the paper
    
    LAVOR, C. . On generating instances for the molecular distance geometry 
    problem. In: Leo Liberti; Nelson Maculan. (Org.). Global Optimization: from
    Theory to Implementation. Global Optimization: from Theory to 
    Implementation. New York: Springer, 2006, v. 84, p. 405-414. 

and that instance is saved in a delimited file named, optionally, just like the outputFileName parameter. By default, the file has the name "`n`.xyz", where `n` is the size of instance.

## Example 

```julia-repl
julia> randomInstanceCreate(10)
```
"""
function randomInstanceCreate(n::Integer, outputFileName::AbstractString = "")
    positions = zeros(n, 3)
    ω=[60;180;300]
    ωₑ=(-15:15)'
    
    θ=109.5*pi/180;
    r=1.526;

    B1=Array(1.0*I(4));
    B2=Array(1.0*I(4));
    B3=Array(1.0*I(4));

    B2[1,1]=-1;
    B2[3,3]=-1;
    B2[1,4]=-r;

    B3[1,1]=-cos(θ);
    B3[1,2]=-sin(θ);
    B3[1,4]=-r*cos(θ);
    B3[2,1]=sin(θ);
    B3[2,2]=-cos(θ);
    B3[2,4]=r*sin(θ);

    Orig=[0;0;0;1];

    B=B1*B2;
    v=B*Orig;
    positions[2,:]=(v[1:3])';
    B=B*B3;
    v=B*Orig;
    positions[3,:]=(v[1:3])';
    Omega=zeros(n-3,1);

    for i=4:n
        n1aux=randperm(3);
        n1=n1aux[1];
        n2aux=randperm(31);
        n2=n2aux[7];
        
        omega=(ω[n1]+ωₑ[n2])*pi/180;
        Omega[i-3]=omega;
        Bi=zeros(4,4);

        Bi[1,1]=-cos(θ);
        Bi[1,2]=-sin(θ);
        Bi[1,4]=-r*cos(θ);
        Bi[2,1]=sin(θ)*cos(omega);
        Bi[2,2]=-cos(θ)*cos(omega);
        Bi[2,3]=-sin(omega);
        Bi[2,4]=r*sin(θ)*cos(omega);
        Bi[3,1]=sin(θ)*sin(omega);
        Bi[3,2]=-cos(θ)*sin(omega);
        Bi[3,3]=cos(omega);
        Bi[3,4]=r*sin(θ)*sin(omega);
        Bi[4,4]=1;
        
        B=B*Bi;
        
        v=B*Orig;
        positions[i,:]=(v[1:3])';
    end

    open((outputFileName == "") ? string(n)*".xyz" : outputFileName, "w") do io
        writedlm(io, positions)
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
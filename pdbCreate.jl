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
        open(outputFileName == "" ? basename(string(splitext(inputFileName)[1],".pdb")) : outputFileName, "w") do f
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

function randomInstanceCreate(n::Integer, outputFileName::AbstractString = "")
    positions = zeros(n, 3)
    ω=[60;180;300]
    ωₑ=(-15:15)'
    
    θ=109.5*pi/180;
    r=1.526;

    B1=I(4);
    B2=I(4);
    B3=I(4);

    B2(1,1)=-1;
    B2(3,3)=-1;
    B2(1,4)=-r;

    B3(1,1)=-cos(teta);
    B3(1,2)=-sin(teta);
    B3(1,4)=-r*cos(teta);
    B3(2,1)=sin(teta);
    B3(2,2)=-cos(teta);
    B3(2,4)=r*sin(teta);

    Orig=[0;0;0;1];

    B=B1*B2;
    v=B*Orig;
    Pts(2,:)=(v(1:3))';
    B=B*B3;
    v=B*Orig;
    Pts(3,:)=(v(1:3))';
    Omega=zeros(n-3,1);
    clear B1 B2 B3 v

    for i=4:n
        n1aux=randperm(3);
        n1=n1aux(1);
        n2aux=randperm(31);
        n2=n2aux(7);
        
        omega=(Tor1(n1)+Tor2(n2))*pi/180;
        Omega(i-3)=omega;
        Bi=zeros(4,4);

        Bi(1,1)=-cos(teta);
        Bi(1,2)=-sin(teta);
        Bi(1,4)=-r*cos(teta);
        Bi(2,1)=sin(teta)*cos(omega);
        Bi(2,2)=-cos(teta)*cos(omega);
        Bi(2,3)=-sin(omega);
        Bi(2,4)=r*sin(teta)*cos(omega);
        Bi(3,1)=sin(teta)*sin(omega);
        Bi(3,2)=-cos(teta)*sin(omega);
        Bi(3,3)=cos(omega);
        Bi(3,4)=r*sin(teta)*sin(omega);
        Bi(4,4)=1;
        
        B=B*Bi;
        clear Bi
        
        v=B*Orig;
        Pts(i,:)=(v(1:3))';
        clear v
    end

    clear B

    Ares=zeros(n-1,2);
    Ares(:,1)=(1:n-1)';
    Ares(:,2)=(2:n)';

    if nargin<2|strcmp(figura,'sim')|strcmp(figura,'Sim')|strcmp(figura,'s')|strcmp(figura,'S')
        clf
        scatter3(Pts(:,1),Pts(:,2),Pts(:,3));
        hold
        for i=1:n-1
            line(Pts(Ares(i,:),1),Pts(Ares(i,:),2),Pts(Ares(i,:),3));
        end
    end



    D=zeros(n,n);
    for i=1:n
        for j=(i+1):n
            D(i,j)=norm(Pts(i,:)-Pts(j,:));
            D(j,i)=D(i,j);
        end
    end

    writedlm(positions, outputFileName == "" ? string(n,".xyz") : outputFileName)
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
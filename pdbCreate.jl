using DelimitedFiles

function pdbCreate(pathFile::AbstractString, nameFile::AbstractString)
    pathFile = string(pwd(),pathFile)
    if (isdir(pathFile))
        println("Invalid File Path")
        usage()
        return 0
    else
        realizations = readdlm(pathFile)
        open(nameFile, "w") do f
            write(f, "test\n")
        end
    end    
end	

function usage()
    print("usage:")    
end
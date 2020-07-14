-- show <file>: Shows the content of a file      --
function main(filename)
    filename = filename[1]
    if type(filename) == "string" then
        if filename:match("[^.]+$") == "lua" then
            fail("This is a binary file, it cant be displayed!")
        else
            if fileexists(filename) then 
                data = love.filesystem.read(filename)
            elseif fileexists(curPath..filename) then
                data = love.filesystem.read(curPath..filename)
            else
                fail("The file doesn't exists!")
            end
            
            if utf8valid(data) then
                printc(data, 9)
            else
                fail("Not valid utf8 file!")
            end
        end
    else
        fail("Expected file!")
    end
end
return main
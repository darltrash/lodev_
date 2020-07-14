-- show <file>: Shows the content of a file      --
function main(filename)
    filename = filename[1]
    if type(filename) == "string" then
        if fileexists(filename) then 
            path = filename
        elseif fileexists(curPath..filename) then
            path = curPath..filename
        else
            fail("The file doesn't exists!")
            return nil
        end
        printc("------------------------------", 9)

        info = love.filesystem.getInfo(path)
        printc(" > Name: '"..filename.."'")
        if (info.type == "directory") then 
            printc(" > Path: '"..path.."/'")
        else 
            printc(" > Path: '"..path.."'")
        end
        if filename:match("[^.]+$") == "lua" then
            printc(" > Runnable: True")
        else
            printc(" > Runnable: False")
        end
        if not info.type == "directory" then 
            printc(" > Size: "..tostring(info.size/1024 or 0):sub(1,4).."MB")
        end
        printc(" > Type: "..(info.type or "UNKNOWN"):upper())
        printc(" > Last mod.: "..(info.modtime or 0).."")
        printc("------------------------------", 9)
    else
        fail("Expected file!")
    end
end
return main
-- cd <dir>: Goes to a directory                 --
function main(dir)
    dirname = dir[1]
    if type(dirname) == "string" then
        if dirname == ".." then
            local t = {}
            for str in string.gmatch(curPath, "([^/]+)") do
                table.insert(t, str)
            end
            
            ndir = ""
            for k, v in ipairs(t) do
                if k < #t then
                    ndir = ndir .. v .. "/"
                end
            end

            curPath = ndir
        elseif dirname == "/" then
            curPath = ""
        elseif dirname == "." then
            --placeholder!!!
        else
            if direxists(dirname) then 
                curPath = dirname 
            elseif direxists(curPath .. dirname) then
                curPath = curPath .. dirname
            else
                fail("The dir doesn't exists or is not a dir!")
            end
            if curPath:sub(#curPath, #curPath) ~= "/" then
                curPath = curPath .. "/"
            end
        end
    else
        fail("Expected directory!")
    end
end

return main
-- ls: Shows the insides of a dir (def: current) --
-- TODO: Add the ability to ls to other directories
function main(dir)
    local things = love.filesystem.getDirectoryItems(curPath)
    local files  = ""
    local bins   = ""
    local dirs   = ""

    for k, v in ipairs(things) do
        if love.filesystem.getInfo(curPath .. v).type == "directory" then
            v = v .. "/ "
            if (#dirs + #v)>48 then dirs = dirs .. "\n" end
            dirs = dirs .. v 
        elseif love.filesystem.getInfo(curPath .. v).type == "file" then
            if v:match("[^.]+$") == "lua" then
                v = v .. " "
                if (#bins + #v)>48 then bins = bins .. "\n" end
                bins = bins .. v 
            else
                v = v .. "  "
                if (#files + #v)>48 then files = files .. "\n" end
                files = files .. v 
            end
        end
    end

    printc(dirs, 5)
    printc(bins, 3)
    printc(files, 9)
end

return main
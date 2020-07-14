-- help: Shows all the commands                  --
function main()
    local programs_files = love.filesystem.getDirectoryItems(binPath:gsub("[.]", "/"))
    fail("THE SYSTEM INTEGRITY ISNT OPTIMAL.")
    fail("AN OLDER BACKUP HAS BEEN LOADED,")
    fail("SOME APPLICATIONS WONT WORK PROPERLY.")
    printc()
    for k, v in ipairs(programs_files) do
        desc = love.filesystem.read(binPath:gsub("[.]", "/")..v, 51)
        if desc:sub(1, 2) == "--" then 
            printc(desc:sub(4, 51-2), 9)
        end
    end
end 

return main
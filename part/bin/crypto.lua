-- crypto: encryption utility, check crypto help --

local algo = {
    encode = function (str, key)
        love.math.setRandomSeed(key)
        local nstr = ""
        for x = 1, #str do
            nstr = nstr .. string.char(str:sub(x, x):byte() + love.math.random(1, 20))
        end
        return nstr
    end,
    decode = function (str, key)
        love.math.setRandomSeed(key)
        local nstr = ""
        for x = 1, #str do
            nstr = nstr .. string.char(str:sub(x, x):byte() - love.math.random(1, 20))
        end
        return nstr
    end
}

local function help()
    printc("Crypto utility by '"..algo.encode("NOTHING", 2007).." "..algo.encode("HERE", 2009).."' 2007-2009\n\t\nUsage:", 3)

    printc("crypto encode <file> <passcode> -p:\n> Encripts a file with the following passcode\n\t", 9)
    printc("crypto encode <file> <passfile>:   \n> Encripts a file with the following passfile\n\t", 9)
    printc("crypto decode <file> <passcode> -p:\n> Decripts a file with the following passcode\n\t", 9)
    printc("crypto decode <file> <passfile>:   \n> Decripts a file with the following passfile\n\t", 9)
end

function main(arg)
    printc(algo.encode("JAM SANDWICH", 88674532))
    if (arg[1] == "help") or (arg[1] == "") then
        help()
    elseif (arg[1] == "encode") or (arg[1] == "decode") then
        originfile = curPath..arg[2]
        if fileexists(originfile) then
            key = arg[3]
            origin = love.filesystem.read(originfile)
            if arg[4] == "-p" then
                keypath = curPath..arg[3]
                if fileexists(keypath) then 
                    key = love.filesystem.read(keypath)
                else
                    fail("The passfile given doesnt exists!")
                    return nil
                end
            end
            printc(algo[arg[1]](origin, key))
        else
            fail("The origin file doesnt exists!")
        end
    else
        fail("Option '"..arg[1].."' unrecognized!")
        help()
    end
end

return help
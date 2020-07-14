local utf8  = require("utf8")
utf8valid   = require("utf8_validator")
_G.binPath  = "part.bin."
_G.curPath  = "part/users/"
_G.user     = "recovery"
_G.log      = ""

local function hexC(hex)
    local hex = hex:gsub("#","")
    return {tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255, 1}
end

local palette = { -- light then darker
    hexC("#FFFFFF"), hexC("#06001c"), -- WHITE / BLACK
    hexC("#FFE712"), hexC("#F3DA00"), -- YELLOW
    hexC("#00FF84"), hexC("#00A958"), -- GREEN
    hexC("#FF4100"), hexC("#F33E00"), -- RED
    hexC("#6E0DFF"), hexC("#4301A5"), -- PURPLE
}
local corrupted = "_"

function fileexists(f)
    return (love.filesystem.getInfo(f) ~= nil)
end

function direxists(f)
    local d = love.filesystem.getInfo(f)
    if d then
        return d.type=="directory"
    end
    return false
end

function clear()
    log = ""
    printc("Cleared.")
end

local function remspaces(str) --https://scripters.boards.net/post/389/thread
    local t = (str:gsub(" +"," "))
    if t:sub(#t, #t) == " " then
        return t:sub(1, #t-1)
    else
        return t
    end
end

function splitsp(str)
    local str = str or ""
    local lines = {}
    for s in str:gmatch("%S+") do
        table.insert(lines, s)
    end
    return lines
end

function split(str)
    local str = str or ""
    local lines = {}
    for s in str:gmatch("[^\n]+") do
        table.insert(lines, s)
    end
    return lines
end

function printc(txt, c, skipsep)
    local txt = txt or "\n\t"
    local x = split(tostring(txt))
    local sep = " "
    if skipsep then sep = "" end
    for k, v in ipairs(x) do
        log = log .. ((c or 9) -1) .. sep .. v .. "\n"
    end
end

function input(txt, keep, max, def)
    shellmsg = txt or "Input: "
    state = "get"
    text = def or ""
    _input = nil
    while true do
        if _input then
            break
        end
        coroutine.yield()
    end
    state = "none"

    if keep then 
        printc(txt)
        printc(" '".._input.."'", 1)
    end

    return _input 
end

function sleep(n)  -- seconds
    local t0 = love.timer.getTime()
    while love.timer.getTime() - t0 <= n do 
        coroutine.yield()
    end
end

function getlast(tab, l)
    local ex = {}
    if (#tab - l) < 1 then return ex end
    for x = 1, l do
        table.insert(ex, tab[#tab+1-l])
    end
    return ex
end

function concat2(tbl, div)
    local t = ""
    for k, v in ipairs(tbl) do
        t = t .. v .. (div or " ")
    end
    return t 
end

function fail(txt)
    local x = split(txt)
    for k, v in ipairs(x) do
        log = log .. "7# " .. v .. "\n"
    end
end

function corrupt(input, percent, seed)
    love.math.setRandomSeed(seed or love.timer.getTime())
    local lines = split(input)
    for k, v in ipairs(lines) do
        local _tv = v:sub(1, 1)
        for i = 2, #v do
            if (love.math.random(1, 100) < percent) then
                local c = love.math.random(1, #corrupted)
                _tv = _tv .. corrupted:sub(c, c)
            else
                _tv = _tv .. v:sub(i, i)
            end
        end
        lines[k] = _tv .. "\n"
    end
    return table.concat(lines)
end

function runcommand(cmd, ...)
    if fileexists(binPath:gsub("[.]", "/")..cmd..".lua") then
        requireOK, requireFail = pcall(require, binPath..cmd)
        if requireOK then
            cmdData = require(binPath..cmd)
            runOK, runFail = pcall(cmdData, {...})
            if not runOK then
                fail("File failed to run. \n"..runFail)
            end
        else
            fail("File is invalid/corrupted. \n"..requireFail)
        end
    else
        fail("File not found in "..binPath:gsub("[.]", "/")..".")
    end
end

local indicator = ""

function love.load()
    state = "run" 
    shellmsg = "Input:"

    --[[
        Run: Run the command
        Get: Passes the input to input()
        None: Does literally nothing
    ]]

    f = love.graphics.newFont("font/ponde___.ttf", 10)
    f:setFilter("nearest", "nearest")
    love.graphics.setFont(f)

    vignette = love.graphics.newImage("vignette.png")
    vignette:setFilter("linear", "linear")

    text = ""
    printc("--- WELCOME TO NUTSHELL OS (recovery mode) ---", 3, true)
    love.keyboard.setKeyRepeat(true)

    middleh = love.graphics.getHeight()/2

    w, h = love.graphics.getDimensions()

    shader = love.graphics.newShader(love.filesystem.read("shader.frag"))
    shader:send("vignette", vignette)
end

function love.textinput(t)
    text = text .. t
end

function love.keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(text, -1)
        if byteoffset then
            text = string.sub(text, 1, byteoffset - 1)
        end
    elseif key == "return" then
        if state == "run" then
            crazyness = 0
            state = "none"
            if remspaces(text)=="" then
                printc()
                printc("> ", 1, true)
                fail("Nothing runned")
            else
                printc()
                printc("> "..remspaces(text)..":", 1, true)
                co = coroutine.create(runcommand)
                coroutine.resume(co, unpack(splitsp(text:lower())))
            end
            if co then 
                if coroutine.status(co) == "dead" then
                    state = "run"
                end
            else 
                state = "run"
            end
            text = ""
        elseif state == "get" then 
            _input = text 
            text = ""
        end
    end
end

function lerp(a,b,t) return (1-t)*a + t*b end

local s = 0
local lines = {}
local cursor = 12

function love.update(delta)
    shader:send("time", love.timer.getTime())

    s = math.sin(love.timer.getTime()*5)
    if s>0 then indicator = "_" else indicator = "" end

    --lines = split(corrupt(log, 2, math.floor(love.timer.getTime()/2)))
    lines = split(log)
    if state == "none" then
        cursor = lerp(cursor, (#lines+1) * 12, delta*20)
    else
        cursor = lerp(cursor, (#lines+4) * 12, delta*20)
    end

    if co then
        if coroutine.status(co) ~= "dead" then 
            coroutine.resume(co)
        else
            state = "run"
        end
    else
        state = "run"
    end

    if love.keyboard.isDown("lctrl", "rctrl") and love.keyboard.isDown("c") and not(state == "run") then 
        co = nil 
        fail("KILLED (CTRL + C)") --this isnt a fail
    end

    middleh = love.graphics.getHeight()/2

    w, h = love.graphics.getDimensions()
end

function drawShell()
    love.graphics.push()
        love.graphics.setShader(shader)
        love.graphics.setColor(palette[2])
        love.graphics.rectangle("fill", 0, 0, w, h)
        love.graphics.scale(2, 2)
        love.graphics.translate(0, -cursor + middleh)

        local last  = 1
        for k, v in ipairs(lines) do
            love.graphics.setColor(palette[(tonumber(v:sub(1,1))+1) or 1])
            love.graphics.print(v:sub(2, #v), 0, (k-1)* 12)
            last = last + 1
        end

        if state ~= "none" then 
            love.graphics.setColor(palette[3])
            if state == "run" then
                love.graphics.print("#"..user.." ("..curPath..")", 0, last* 12)
            elseif state == "get" then 
                love.graphics.print(shellmsg, 0, last* 12)
            end
            love.graphics.setColor(palette[1])
            love.graphics.print("> "..text..indicator, 0, (last+1)* 12)
            love.graphics.setColor(palette[9])
        end
    love.graphics.pop()
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    drawShell()
    --love.graphics.setColor(1, 1, 1, 0.05)
    --love.graphics.draw(vignette, 0, 0, 0, w/vignette:getWidth(), h/vignette:getHeight())
end
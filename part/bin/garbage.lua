local function ranchar(l)
    s = ""
    for x = 1, l do 
        s = s .. string.char(love.math.random(33,126))
    end
    return s 
end

function main() 
    while true do 
        crazyness = crazyness + love.timer.getDelta()
        printc(ranchar(48))
        sleep(0.5)
        coroutine.yield() 
    end 
end

return main
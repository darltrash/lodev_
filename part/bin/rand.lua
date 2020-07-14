-- rand [min] [max] [seed]: Says a random number --
function main(arg)
    love.math.setRandomSeed(tonumber(arg[3]) or love.timer.getTime())
    printc(love.math.random(tonumber(arg[1]) or 1, tonumber(arg[2]) or 255), 9)
end
return main
local function main(f)
    local function adv()
        local should_exit = false
        local _log = log 
        log = "2"

        -- SETUP
        _adv = {
            objects = {
                car = {
                    info    = "A normal car, seems a little broken",
                    open    = "Inside there is normal car stuff and a decorative pine scent thingy",
                    close   = "why would you?",
                    grab    = "this is too big for you to grab",
                    attack  = "you kick the car... it does nothing, the battery is dead",
                    turnon  = "the battery is dead",
                    turnoff = "... You cant turn off something that is already off."
                }
            },
            commands = {
                exit = function() should_exit = true end,
                inspect = function(...) 
                    printc(...)
                end
            }
        }

        local function rn(args)
            log = "2\n"
            if args == "" then 
                return false 
            end
            args = splitsp(args) or {""}
            print(args[1])
            if type(args[1]) == "string" then 
                if type(_adv.commands[args[1]]) == "function" then 
                    _adv.commands[args[1]](select(2, unpack(args)))
                    return true
                else 
                    fail("Command '"..args[1].."' doesnt exists!")
                    return false
                end
            else 
                fail("i have no idea what the fuck you did here\nreport this bug NOW")
                --bruh
                return false
            end
        end

        _adv = (f or function(a) return a end)(_adv)

        repeat 
            rn(input("What should i do?"))
        until should_exit

        log = _log
        printc("Game terminated.")
    end
    return adv
end
return main
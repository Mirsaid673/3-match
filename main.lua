require "screen"
require "game"


local screen = Screen.new(12, 12)
local game = Game.new(screen)
game.init()
local running = true
while running do
    screen.clearConsole()

    game.dump()
    screen.draw()
    
    local s = io.read("*n")
    if s == 1 then
        running = false
    end
end
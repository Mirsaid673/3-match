require "screen"
require "game"
require "input"


local screen = Screen.new(12, 13)
local input = Input.new()
local game = Game.new(screen)

game.init()

while not input.shouldClose() do
    screen.clearConsole()

    if input.isCorrect() then
        game.move(input.getSwapPints())
    end
    
    game.dump()
    screen.draw()
    input.update()
end

print("your score: " .. game.getScore())
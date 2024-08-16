require "screen"
require "game"
require "input"

App = {}

App.new = function()
    local self = setmetatable({}, App)

    self.screen = Screen.new(12, 12)
    self.input = Input.new()
    self.game = Game.new(self.screen)

    self.tick = function()
        self.screen.clearConsole()

        if self.input.isCorrect() then
            self.game.move(self.input.getSwapPints())
        end

        self.game.dump()
        self.screen.draw()
        print("your score: " .. self.game.getScore())
        self.input.update()

    end

    self.best = 0
    self.onStart = function()
        self.game.init()

        io.write("3 match game")
        io.write("commands:\n")
        io.write("q - quit the game\n")
        io.write("m x y d - move the gem with (x, y) coordinates to d direction.\n          d can be l (left) r (right) u (up) d (down) for example:\n          m 5 3 r\n")
        io.write("press enter to start...")
        local unused = io.read("*l")

        local file = io.open("best.txt", "r")
        if not file then return end

        self.best = file:read("n")
        if not self.best then self.best = 0 end
    end

    self.onExit = function()
        if self.game.getScore() > self.best then
            self.best = self.game.getScore()
            io.write("new best! congratulations!\n")
        end
        print("your best: " .. self.best)
        
        local file = io.open("best.txt", "w")
        if file then file:write(self.best) end
    end

    self.run = function()
        self.onStart()

        while not self.input.shouldClose() do self.tick() end

        self.onExit()
    end

    return self
end

return App

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

    self.onStart = function() 
        self.game.init()
    end

    self.onExit = function() end

    self.run = function()
        self.onStart()

        while not self.input.shouldClose() do self.tick() end

        self.onExit()
    end

    return self
end

return App

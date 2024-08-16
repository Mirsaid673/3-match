Game = {}

Game.new = function(screen_)
    local self = setmetatable({}, Game)
    local screen = screen_
    local width = 10
    local height = 10
    local intToGems = {'A', 'B', 'C', 'D', 'E', 'F'}
    local field = {}

    self.getRandonGem = function()
        return math.random(1, 6)
    end

    self.init = function()
        for i=1, height do
            field[i] = {}
            for j=1, width do
                field[i][j] = self.getRandonGem()
            end
        end

        -- drawing screen decorations
        for i=0, 9 do
            screen.put(i+3, 1, i)
            screen.put(i+3, 2, '_')
            screen.put(1, i+3, i)
            screen.put(2, i+3, '|')
        end
    
    end

    self.get = function(x, y)
        return field[y][x]
    end


    self.dump = function()
        offsetX = 2
        offsetY = 2

        for y=1, height do
            for x=1, width do
                screen.put(x+offsetX, y+offsetY, intToGems[self.get(x, y)])
            end
        end
    end

    return self
end

return Game
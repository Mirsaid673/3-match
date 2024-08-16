Screen = {} 

Screen.new = function(w, h)
    local self = setmetatable({}, Screen)
    local buffer = {}
    local width = w
    local height = h

    self.draw = function()
        for i=1, height do
            for j=1, width do
                io.write(buffer[i][j], ' ')
            end
            io.write("\n")
        end
    end
    
    self.put = function(x, y, val)
        buffer[y][x] = val
    end

    self.get = function(x, y)
        return buffer[y][x]
    end

    self.clear = function()
        for i=1, height do
            buffer[i] = {}
            for j=1, width do
                buffer[i][j] = ' '
            end
        end
    end

    self.clearConsole = function()
        if os.execute("clear") then
            return
        elseif os.execute("cls") then
            return
        end

        for i = 1,25 do
            print("\n\n")
        end
                
    end

    self.clear()
    return self
end

return Screen
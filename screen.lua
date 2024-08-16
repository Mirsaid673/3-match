Screen = {}

Screen.new = function(w, h)
    local self = setmetatable({}, Screen)
    local buffer = {}
    local width = w
    local height = h

    self.draw = function()
        for i = 1, height do
            for j = 1, width do
                local output = buffer[i][j]
                if output == nil then output = ' ' end
                io.write(output, ' ')
            end
            io.write("\n")
        end
    end

    self.put = function(x, y, val)
        if x > width or x < 1 or y > height or y < 1 then return end
        buffer[y][x] = val
    end

    self.get = function(x, y)
        if x > width or x < 1 or y > height or y < 1 then return ' ' end
        return buffer[y][x]
    end

    self.clear = function()
        for i = 1, height do
            buffer[i] = {}
            for j = 1, width do buffer[i][j] = ' ' end
        end
    end

    self.clearConsole = function()
        if os.execute("clear") then
            return
        elseif os.execute("cls") then
            return
        end

        for i = 1, 25 do print("\n\n") end

    end

    local cursor = {1, 1}

    self.setCursor = function(x, y)
        if x > width or x < 1 or y > height or y < 1 then return end

        cursor[1] = x
        cursor[2] = y
    end

    local updateCursor = function()
        cursor[2] = math.floor(cursor[2] + cursor[1] / width)
        cursor[1] = cursor[1] % width + 1
    end

    self.print = function(str)
        for i = 1, #str do
            io.write(string.sub(str, i, i))
            self.put(cursor[1], cursor[2], string.sub(str, i, i))
            updateCursor()
        end
    end

    self.clear()
    return self
end

return Screen

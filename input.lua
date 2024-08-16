Input = {}

Input.new = function()
    local self = setmetatable({}, Input)
    local shouldClose = false
    local error = ""
    local correctInput = false

    local fromX, fromY, toX, toY

    local trim = function(s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end

    local split = function(inputstr, sep)
        if sep == nil then sep = "%s" end
        local t = {}
        for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
            table.insert(t, str)
        end
        return t
    end

    self.update = function()
        print(error)
        io.write("input>")

        local s = io.read("*l")
        s = trim(s)
        correctInput = false
        if #s == 0 then
            return
        elseif s == "q" then
            shouldClose = true
            error = ""
            return
        end

        s = split(s)

        if s[1] ~= "m" then
            error = "invalid command"
            return
        end
        if #s ~= 4 then
            error = "invalid parameters number"
            return
        end
        local x = tonumber(s[2])
        local y = tonumber(s[3])
        local dir = s[4]

        if x == nil then
            error = "invalid x coordinate"
            return
        elseif y == nil then
            error = "invalid y coordinate"
            return
        elseif dir ~= "l" and dir ~= "r" and dir ~= "u" and dir ~= "d" then
            error = "invalid direction"
            return
        end
        local changeX = {["l"] = -1, ["r"] = 1, ["u"] = 0, ["d"] = 0}
        local changeY = {["l"] = 0, ["r"] = 0, ["u"] = -1, ["d"] = 1}
        fromX = x + 1
        fromY = y + 1
        toX = x + 1 + changeX[dir]
        toY = y + 1 + changeY[dir]

        correctInput = true
        error = ""
    end

    self.getSwapPints = function ()
        return fromX, fromY, toX, toY        
    end

    self.isCorrect = function ()
        return correctInput
    end

    self.getError = function() return error end

    self.shouldClose = function() return shouldClose end

    return self
end

return Input

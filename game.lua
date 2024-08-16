Game = {}

Game.new = function(screen_)
    local self = setmetatable({}, Game)
    local screen = screen_
    local width = 10
    local height = 10
    local intToGems = {'A', 'B', 'C', 'D', 'E', 'F'}
    local board = {}

    -- methods
    local matchAt -- tells if there is match on x, y

    local getRandonGem = function() return math.random(1, #intToGems) end

    self.getAllMatches = function()
        local matches = {}
        for y = 1, height do
            for x = 3, width do
                local curr = self.get(x, y)
                local prevX1 = self.get(x - 1, y)
                local prevX2 = self.get(x - 2, y)
                if prevX1 == prevX2 and curr == prevX1 then
                    matches[#matches + 1] = {{x - 2, y}, {x - 1, y}, {x, y}}
                end
            end
        end

        for x = 1, width do
            for y = 3, height do
                local curr = self.get(x, y)
                local prevY1 = self.get(x, y - 1)
                local prevY2 = self.get(x, y - 2)
                if prevY1 == prevY2 and curr == prevY1 and curr ~= 0 then
                    matches[#matches + 1] = {{x, y - 2}, {x, y - 1}, {x, y}}
                end
            end
        end

        return matches
    end

    local hasHorizontPossibleMatches
    local hasVertPossibleMatches
    self.hasPossibleMatches = function()
        if hasHorizontPossibleMatches() then return true end
        return hasVertPossibleMatches()
    end

    local randomize = function()
        for i = 1, width do
            board[i] = {}
            for j = 1, height do
                local gem = getRandonGem()

                while matchAt(i, j, gem) do
                    gem = gem % (#intToGems) + 1
                end

                board[i][j] = gem
            end
        end
    end

    self.mix = function()
        randomize()
        while not self.hasPossibleMatches() do randomize() end
    end

    self.get = function(x, y)
        if x > width or x < 1 or y > height or y < 1 then return 0 end
        return board[x][y]
    end

    self.put = function(x, y, val)
        if x > width or x < 1 or y > height or y < 1 then return end
        board[x][y] = val
    end

    self.swap = function(fromX, fromY, toX, toY)
        local from = self.get(fromX, fromY)
        local to = self.get(toX, toY)

        self.put(fromX, fromY, to)
        self.put(toX, toY, from)
    end

    local score = 0
    self.eraseMatches = function(matches)
        for i = 1, #matches do
            local match = matches[i]
            for j = 1, #match do
                local x = match[j][1]
                local y = match[j][2]
                self.put(x, y, 0)
            end
            score = score + 50
        end
    end

    self.fillEmptys = function()
        for i = 1, width do
            local curColumn = board[i]

            local start = #curColumn
            for j = #curColumn, 1, -1 do
                if curColumn[j] ~= 0 then
                    curColumn[j], curColumn[start] = curColumn[start],
                                                     curColumn[j]
                    start = start - 1
                end
            end -- now start contains count of zeros

            -- fillind with random gems
            for j = 1, start do curColumn[j] = getRandonGem() end
        end
    end

    self.move = function(fromX, fromY, toX, toY)
        if fromX > width or fromX < 1 or fromY > height or fromY < 1 or toX >
            width or toX < 1 or toY > height or toY < 1 then return end
        self.swap(fromX, fromY, toX, toY)
        local matches = self.getAllMatches()
        if #matches == 0 then
            self.swap(fromX, fromY, toX, toY)
            return
        end

        local i = 0
        local MAX_ITERATIONS = 15
        while #matches > 0 do
            if i > MAX_ITERATIONS then -- if too many iteration we just mix the board
                self.mix()
                return
            end

            self.eraseMatches(matches)
            self.fillEmptys()
            matches = self.getAllMatches()

            i = i + 1
        end

        while not self.hasPossibleMatches() do randomize() end
    end

    self.init = function()
        self.mix()

        -- drawing screen decorations
        for i = 0, 9 do
            screen.put(i + 3, 1, i)
            screen.put(i + 3, 2, '_')
            screen.put(1, i + 3, i)
            screen.put(2, i + 3, '|')
        end

    end

    self.dump = function()
        local offsetX = 2
        local offsetY = 2

        for y = 1, height do
            for x = 1, width do
                screen.put(x + offsetX, y + offsetY, intToGems[self.get(x, y)])
            end
        end
    end

    matchAt = function(x, y, gem)
        if x < 3 and y < 3 then return false end
        local curr = gem

        local prevX1 = self.get(x - 1, y)
        local prevX2 = self.get(x - 2, y)

        local prevY1 = self.get(x, y - 1)
        local prevY2 = self.get(x, y - 2)

        if prevX1 == prevX2 and curr == prevX1 and curr ~= 0 then
            return true
        elseif prevY1 == prevY2 and curr == prevY1 and curr ~= 0 then
            return true
        end

        return false
    end

    self.getScore = function() return score end

    hasHorizontPossibleMatches = function()
        for y = 1, height do
            for x = 3, width do
                -- cases where X is possible match gem
                -- firts   second  third
                -- XOO       OXO     OOX
                -- OXX       XOX     XXO
                -- OOO       OOO     OOO
                local curr = self.get(x, y)
                local prev1 = self.get(x - 1, y)

                local prev21 = self.get(x - 2, y - 1)
                local prev22 = self.get(x - 2, y + 1)
                if curr == prev1 and (curr == prev21 or curr == prev22) then
                    return true
                end

                -- curr = self.get(x, y)
                prev1 = self.get(x - 2, y)

                prev21 = self.get(x - 1, y - 1)
                prev22 = self.get(x - 1, y + 1)
                if curr == prev1 and (curr == prev21 or curr == prev22) then
                    return true
                end
                curr = self.get(x - 1, y)
                -- prev1 = self.get(x - 2, y)

                prev21 = self.get(x, y - 1)
                prev22 = self.get(x, y + 1)
                if curr == prev1 and (curr == prev21 or curr == prev22) then
                    return true
                end
            end
        end

        return false;
    end

    hasVertPossibleMatches = function()
        for x = 1, width do
            for y = 3, height do
                -- cases where X is possible match gem
                -- firts   second  third
                -- OOX       OXO     OXO
                -- OXO       OOX     OXO
                -- OXO       OXO     OOX
                local curr = self.get(x, y)
                local prev1 = self.get(x, y - 1)

                local prev21 = self.get(x + 1, y - 2)
                local prev22 = self.get(x - 1, y - 2)
                if curr == prev1 and (curr == prev21 or curr == prev22) then
                    return true
                end

                -- curr = self.get(x, y)
                prev1 = self.get(x, y - 2)

                prev21 = self.get(x - 1, y - 1)
                prev22 = self.get(x + 1, y - 1)
                if curr == prev1 and (curr == prev21 or curr == prev22) then
                    return true
                end
                curr = self.get(x, y - 1)
                -- prev1 = self.get(x, y-2)

                prev21 = self.get(x - 1, y)
                prev22 = self.get(x + 1, y)
                if curr == prev1 and (curr == prev21 or curr == prev22) then
                    return true
                end
            end
        end

        return false;
    end

    return self
end

return Game

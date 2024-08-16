Point = {}

Point.new = function (x_, y_)
    local self = setmetatable({}, Point)
    self.x = x_
    self.y = y_
    return self
end

return Point

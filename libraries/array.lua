local Array = {}

function Array:new(width, height)
    self.cells = {}
    self.width = width
    self.height = height

    return self
end

function Array:set(x, y, value)
    if x <= self.width and y <= self.height then
        self.cells[((y-1)*self.width)+x] = value
    else
        error("[Array] Out of bounds error")
    end
end

function Array:get(x, y)
    return self.cells[((y-1)*self.width)+x]
end

function Array:length()
    local length = 0
    for _, item in ipairs(self.cells) do
        if item ~= nil then
            length = length + 1
        end
    end

    return length
end

function Array:apairs()
    local function apairs(self, i)
        while i <= self.width*self.height do
            i = i+1
            local x = ((i-1)%self.width) + 1
            local y = math.floor((i-1)/self.width) + 1
            local v = self.cells[i]
            if v ~= nil then
                return i, x, y, v
            end
        end
        return nil
    end

    return apairs, self, 0
end

return Array

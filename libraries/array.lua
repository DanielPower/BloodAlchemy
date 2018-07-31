local Array = {}

function Array.new(width, height)
    assert(
        Array._checkDimensions(width, height),
        'Invalid dimensions ('..tostring(width)..', '..tostring(height)..')'
    )

    local self = {}
    self._cells = {}
    self.width = width
    self.height = height

    -- Index metatable for an Array
    -- Returns another table with its own index metatable, allowing two-
    -- dimensional array access.
    local function index(table, x)
        if type(x) == 'number' then
            local subtable = {}

            local function subindex(_, y)
                return table:get(x, y)
            end

            local function subnewindex(_, y, v)
                return table:set(x, y, v)
            end

            setmetatable(subtable, {
                __index=subindex,
                __newindex=subnewindex,
            })

            return subtable
        else
            return Array[x]
        end
    end

    setmetatable(self, {__index=index})
    return self
end


function Array:set(x, y, value)
    assert(
        self:_checkIndex(x, y),
        "Given index is invalid"
    )
    self._cells[((y-1)*self.width)+x] = value
end


function Array:get(x, y)
    if not self:_checkIndex(x, y) then
        return nil
    else
        return self._cells[((y-1)*self.width)+x]
    end
end


function Array:length()
    local length = 0
    for _, item in apairs(self._cells) do
        length = length + 1
    end

    return length
end


function Array:find(target)
    for i, x, y, item in self:apairs() do
        if item == target then
            return i, x, y
        end
    end
end


function Array:findAll(target, limit)
    local found = {}
    for i, x, y, item in self:apairs() do
        if item == target then
            table.insert(found, {i, x, y})
            if #found == limit then
                return found
            end
        end
    end

    return found
end


function Array:apairs()
    local function apairs(self, i)
        while i <= self.width*self.height do
            i = i+1
            local x = ((i-1)%self.width) + 1
            local y = math.floor((i-1)/self.width) + 1
            local v = self._cells[i]
            if v ~= nil then
                return i, x, y, v
            end
        end
        return nil
    end

    return apairs, self, 0
end


-- Check if the given dimensions are valid
-- Ensure dimensions are integers
function Array._checkDimensions(width, height)
    return (
        type(width) == 'number'
        and type(width) == 'number'
        and Array._isInt(width)
        and Array._isInt(height)
    )
end


-- Check if the given index is valid
-- Ensure index is an integer and is within valid bounds
function Array:_checkIndex(x, y)
    if x > 0 and x <= self.width
    and y > 0 and y <= self.height
    and Array._isInt(x)
    and Array._isInt(y) then
        return true
    else
        return false
    end
end


-- Check if the input is an integer
-- Prevents invalid array indices
function Array._isInt(x)
    if x == math.floor(x) then
        return true
    else
        return false
    end
end


-- Call metatable
-- Allows an array to be created using function format
--      Example: a = Array(width, height)
local function call(_, width, height)
    return Array.new(width, height)
end

setmetatable(Array, {
    __call=call,
})

return Array
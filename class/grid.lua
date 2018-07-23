local class = require('libraries/middleclass')
local array = require('libraries/array')

local Grid = class('Grid')

function Grid:create(width, height, cellSize)
    self.cells = array:new(width, height)
    self.cellSize = cellSize
end

function Grid:set(x, y, item)
	local oldItem = self.cells:get(x, y)

	self.cells:set(x, y, item)

	if oldItem then
		return oldItem
	end
end

function Grid:get(x, y)
    return self.cells:get(x, y)
end

function Grid:getFromScreen(x, y)
    local cellX, cellY = self:toGrid(x, y)
    return self:get(cellX, cellY)
end

function Grid:find(item)
    for _, x, y, v in self.cells:apairs() do
        if v == item then
            return x, y, item
        end
    end
end

function Grid:toGrid(x, y)
    local cellX = math.floor(x / self.cellSize) + 1
    local cellY = math.floor(y / self.cellSize) + 1

    return cellX, cellY
end

function Grid:toScreen(cellX, cellY)
    local x = (cellX-1)*self.cellSize
    local y = (cellY-1)*self.cellSize

    return x, y
end

function Grid:mousepressed(x, y, button)
    local cellX, cellY= self:toGrid(x, y)
    local item = self:get(cellX, cellY)
    if item and item.mousepressed then
        item:mousepressed(cellX, cellY, button)
    end

    return cellX, cellY, item
end

return Grid

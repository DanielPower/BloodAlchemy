local Array = require('libraries/array')

local Grid = {}


function Grid.new(width, height, cellSize)
	local self = {}
	self.cellSize = cellSize
	self.array = Array.new(width, height)

	local function index(table, x)
		if Grid[x] then
			return Grid[x]
		else
			return table.array[x]
		end
	end

	setmetatable(self, {
		__index=index,
	})

	return self
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


-- Call metatable
-- Allows a grid to be created using function format
--      Example: a = Grid(width, height, cellSize)
local function call(_, width, height, cellSize)
	return Grid.new(width, height, cellSize)
end

setmetatable(Grid, {
	__call=call,
})

return Grid
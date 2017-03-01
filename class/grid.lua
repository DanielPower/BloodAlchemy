local Grid = Lib.class('Grid')

function Grid:create(width, height, cellSize)
    Lib.barrack.check({width, height, cellSize}, {'int', 'int', 'int'})
    self.cells = Lib.array:new(width, height)
    self.cellSize = cellSize
end

function Grid:set(x, y, item)
    Lib.barrack.check({x, y}, {'int', 'int'})
	local oldItem = self.cells:get(x, y)

	self.cells:set(x, y, item)

	if oldItem then
		return oldItem
	end
end

function Grid:get(x, y)
    Lib.barrack.check({x, y}, {'int', 'int'})
    return self.cells:get(x, y)
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
    local mouseX, mouseY = self.scene.camera:toWorld(x, y)
    local cellX, cellY= self:toGrid(mouseX, mouseY)
    local item = self:get(cellX, cellY)
    if item and item.mousepressed then
        item:mousepressed(cellX, cellY, button)
    end

    return cellX, cellY, item
end

return Grid

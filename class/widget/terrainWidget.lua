local class = require('libraries/middleclass')

local Widget = require('class/widget')

local TerrainWidget = class('TerrainWidget', Widget)

function TerrainWidget:create()
    Widget.create(self, 80, 24)
    self.location = 'left'
end

function TerrainWidget:update()
    local grid = self.scene.grid
    local map = self.scene.map
    local camera = self.scene.interface.camera

    local mouseX, mouseY = camera:toWorld(love.mouse.getPosition())
    local cellX, cellY = grid:toGrid(mouseX, mouseY)

    for layer=#map.layers, 0, -1 do
        if (cellX > 0) and (cellY > 0) and (cellX <= grid.width) and (cellY <= grid.height) then
            if map.layers[layer].data and map.layers[layer].data[cellY] and map.layers[layer].data[cellY][cellX] then
                self.tile = map.layers[layer].data[cellY][cellX]
                break
            end
        end
    end
end

function TerrainWidget:draw(x, y, scale)
    if self.tile then
        Widget.draw(self, x, y, scale)
        love.graphics.draw(Res.tileset, self.tile.quad, x+(4*scale), y+(4*scale), 0, scale)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(Res.font)
        if self.tile.properties.name then
            love.graphics.print(self.tile.properties.name, x+(26*scale), y+(4*scale))
        end
        if not self.tileIsWall then
            love.graphics.print('Move Cost: '..(self.tile.properties.movementCost or 1), x+(26*scale), y+(12*scale))
        end
        love.graphics.setColor(1, 1, 1, 1)

        return true
    end
end

return TerrainWidget

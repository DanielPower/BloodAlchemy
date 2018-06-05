local TerrainWidget = Lib.class('TerrainWidget', Class.widget)

function TerrainWidget:create()
    Class.widget.create(self, 80, 24)
    self.location = 'left'
end

function TerrainWidget:update(dt)
    local grid = self.scene.grid
    local map = self.scene.map

    local mouseX, mouseY = self.scene.camera:toWorld(love.mouse.getPosition())
    local cellX, cellY = grid:toGrid(mouseX, mouseY)

    for layer=#map.layers, 0, -1 do
        if (cellX > 0) and (cellY > 0) and (cellX <= grid.cells.width) and (cellY <= grid.cells.height) then
            if map.layers[layer].data[cellY] and map.layers[layer].data[cellY][cellX] then
                self.tile = map.layers[layer].data[cellY][cellX]
                self.tileIsWall = (map.layers['Wall'].data[cellY][cellX] ~= nil)
                break
            end
        end
    end
end

function TerrainWidget:draw(x, y, scale)
    if self.tile then
        Class.widget.draw(self, x, y, scale)
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

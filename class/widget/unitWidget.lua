local UnitWidget = Lib.class('Widget', Class.widget)

function UnitWidget:create()
    Class.widget.create(self, 80, 32)
end

function UnitWidget:update(dt)
    local grid = self.scene.grid
    local selected = self.scene.selected
    local mouseX, mouseY = self.scene.camera:toWorld(love.mouse.getPosition())
    local cellX, cellY = grid:toGrid(mouseX, mouseY)

    if selected then
        self.hovered = grid:get(selected.x, selected.y)
    else
        self.hovered = grid:get(cellX, cellY)
    end
end

function UnitWidget:draw(x, y, scale)
    if self.hovered then
        local unit = self.hovered

        -- Draw Background
        Class.widget.draw(self, x, y, scale)

        -- Draw unit image
        love.graphics.draw(Res.tileset, unit.quad, x+(4*scale), y+(12*scale), 0, scale)

        -- Draw text
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.setFont(Res.font)
        love.graphics.print(unit.class.name, x+(4*scale), y+(1*scale))
        love.graphics.print("Health: ", x+(24*scale), y+(8*scale))
        love.graphics.print((unit.hp..' / '..unit.maxHp), x+(56*scale), y+(8*scale))
        love.graphics.print("Energy: ", x+(24*scale), y+(18*scale))
        love.graphics.print((unit.movementPoints..' / '..unit.moveSpeed), x+(56*scale), y+(18*scale))
        love.graphics.setColor(255, 255, 255, 255)

        -- Draw health and energy bar
        self:drawBar(x+(24*scale), y+(15*scale), 52*scale, 3*scale, (unit.hp/unit.maxHp), {255, 10, 10, 255}, {58, 43, 35, 255})
        self:drawBar(x+(24*scale), y+(25*scale), 52*scale, 3*scale, (unit.movementPoints/unit.moveSpeed), {234, 149, 20, 255}, {58, 43, 35, 255})

        return true
    end
end

return UnitWidget

local class = require('libraries/middleclass')

local Widget = require('class/widget')

local UnitWidget = class('Widget', Widget)
UnitWidget.healthFillColor = {1.000, 0.039, 0.039, 1.000}
UnitWidget.healthOutlineColor = {0.227, 0.169, 0.137, 1.000}
UnitWidget.energyFillColor = {0.918, 0.584, 0.078, 1.000}
UnitWidget.energyOutlineColor = {0.227, 0.169, 0.137, 1.000}

function UnitWidget:create()
    Widget.create(self, 80, 32)
end

function UnitWidget:update(dt)
    local grid = self.scene.grid
    local selected = self.scene.selected
    local camera = self.scene.interface.camera

    local mouseX, mouseY = camera:toWorld(love.mouse.getPosition())
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
        Widget.draw(self, x, y, scale)

        -- Draw unit image
        love.graphics.draw(Res.tileset, unit.quad, x+(4*scale), y+(12*scale), 0, scale)

        -- Draw text
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(Res.font)
        love.graphics.print(unit.class.name, x+(4*scale), y+(1*scale))
        love.graphics.print("Health: ", x+(24*scale), y+(8*scale))
        love.graphics.print((unit.hp..' / '..unit.maxHp), x+(56*scale), y+(8*scale))
        love.graphics.print("Energy: ", x+(24*scale), y+(18*scale))
        love.graphics.print((unit.movementPoints..' / '..unit.moveSpeed), x+(56*scale), y+(18*scale))
        love.graphics.setColor(1, 1, 1, 1)

        -- Draw health and energy bar
        self:drawBar(x+(24*scale), y+(15*scale), 52*scale, 3*scale, (unit.hp/unit.maxHp), self.healthFillColor, self.healthOutlineColor)
        self:drawBar(x+(24*scale), y+(25*scale), 52*scale, 3*scale, (unit.movementPoints/unit.moveSpeed), self.energyFillColor, self.energyOutlineColor)

        return true
    end
end

return UnitWidget

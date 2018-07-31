local class = require('libraries/middleclass')

local Widget = require('class/widget')

local CardWidget = class('CardWidget', Widget)
CardWidget.slotColor = {0.38, 0.27, 0.17, 0.75}
CardWidget.expanderColor = {}


function CardWidget:create()
    Widget.create(self, 92, 24)
    self.expand = true
end

function CardWidget:mousepressed(x, y, button)
    -- local camera = self.scene.interface.camera

    -- local mouseX, mouseY = camera:toWorld(x, y)
    -- if (mouseX > self.x) and (mouseX < self.x + self.width)
    -- and (mouseY > self.y) and (mouseY < self.y + 4) then
    --     self.expand = not self.expand
    -- end

    -- if (mouseX > self.x) and (mouseX < self.x + self.width)
    -- and (mouseY > self.y) and (mouseY < self.y + self.height) then
    --     return true
    -- else
    --     return false
    -- end
end

function CardWidget:draw(scale)
    local x = (love.graphics.getWidth()/2) - (self.width*scale/2)
    local y
    if self.expand then
        y = love.graphics.getHeight() - (self.height*scale)
    else
        y = love.graphics.getHeight() - (4*scale)
    end

    Widget.draw(self, x, y, scale)
    love.graphics.setColor(self.slotColor)
    love.graphics.line(x, y+(4*scale), x+(self.width*scale), y+(4*scale))
    love.graphics.rectangle('fill', x+(2*scale), y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', x+(20*scale), y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', x+(38*scale), y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', x+(56*scale), y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', x+(74*scale), y+(6*scale), 16*scale, 16*scale)
    love.graphics.setColor(1, 1, 1, 1)

    local scene = self.scene
    local hand = scene.team[scene.activeTeam].hand
    for i, card in ipairs(hand) do
        love.graphics.draw(card.image, x+(2+18*(i-1))*scale, y + (6*scale), 0, scale)
    end
end

return CardWidget

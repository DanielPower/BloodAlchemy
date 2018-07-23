local class = require('libraries/middleclass')

local Widget = require('class/widget')

local CardWidget = class('CardWidget', Widget)
CardWidget.slotColor = {0.38, 0.27, 0.17, 0.75}
CardWidget.expanderColor = {}


function CardWidget:create(camera)
    Widget.create(self, 92, 24)
    self.x = 0
    self.y = 0
    self.camera = camera
    self.expand = true
end

function CardWidget:mousepressed(x, y, button)
    local mouseX, mouseY = self.camera:toWorld(x, y)
    if (mouseX > self.x) and (mouseX < self.x + self.width)
    and (mouseY > self.y) and (mouseY < self.y + 4) then
        self.expand = not self.expand
        print(self.expand)
    end

    if (mouseX > self.x) and (mouseX < self.x + self.width)
    and (mouseY > self.y) and (mouseY < self.y + self.height) then
        return true
    else
        return false
    end
end

function CardWidget:update(dt)
    local scale = self.camera.scale
    self.x = (love.graphics.getWidth()/2) - (self.width*scale/2)
    if self.expand then
        self.y = love.graphics.getHeight() - (self.height*scale)
    else
        self.y = love.graphics.getHeight() - (4*scale)
    end
end

function CardWidget:draw()
    local scale = self.camera.scale

    Widget.draw(self, self.x, self.y, scale)
    love.graphics.setColor(self.slotColor)
    love.graphics.line(self.x, self.y+(4*scale), self.x+(self.width*scale), self.y+(4*scale))
    love.graphics.rectangle('fill', self.x+(2*scale), self.y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', self.x+(20*scale), self.y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', self.x+(38*scale), self.y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', self.x+(56*scale), self.y+(6*scale), 16*scale, 16*scale)
    love.graphics.rectangle('fill', self.x+(74*scale), self.y+(6*scale), 16*scale, 16*scale)
    love.graphics.setColor(1, 1, 1, 1)

    local scene = self.scene
    local hand = scene.team[scene.activeTeam].hand
    for i, card in ipairs(hand) do
        love.graphics.draw(card.image, self.x+(2+18*(i-1))*scale, self.y + (6*scale), 0, scale)
    end
end

return CardWidget

local class = require('libraries/middleclass')
local hitIndicator = class('hitWidget')

function hitIndicator:create(x, y, num, time, color)
    self.x = x
    self.y = y
    self.num = num
    self.time = time
    self.color = color or {255, 255, 255, 255}
    self.text = love.graphics.newText(Res.font, num)
end

function hitIndicator:update(dt)
    self.time = self.time - dt
    if self.time <= 0 then
        self.scene:destroyInstance(self)
    end
end

function hitIndicator:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.text, self.x, self.y)
end

return hitIndicator

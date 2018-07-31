local class = require('libraries/middleclass')

local Widget = require('class/widget')

local DialogWidget = class('DialogWidget', Widget)

function DialogWidget:create()
	Widget.create(self, 232, 40)
end

function DialogWidget:draw(scale)
	local x = (love.graphics.getWidth()/2) - (self.width*scale/2)
	local y = love.graphics.getHeight() - (self.height*scale) - 4*scale

	Widget.draw(self, x, y, scale)
end

return DialogWidget
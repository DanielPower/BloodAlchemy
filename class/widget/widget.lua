local Widget = Lib.class('Widget')
Widget.background = {193, 186, 111, 192}
Widget.outline = {62, 60, 39, 192}

function Widget:create(width, height)
    self.width = width
    self.height = height
end

function Widget:draw(x, y, scale)
    love.graphics.setColor(unpack(self.background))
    love.graphics.rectangle('fill', x, y, self.width*scale, self.height*scale)
    love.graphics.setColor(unpack(self.outline))
    love.graphics.rectangle('line', x, y, self.width*scale, self.height*scale)
    love.graphics.setColor(255, 255, 255, 255)
end

function Widget:drawBar(x, y, width, height, state, fill, outline)
    local fill = fill or {255, 0, 0, 255}
    local outline = outline or {0, 0, 0, 255}

    love.graphics.setColor(unpack(fill))
    love.graphics.rectangle('fill', x, y, width*state, height)
    love.graphics.setColor(unpack(outline))
    love.graphics.rectangle('line', x, y, width, height)
    love.graphics.setColor(255, 255, 255, 255)
end

return Widget

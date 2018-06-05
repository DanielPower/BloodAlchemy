local Widget = Lib.class('Widget')
Widget.background = {0.76, 0.73, 0.43, 0.75}
Widget.outline = {0.24, 0.24, 0.15, 0.75}

function Widget:create(width, height)
    self.width = width
    self.height = height
end

function Widget:draw(x, y, scale)
    love.graphics.setColor(unpack(self.background))
    love.graphics.rectangle('fill', x, y, self.width*scale, self.height*scale)
    love.graphics.setColor(unpack(self.outline))
    love.graphics.rectangle('line', x, y, self.width*scale, self.height*scale)
    love.graphics.setColor(1, 1, 1, 1)
end

function Widget:drawBar(x, y, width, height, state, fill, outline)
    local fill = fill or {1, 0, 0, 1}
    local outline = outline or {0, 0, 0, 1}

    love.graphics.setColor(unpack(fill))
    love.graphics.rectangle('fill', x, y, width*state, height)
    love.graphics.setColor(unpack(outline))
    love.graphics.rectangle('line', x, y, width, height)
    love.graphics.setColor(1, 1, 1, 1)
end

return Widget

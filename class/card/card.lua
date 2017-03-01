local Card = Lib.class('Card')

function Card:draw(x, y, size)
    love.graphics.draw(self.image, x, y, 0, size)
end

return Card

return function(tileset, x, y, width, height)
    return love.graphics.newQuad(3+(x-1)*(width+2), 3+(y-1)*(height+2), width, height, tileset:getDimensions())
end

local scene = Class.scene:new()

function scene:begin(args)
    self.scene1 = args[1]
    self.scene2 = args[2]
    self.length = args[3]
    self.onComplete = args[4]
    self.time = 0
end

function scene:update(dt)
    self.time = self.time + dt
    if self.time >= self.length then
        if self.onComplete then
            self:onComplete() -- Run callback function
        end
        activeScene = self.scene2 -- Switch to the new scene
        love.graphics.setBlendMode("alpha") -- Return blending to normal
        love.graphics.setColor(255, 255, 255, 255) -- Return draw color to normal
    end
end

function scene:draw()
    local canvas = love.graphics.newCanvas()
    local opacity = 255*(1-(self.time/self.length))

    -- Draw Scene 2 to screen
    self.scene2:draw()

    -- Draw Scene 1 to canvas
    love.graphics.setCanvas(canvas)
    love.graphics.setColor(255, 255, 255, 255)
    self.scene1:draw()

    -- Draw Scene 1 to screen
    love.graphics.setCanvas()
    love.graphics.setColor(255, 255, 255, opacity)
    love.graphics.draw(canvas)
end

return scene

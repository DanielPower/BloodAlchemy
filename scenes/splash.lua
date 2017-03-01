local scene = Class.scene:new()
function scene:remove()
    self = nil
end

function scene:begin()
    local splash = require("libraries/splash")
    self.splashScreen = splash.new({fill='lighten'})
    self.splashScreen.onDone = function()
        activeScene = Class.scene:load("scenes/transition", self, Scene.game, 0.5, self:remove())
    end
end

function scene:update(dt)
    self.splashScreen:update(dt)
end

function scene:draw()
    self.splashScreen:draw()
end

function scene:keyreleased(key)
    activeScene = Class.scene:load("scenes/transition", self, Scene.game, 0.5, self:remove())
end

function scene:mousereleased(key)
    activeScene = Class.scene:load("scenes/transition", self, Scene.game, 0.5, self:remove())
end

return scene

local class = require('libraries/middleclass')
local CameraController = class('CameraController')

function CameraController:create(camera)
    self.camera = camera
	self.camera:setScale(Game.scale)
	self.gameScale = 1
end

function CameraController:mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(3) then
        local cameraX = self.camera.x - (dx/self.camera.scale)
		local cameraY = self.camera.y - (dy/self.camera.scale)
		self.camera:setPosition(cameraX, cameraY)
	end
end

function CameraController:wheelmoved(x, y)
    self.gameScale = self.gameScale + (y*0.1)
    if self.gameScale < 0.5 then
        self.gameScale = 0.5
    elseif self.gameScale > 3 then
        self.gameScale = 3
    end
    self:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function CameraController:resize(w, h)
    self.scene.map:resize(w, h)
    self.camera:setWindow(0, 0, w, h)
    if (w/Game.width) < (h/Game.height) then
        self.camera:setScale((w/Game.width)*self.gameScale)
    else
        self.camera:setScale((h/Game.height)*self.gameScale)
    end
    Res.font = love.graphics.newFont('resources/font.ttf', 8*self.camera.scale)
end

return CameraController

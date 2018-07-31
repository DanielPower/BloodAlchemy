local gamera = require('libraries/gamera')
local class = require('libraries/middleclass')

local CameraController = class('CameraController')

function CameraController:create(camera)
    self.gameWidth = 240
    self.gameHeight = 160
    self.viewScale = 1
    self.camera = gamera.new(0, 0, 240, 160)

    self:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function CameraController:mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(3) then
        local cameraX = self.camera.x - (dx/self.camera.scale)
		local cameraY = self.camera.y - (dy/self.camera.scale)
		self.camera:setPosition(cameraX, cameraY)
	end
end

function CameraController:wheelmoved(x, y)
    self.viewScale = self.viewScale + (y*0.1)
    if self.viewScale < 1 then
        self.viewScale = 1
    elseif self.viewScale > 3 then
        self.viewScale = 3
    end
    self:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function CameraController:resize(w, h)
    self.scene.map:resize(w, h)
    self.camera:setWindow(0, 0, w, h)
    if (w/self.gameWidth) < (h/self.gameHeight) then
        self.camera:setScale((w/self.gameWidth)*self.viewScale)
        self.winScale = w/self.gameWidth
    else
        self.camera:setScale((h/self.gameHeight)*self.viewScale)
        self.winScale = h/self.gameHeight
    end
    Res.font = love.graphics.newFont('resources/font.ttf', 8*self.winScale)
end

return CameraController

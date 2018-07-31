local Scene = require('class/scene')

love.graphics.setDefaultFilter("nearest")
-- Debug
inspect = require('libraries/inspect')

-- Global variables
Game = {}
Game.width = 240
Game.height = 160

-- Load Resources
Res = {}
Res.tileset = love.graphics.newImage('resources/tileset.png')
Res.smallFont = love.graphics.newFont('resources/font.ttf', 4)
Res.font = love.graphics.newFont('resources/font.ttf', 8)
Res.bigFont = love.graphics.newFont('resources/font.ttf', 72)

-- Initialize Scenes
activeScene = Scene:load('class/scene/game')

function love.mousepressed(x, y, button)
	activeScene:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	activeScene:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
	activeScene:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	activeScene:wheelmoved(x, y)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	activeScene:keypressed(key)
end

function love.keyreleased(key)
	activeScene:keyreleased(key)
end

function love.resize(w, h)
	activeScene:resize(w, h)
end

function love.update(dt)
	activeScene:update(dt)
end

function love.draw()
	love.graphics.setColor(1, 1, 1, 1)
	activeScene:draw()

	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print( love.timer.getFPS(), 5, 5)
	love.graphics.setColor(1, 1, 1, 1)
end

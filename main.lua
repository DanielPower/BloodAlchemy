love.graphics.setDefaultFilter("nearest")
-- Global variables
Game = {}
Game.scale = 1
Game.width = 240
Game.height = 160

-- Import Libraries
Lib = {}
Lib.array = require('libraries/array')
Lib.barrack = require('libraries/barrack'); Lib.barrack.enable()
Lib.class = require('libraries/middleclass')
Lib.inspect = require('libraries/inspect')
Lib.pathfinder = require('libraries/pathfinder')
Lib.sti = require('libraries/sti')
Lib.cpml = require('libraries/cpml')
Lib.gamera = require('libraries/gamera')
Lib.getQuad = require('libraries/getQuad')

-- Load Resources
Res = {}
Res.tileset = love.graphics.newImage('resources/tileset.png')
Res.smallFont = love.graphics.newFont('resources/font.ttf', 4*Game.scale)
Res.font = love.graphics.newFont('resources/font.ttf', 8*Game.scale)
Res.bigFont = love.graphics.newFont('resources/font.ttf', 72)

-- Include Classes
Class = {}
Class.scene = require('class/scene')
Class.unit = require('class/unit/unit')
	Class.archer = require('class/unit/archer')
	Class.militia = require('class/unit/militia')
	Class.knight = require('class/unit/knight')
	Class.mountedKnight = require('class/unit/mountedKnight')
Class.grid = require('class/grid')
Class.widget = require('class/widget/widget')
	Class.unitWidget = require('class/widget/unitWidget')
	Class.terrainWidget = require('class/widget/terrainWidget')
	Class.cardWidget = require('class/widget/cardWidget')
Class.deck = require('class/deck')
Class.card = require('class/card/card')
Class.cardFireball = require('class/card/fireball')
Class.cameraController = require('class/control/camera')
Class.desktop = require('class/interface/desktop')
Class.hitIndicator = require('class/interface/hitIndicator')

-- Initialize Scenes
Scene = {}
Scene.game = Class.scene:load('scenes/game')

activeScene = Scene.game

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
end

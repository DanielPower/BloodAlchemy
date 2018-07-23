local sti = require('libraries/sti')
local pathfinder = require('libraries/pathfinder')

local Deck = require('class/deck')
local Desktop = require('class/interface/desktop')
local Grid = require('class/grid')
local Scene = require('class/scene')

-- Units
local Archer = require('class/unit/archer')
local Knight = require('class/unit/knight')
local Militia = require('class/unit/militia')
local MountedKnight = require('class/unit/mountedKnight')

-- Cards
local CardFireball = require('class/card/fireball')

local scene = Scene:new()

function scene:begin()
	-- Setup Map and Camera
	self:loadMap('resources/map.lua')

	-- Setup Gui
	self.interface = self:newInstance(Desktop, {})

	-- Setup Player Decks
	self.team = {}
	self.team[1] = {deck = Deck:new(CardFireball:new()), hand = {}}
	self.team[2] = {deck = Deck:new(), hand = {}}

	-- Setup Game
	self.turn = 0
	self:beginTurn()
	self.mode = "select"
end

-- Scene Functions
function scene:loadMap(file)
	-- Load STI Map
	self.map = sti(file)
	self.grid = self:newInstance(Grid, {self.map.width, self.map.height, 16}, 'update', 'draw')
	for x=1, self.map.width do
		for y=1, self.map.height do
			if self.map.layers['Unit'].data[y][x] then
				local unitTypes = {
					archer = Archer,
					knight = Knight,
					militia = Militia,
					mountedKnight = MountedKnight,
				}
				local properties = self.map:getTileProperties('Unit', x, y)
				local unit = self:newInstance(unitTypes[properties.type], {self.grid, x, y, properties.team}, 'draw', 'turn')
				unit.quad = self.map.layers['Unit'].data[y][x].quad
			end
		end
	end
	self.map:removeLayer('Unit')

	-- Setup nodes for pathfinding
	self.nodes = {}
	for x=1, self.map.width do
		for y=1, self.map.height do
			if not self.map.layers['Wall'].data[y][x] then
				local gCost = self.map:getTileProperties('Main', x, y).movementCost
				pathfinder.getNode(self.nodes, x, y, gCost)
			end
		end
	end	self:resize(love.graphics.getWidth(), love.graphics.getHeight())
	pathfinder.setupNeighbors(self.nodes)
end

-- Event Functions
function scene:mousepressed(x, y, button)
	self.interface:mousepressed(x, y, button)
	self:exec('mouse', 'mousepressed', x, y, button)
end

function scene:mousemoved(x, y, dx, dy, istouch)
	self:exec('mouse', 'mousemoved', x, y, dx, dy, istouch)
end

function scene:wheelmoved(x, y)
	self:exec('mouse', 'wheelmoved', x, y)
end

function scene:keypressed(key)
	self:exec('keyboard', 'keypressed', key)

	if key == 'space' then
		self:beginTurn(self.turn+1)
	end
end

function scene:keyreleased(key)
	self:exec('keyboard', 'keyreleased', key)
end

function scene:resize(w, h)
	self:exec('resize', 'resize', w, h)
end

function scene:update(dt)
	self:exec('update', 'update', dt)
end

function scene:draw()
	self.interface:draw()
end

function scene:beginTurn()
	self.turn = self.turn + 1
	self.activeTeam = ((self.turn-1)%2)+1
	self.selected = nil
	print("Beginning turn "..self.turn)
	self:exec('turn', 'beginTurn', self.activeTeam)

	local hand = self.team[self.activeTeam].hand
	local deck = self.team[self.activeTeam].deck
	if #hand < 5 then
		table.insert(hand, deck:pull())
	end
end

return scene

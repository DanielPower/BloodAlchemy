local class = require('libraries/middleclass')
local gamera = require('libraries/gamera')
local getQuad = require('libraries/getQuad')

local CameraController = require('class/control/camera')
local TerrainWidget = require('class/widget/terrainWidget')
local UnitWidget = require('class/widget/unitWidget')
local CardWidget = require('class/widget/cardWidget')

local Desktop = class('Interface')

function Desktop:create()
	self.mode = "normal"

	local scene = self.scene

	-- Setup Map and Camera
	self.camera = gamera.new(0, 0, Game.width, Game.height)
	self.cameraController = scene:newInstance(CameraController, {self.camera}, 'mouse', 'resize')

	self.unitWidget = scene:newInstance(UnitWidget, {self.camera}, 'update')
	self.terrainWidget = scene:newInstance(TerrainWidget, {self.camera}, 'update')
	self.cardWidget = scene:newInstance(CardWidget, {self.camera}, 'update', 'mouse')
	self.widgetX = 4*self.camera:getScale()
end

function Desktop:mousepressed(x, y, button)
	local scene = self.scene
	local grid = self.scene.grid

	local screenX, screenY = self.camera:toWorld(x, y)
	local cellX, cellY, item = grid:mousepressed(screenX, screenY, button)

	if self.mode == "normal" then
		if button == 1 then
			if scene.selected then
				local unit = grid:get(scene.selected.x, scene.selected.y)
				if item then
					if item.team == scene.activeTeam then
						scene.selected = {x=cellX, y=cellY}
					else
						for _, target in ipairs(unit.attackable) do
							if (target.x == item.x) and (target.y == item.y) then
								unit:attack(target)
							end
						end
						scene.selected = nil
					end
				elseif not unit.rest then
					for _, node in ipairs(unit.walkable.closedNodes) do
						if node.x == cellX and node.y == cellY then
							unit:move(node)
							break
						end
					end
					scene.selected = nil
				end
			else
				if item then
					if item.team == scene.activeTeam and not item.rest then
						scene.selected = {x=cellX, y=cellY}
					end
				end
			end
		end
	elseif self.mode == "target" then
		if self.target.validTarget(item) then
			self.target.callback(item, unpack(self.target.args))
		end
		self.mode = "normal"
	end
end

function Desktop:draw()
	local scene = self.scene
	local grid = self.scene.grid

	self.camera:draw( function()
		self.scene.map:draw()
		self.scene:exec('draw', 'draw')

		if scene.selected then
			local selected = grid:get(scene.selected.x, scene.selected.y)

			-- Draw walkable tiles
			if selected.walkable and selected.walkable.closedNodes then
				for _, node in ipairs(selected.walkable.closedNodes) do
					local draw = true
					-- If there is a unit on this tile, don't draw it as walkable.
					-- SHITTY CODE, UPDATE ME
					for _, x, y in grid.cells:apairs() do
						if node.x == x and node.y == y then
							draw = false
						end
					end
					if draw == true then
						love.graphics.setColor(0, 0, 0.75, 0.25)
						love.graphics.rectangle('fill', (node.x-1)*16, (node.y-1)*16, 16, 16)
						love.graphics.setColor(1, 1, 1, 1)
					end
				end
			end

			-- Outline attackable enemies
			if selected.attackable then
				for _, node in ipairs(selected.attackable) do
					love.graphics.setColor(0.75, 0, 0, 0.75)
					love.graphics.rectangle('line', (node.x-1)*16, (node.y-1)*16, 16, 16)
					love.graphics.setColor(1, 1, 1, 1)
				end
			end

			-- Draw cursor
			local x, y = grid:toScreen(scene.selected.x, scene.selected.y)
			local quad = getQuad(Res.tileset, 4, 43, 16, 16)
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(Res.tileset, quad, x, y)
		end
	end)

	self:drawGui()
end

function Desktop:drawGui()
	local scale = self.camera.scale
	local y = 4*scale

	local mouseX, mouseY = love.mouse.getPosition()
	if mouseX < (self.terrainWidget.width+8)*scale then
		self.widgetX = love.graphics.getWidth()-((self.terrainWidget.width+8)*scale)
	elseif mouseX > (Game.width-self.terrainWidget.width-8)*scale then
		self.widgetX = 4*scale
	end

	self.cardWidget:draw()
	if self.terrainWidget:draw(self.widgetX, y, scale) then
		y = y + (self.terrainWidget.height+4)*scale
	end

	if self.unitWidget:draw(self.widgetX, y, scale) then
		y = y + (self.unitWidget.height+4)*scale
	end
end

function Desktop:getTarget(validTarget, callback, ...)
	self.mode = "target"
	self.target = {
		validTarget = validTarget,
		callback = callback,
		args = {...}
	}
end

return Desktop

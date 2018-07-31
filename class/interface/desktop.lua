local class = require('libraries/middleclass')
local gamera = require('libraries/gamera')
local getQuad = require('libraries/getQuad')

local CameraController = require('class/control/camera')
local TerrainWidget = require('class/widget/terrainWidget')
local UnitWidget = require('class/widget/unitWidget')
local CardWidget = require('class/widget/cardWidget')
local DialogWidget = require('class/widget/dialogWidget')

local Desktop = class('Interface')

function Desktop:create()
	local scene = self.scene

	-- Setup Map and Camera
	self.cameraController = scene:newInstance(CameraController, {}, 'mousemoved', 'mousewheel', 'resize')
	self.camera = self.cameraController.camera

	self.unitWidget = scene:newInstance(UnitWidget, {}, 'update')
	self.terrainWidget = scene:newInstance(TerrainWidget, {}, 'update')
	self.cardWidget = scene:newInstance(CardWidget, {}, 'mousepressed')
	self.dialogWidget = scene:newInstance(DialogWidget, {})
	self.widgetX = 4*self.camera:getScale()

	self.mode = "normal"

	self.cursors = self:generateCursors(self.cameraController.winScale)
end

function Desktop:mousepressed(x, y, button)
	local scene = self.scene
	local grid = self.scene.grid

	local screenX, screenY = self.camera:toWorld(x, y)
	local cellX, cellY = grid:toGrid(screenX, screenY)
	local item = grid[cellX][cellY]
	if item and item.mousepressed then
		item:mousepressed(cellX, cellY, button)
	end

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
		love.mouse.setCursor(self.cursors.normal1)
		if self.target.validTarget(item) then
			self.target.callback(item, unpack(self.target.args))
		end
		self.mode = "normal"
	end
end

function Desktop:keypressed(key)
	local scene = self.scene

	if key == 'space' then
		scene:beginTurn(scene.turn+1)
	end

	if key == 't' then
		self:getTarget(
		function()
			return true
		end,
		function(target, arg)
			print(target);print(arg)
		end,
		'foo')
	end

	if key == 'd' then
		if self.mode == 'dialog' then
			self.mode = 'normal'
		else
			self.mode = 'dialog'
		end
	end
end

function Desktop:resize(w, h)
	self.cursors = self:generateCursors(self.cameraController.winScale)
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
					if grid:get(node.x, node.y) then
						draw = false
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

function Desktop:beginTurn()
	local scene = self.scene
	if scene.activeTeam == 1 then
		love.mouse.setCursor(self.cursors.normal1)
	elseif scene.activeTeam == 2 then
		love.mouse.setCursor(self.cursors.normal2)
	end	
end

function Desktop:drawGui()
	local scale = self.cameraController.winScale

	if self.mode == "dialog" then
		self.dialogWidget:draw(scale)
	else
		local y = 4*scale
		local mouseX, mouseY = love.mouse.getPosition()
		if mouseX < (self.terrainWidget.width+8)*scale then
			self.widgetX = love.graphics.getWidth()-((self.terrainWidget.width+4)*scale)
		elseif mouseX > (Game.width-self.terrainWidget.width-4)*scale then
			self.widgetX = 4*scale
		end

		self.cardWidget:draw(scale)
		if self.terrainWidget:draw(self.widgetX, y, scale) then
			y = y + (self.terrainWidget.height+4)*scale
		end

		if self.unitWidget:draw(self.widgetX, y, scale) then
			y = y + (self.unitWidget.height+4)*scale
		end
	end
end

function Desktop:getTarget(validTarget, callback, ...)
	love.mouse.setCursor(self.cursors.target)
	self.mode = "target"
	self.target = {
		validTarget = validTarget,
		callback = callback,
		args = {...}
	}
end

function Desktop:generateCursors(scale)
	-- Create mouse cursors
	local cursorCanvas = love.graphics.newCanvas(16*scale, 16*scale)
	local cursorNormal1Quad = getQuad(Res.tileset, 7, 42, 16, 16)
	local cursorNormal2Quad = getQuad(Res.tileset, 5, 39, 16, 16)
	local cursorTargetQuad = getQuad(Res.tileset, 1, 44, 16, 16)

	-- Player 1 Normal Cursor
	love.graphics.setCanvas(cursorCanvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.draw(Res.tileset, cursorNormal1Quad, 0, 0, nil, scale, scale)
	love.graphics.setCanvas()
	local cursorNormal1Image = cursorCanvas:newImageData()

	-- Player 2 Normal Cursor
	love.graphics.setCanvas(cursorCanvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.draw(Res.tileset, cursorNormal2Quad, 0, 0, nil, scale, scale)
	love.graphics.setCanvas()
	local cursorNormal2Image = cursorCanvas:newImageData()

	-- Target Cursor
	love.graphics.setCanvas(cursorCanvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.draw(Res.tileset, cursorTargetQuad, 0, 0, nil, scale, scale)
	love.graphics.setCanvas()
	local cursorTargetImage = cursorCanvas:newImageData()

	local cursors = {}
	cursors.normal1 = love.mouse.newCursor(cursorNormal1Image)
	cursors.normal2 = love.mouse.newCursor(cursorNormal2Image)
	cursors.target = love.mouse.newCursor(cursorTargetImage, 8, 8)

	return cursors
end

return Desktop

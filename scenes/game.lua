local scene = Class.scene:new()

function scene:begin()
	-- Setup Map and Camera
	self:loadMap('resources/map.lua')
	self.camera = Lib.gamera.new(0, 0, Game.width, Game.height)
	self.cameraController = self:newInstance(Class.cameraController, {self.camera}, 'mouse', 'resize')

	-- Setup Gui
	self.unitWidget = self:newInstance(Class.unitWidget, {}, 'update')
	self.terrainWidget = self:newInstance(Class.terrainWidget, {}, 'update')
	self.cardWidget = self:newInstance(Class.cardWidget, {}, 'update', 'mouse')
	self.widgetX = 4*self.camera:getScale()

	-- Setup Player Decks
	self.team = {}
	self.team[1] = {deck = Class.deck:new(Class.cardFireball:new()), hand = {}}
	self.team[2] = {deck = Class.deck:new(), hand = {}}

	-- Setup Game
	self.turn = 0
	self:beginTurn()
end

-- Scene Functions
function scene:loadMap(file)
	-- Load STI Map
	self.map = Lib.sti(file)
	self.grid = self:newInstance(Class.grid, {self.map.width, self.map.height, 16}, 'update', 'draw')
	for x=1, self.map.width do
		for y=1, self.map.height do
			if self.map.layers['Unit'].data[y][x] then
				local properties = self.map:getTileProperties('Unit', x, y)
				local unit = self:newInstance(Class[properties.type], {self.grid, x, y, properties.team}, 'draw', 'turn')
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
				Lib.pathfinder.getNode(self.nodes, x, y, gCost)
			end
		end
	end	self:resize(love.graphics.getWidth(), love.graphics.getHeight())
	Lib.pathfinder.setupNeighbors(self.nodes)
end

-- Event Functions
function scene:mousepressed(x, y, button)
	-- If the toolbar was clicked, don't pass the event on to other objects
	if button == 1 then
		if not self.cardWidget:mousepressed(x, y, button) then
			local cellX, cellY, item = self.grid:mousepressed(x, y, button)
			if self.selected then
				local unit = self.grid:get(self.selected.x, self.selected.y)
				if item then
					if item.team == self.activeTeam then
						self.selected = {x=cellX, y=cellY}
					else
						for _, target in ipairs(unit.attackable) do
							if (target.x == item.x) and (target.y == item.y) then
								unit:attack(target)
							end
						end
						self.selected = nil
					end
				elseif not unit.rest then
					for _, node in ipairs(unit.walkable.closedNodes) do
						if node.x == cellX and node.y == cellY then
							unit:move(node)
							break
						end
					end
					self.selected = nil
				end
			else
				if item then
					if item.team == self.activeTeam and not item.rest then
					 	self.selected = {x=cellX, y=cellY}
					end
				end
			end
		end
	end
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
	self.camera:draw( function(l,t,w,h)
		self.map:draw()
		scene:exec('draw', 'draw')

		-- Draw walkable tiles
		if self.selected then
			local selected = self.grid:get(self.selected.x, self.selected.y)
			if selected.walkable and selected.walkable.closedNodes then
				for _, node in ipairs(selected.walkable.closedNodes) do
					local draw = true
					-- If there is a unit on this tile, don't draw it as walkable.
					for _, x, y in self.grid.cells:apairs() do
						if node.x == x and node.y == y then
							draw = false
						end
					end
					if draw == true then
						love.graphics.setColor(0, 0, 192, 64)
						love.graphics.rectangle('fill', (node.x-1)*16, (node.y-1)*16, 16, 16)
						love.graphics.setColor(255, 255, 255, 255)
					end
				end
			end
			-- Outline attackable enemies
			if selected.attackable then
				for _, node in ipairs(selected.attackable) do
					love.graphics.setColor(192, 0, 0, 192)
					love.graphics.rectangle('line', (node.x-1)*16, (node.y-1)*16, 16, 16)
					love.graphics.setColor(255, 255, 255, 255)
				end
			end
		end

		-- Draw Cursor
		if self.selected then
			local x, y = self.grid:toScreen(self.selected.x, self.selected.y)
			local cellSize = self.grid.cellSize
			local quad = Lib.getQuad(Res.tileset, 4, 43, 16, 16)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(Res.tileset, quad, x, y)
		end
	end)

	self:drawGui()
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

function scene:drawGui()
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

return scene

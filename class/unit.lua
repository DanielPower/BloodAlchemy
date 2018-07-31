local class = require('libraries/middleclass')
local getQuad = require('libraries/getQuad')
local pathfinder = require('libraries/pathfinder')

local HitIndicator = require('class/interface/hitIndicator')

local Unit = class('Unit')
Unit.restQuad = getQuad(Res.tileset, 1, 45, 16, 16)

-- Event Functions
function Unit:create(grid, x, y, team)
    self.grid = grid
    self.x = x
    self.y = y
    self.team = team
    self.hp = self.maxHp
    self.movementPoints = self.moveSpeed

    grid:set(x, y, self)
end

function Unit:draw()
    local cellSize = self.grid.cellSize
    local x = self.x
    local y = self.y
    local tileset = Res.tileset

    if tileset and self.quad then
        love.graphics.draw(tileset, self.quad, (x-1)*cellSize, (y-1)*cellSize)
    else
        love.graphics.rectangle('fill', (self.x-1)*16, (self.y-1)*cellSize, cellSize, cellSize)
    end

    if self.rest then
        love.graphics.draw(tileset, self.restQuad, (x-1)*cellSize, (y-1)*cellSize)
    end
end

function Unit:attack(target)
    if not self.rest then
        self.rest = true
        self.attackable = {}
        self.walkable = {}
        target:hit(self.damage)
    end
end

function Unit:hit(damage)
    local grid = self.grid
    local x, y = grid:toScreen(self.x, self.y)
    self.scene:newInstance(HitIndicator, {x, y, damage, 2}, 'draw', 'update')
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self:kill()
    end
end

function Unit:kill()
    self.grid:set(self.x, self.y, nil)
    self.scene:destroyInstance(self)
end

function Unit:mousepressed(x, y, button)
    if not rest then
        if button == 1 then
            if (self.scene.activeTeam == self.team) and (self.rest == false) then
                local index = pathfinder.getNode(self.scene.nodes, x, y)
                self.attackable = self:validTargets()
                self.walkable = pathfinder:new(self.scene.nodes, index, self.movementPoints)
            end
        end
    end
end

-- Game Functions
function Unit:beginTurn(team)
    self.rest = false
    if team == self.team then
        self.movementPoints = self.moveSpeed
    end
end

function Unit:move(node)
    -- Remove self from original position on grid
    self.grid[self.x][self.y] = nil
    -- Update position, and insert self back into grid
    self.x, self.y = node.x, node.y
    self.grid[self.x][self.y] = self
    self.movementPoints = self.movementPoints - node.fCost
end

return Unit

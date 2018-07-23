local class = require('libraries/middleclass')

local Unit = require('class/unit')

local Knight = class('Knight', Unit)
Knight.damage = 4
Knight.maxHp = 10
Knight.moveSpeed = 3

function Knight:create(grid, x, y, team)
    Unit.create(self, grid, x, y, team)
end

function Knight:validTargets()
    local targets = {}

    local function checkTarget(x, y)
        local target = self.grid:get(x, y)
        if target and (target.team ~= self.team) then
            table.insert(targets, target)
        end
    end

    checkTarget(self.x-1, self.y-1)
    checkTarget(self.x-1, self.y)
    checkTarget(self.x-1, self.y+1)
    checkTarget(self.x, self.y-1)
    checkTarget(self.x, self.y)
    checkTarget(self.x, self.y+1)
    checkTarget(self.x+1, self.y-1)
    checkTarget(self.x+1, self.y)
    checkTarget(self.x+1, self.y+1)

    return targets
end

return Knight

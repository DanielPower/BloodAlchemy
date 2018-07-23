local class = require('libraries/middleclass')

local Unit = require('class/unit')

local Militia = class('Militia', Unit)
Militia.damage = 3
Militia.maxHp = 6
Militia.moveSpeed = 4

function Militia:create(grid, x, y, team)
    Unit.create(self, grid, x, y, team)
end

function Militia:validTargets()
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

return Militia

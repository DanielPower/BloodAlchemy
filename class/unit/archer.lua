local Archer = Lib.class('Archer', Class.unit)
Archer.damage = 3
Archer.maxHp = 4
Archer.moveSpeed = 4

function Archer:create(grid, x, y, team)
    Class.unit.create(self, grid, x, y, team)
end

function Archer:validTargets()
    local targets = {}

    local function checkTarget(x, y)
        local target = self.grid:get(x, y)
        if target and (target.team ~= self.team) then
            table.insert(targets, target)
        end
    end

    checkTarget(self.x-2, self.y-2)
    checkTarget(self.x-2, self.y-1)
    checkTarget(self.x-2, self.y)
    checkTarget(self.x-2, self.y+1)
    checkTarget(self.x-2, self.y+2)
    checkTarget(self.x-1, self.y-2)
    checkTarget(self.x-1, self.y+2)
    checkTarget(self.x, self.y-2)
    checkTarget(self.x, self.y+2)
    checkTarget(self.x+1, self.y-2)
    checkTarget(self.x+1, self.y+2)
    checkTarget(self.x+2, self.y-2)
    checkTarget(self.x+2, self.y-1)
    checkTarget(self.x+2, self.y)
    checkTarget(self.x+2, self.y+1)
    checkTarget(self.x+2, self.y+2)

    return targets
end

return Archer

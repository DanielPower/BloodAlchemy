local MountedKnight = Lib.class('MountedKnight', Class.unit)
MountedKnight.damage = 2
MountedKnight.maxHp = 8
MountedKnight.moveSpeed = 5

function MountedKnight:create(grid, x, y, team)
    Class.unit.create(self, grid, x, y, team)
end

function MountedKnight:validTargets()
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

return MountedKnight

local Desktop = Lib.class('Interface')

function Desktop:create()
end

function Desktop:mousepressed(x, y, button)
	local scene = self.scene
	local grid = self.scene.grid

	if button == 1 then
		local cellX, cellY, item = grid:mousepressed(x, y, button)
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
end

return Desktop

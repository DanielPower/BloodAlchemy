local Pathfinder = {}

-- Class Functions
function Pathfinder.getNode(nodes, x, y, gCost)
    -- Ensure node isn't already in table
    for index, node in ipairs(nodes) do
        if node.x == x and node.y == y then
            return index
        end
    end

    -- Otherwise, add the node to the table, and return its index
    local node = {}
    node.x = x
    node.y = y
    node.gCost = gCost or 1
    node.index = #nodes+1
    table.insert(nodes, node)

    return #nodes
end

function Pathfinder.setupNeighbors(nodes)
    for _, node in ipairs(nodes) do
		node.neighbors = {}
		for index, potentialNeighbor in ipairs(nodes) do
			if (potentialNeighbor.x == node.x+1 and potentialNeighbor.y == node.y)
			or (potentialNeighbor.x == node.x-1 and potentialNeighbor.y == node.y)
			or (potentialNeighbor.y == node.y+1 and potentialNeighbor.x == node.x)
			or (potentialNeighbor.y == node.y-1 and potentialNeighbor.x == node.x) then
				table.insert(node.neighbors, index)
			end
		end
	end
end

-- Instance Functions
function Pathfinder:new(nodes, start, maxDistance)
    self.nodes = nodes
    self.nodes[start].fCost = 0
    self.start = start
    self.openNodes = {nodes[start]}
    self.closedNodes = {}

    while #self.openNodes > 0 do
        -- Find the open node with the lowest fCost
        local lowestIndex
        local lowestNode = {fCost = 1/0}
        for i, node in ipairs(self.openNodes) do
            if node.fCost < lowestNode.fCost then
                lowestNode = node
                lowestIndex = i
            end
        end

        -- Close the current node, and open its neighbours
        table.remove(self.openNodes, lowestIndex)
        table.insert(self.closedNodes, lowestNode)

        for _, neighborIndex in ipairs(lowestNode.neighbors) do
            self:_openNode(self.nodes[neighborIndex], lowestNode.index, maxDistance)
        end
    end

    return self
end

function Pathfinder:newPath(node)
    local node = self.nodes[node]
    local path = {node}
    while node.parent do
        node = self.nodes[node.parent]
        table.insert(path, node)
    end

    return path
end

-- Local Functions
function Pathfinder:_openNode(node, parent, maxDistance)
    local better = false
    local fCost = self.nodes[parent].fCost + node.gCost

    if fCost <= maxDistance then
        better = true
        -- Check if this node is already opened
        for i, open in ipairs(self.openNodes) do
            if (node.x == open.x) and (node.y == open.y) then
                -- If the new fCost is lower, remove the old one
                if node.fCost < open.fCost then
                    table.remove(self.openNodes, i)
                else
                    better = false
                end
            end
        end

        -- Check if this node is already closed
        for i, closed in ipairs(self.closedNodes) do
            if (node.x == closed.x) and (node.y == closed.y) then
                -- If the new fCost is lower, re-open it
                if node.fCost < closed.fCost then
                    table.remove(self.closedNodes, i)
                else
                    better = false
                end
            end
        end
    end

    if better then
        node.parent = parent
        node.fCost = fCost
        table.insert(self.openNodes, node)
    end
end

return Pathfinder

local class = require('libraries/middleclass')

local Scene = class('Scene')

function Scene:initialize()
	self.groups = {}
	self.destroyQueue = {}
end

function Scene:load(file, ...)
	args = {...}
	local scene = require(file)
	if scene.begin then
		scene:begin(args)
	end
	if scene.resize then
		scene:resize(love.graphics.getWidth(), love.graphics.getHeight())
	end

	return scene
end

function Scene:newInstance(class, args, ...)
	local instance = class:new()
	instance._groups = {}
	instance.scene = self
	if instance.create then
		instance:create(unpack(args))
	end

	local groups = {'all', instance.class.name, ...}
	self:add(instance, unpack(groups))

	return instance
end

function Scene:destroyInstance(instance)
	if instance.destroy then
		instance:destroy()
	end
	self.destroyQueue[instance] = true
	return instance
end

function Scene:add(instance, ...)
	local groups = {...}
	for _, group in pairs(groups) do
		-- Create the group if it does not exist yet
		if not self.groups[group] then
			self.groups[group] = {}
		end

		-- Check if the instance is already in the group
		for _, item in ipairs(self.groups[group]) do
			if item == instance then
				print("[Warning] '"..instance.class.name.."' is already a member of '"..group.."'")
				return false
			end
		end

		-- If the instance was not in the group, add it
		table.insert(self.groups[group], instance)
		table.insert(instance._groups, group)
	end
end

function Scene:remove(instance, ...)
	local groups = {...}
	for _, group in pairs(self.groups) do
		for i=#group, 0, -1 do
			if group[i] == instance then
				table.remove(group, i)
			end
		end
	end
end

function Scene:exec(group, func, ...)
	-- Remove any instances in the destroyQueue first
	for instance in pairs(self.destroyQueue) do
		self:remove(instance, unpack(instance._groups))
	end
	self.destroyQueue = {}

	local args = {...}
	local output = {}

	if self.groups[group] then
		for _, instance in ipairs(self.groups[group]) do
			if instance[func] then
				local o = instance[func](instance, unpack(args))
				table.insert(output, o)
			else
				print("[Warning] Instance '"..instance.class.name.."' does not have a function '"..func.."'")
			end
		end
	else
		print("[Warning] ExecList '"..group.."' does not exist")
	end

	return output
end

-- Initialize empty event functions
function Scene:begin() end
function Scene:mousepressed() end
function Scene:mousereleased() end
function Scene:keypressed() end
function Scene:keyreleased() end
function Scene:update() end
function Scene:draw() end

return Scene

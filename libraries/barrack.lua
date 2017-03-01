local barrack = {}
barrack.definition = {}

-- Main functions
function barrack.enable()
	barrack.check = barrack._check
end

function barrack.disable()
	-- Make barrack.check an empty function to remove any performance impedence.
	barrack.check = function() end
end

function barrack.check()
	-- Blank by default.
	-- Use barrack.enable() to enable this function.
	-- Code located in barrack._check()
end

function barrack._check(input, definition)
	-- There must be an expectation for each input
	if #input ~= #definition then
		error("Length of input and expectations do not match.", 2)
	else
		for i=1, #input do
			local arg = input[i]
			local def = definition[i]

			if type(def) ~= 'string' then
				error("Definition table should only contain strings.", 2)
			else
				if barrack.definition[def] == nil then
					error("Definition '"..def.."' not found.", 2)
				else
					if barrack.definition[def](arg) ~= true then
						local argDefinition = barrack._getDefinitions(arg)
						local defString = barrack._listString(argDefinition)
						error("Argument "..i.." expected '"..def.."' but received '"..defString.."'", 2)
					end
				end
			end
		end
	end
end

-- Definition functions
function barrack.definition.boolean(arg)
	if type(arg) == 'boolean' then
		return(true)
	end
end

function barrack.definition.func(arg)
	if type(arg) == 'function' then
		return(true)
	end
end

function barrack.definition.int(arg)
	if type(arg) == 'number' then
		if math.floor(arg) == arg then
			return(true)
		end
	end
end

function barrack.definition.number(arg)
	if type(arg) == 'number' then
		return(true)
	end
end

function barrack.definition.string(arg)
	if type(arg) == 'string' then
		return(true)
	end
end

function barrack.definition.table(arg)
	if type(arg) == 'table' then
		return(true)
	end
end

-- Debug functions
function barrack._getDefinitions(arg)
	local valueType = {}
	for def in pairs(barrack.definition) do
		if barrack.definition[def](arg) then
			table.insert(valueType, def)
		end
	end

	return(valueType)
end

function barrack._listString(table)
	local string = table[1]
	for i=2, #table do
		string = string..", "..table[i]
	end

	return(string)
end

return(barrack)

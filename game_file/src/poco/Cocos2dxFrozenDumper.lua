function import_poco(moduleName, currentModuleName)
	local currentModuleNameParts
	local moduleFullName = moduleName
	local offset = 1
	while true do
		if string.byte(moduleName, offset) ~= 46 then
			moduleFullName = string.sub(moduleName, offset)
			if currentModuleNameParts and 0 < #currentModuleNameParts then
				moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
			end
			break
		end
		offset = offset + 1
		if not currentModuleNameParts then
			if not currentModuleName then
				local n, v = debug.getlocal(3, 1)
				currentModuleName = v
			end
			currentModuleNameParts = string.split(currentModuleName, ".")
		end
		table.remove(currentModuleNameParts, #currentModuleNameParts)
	end
	return require(moduleFullName)
end
local cc = _G.cc or require("cc")
local AbstractDumper = import_poco(".sdk.AbstractDumper")
local FrozenNode = import_poco(".Cocos2dxFrozenNode")
local director = cc.Director:getInstance()
local _ENV, FrozenDumper = cc.Director, cc.Director
FrozenDumper.__index = FrozenDumper
setmetatable(FrozenDumper, AbstractDumper)
FrozenDumper._nodes_cache, _ENV = setmetatable, setmetatable
function FrozenDumper:getRoot()
	self._nodes_cache, director = nil, nil
	local winSize = director:getWinSize()
	return FrozenNode:new(director:getRunningScene(), winSize.width, winSize.height)
end
function FrozenDumper:dumpHierarchyImpl(node, onlyVisibleNode)
	local result = AbstractDumper.dumpHierarchyImpl(self, node, onlyVisibleNode)
	local instanceId = node:getAttr("_instanceId")
	if instanceId ~= nil then
		self._nodes_cache[instanceId] = node
	end
	return result
end
function FrozenDumper:getCachedNode(instanceId)
	return self._nodes_cache[instanceId]
end
return FrozenDumper

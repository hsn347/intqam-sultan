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
local Cocos2dxNode = import_poco(".Cocos2dxNode")
local _ENV, FrozenNode = ".Cocos2dxNode", ".Cocos2dxNode"
FrozenNode.__index = FrozenNode
setmetatable(FrozenNode, Cocos2dxNode)
function FrozenNode:new(node, screenWidth, screenHeight)
	local _ENV, n
	setmetatable(n, FrozenNode)
	n.node = node
	n.screenWidth = screenWidth
	n.screenHeight = screenHeight
	return n
end
function FrozenNode:getAvailableAttributeNames()
	Cocos2dxNode = nil
	local (nil)[1], ret = "_instanceId", nil
	for _, name in ipairs(Cocos2dxNode.getAvailableAttributeNames(self)) do
		table.insert(ret, name)
	end
	return ret
end
function FrozenNode:getAttr(attrName)
	if attrName == "_instanceId" then
		if self.node.setString ~= nil or self.node.setText ~= nil then
			return tostring(self.node)
		end
		return nil
	end
	return Cocos2dxNode.getAttr(self, attrName)
end
return FrozenNode

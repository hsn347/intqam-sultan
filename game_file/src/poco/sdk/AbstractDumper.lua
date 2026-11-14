local _ENV, IDumper
IDumper.__index = IDumper
function IDumper:getRoot()
end
function IDumper:dumpHierarchy(onlyVisibleNode)
end
local _ENV, AbstractDumper = function(self, onlyVisibleNode)
end, function(self, onlyVisibleNode)
end
AbstractDumper.__index = AbstractDumper
setmetatable(AbstractDumper, IDumper)
function AbstractDumper:dumpHierarchy(onlyVisibleNode)
	if onlyVisibleNode == nil then
		onlyVisibleNode = true
	end
	return self:dumpHierarchyImpl(self:getRoot(), onlyVisibleNode)
end
function AbstractDumper:dumpHierarchyImpl(node, onlyVisibleNode)
	if node == nil then
		return nil
	end
	if onlyVisibleNode == nil then
		onlyVisibleNode = true
	end
	local payload = node:enumerateAttrs()
	local _ENV, result = node, node
	local _ENV, children
	for _, child in ipairs(node:getChildren()) do
		if not onlyVisibleNode or child:getAttr("visible") then
			table.insert(children, self:dumpHierarchyImpl(child, onlyVisibleNode))
		end
	end
	if 0 < #children then
		result.children = children
	end
	result.name = payload.name or node:getAttr("name")
	result.payload = payload
	return result
end
return AbstractDumper

local nodeCache = include("nodeCache")
local normalNodeCache = class("normalNodeCache", nodeCache)
function normalNodeCache:ctor()
	normalNodeCache.super.ctor(self)
end
function normalNodeCache:addInstance(node)
	if node then
		node:setVisible(false)
		self:addNode(node)
	end
end
function normalNodeCache:getInstance()
	local node = self:getNode()
	if node then
		node:setVisible(true)
	end
	return node
end
return normalNodeCache

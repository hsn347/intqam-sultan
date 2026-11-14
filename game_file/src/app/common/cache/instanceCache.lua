local nodeCache = include("nodeCache")
local instanceCache = class("instanceCache", nodeCache)
function instanceCache:ctor()
	instanceCache.super.ctor(self)
end
function instanceCache:addInstance(node)
	if node then
		node:addCacheInstanceBefore()
		node:setVisible(false)
		self:addNode(node)
	end
end
function instanceCache:getInstance()
	local node = self:getNode()
	if node then
		node:removeCacheBefore()
		node:setVisible(true)
	end
	return node
end
return instanceCache

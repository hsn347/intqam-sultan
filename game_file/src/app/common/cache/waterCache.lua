local nodeCache = include("nodeCache")
local waterCache = class("waterCache", nodeCache)
function waterCache:ctor()
	waterCache.super.ctor(self)
end
function waterCache:addInstance(node)
	if node then
		node:setVisible(false)
		self:addNode(node)
	end
end
function waterCache:getInstance()
	local node = self:getNode()
	if node then
		node:setVisible(true)
	end
	return node
end
function waterCache:clean()
	for _, node in pairs(self.cache) do
		node:clean()
		node:cleanup()
		node:release()
	end
	self.cache, _ENV = pairs(self.cache)
end
return waterCache

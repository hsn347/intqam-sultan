local nodeCache = include("nodeCache")
local animateCache = class("animateCache", nodeCache)
function animateCache:ctor()
	animateCache.super.ctor(self)
end
function animateCache:addInstance(node)
	if node then
		node:setVisible(false)
		self:addNode(node)
	end
end
function animateCache:getInstance()
	local node = self:getNode()
	if node then
		node:setVisible(true)
	end
	return node
end
return animateCache

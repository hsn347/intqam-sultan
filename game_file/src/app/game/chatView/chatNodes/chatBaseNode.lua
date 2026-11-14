local chatBaseNode = class("chatBaseNode", function(nodeName)
	return display.newNode()
end)
function chatBaseNode:ctor()
	self.width = 0
	self.height = 0
	self.retainOnCache = false
end
function chatBaseNode:reset()
end
function chatBaseNode:init(data)
end
function chatBaseNode.measureSize(data, target)
end
function chatBaseNode:getWidth()
	return self.width
end
function chatBaseNode:getHeight()
	return self.height
end
function chatBaseNode:onAfterCached()
end
function chatBaseNode:isRetainOnCache()
	return self.retainOnCache
end
function chatBaseNode:setScroll(scroll)
	self.scroll = scroll
	if self.bubble and self.bubble.setScroll then
		self.bubble:setScroll(scroll)
	else
	end
end
function chatBaseNode:onThemeUpdate()
end
return chatBaseNode

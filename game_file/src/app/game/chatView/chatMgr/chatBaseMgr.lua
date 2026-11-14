local chatBaseMgr = class("chatBaseMgr")
function chatBaseMgr:ctor()
end
function chatBaseMgr:init()
	self:reset()
end
function chatBaseMgr:reset()
end
function chatBaseMgr:clean()
	self:reset()
end
function chatBaseMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatBaseMgr:registerMessageListener()
	self:removeMessageListener()
end
return chatBaseMgr

local worldMapInstanceBase = class("worldMapInstanceBase", function(target)
	if target then
		return target
	end
	local view = display.newNode()
	return view
end)
function worldMapInstanceBase:ctor()
	self:setNodeEventEnabled(true)
end
function worldMapInstanceBase:onMessageListener()
end
function worldMapInstanceBase:onEnterOther()
end
function worldMapInstanceBase:onExitOther()
end
function worldMapInstanceBase:onEnter()
	self:onMessageListener()
	self:onEnterOther()
end
function worldMapInstanceBase:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
	self:onExitOther()
end
return worldMapInstanceBase

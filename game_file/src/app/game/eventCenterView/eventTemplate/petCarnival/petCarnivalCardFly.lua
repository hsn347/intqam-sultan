local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = gametop.playertop_:getModule("petCarnivalCtrl")
local petCarnivalCardFly = class("petCarnivalCardFly", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petCarnivalCardFly")
	end
	return target
end)
function petCarnivalCardFly:ctor()
end
function petCarnivalCardFly:showFly()
	local cssFilePath = getCCSPath(self.__cname)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:setFrameEventCallFunc(handler(self, self.callBackHandler))
	action:gotoFrameAndPlay(0, false)
	self:runAction(action)
end
function petCarnivalCardFly:callBackHandler(frame)
	local eventName = frame:getEvent()
	if eventName == "end" then
		print("播放结束")
		if self.handle then
			self.handle()
		end
	end
end
function petCarnivalCardFly:setHandle(handle)
	self.handle = handle
end
return petCarnivalCardFly

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FollowTestPanel = class("FollowTestPanel", baseFguiPanel)
function FollowTestPanel:ctor(...)
	self.isLRU = true
	FollowTestPanel.super.ctor(self, ...)
	print("FollowTestPanel:ctor", self.viewName)
end
function FollowTestPanel:onInit()
	print("=======FollowTestPanel:onInit")
end
function FollowTestPanel:endShow()
	print("=======FollowTestPanel:endShow", self.timeHandle)
	self.fields.Com_head:setPositionX(320)
	_UPVALUE5_ = nil
	;(nil)[1] = ffa.moveBy(1, 100, 0)
	;(nil)[2] = ffa.moveBy(1, 0, 100)
	;(nil)[3] = ffa.moveBy(1, -100, 0)
	;(nil)[4] = ffa.moveBy(1, -100, 0)
	;(nil)[5] = ffa.moveBy(1, 0, -100)
	;(nil)[6] = ffa.moveBy(1, 100, 0)
	;(nil)[7] = ffa.moveBy(1, 100, 0)
	;(nil)[8] = ffa.moveBy(1, 100, 0)
	;(nil)[9] = ffa.moveBy(1, 100, 0)
	self.fields.Com_head:runAction(ffa.repeatForever(ffa.seq(nil)))
	if self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
	end
	self.totalTime = 0
	self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime), true)
end
function FollowTestPanel:updateTime(dt)
	print("==FollowTestPanel:updateTime==", dt)
	self.totalTime = self.totalTime + dt
	local actionTime = 0.5
	if actionTime > self.totalTime then
		return
	end
	self.totalTime = 0
	local newPos = self.fields.Com_head:getPosition()
	self.fields.Image_gold:runAction(ffa.moveTo(actionTime, newPos.x, newPos.y - 68))
end
return FollowTestPanel

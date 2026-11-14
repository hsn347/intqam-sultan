local publicRead = include("publicRead")
local activity_9001712_Read = include("activity_9001712_Read")
local activity_9001712_Ctrl = SoraDGetCtrl("activity_9001712_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001712_ScratchPanel = class("Activity_9001712_ScratchPanel", baseFguiPanel)
function Activity_9001712_ScratchPanel:ctor(...)
	self.isLRU = true
	Activity_9001712_ScratchPanel.super.ctor(self, ...)
	print("Activity_9001712_ScratchPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
end
function Activity_9001712_ScratchPanel:onInit()
	print("=======Activity_9001712_ScratchPanel:onInit")
end
function Activity_9001712_ScratchPanel:endShow()
	print("=======Activity_9001712_ScratchPanel:endShow")
	self:initData(self.param.callback, self.param.cardIndex, self.param.rewards)
end
function Activity_9001712_ScratchPanel:onHide()
	self.fields.itemLoader:setAlpha(0)
	self.fields.effect:setVisible(false)
	if self.callback then
		self.callback()
	end
end
function Activity_9001712_ScratchPanel:initData(callback, cardIndex, rewards)
	self.callback = callback
	if not IsArClient then
		self.fields.card.fields.icon:setURL("frame_9001712_rosjj2.png")
	end
	self.fields.Usm_1:setVisible(true)
	self.fields.Usm_1:setEffectPath("9001712_cj_new.usm")
	self.fields.itemLoader:setURL()
	local seq = ffa.seq(ffa.delay(1.1), ffa.callFunc(function()
		self.fields.effect:setAllFrameNameOnce("dh_zbhd1_%.2d.png", 1)
		self.transitions.t0:Play()
		self.fields.itemLoader:setURL(publicRead.getIcon(rewards[1].id))
	end), ffa.delay(1.5), ffa.callFunc(function()
		self:close()
	end))
	seq:setTag(9001712)
	self:stopActionByTag(9001712)
	self:runAction(seq)
end
function Activity_9001712_ScratchPanel:onScratchAniEnd()
	self:close()
end
return Activity_9001712_ScratchPanel

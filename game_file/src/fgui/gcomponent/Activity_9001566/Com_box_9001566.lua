local activity_9001566_Read = include("activity_9001566_Read")
local activity_9001566_Ctrl = SoraDGetCtrl("activity_9001566_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_box_9001566 = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Activity_9001566/Com_box_9001566", Com_box_9001566)
function Com_box_9001566:onInit()
	self.fields.Com_item:setClickCallback(handler(self, self.onClickItemm))
end
function Com_box_9001566:onShow()
end
function Com_box_9001566:initData(activityId, eventType, idx)
	activity_9001566_Ctrl = nil
	;(nil).activityId = activityId
	;(nil).eventType = eventType
	self.tabParam, (nil).idx = nil, idx
	local state = activity_9001566_Ctrl:getRewardState(self.tabParam)
	self.controllers.c1:setSelectedIndex(state - 1)
	local taskTarget = activity_9001566_Read.getTaskTarget2(self.tabParam)
	self.fields.title:setString(string.formatnumberthousands(taskTarget))
	local taskReward = activity_9001566_Read.getTaskReward(self.tabParam)
	local reward = taskReward[1]
	self.fields.Com_item:initData(reward.id, reward.count)
	if state == gBtnTargetStatusDef.GET then
		self.fields.Com_item:setEffectShow(true)
	else
		self.fields.Com_item:setEffectShow(false)
	end
	if state == gBtnTargetStatusDef.GOT then
		self.fields.Com_item:setGrayed(true)
	else
		self.fields.Com_item:setGrayed(false)
	end
end
function Com_box_9001566:onClickItemm()
	local state = activity_9001566_Ctrl:getRewardState(self.tabParam)
	if state == gBtnTargetStatusDef.GET then
		activity_9001566_Ctrl:reqItemRebateReward(self.tabParam.activityId, self.tabParam.eventType, self.tabParam.idx)
		SoraDShowLoading()
	end
end
return Com_box_9001566

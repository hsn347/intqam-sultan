local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
local taskRushActivityRead = include("taskRushActivityRead")
local baseComponent = require("fgui.base.baseComponent")
local box_bar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001695/box_bar", box_bar)
function box_bar:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001695
	self.fields.Text_time:setTimeEndListener(handler(self, self.timeEndEvent))
	self.fields.Text_des:setString(i18n("Bright_night_activity_tips_0001"))
	self.fields.btn_box:addClickListener(handler(self, self.onClickBox))
	self.fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	self:fixChildrenPos()
end
function box_bar:onShow()
end
function box_bar:timeEndEvent()
	self:initData()
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_TASKRUSH_UPDATE"
	SoraDSendMessage(self)
end
function box_bar:getBoxStatus()
	local status = gBtnTargetStatusDef.GO
	if taskRushActivityCtrl:isBoxGot(self.activityID) then
		status = gBtnTargetStatusDef.GOT
	elseif taskRushActivityCtrl:isBoxCanGet(self.activityID) then
		status = gBtnTargetStatusDef.GET
	end
	return status
end
function box_bar:initData()
	local leftTime = taskRushActivityCtrl:getActivityQuestEffectTime(self.activityID) - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.fields.Text_time:beginTime(leftTime)
	end
	local num = taskRushActivityCtrl:getFinishQuestNum(self.activityID)
	self.fields.Label_reddot:setString(num)
	self.fields.Label_reddot:setVisible(0 < num)
	self.status = self:getBoxStatus()
	if self.status == gBtnTargetStatusDef.GO then
		self.controllers.c1:setSelectedIndex(0)
	elseif self.status == gBtnTargetStatusDef.GET then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_claim:setString(i18n("Bright_night_activity_tips_0003"))
	elseif self.status == gBtnTargetStatusDef.GOT then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.Text_claim:setString(i18n("common_text_1892"))
	end
	local totalNum = taskRushActivityRead.getTotalQuestNum(self.activityID)
	self.fields.bar:setMax(totalNum)
	self.fields.bar:setValue(num)
end
function box_bar:onClickBox()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GO then
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("taskRushReward", nil)
	end
	if self.status == gBtnTargetStatusDef.GET then
		taskRushActivityCtrl:reqClaimChest(self.activityID)
	end
end
return box_bar

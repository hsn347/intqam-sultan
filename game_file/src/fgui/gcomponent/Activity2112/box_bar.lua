local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
local taskRushActivityRead = include("taskRushActivityRead")
local baseComponent = require("fgui.base.baseComponent")
local box_bar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/box_bar", box_bar)
function box_bar:onInit()
	self.activityID = gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.Text_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = ""
		return strTime .. "\n" .. i18n("common_text_3722", nil)
	end)
	self.Text_time:setTimeEndListener(handler(self, self.timeEndEvent))
	self.fields.Text_des:setString(i18n("Bright_night_activity_tips_0001"))
	self.fields.Text_des:setAlign(0)
	self.fields.btn_box:addClickListener(handler(self, self.onClickBox))
end
function box_bar:onShow()
end
function box_bar:timeEndEvent()
	self:initData(self.parent)
	_ENV = self
	self.msg = "MESSAGE_ACTIVITY_TASKRUSH_UPDATE"
	SoraDSendMessage(self)
end
function box_bar:getBoxStatus()
	local status = gBtnTargetStatusDef.GO
	if taskRushActivityCtrl:isBoxGot() then
		status = gBtnTargetStatusDef.GOT
	elseif taskRushActivityCtrl:isBoxCanGet() then
		status = gBtnTargetStatusDef.GET
	end
	return status
end
function box_bar:initData(parent)
	self.parent = parent
	local leftTime = taskRushActivityCtrl:getActivityQuestEffectTime() - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.Text_time:beginTime(leftTime)
	end
	local num = taskRushActivityCtrl:getFinishQuestNum()
	self.fields.Text_red:setString(num)
	self.fields.Text_red:setVisible(0 < num)
	self.fields.n12:setVisible(0 < num)
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
	local totalNum = taskRushActivityRead.getTotalQuestNum()
	self.fields.bar:setMax(totalNum)
	self.fields.bar:setValue(num)
end
function box_bar:onClickBox()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GO then
		uiManager:show("taskRushReward")
	end
	if self.status == gBtnTargetStatusDef.GET then
		SoraDShowLoading(self.parent:displayObject())
		taskRushActivityCtrl:reqClaimChest()
	end
end
return box_bar

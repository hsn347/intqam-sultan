local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local activity_9001594_Ctrl = SoraDGetCtrl("activity_9001594_Ctrl")
local activity_9001594_Read = include("activity_9001594_Read")
local activity_9001720_Ctrl = SoraDGetCtrl("activity_9001720_Ctrl")
local activity_9001720_Read = include("activity_9001720_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_timegift = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_timegift", Com_timegift)
function Com_timegift:onInit()
	self.oneDayTime = 86400
	self.title = SoraDCreateTimerLabel(self, self.fields.title)
	self.fields.Bar:setMax(self.oneDayTime)
	self.fields.item:initData(activity_9001661_Read.getItemID())
	self.fields.item:setClickCallback(handler(self, self.btnClick))
end
function Com_timegift:onShow()
end
function Com_timegift:setActivityID(activityID)
	self.activityID = activityID
	if self.activityID == gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY then
		self.fields.item:initData(activity_9001594_Read.getItemID())
	elseif self.activityID == gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720 then
		self.fields.item:initData(activity_9001720_Read.getItemID())
	end
end
function Com_timegift:initData()
	if self.activityID == gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY then
		self.isCanReceive = activity_9001594_Ctrl:checkTreeCanReceive()
	elseif self.activityID == gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720 then
		self.isCanReceive = activity_9001720_Ctrl:checkLionCanReceive()
	else
		self.isCanReceive = activity_9001661_Ctrl:checkCanReceive()
	end
	self.controllers.c1:setSelectedIndex(self.isCanReceive and 1 or 0)
	self:setReddot(self.isCanReceive)
	if self.isCanReceive then
		self.title:endTime()
		self.title:setString(i18n("Bright_night_activity_tips_0003"))
		self.fields.Bar:setValue(self.oneDayTime)
		self.fields.Bar:hideLabelTime()
		self.fields.Bar:hideTitle()
	else
		local time = serviceFunctions.getTomorrowZeroHourUTC() - serviceFunctions.systemTime()
		self.title:setTimeLast(function(timeStr)
			_ENV = nil
			;(nil).time = timeStr
			return i18n("bubble_farm_text2", nil)
		end)
		self.title:setTimeEndListener(function()
			self.isCanReceive = true
			self.title:setString(i18n("Bright_night_activity_tips_0003"))
			self.fields.Bar:setValue(self.oneDayTime)
			self.controllers.c1:setSelectedIndex(self.isCanReceive and 1 or 0)
		end)
		self.fields.Bar:setTime(time, self.oneDayTime, true)
		self.fields.Bar:hideLabelTime()
		self.title:beginTime(time)
	end
end
function Com_timegift:btnClick()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY then
		if self.isCanReceive then
			activity_9001594_Ctrl:reqReward()
		else
			SoraDShowMsgTip(i18n("datepalm_tree_text5"))
		end
		return
	end
	if self.activityID == gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720 then
		if self.isCanReceive then
			activity_9001720_Ctrl:reqReward()
		else
			SoraDShowMsgTip(i18n("lion_park_text41"))
		end
		return
	end
	if self.isCanReceive then
		activity_9001661_Ctrl:reqBubbleGrangeReward()
	else
		SoraDShowMsgTip(i18n("bubble_farm_text3"))
	end
end
return Com_timegift

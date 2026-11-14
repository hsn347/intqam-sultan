local activityTimeRead = include("activityTimeRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_ramadanCalendar = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_ramadanCalendar", Btn_ramadanCalendar)
function Btn_ramadanCalendar:onInit()
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_ramadanCalendar:onShow()
	self:initActivityIcon()
	self:initActivityTime()
end
function Btn_ramadanCalendar:initActivityIcon(...)
	local iconName
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		iconName = "icon_xydw_jrrk.png"
	else
		iconName = activityTimeRead.getActivityIconByID(self.activityID)
	end
	self.fields.icon:setSpriteFrame(iconName)
end
function Btn_ramadanCalendar:initActivityTime(...)
	local eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_Time:setVisible(true)
		if self.activityID == gActivityTimeActivityID.FANTASY_LAND then
			local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
			self.Text_Time:beginTime(activity_9001717_Ctrl:getPartyRemainTime())
		else
			self.Text_Time:beginTime(eventTime.timerNode.timer:getRemainTime())
		end
	else
		self.Text_Time:setVisible(false)
		self.fields.n6:setVisible(false)
	end
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001700 then
		local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
		self.Text_Time:setTimeUpdateListener(function(...)
			if activity_9001700_Ctrl:getLetOffRedNum() then
				self:setRed(1)
			else
				self:setRed(0)
			end
		end)
	end
end
function Btn_ramadanCalendar:onBtnClick()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001700 then
		local activity_9001700_Read = include("activity_9001700_Read")
		activity_9001700_Read.singleClickEvent()
	else
		clientEventMgr.singleClickEvent(self.activityID)
	end
end
function Btn_ramadanCalendar:initData(data)
	if data and data.activityID then
		self.activityID = data.activityID
		if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
			self:updateActivityNebula()
		end
		if data.showRed then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local red, num = activityShowCtrl:getReceiveStatusAndNum(self.activityID)
			self.fields.Label_reddot:initData(red, num)
		end
	end
end
function Btn_ramadanCalendar:setRed(num)
	self.fields.Label_reddot:initData(0 < num)
end
function Btn_ramadanCalendar:updateActivityNebula(...)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	if nebulaActivityCtrl:getScoreStatusAndNum() then
		self:setRed(1)
	else
		self:setRed(0)
	end
end
return Btn_ramadanCalendar

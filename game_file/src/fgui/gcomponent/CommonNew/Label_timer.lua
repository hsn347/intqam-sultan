local Label_countDown = require("fgui.gcomponent.CommonNew.Label_countDown")
local baseComponent = require("fgui.base.baseComponent")
local Label_timer = fgui.extension_class(fgui.GLabel, Label_countDown)
fgui.register_extension("ui://CommonNew/Label_timer", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer2", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer3", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer4", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer5", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer6", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer7", Label_timer)
fgui.register_extension("ui://RamadanWorldExplorer/Label_timer", Label_timer)
fgui.register_extension("ui://CommonNew/com_time_New", Label_timer)
fgui.register_extension("ui://Activity_9001492/com_time", Label_timer)
fgui.register_extension("ui://ChronicleView/Com_time", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer_black", Label_timer)
fgui.register_extension("ui://CommonNew/Label_timer_new", Label_timer)
fgui.register_extension("ui://svipCenterView/Label_timer", Label_timer)
fgui.register_extension("ui://ManorFarm/ComTimer", Label_timer)
function Label_timer:onInit()
	self.super.onInit(self)
	self:fixChildrenPos()
	if self.fields.n2 then
		self.fields.n2:fix()
	end
end
function Label_timer:setIconScale(scale)
	if self.fields.icon_hourglass then
		self.fields.icon_hourglass:setScale(scale)
	end
	if self.fields.icon then
		self.fields.icon:setScale(scale)
	end
end
function Label_timer:setUbbOn()
	fguiHelper.SoraDChangeTextToHtml(self.fields.title)
end
function Label_timer:initCommonActivityTime(activityID, handle)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self:setUbbOn()
	self:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#F0E6D2", strTime)
		return str
	end)
	if handle then
		self:setTimeUpdateListener(handle)
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(activityID)
	if eventTime then
		self:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function Label_timer:initSpecialTime(leftTime, leftStr)
	local langKey = leftStr or "end_time_text"
	self:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = fguiHelper.getColorString("#F0E6D2", strTime)
		return fguiHelper.getColorString("#FFC864", i18n(langKey, nil))
	end)
	if leftTime then
		self:beginTime(leftTime)
	end
end
function Label_timer:initSpecialActivityTime(leftTime, leftStr)
	self:setUbbOn()
	self:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", leftStr or i18n("common_text_2669")) .. fguiHelper.getColorString("#F0E6D2", strTime)
		return str
	end)
	if leftTime then
		self:beginTime(leftTime)
	end
end
function Label_timer:initSpecialActivityTimeNew(activityID, leftStr)
	self:setUbbOn()
	self:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", leftStr or i18n("common_text_2669")) .. fguiHelper.getColorString("#F0E6D2", strTime)
		return str
	end)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local timer = activityShowCtrl:getTimeInfoByID(activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self:beginTime(leftTime)
	end
end
function Label_timer:initActivityTime(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local timer = activityShowCtrl:getTimeInfoByID(activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self:beginTime(leftTime)
	else
		self:setString(i18n("Anchor_text_21"))
	end
	self:setTimeEndListener(function()
		self:setString(i18n("Anchor_text_21"))
	end)
end
function Label_timer:initActivityTimeStyle(activityID, strTips, defaultColor)
	if strTips then
		self:setTimeLast(function(strTime)
			_ENV = nil
			_ENV, _ENV, (nil).time = nil, nil, strTime
			_ENV, (nil).time, (nil).color = nil, nil, "#F0E6D2"
			;(nil).__default, (nil).color = nil, defaultColor or "#FFC864"
			return i18n_html(strTips, nil, nil)
		end)
	else
		self:setTimeLast(function(strTime)
			_ENV = nil
			_ENV, _ENV, (nil).time = nil, nil, strTime
			;(nil).time, (nil).color = nil, "#F0E6D2"
			if not defaultColor then
				_ENV = defaultColor
				defaultColor.color = "#FFC864"
			end
			;(nil).__default = defaultColor
			return i18n_html("common_text_4415", nil, nil)
		end)
	end
	self:initActivityTime(activityID)
end

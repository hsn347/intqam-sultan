local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local UI_Lab_timer = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Lab_timer", UI_Lab_timer)
fgui.register_extension("ui://CommonUI/UI_Lab_timer2", UI_Lab_timer)
fgui.register_extension("ui://CommonUI/UI_Lab_timer3", UI_Lab_timer)
fgui.register_extension("ui://CommonUI/UI_Lab_timer4", UI_Lab_timer)
fgui.register_extension("ui://CommonUI/UI_Lab_timer5", UI_Lab_timer)
function UI_Lab_timer:onInit()
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.title)
	self:fixChildrenPos()
	if self.fields.bg then
		self.fields.bg:fix()
	end
end
function UI_Lab_timer:onShow()
end
function UI_Lab_timer:beginTime(time, isUp, isNum, maxTime)
	self.Text_time:beginTime(time, isUp, isNum, maxTime)
end
function UI_Lab_timer:beginTimeNode(getTimeFun)
	self.Text_time:beginTimeNode(getTimeFun)
end
function UI_Lab_timer:endTime()
	self.Text_time:endTime()
end
function UI_Lab_timer:removeTime()
	self.Text_time:removeTime()
end
function UI_Lab_timer:setTimeLast(timeHandle)
	self.Text_time:setTimeLast(timeHandle)
end
function UI_Lab_timer:setTimeUpdateListener(listener)
	self.Text_time:setTimeUpdateListener(listener)
end
function UI_Lab_timer:setTimeEndListener(listener)
	self.Text_time:setTimeEndListener(listener)
end
function UI_Lab_timer:endTimeNoCauseEndCallBack()
	self.Text_time:endTimeNoCauseEndCallBack()
end
function UI_Lab_timer:setTimeColor(color)
	self.Text_time:setColor(color)
end
function UI_Lab_timer:setTimeFontSize(fontSize)
	self.Text_time:setFontSize(fontSize)
end
function UI_Lab_timer:updateLabel(timeNumber)
	self.Text_time:updateLabel(timeNumber)
end
function UI_Lab_timer:getTimeNumber()
	return self.Text_time.timeNumber
end
function UI_Lab_timer:initCommonActivityTime(activityID, handle)
	self:setTimeLast(function(strTime)
		return fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#F0E6D2", strTime)
	end)
	if handle then
		self:setTimeUpdateListener(handle)
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(activityID)
	if eventTime then
		self:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function UI_Lab_timer:initSpecialActivityTime(leftTime, leftStr)
	self:setTimeLast(function(strTime)
		return fguiHelper.getColorString("#FFC864", leftStr or i18n("common_text_2669")) .. fguiHelper.getColorString("#F0E6D2", strTime)
	end)
	if leftTime then
		self:beginTime(leftTime)
	end
end
function UI_Lab_timer:initSpecialTime(leftTime, leftStr)
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
function UI_Lab_timer:initSpecialActivityTimeNew(activityID, leftStr)
	self:setTimeLast(function(strTime)
		return fguiHelper.getColorString("#FFC864", leftStr or i18n("common_text_2669")) .. fguiHelper.getColorString("#F0E6D2", strTime)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self:beginTime(leftTime)
	end
end
function UI_Lab_timer:initActivityTime(activityID)
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
function UI_Lab_timer:initActivityTimeStyle(activityID, strTips, defaultColor)
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
return UI_Lab_timer

local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_anniv2022Calendar = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AnniversaryCountdown2022/Com_anniv2022Calendar", Com_anniv2022Calendar)
_UPVALUE7_, Com_anniv2022Calendar.onInit = function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end, function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end
;(function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[1] = "calendar2021_text03"
;(function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[2] = "calendar2021_text04"
;(function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[3] = "calendar2021_text05"
;(function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[4] = "calendar2021_text06"
;(function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[5] = "calendar2021_text07"
;(function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[6] = "calendar2021_text08"
local (function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end)[7], weekTitle = "calendar2021_text09", function(self)
	if SoraDGetDefaultLanguage() == "ar" then
		self.fields.Load_title:setURL("font_anniversarycalendarl_title_02.png")
	end
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	self.fields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.fields.List_date:setNumItems(7)
	self.fields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.fields.Text_Tip:setString(i18n("calendar2021_text02"))
end
local DAY_TIME = 86400
function Com_anniv2022Calendar:onDateItemRenderer(index, object)
	local i = index + 1
	object:getChild("Text_date"):setString(os.date("!%m-%d", serviceFunctions.systemTime() + (i - self.todayWeek) * DAY_TIME))
	object:getChild("Text_week"):setString(i18n(weekTitle[i]))
	object:setSelected(i == self.todayWeek)
end
function Com_anniv2022Calendar:onActivityItemRenderer(index, object)
	local data = self.data[index + 1]
	local Com_activity = object:getChild("Com_activity")
	if data then
		Com_activity:setVisible(true)
		local beginWeek = self:getEndWeekDay(data.beginTime)
		local endWeek = self:getEndWeekDay(data.endTime, true)
		print("==beginWeek, endWeek==", beginWeek, endWeek)
		object:initData(data, beginWeek, endWeek)
	else
		Com_activity:setVisible(false)
	end
	object:setTodayWeek(self.todayWeek)
end
function Com_anniv2022Calendar:getTimeData()
	if not activityShowCtrl:getParamByID(self.activityID).showConfig then
		local activityShowCtrl, activityInfo = activityShowCtrl:getParamByID(self.activityID).showConfig, activityShowCtrl:getParamByID(self.activityID).showConfig
	end
	local curTime = serviceFunctions.systemTime()
	local oneDay = 86400
	local beginActivityID = 9001267
	local activityShowCtrl, ret
	for k, data in ipairs(activityInfo) do
		if not self:isEndLastWeek(data.endTime) and not self:isBeginNextWeek(data.beginTime) then
			table.insert(ret, data)
		end
	end
	table.sort(ret, function(a, b)
		if a.beginTime ~= b.beginTime then
			return a.beginTime < b.beginTime
		end
		return a.activityID < b.activityID
	end)
	dump(ret, "fkldfkldkflkdl")
	return ret
end
function Com_anniv2022Calendar:getEndWeekDay(time, isEnd)
	local tb = os.date("!*t", serviceFunctions.systemTime())
	tb.hour = 0
	tb.min = 0
	tb.sec = 0
	local todayTime = os.time(tb)
	if isEnd then
		time = time - 1
	end
	tb = os.date("!*t", time)
	tb.hour = 0
	tb.min = 0
	tb.sec = 0
	local endDayTime = os.time(tb)
	return math.max(1, self.todayWeek + (endDayTime - todayTime) / 86400)
end
function Com_anniv2022Calendar:isEndLastWeek(endTime)
	local tb = os.date("!*t", serviceFunctions.systemTime())
	tb.hour = 0
	tb.min = 0
	tb.sec = 0
	local todayTime = os.time(tb) - (self.todayWeek - 1) * 86400
	if endTime < todayTime then
		return true
	else
		return false
	end
end
function Com_anniv2022Calendar:isBeginNextWeek(beginTime)
	local tb = os.date("!*t", serviceFunctions.systemTime())
	tb.hour = 0
	tb.min = 0
	tb.sec = 0
	local todayTime = os.time(tb) + (8 - self.todayWeek) * 86400
	if beginTime >= todayTime then
		return true
	else
		return false
	end
end
function Com_anniv2022Calendar:onShow()
	self.data = self:getTimeData()
	self.fields.List_activity:setNumItems(math.max(7, #self.data))
end
return Com_anniv2022Calendar

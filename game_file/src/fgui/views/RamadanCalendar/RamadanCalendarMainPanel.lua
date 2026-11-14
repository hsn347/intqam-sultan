local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanCalendarMainPanel = class("RamadanCalendarMainPanel", baseFguiPanel)
function RamadanCalendarMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RamadanCalendarMainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.RAMADAN_CALENDAR_ACTIVITY
	self.todayWeek = os.date("!*t", serviceFunctions.systemTime()).wday
end
function RamadanCalendarMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanCalendarMainPanel:onInit()
	print("=======RamadanCalendarMainPanel:onInit")
	self.comFields = fguiHelper.get_fields(self.fields.Com_view)
	self.comFields.List_date:setItemRenderer(handler(self, self.onDateItemRenderer))
	self.comFields.List_date:setNumItems(7)
	self.comFields.List_activity:setItemRenderer(handler(self, self.onActivityItemRenderer))
	self.comFields.Text_Tip:setString(i18n("calendar2021_text02"))
end
_UPVALUE7_, RamadanCalendarMainPanel.onShow = function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end, function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end
;(function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[1] = "calendar2021_text03"
;(function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[2] = "calendar2021_text04"
;(function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[3] = "calendar2021_text05"
;(function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[4] = "calendar2021_text06"
;(function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[5] = "calendar2021_text07"
;(function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[6] = "calendar2021_text08"
local (function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end)[7], weekTitle = "calendar2021_text09", function(self)
	print("=======RamadanCalendarMainPanel:onShow")
	self.data = self:getTimeData()
	self.comFields.List_activity:setNumItems(math.max(7, #self.data))
end
function RamadanCalendarMainPanel:onDateItemRenderer(index, object)
	local i = index + 1
	object:getChild("Text_date"):setString(os.date("!%m-%d", serviceFunctions.systemTime() + (i - self.todayWeek) * 86400))
	object:getChild("Text_week"):setString(i18n(weekTitle[i]))
	object:setSelected(i == self.todayWeek)
end
function RamadanCalendarMainPanel:onActivityItemRenderer(index, object)
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
function RamadanCalendarMainPanel:getTimeData()
	if not activityShowCtrl:getParamByID(self.activityID).showConfig then
		local activityShowCtrl, activityInfo = activityShowCtrl:getParamByID(self.activityID).showConfig, activityShowCtrl:getParamByID(self.activityID).showConfig
	end
	dump(activityInfo, "self.data")
	local activityShowCtrl, ret = dump, dump
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
	return ret
end
function RamadanCalendarMainPanel:getEndWeekDay(time, isEnd)
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
function RamadanCalendarMainPanel:isEndLastWeek(endTime)
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
function RamadanCalendarMainPanel:isBeginNextWeek(beginTime)
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
return RamadanCalendarMainPanel

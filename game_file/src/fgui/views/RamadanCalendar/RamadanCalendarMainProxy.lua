local baseProxy = require("fgui.base.baseProxy")
local RamadanCalendarMainProxy = class("RamadanCalendarMainProxy", baseProxy)
function RamadanCalendarMainProxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.RAMADAN_CALENDAR_ACTIVITY
	_ENV = ...
	....byUID = true
	local config = SoraDConfigGet("Game:GameSettingView:RamadanCalendar~string", ...)
	if not config or not json.decode(config) then
		local _ENV, redConfig = json.decode(config), json.decode(config)
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local opencount = activityShowCtrl:getOpenCount(self.activityID)
	if not redConfig.opencount or redConfig.opencount ~= opencount then
		_ENV = redConfig.opencount
		self.redConfig, redConfig.opencount.data, _ENV, redConfig.opencount.opencount = redConfig.opencount, self.activityID, self.activityID, opencount
		self:refreshConfig()
	else
		self.redConfig = redConfig
	end
end
function RamadanCalendarMainProxy:onRegisterEvent()
	print("=======RamadanCalendarMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanCalendarMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function RamadanCalendarMainProxy:resetData()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local opencount = activityShowCtrl:getOpenCount(self.activityID)
	_ENV = activityShowCtrl
	self.redConfig, activityShowCtrl.data, _ENV, activityShowCtrl.opencount = activityShowCtrl, self.activityID, self.activityID, opencount
	self:refreshConfig()
end
function RamadanCalendarMainProxy:setActivityClicked(activityID)
	self.redConfig.data[tostring(activityID)] = true
	self:refreshConfig()
end
function RamadanCalendarMainProxy:getActivityClicked(activityID)
	return self.redConfig.data[tostring(activityID)]
end
function RamadanCalendarMainProxy:refreshConfig(...)
	_ENV = self.redConfig
	self.redConfig.byUID = true
	SoraDConfigSet("Game:GameSettingView:RamadanCalendar~string", json.encode(self.redConfig), self.redConfig)
end
return RamadanCalendarMainProxy

local baseProxy = require("fgui.base.baseProxy")
local Anniv2022CalendarProxy = class("Anniv2022CalendarProxy", baseProxy)
function Anniv2022CalendarProxy:ctor(...)
	self.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_CALENDAR_2022
	_ENV = ...
	....byUID = true
	local config = SoraDConfigGet("Game:GameSettingView:Anniv2022Calendar~string", ...)
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
function Anniv2022CalendarProxy:onRegisterEvent()
	print("=======Anniv2022CalendarProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Anniv2022CalendarProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Anniv2022CalendarProxy:resetData()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local opencount = activityShowCtrl:getOpenCount(self.activityID)
	_ENV = activityShowCtrl
	self.redConfig, activityShowCtrl.data, _ENV, activityShowCtrl.opencount = activityShowCtrl, self.activityID, self.activityID, opencount
	self:refreshConfig()
end
function Anniv2022CalendarProxy:setActivityClicked(activityID)
	self.redConfig.data[tostring(activityID)] = true
	self:refreshConfig()
end
function Anniv2022CalendarProxy:getActivityClicked(activityID)
	return self.redConfig.data[tostring(activityID)]
end
function Anniv2022CalendarProxy:refreshConfig(...)
	_ENV = self.redConfig
	self.redConfig.byUID = true
	SoraDConfigSet("Game:GameSettingView:Anniv2022Calendar~string", json.encode(self.redConfig), self.redConfig)
end
return Anniv2022CalendarProxy

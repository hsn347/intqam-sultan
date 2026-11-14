local baseProxy = require("fgui.base.baseProxy")
local StarLampCeremonyMainProxy = class("StarLampCeremonyMainProxy", baseProxy)
function StarLampCeremonyMainProxy:onRegisterEvent()
	print("=======StarLampCeremonyMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_STAR_LAMP_CEREMONY", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function StarLampCeremonyMainProxy:onUpdateView(target, data)
	self.view:updateView()
end
function StarLampCeremonyMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_LAMP_CEREMONY_ACTIVITY) then
		self.view:close()
	end
end
return StarLampCeremonyMainProxy

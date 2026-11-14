local baseProxy = require("fgui.base.baseProxy")
local RamadanLetterAwardProxy = class("RamadanLetterAwardProxy", baseProxy)
function RamadanLetterAwardProxy:onRegisterEvent()
	print("=======RamadanLetterAwardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanLetterAwardProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY) then
		self.view:close()
	end
end
return RamadanLetterAwardProxy

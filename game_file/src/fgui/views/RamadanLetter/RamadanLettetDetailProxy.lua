local baseProxy = require("fgui.base.baseProxy")
local RamadanLettetDetailProxy = class("RamadanLettetDetailProxy", baseProxy)
function RamadanLettetDetailProxy:onRegisterEvent()
	print("=======RamadanLettetDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanLettetDetailProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY) then
		self.view:close()
	end
end
return RamadanLettetDetailProxy

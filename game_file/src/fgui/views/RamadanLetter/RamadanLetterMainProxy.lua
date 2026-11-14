local baseProxy = require("fgui.base.baseProxy")
local RamadanLetterMainProxy = class("RamadanLetterMainProxy", baseProxy)
function RamadanLetterMainProxy:onRegisterEvent()
	print("=======RamadanLetterMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RAMADAN_LETTER", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanLetterMainProxy:refreshView()
	self.view:refreshView()
end
function RamadanLetterMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY) then
		self.view:close()
		_ENV = nil
		gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(nil)
	end
end
return RamadanLetterMainProxy

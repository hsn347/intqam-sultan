local baseProxy = require("fgui.base.baseProxy")
local RaidersLostArkGetKeyPopProxy = class("RaidersLostArkGetKeyPopProxy", baseProxy)
function RaidersLostArkGetKeyPopProxy:onRegisterEvent()
	print("=======RaidersLostArkGetKeyPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshView))
end
function RaidersLostArkGetKeyPopProxy:refreshView()
	self.view:refreshView()
end
function RaidersLostArkGetKeyPopProxy:judgeClose(target, redata)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAIDERS_LOST_ARK) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RaidersLostArkGetKeyPopProxy

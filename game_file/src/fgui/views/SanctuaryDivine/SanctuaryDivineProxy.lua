local baseProxy = require("fgui.base.baseProxy")
local SanctuaryDivineProxy = class("SanctuaryDivineProxy", baseProxy)
function SanctuaryDivineProxy:onRegisterEvent()
	print("=======SanctuaryDivineProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MAGICLAMPDRAW_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MAGICLAMPDRAW_DRAWBACK", handler(self, self.drawBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SanctuaryDivineProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function SanctuaryDivineProxy:drawBack(target, data)
	self.view:drawBack(target, data)
end
function SanctuaryDivineProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return SanctuaryDivineProxy

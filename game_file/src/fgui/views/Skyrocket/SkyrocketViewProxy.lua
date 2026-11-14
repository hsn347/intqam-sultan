local baseProxy = require("fgui.base.baseProxy")
local SkyrocketViewProxy = class("SkyrocketViewProxy", baseProxy)
function SkyrocketViewProxy:onRegisterEvent()
	print("=======SkyrocketViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROCKETRUSH_UI_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SkyrocketViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function SkyrocketViewProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROCKET_RUSH) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return SkyrocketViewProxy

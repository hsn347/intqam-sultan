local baseProxy = require("fgui.base.baseProxy")
local SunnyLaneMainProxy = class("SunnyLaneMainProxy", baseProxy)
function SunnyLaneMainProxy:onRegisterEvent()
	print("=======SunnyLaneMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MONSTER_INVASION_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateItemCount))
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", handler(self, self.onUpdateItemCount))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SunnyLaneMainProxy:onUpdateView()
	self.view:updateView()
end
function SunnyLaneMainProxy:onUpdateItemCount()
	self.view:updateItemCount()
end
function SunnyLaneMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY) then
		self.view:close()
	end
end
return SunnyLaneMainProxy

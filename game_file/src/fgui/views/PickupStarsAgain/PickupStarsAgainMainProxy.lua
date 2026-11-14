local baseProxy = require("fgui.base.baseProxy")
local PickupStarsAgainMainProxy = class("PickupStarsAgainMainProxy", baseProxy)
function PickupStarsAgainMainProxy:onRegisterEvent()
	print("=======PickupStarsAgainMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_PICKUP_STARS_AGAIN_REFRESH", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_PICKUP_STARS_AGAIN_BUILD", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_PICKUP_STARS_AGAIN_GET_REWARD", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_PICKUP_STARS_AGAIN_TOTAL_SCORE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.onSearch))
end
function PickupStarsAgainMainProxy:onSearch(target, data)
	dump(data, "PickupStarsAgainMainProxy:onSearch", 10)
	if data.err then
		SoraDShowMsgTip("search fail " .. data.err)
	elseif data.retdate and data.retdate.mapType == gMapObjTypeDef.desertMeteorite then
		SoraDRemoveAllPanelFromManager()
		SoraDGotoWorldMapPoint(cc.p(data.retdate.x, data.retdate.y), true)
	end
end
function PickupStarsAgainMainProxy:onUpdateView(target, data)
	self.view:updateUI()
end
function PickupStarsAgainMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PICKUP_STARS_AGAIN_ACTIVITY) then
		self.view:close()
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return PickupStarsAgainMainProxy

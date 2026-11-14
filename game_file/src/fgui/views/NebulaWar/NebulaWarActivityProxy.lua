local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local NebulaWarActivityProxy = class("NebulaWarActivityProxy", baseProxy)
function NebulaWarActivityProxy:onRegisterEvent()
	print("=======NebulaWarActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_DATA", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.refreshRedDot))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateBtnShopReddot))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.openExchangeShop))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_CAMP_SCORE_UPDATE", handler(self, self.omMsgUpdateCampScore))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_SCORE_REWARD_UPDATE", handler(self.view, self.view.onMsgUpdateScore))
end
function NebulaWarActivityProxy:judgeClose(target, data)
	if not nebulaActivityCtrl:isNebulaActivityOpen() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaWarActivityProxy:refreshView(...)
	self.view:refreshView(...)
end
function NebulaWarActivityProxy:refreshRedDot(target, data)
	if data.eventID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		self.view:refreshRedDot()
	end
end
function NebulaWarActivityProxy:updateBtnShopReddot()
	self.view:updateBtnShopReddot()
end
function NebulaWarActivityProxy:openExchangeShop()
	self.view:openExchangeShop()
end
function NebulaWarActivityProxy:omMsgUpdateCampScore(target, event)
	SoraDCloseLoading(self.view:displayObject())
	self.view:updateCampScore(event.rspdata)
end
return NebulaWarActivityProxy

local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_MainProxy = class("RoaringFlame_MainProxy", baseProxy)
function RoaringFlame_MainProxy:onRegisterEvent()
	print("=======RoaringFlame_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.checkCloseActivity))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_STATEDATA", handler(self, self.onMsgUpdateStateData))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_MATCHRESULT", handler(self, self.onMsgMatchResult))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUILDING_OWNER", handler(self, self.onMsgBuildingInfo))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_MILESTONE", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_DECREEREWARD", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_REFRESHDATA", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_QUESTREWARD", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUYGIFT", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CLAIMWEEKLY", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_ACTIVITY_RED", handler(self, self.setRedPoint))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_PHOENIX_LIST", handler(self, self.setRedPoint))
end
function RoaringFlame_MainProxy:checkCloseActivity(...)
	self.view:checkCloseActivity(...)
end
function RoaringFlame_MainProxy:onMsgUpdateStateData(...)
	self.view:onMsgUpdateStateData(...)
end
function RoaringFlame_MainProxy:onMsgMatchResult(...)
	self.view:onMsgMatchResult(...)
end
function RoaringFlame_MainProxy:setRedPoint(...)
	self.view:setRedPoint(...)
end
function RoaringFlame_MainProxy:onMsgBuildingInfo(...)
	self.view:onMsgBuildingInfo(...)
end
return RoaringFlame_MainProxy

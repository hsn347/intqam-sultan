local baseProxy = require("fgui.base.baseProxy")
local evilPalaceMapViewProxy = class("evilPalaceMapViewProxy", baseProxy)
function evilPalaceMapViewProxy:onRegisterEvent()
	print("=======evilPalaceMapViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_UPDATE_SYSTEMAWARD", handler(self, self.noticeBanner))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initBattleHorn))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_ENTERBATTLE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_ATTACK", handler(self, self.attackCB))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_UPDATEACTIVESTATUS", handler(self, self.changeState))
	SoraDAddMessage(self, "MESSAGE_SERVER_MONSTERPALACE_ERRCALLBACK", handler(self, self.errCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.refreshTimerLabel))
end
function evilPalaceMapViewProxy:noticeBanner(target, data)
	self.view:noticeBanner(target, data)
end
function evilPalaceMapViewProxy:initBattleHorn(target, data)
	self.view:initBattleHorn(target, data)
end
function evilPalaceMapViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function evilPalaceMapViewProxy:attackCB(target, data)
	self.view:attackCB(target, data)
end
function evilPalaceMapViewProxy:changeState(target, data)
	self.view:changeState(target, data)
end
function evilPalaceMapViewProxy:errCallBack(target, data)
	self.view:errCallBack(target, data)
end
function evilPalaceMapViewProxy:refreshTimerLabel(target, data)
	self.view:refreshTimerLabel(target, data)
end
return evilPalaceMapViewProxy

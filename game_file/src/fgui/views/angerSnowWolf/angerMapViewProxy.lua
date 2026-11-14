local baseProxy = require("fgui.base.baseProxy")
local angerMapViewProxy = class("angerMapViewProxy", baseProxy)
function angerMapViewProxy:onRegisterEvent()
	print("=======angerMapViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATE_SYSTEMAWARD", handler(self, self.noticeBanner))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initBattleHorn))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_ENTERBATTLE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_ATTACK", handler(self, self.attackCB))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_UPDATEACTIVESTATUS", handler(self, self.changeState))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_ERRCALLBACK", handler(self, self.errCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_FEATHERSHOPBUY", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_SERVER_SNOW_WOLF_KING_DECREE", handler(self, self.updateSign))
end
function angerMapViewProxy:noticeBanner(target, data)
	self.view:noticeBanner(target, data)
end
function angerMapViewProxy:initBattleHorn(target, data)
	self.view:initBattleHorn(target, data)
end
function angerMapViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function angerMapViewProxy:attackCB(target, data)
	self.view:attackCB(target, data)
end
function angerMapViewProxy:changeState(target, data)
	self.view:changeState(target, data)
end
function angerMapViewProxy:errCallBack(target, data)
	self.view:errCallBack(target, data)
end
function angerMapViewProxy:updateRed(target, data)
	self.view:updateRed(target, data)
end
function angerMapViewProxy:updateSign(target, data)
	self.view:updateSign(target, data)
end
return angerMapViewProxy

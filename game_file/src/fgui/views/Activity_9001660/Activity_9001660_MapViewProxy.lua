local baseProxy = require("fgui.base.baseProxy")
local Activity_9001660_MapViewProxy = class("Activity_9001660_MapViewProxy", baseProxy)
function Activity_9001660_MapViewProxy:onRegisterEvent()
	print("=======Activity_9001660_MapViewProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_UPDATE_SYSTEMAWARD", handler(self, self.noticeBanner))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initBattleHorn))
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_ENTERBATTLE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_ATTACK", handler(self, self.attackCB))
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_UPDATEACTIVESTATUS", handler(self, self.changeState))
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_ERRCALLBACK", handler(self, self.errCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_MUTANT_TENTACLES_FEATHERSHOPBUY", handler(self, self.updateRed))
end
function Activity_9001660_MapViewProxy:noticeBanner(target, data)
	self.view:noticeBanner(target, data)
end
function Activity_9001660_MapViewProxy:initBattleHorn(target, data)
	self.view:initBattleHorn(target, data)
end
function Activity_9001660_MapViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function Activity_9001660_MapViewProxy:attackCB(target, data)
	self.view:attackCB(target, data)
end
function Activity_9001660_MapViewProxy:changeState(target, data)
	self.view:changeState(target, data)
end
function Activity_9001660_MapViewProxy:errCallBack(target, data)
	self.view:errCallBack(target, data)
end
function Activity_9001660_MapViewProxy:updateRed(target, data)
	self.view:updateRed(target, data)
end
return Activity_9001660_MapViewProxy

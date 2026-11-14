local baseProxy = require("fgui.base.baseProxy")
local DesertSecretTreasureProxy = class("DesertSecretTreasureProxy", baseProxy)
function DesertSecretTreasureProxy:onRegisterEvent()
	print("=======DesertSecretTreasureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_DESERT_TREASURE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_DESERT_TREASURE_GET", handler(self, self.getReward))
	SoraDAddMessage(self, "MESSAGE_DESERT_TREASURE_READY", handler(self, self.enterUsmReady))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
end
function DesertSecretTreasureProxy:initData(target, data)
	if self.view then
		self.view:initData(data)
	end
end
function DesertSecretTreasureProxy:getReward(target, data)
	if self.view then
		self.view:getReward(data)
	end
end
function DesertSecretTreasureProxy:enterUsmReady(target, data)
	if self.view then
		self.view:enterUsmReady(data)
	end
end
function DesertSecretTreasureProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DESERT_TREASURE_ACTIVITY) then
		self.view:close()
	end
end
return DesertSecretTreasureProxy

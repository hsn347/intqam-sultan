local baseProxy = require("fgui.base.baseProxy")
local soldiersCampViewProxy = class("soldiersCampViewProxy", baseProxy)
function soldiersCampViewProxy:onRegisterEvent()
	print("=======soldiersCampViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SOLDIER_UI_TRAIN_SELECT", handler(self, self.trainSelect))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKY_DAY_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_ARMY_TOOL_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.onMsgSpeedUpBack))
	SoraDAddMessage(self, "MESSAGE_SOLDIER_TRAIN_DONE", handler(self, self.armyTrainDone))
	SoraDAddMessage(self, "MESSAGE_ARMY_TRAIN_IMM_BACK", handler(self, self.trainNow))
	SoraDAddMessage(self, "MESSAGE_ARMY_DISMISSAL", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateTrainNode))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateToolTrainInfo))
	SoraDAddMessage(self, "MESSAGE_ARMY_INFO_UPDATE", handler(self, self.updateArmyInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END", handler(self, self.buildQueueCallback))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK", handler(self, self.resetWarframeSlider))
	SoraDAddMessage(self, "MESSAGE_SOLDIER_UI_QUICK_TRAIN", handler(self, self.quickTrain))
end
function soldiersCampViewProxy:quickTrain(target, data)
	self.view:quickTrain(target, data)
end
function soldiersCampViewProxy:trainSelect(target, data)
	self.view:trainSelect(target, data)
end
function soldiersCampViewProxy:updateLuckyBless(target, data)
	self.view:updateLuckyBless(target, data)
end
function soldiersCampViewProxy:updateMode(target, data)
	self.view:updateMode(target, data)
end
function soldiersCampViewProxy:onMsgSpeedUpBack(target, data)
	self.view:onMsgSpeedUpBack(target, data)
end
function soldiersCampViewProxy:armyTrainDone(target, data)
	self.view:armyTrainDone(target, data)
end
function soldiersCampViewProxy:trainNow(target, data)
	self.view:trainNow(target, data)
end
function soldiersCampViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function soldiersCampViewProxy:updateTrainNode(target, data)
	self.view:updateTrainNode(target, data)
end
function soldiersCampViewProxy:updateToolTrainInfo(target, data)
	self.view:updateToolTrainInfo(target, data)
end
function soldiersCampViewProxy:updateArmyInfo(target, data)
	self.view:updateArmyInfo(target, data)
end
function soldiersCampViewProxy:buildQueueCallback(target, data)
	self.view:buildQueueCallback(target, data)
end
function soldiersCampViewProxy:resetWarframeSlider(target, data)
	self.view:resetWarframeSlider(target, data)
end
return soldiersCampViewProxy

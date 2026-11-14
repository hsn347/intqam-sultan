local baseProxy = require("fgui.base.baseProxy")
local MiningMeteoritesProxy = class("MiningMeteoritesProxy", baseProxy)
function MiningMeteoritesProxy:onRegisterEvent()
	print("=======MiningMeteoritesProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_MINING_METEORITES", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MINING_METEORITES_REWARD", handler(self, self.onExplore))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.updateCost))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function MiningMeteoritesProxy:judgeClose(target, data)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.MINING_METEORITES_ACTIVITY)
	if eventState ~= gActivityState.OPEN and eventState ~= gActivityState.PREPARE then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function MiningMeteoritesProxy:updateView(target, data)
	self.view:updateView()
end
function MiningMeteoritesProxy:onExplore(target, data)
	dump(data, "MiningMeteoritesProxy")
	self.view:showReward(data.rewards)
end
function MiningMeteoritesProxy:updateCost(target, data)
	self.view:updateCost()
end
return MiningMeteoritesProxy

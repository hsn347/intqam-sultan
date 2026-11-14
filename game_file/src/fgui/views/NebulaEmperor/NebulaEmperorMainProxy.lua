local baseProxy = require("fgui.base.baseProxy")
local NebulaEmperorMainProxy = class("NebulaEmperorMainProxy", baseProxy)
function NebulaEmperorMainProxy:onRegisterEvent()
	print("=======NebulaEmperorMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_IN_WAR_PLAYER", handler(self, self.onMsgUpdatePlayerCount))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_DONATE_GOLD", handler(self, self.onMsgDonateGoldBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_DONATE_REWARD", handler(self, self.onMsgDonateRewardBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ENERGY_EXCHANGE", handler(self, self.onMsgEnergyExchangeBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_BUFFE_NERGY", handler(self, self.onMsgBuffEnergyChange))
end
function NebulaEmperorMainProxy:onMsgCommonRefresh(target, event)
	local nebulaEmperorUtil = include("nebulaEmperorUtil")
	local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
	if nebulaEmperorCtrl:checkActivityID(event) then
		if nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.PREPARE) or nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.ACTIVE) then
			self.view:updateActivityState()
		else
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end
end
function NebulaEmperorMainProxy:onMsgUpdatePlayerCount(target, event)
	self.view:updatePlayerCount(event.count)
end
function NebulaEmperorMainProxy:onMsgDonateGoldBack(...)
	self.view:updateBtnDonateState()
end
function NebulaEmperorMainProxy:onMsgDonateRewardBack(...)
	self.view:updateBtnDonateState()
end
function NebulaEmperorMainProxy:onMsgEnergyExchangeBack(...)
	self.view:updateBtnEnergyState()
end
function NebulaEmperorMainProxy:onMsgBuffEnergyChange(...)
	self.view:updateBtnEnergyState()
end
return NebulaEmperorMainProxy

local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleInvitationProxy = class("kingdomBattleInvitationProxy", baseProxy)
function kingdomBattleInvitationProxy:onRegisterEvent()
	print("=======kingdomBattleInvitationProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_REINFORCEMENTS", handler(self, self.msgBack))
end
function kingdomBattleInvitationProxy:msgBack(target, data)
	if data.subMsg == "init" then
		self.view:updateInviteList()
		self.view:updatePower()
	elseif data.subMsg == "inviteUpdate" then
		self.view:updateInviteList()
	elseif data.subMsg == "reinforcementsUpdate" then
		self.view:updateReinforceList()
		self.view:updateKindomInfo()
	elseif data.subMsg == "reinforcementsInit" then
		self.view:updateReinforceList()
		self.view:updateKindomInfo()
		self.view:updatePower()
	end
end
return kingdomBattleInvitationProxy

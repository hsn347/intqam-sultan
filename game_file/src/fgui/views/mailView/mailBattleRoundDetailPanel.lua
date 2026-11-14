local baseFguiPanel = require("fgui.base.baseFguiPanel")
local armyDesRead = include("armyDesRead")
local mailBattleRoundDetailPanel = class("mailBattleRoundDetailPanel", baseFguiPanel)
function mailBattleRoundDetailPanel:ctor(...)
	self.isLRU = true
	mailBattleRoundDetailPanel.super.ctor(self, ...)
	print("mailBattleRoundDetailPanel:ctor", self.viewName)
end
function mailBattleRoundDetailPanel:onInit()
	print("=======mailBattleRoundDetailPanel:onInit")
	self.fields.Panel_bg:setString(i18n("battlelog_text_54"))
end
function mailBattleRoundDetailPanel:endShow()
	print("=======mailBattleRoundDetailPanel:endShow")
	if not self.param.battleDetails then
		local _ENV, battleDetails = self.param.battleDetails, self.param.battleDetails
	end
	local realRound = self.param.realRound or 0
	self.isDefense = self.param.isDefense or false
	if not battleDetails or not battleDetails.roundArmy then
		local _ENV, roundArmy = battleDetails.roundArmy, battleDetails.roundArmy
	end
	if not battleDetails or not battleDetails.roundEffect then
		local _ENV, roundEffect = battleDetails.roundEffect, battleDetails.roundEffect
	end
	if not roundArmy[tostring(realRound)] then
		_ENV = roundArmy[tostring(realRound)]
	end
	self.curRoundArmyData = roundArmy[tostring(realRound)]
	if not roundEffect[tostring(realRound)] then
		_ENV = roundEffect[tostring(realRound)]
	end
	self.curRoundEffectData = roundEffect[tostring(realRound)]
	self.fields.Com_mail_BattleRoundDetail:updateData(self.curRoundArmyData, self.curRoundEffectData, self.isDefense)
end
return mailBattleRoundDetailPanel

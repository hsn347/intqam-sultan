local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local nationalFlagRead = include("nationalFlagRead")
local constantRead = include("constantRead")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleInvitationPanel = class("kingdomBattleInvitationPanel", baseFguiPanel)
function kingdomBattleInvitationPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleInvitationPanel:ctor", self.viewName)
end
function kingdomBattleInvitationPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleInvitationPanel:onInit()
	print("=======kingdomBattleInvitationPanel:onInit")
	self.fields.Text_Kingdom:fixPos()
	self.fields.n21:fixPos()
	self.fields.Com_title:initData(i18n("conquestwar_text_11"), handler(self, self.onClickClose))
	self.fields.Button_Invitation:setString(i18n("conquestwar_text_26"))
	self.fields.Button_Invitation:addClickListener(handler(self, self.onClickInvitation))
	self.fields.Label_Time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("conquestwar_text_16", nil, nil)
	end)
	self.fields.Label_Time:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH"
		SoraDSendMessage(nil)
		self:removeFromParent()
	end)
	if conquestWarCtrl:isTriggerReinforcements() and SoraDIsSelfKing() then
		self.curType = 0
	else
		self.curType = 1
	end
	self.controllers.c1:setSelectedIndex(self.curType)
	self.fields.List_In:setItemRenderer(handler(self, self.onInviteItemRender))
	self.fields.List_Out:setItemRenderer(handler(self, self.onItemRender))
end
function kingdomBattleInvitationPanel:onShow()
	print("=======kingdomBattleInvitationPanel:onShow")
	local time = conquestWarCtrl:getReinforceEndTime()
	if time <= 0 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_REFRESH"
		SoraDSendMessage(nil)
		self:removeFromParent()
		return
	end
	self.fields.Label_Time:beginTime(time)
	if self.curType == 1 then
		conquestWarReinforcementsCtrl:sendReqInitDataMsg()
	else
		conquestWarCtrl:reqReinforcementsInfo()
	end
end
function kingdomBattleInvitationPanel:updateReinforceList()
	self.reinforceList = conquestWarCtrl:getReinforcements()
	self.fields.List_Out:setNumItems(#self.reinforceList)
end
function kingdomBattleInvitationPanel:updatePower()
	if self.curType == 1 then
		_ENV = nil
		_ENV, _ENV, (nil).num = conquestWarReinforcementsCtrl:getStrength()
		_ENV, string.formatnumberthousands(conquestWarReinforcementsCtrl:getStrength()).num, conquestWarReinforcementsCtrl:getStrength().color = conquestWarReinforcementsCtrl:getStrength()
		string.formatnumberthousands(conquestWarReinforcementsCtrl:getStrength()).__default, conquestWarReinforcementsCtrl:getStrength().color = conquestWarReinforcementsCtrl:getStrength()
		self.fields.Label_Power:setString(i18n_html("conquestwar_text_28", nil, (string.formatnumberthousands(conquestWarReinforcementsCtrl:getStrength()))))
	else
		_ENV = i18n_html("conquestwar_text_28", nil, (string.formatnumberthousands(conquestWarReinforcementsCtrl:getStrength())))
		i18n_html("conquestwar_text_28", nil, (string.formatnumberthousands(conquestWarReinforcementsCtrl:getStrength()))).num = conquestWarCtrl:getCanReinforceKidsStr()
		self.fields.Label_Power:setString(i18n("conquestwar_text_55", i18n_html("conquestwar_text_28", nil, (string.formatnumberthousands(conquestWarReinforcementsCtrl:getStrength())))))
	end
end
function kingdomBattleInvitationPanel:updateKindomInfo()
	local kid = gametop.playertop_:getKingdomID()
	if lordInfoCtrl:getSourceKid() > 0 then
		kid = lordInfoCtrl:getSourceKid()
	end
	self.fields.Text_Kingdom:setString(string.format("#%d", kid))
	self.fields.Text_Kingdom:setIcon(nationalFlagRead.getAcrossPopupImageByID(kid))
	local power, num = conquestWarCtrl:getAgreePowerAndNum()
	gametop = nationalFlagRead.getAcrossPopupImageByID(kid)
	gametop, gametop, nationalFlagRead.getAcrossPopupImageByID(kid).num = conquestWarCtrl, conquestWarCtrl:getNumString(conquestWarCtrl:getMyStrength()), conquestWarCtrl:getNumString(conquestWarCtrl:getMyStrength())
	gametop, conquestWarCtrl:getNumString(conquestWarCtrl:getMyStrength()).num, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(conquestWarCtrl:getMyStrength()).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_MyPower:setString(i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))
	gametop = i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))
	gametop, gametop, i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)).num = conquestWarCtrl, conquestWarCtrl:getNumString(conquestWarCtrl:getMatchStrength()), conquestWarCtrl:getNumString(conquestWarCtrl:getMatchStrength())
	gametop, conquestWarCtrl:getNumString(conquestWarCtrl:getMatchStrength()).num, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(conquestWarCtrl:getMatchStrength()).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_OppPower:setString(i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))))
	gametop = i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))
	i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))).num1 = conquestWarCtrl:getNumString(power)
	gametop, gametop, i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))).num2 = conquestWarCtrl, conquestWarCtrl:getNumString(conquestWarCtrl:getStrengthDiff()), conquestWarCtrl:getNumString(conquestWarCtrl:getStrengthDiff())
	gametop, conquestWarCtrl:getNumString(conquestWarCtrl:getStrengthDiff()).num1, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(conquestWarCtrl:getStrengthDiff()).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_Power:setString(i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))))
	gametop = i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))))
	i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))).num1 = num
	gametop, gametop, i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))).num2 = "CONQUESTWAR_REINFORCEMENT_AGREE", constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10), constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10)
	gametop, constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10).num1, ("CONQUESTWAR_REINFORCEMENT_AGREE").color = "CONQUESTWAR_REINFORCEMENT_AGREE", "CONQUESTWAR_REINFORCEMENT_AGREE", "#FFF5E1"
	constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10).__default, ("CONQUESTWAR_REINFORCEMENT_AGREE").color = "CONQUESTWAR_REINFORCEMENT_AGREE", "#D7C39B"
	self.fields.Text_Num:setString(i18n_html("conquestwar_text_15", i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))))))
	gametop = i18n_html("conquestwar_text_15", i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))))
	gametop, gametop, i18n_html("conquestwar_text_15", i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid))))).num = conquestWarCtrl, conquestWarCtrl:getNumString(conquestWarCtrl:getMaxStrength()), conquestWarCtrl:getNumString(conquestWarCtrl:getMaxStrength())
	gametop, conquestWarCtrl:getNumString(conquestWarCtrl:getMaxStrength()).num, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFF5E1"
	conquestWarCtrl:getNumString(conquestWarCtrl:getMaxStrength()).__default, conquestWarCtrl.color = conquestWarCtrl, "#D7C39B"
	self.fields.Text_OneMaxPower:setString(i18n_html("conquestwar_text_29", i18n_html("conquestwar_text_15", i18n_html("conquestwar_text_14", i18n_html("conquestwar_text_17", i18n_html("conquestwar_text_13", nationalFlagRead.getAcrossPopupImageByID(kid)))))))
end
function kingdomBattleInvitationPanel:updateInviteList()
	self.inviteList = conquestWarReinforcementsCtrl:getInviteInfo()
	self.fields.List_In:setNumItems(#self.inviteList)
end
function kingdomBattleInvitationPanel:onClickInvitation()
	SoraDPlaySound()
	uiManager:show("kingdomBattleSearch")
end
function kingdomBattleInvitationPanel:onInviteItemRender(index, target)
	target:initData(self.inviteList[index + 1])
end
function kingdomBattleInvitationPanel:onItemRender(index, target)
	target:initData(self.reinforceList[index + 1])
end
function kingdomBattleInvitationPanel:onClickQues()
	SoraDPlaySound()
end
return kingdomBattleInvitationPanel

local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local com_Fight = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/com_Fight", com_Fight)
function com_Fight:onInit()
	self:fixChildrenPos()
	self.fields.n13:fix()
	self.fields.n17:fix()
	self.fields.n13:setAllFrameName("dh_wangguozfz_%02d.png", 1)
	self.fields.Com_EnemyHelp:addClickListener(handler(self, self.onClickReinforcements))
	self.fields.Com_MyHelp:addClickListener(handler(self, self.onClickMyReinforcements))
	self.fields.Com_EnemyHelp:setString(i18n("conquestwar_text_09"))
	self.fields.Com_MyHelp:setString(i18n("conquestwar_text_09"))
	self.fields.Com_EnemyHelp:setVisible(false)
	self.fields.Com_MyHelp:setVisible(false)
	self.fields.Text_oppoPower:setVisible(false)
	self.fields.Text_selfPower:setVisible(false)
	self.fields.Button_cRank:addClickListener(handler(self, self.btnCRankClick))
end
function com_Fight:onShow()
end
function com_Fight:initdata(isStart)
	self.battleInfo = conquestWarCtrl.matchKingdomInfo
	self.oppoKingNum = conquestWarCtrl.matchKid
	local myKid = "" .. gametop.playertop_:getKingdomID()
	local opKid = "" .. self.oppoKingNum
	local sourceKid = "" .. SoraDGetCtrl("lordInfoCtrl"):getMapSourceKid()
	local posX = SoraDFPosX(60, 640)
	self.fields.Button_cRank:setPositionX(myKid == sourceKid and posX or 640 - posX)
	if self.battleInfo[myKid] then
		self.fields.Text_self:setString(self.battleInfo[myKid].kname)
		self.fields.Image_self:setIcon(self:getKidPalace(myKid))
		self:setIntStr(SoraDGetChildByName(self, "Text_selfInt"), self.battleInfo[myKid].kingdomScore, isStart)
		local isKingdomRecovered = conquestWarCtrl:isRecoverd()
		local kingdomRecoverScore = conquestWarCtrl:getRecoverScore()
		local isInSelf = SoraDGetCtrl("lordInfoCtrl"):isInSelfKid()
		local target = isInSelf and self.fields.Image_self or self.fields.Image_oppo
		if not isKingdomRecovered and 0 < kingdomRecoverScore then
			target:setColor(cc.c3b(120, 120, 120))
		else
			target:setColor(cc.c3b(255, 255, 255))
		end
	end
	if self.battleInfo[opKid] then
		self.fields.Text_oppo:setString(self.battleInfo[opKid].kname)
		self.fields.Image_oppo:setIcon(self:getKidPalace(opKid))
		self:setIntStr(self.fields.Text_oppoInt, self.battleInfo[opKid].kingdomScore, isStart)
	end
	local isTimeEnd = 0 >= conquestWarCtrl:getReinforceShowLefttime()
	self.fields.Com_EnemyHelp:setVisible(conquestWarCtrl:isMatchTriggerReinforcements() and isTimeEnd)
	self.fields.Com_MyHelp:setVisible(conquestWarCtrl:isTriggerReinforcements() and isTimeEnd)
	self.fields.Usm_opp:setVisible(conquestWarCtrl:isMatchTriggerReinforcements() and isTimeEnd)
	self.fields.Usm_my:setVisible(conquestWarCtrl:isTriggerReinforcements() and isTimeEnd)
	if isTimeEnd and (conquestWarCtrl:isTriggerReinforcements() or conquestWarCtrl:isMatchTriggerReinforcements()) then
		self.fields.Text_oppoPower:setVisible(true)
		self.fields.Text_selfPower:setVisible(true)
		conquestWarCtrl = self:getKidPalace(opKid)
		self:getKidPalace(opKid).num = conquestWarCtrl:getNumString(conquestWarCtrl:getMatchStrength())
		self.fields.Text_oppoPower:setString(i18n("conquestwar_text_13", self:getKidPalace(opKid)))
		conquestWarCtrl = i18n("conquestwar_text_13", self:getKidPalace(opKid))
		i18n("conquestwar_text_13", self:getKidPalace(opKid)).num = conquestWarCtrl:getNumString(conquestWarCtrl:getMyStrength())
		self.fields.Text_selfPower:setString(i18n("conquestwar_text_13", i18n("conquestwar_text_13", self:getKidPalace(opKid))))
	end
end
function com_Fight:setIntStr(ocx, str, isStart)
	if isStart then
		_ENV = nil
		;(nil).num = str
		ocx:setString(i18n("common_text_2556", nil))
	else
		ocx:setString("")
	end
end
function com_Fight:getKidPalace(kid)
	local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
	local palaceInfoRead = include("palaceInfoRead")
	local kingdomlist = kingdomCtrl:getKingdomList()
	if kingdomlist[tonumber(kid)] then
		return palaceInfoRead.getIcon(kingdomlist[tonumber(kid)].palaceModel or 1)
	else
		return 1
	end
end
function com_Fight:btnCRankClick()
	SoraDPlaySound()
	uiManager:show("kingdomRankingsView")
end
function com_Fight:onClickReinforcements()
	SoraDPlaySound()
	_ENV = nil
	;(nil).kid = self.oppoKingNum
	uiManager:show("kingdomBattleReinforcement", nil)
end
function com_Fight:onClickMyReinforcements()
	SoraDPlaySound()
	_ENV = nil
	;(nil).kid = self.oppoKingNum
	uiManager:show("kingdomBattleReinforcement", nil)
end
return com_Fight

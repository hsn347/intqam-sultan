local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local armyDesRead = include("armyDesRead")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleMailDetail = class("epicBattleMailDetail", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleMailDetail")
	end
	return target
end)
function epicBattleMailDetail:ctor()
	self.lieuTenantHeros, _ENV, self.heros, _ENV, self.data, _ENV = nil, nil, nil, nil, nil, nil
	self.bossID = nil
	self.size = cc.size(640, 462)
	self.singleH = 102
	self.Image_title = SoraDGetChildByName(self, "Image_title")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_title:setString(i18n("common_text_121"))
	self.imgbg = SoraDGetChildByName(self, "imgbg")
	self.border = SoraDGetChildByName(self, "border")
	self.Image_instruction = SoraDGetChildByName(self, "Image_instruction")
	self.Text_loseWord = SoraDGetChildByName(self.Image_instruction, "Text_loseWord")
	self.Text_loseWord:setString(i18n("common_text_116"))
	self.Text_woundWord = SoraDGetChildByName(self.Image_instruction, "Text_woundWord")
	self.Text_woundWord:setString(i18n("common_text_132"))
	self.Text_killWord = SoraDGetChildByName(self.Image_instruction, "Text_killWord")
	self.Text_killWord:setString(i18n("common_text_115"))
	self.Text_remainWord = SoraDGetChildByName(self.Image_instruction, "Text_remainWord")
	self.Text_remainWord:setString(i18n("common_text_117"))
	self.Image_attackBg = SoraDGetChildByName(self, "Image_attackBg")
	self.Text_attack = SoraDGetChildByName(self.Image_attackBg, "Text_attack")
	self.Text_attack:setString(i18n("common_text_125"))
	self.Image_defendBg = SoraDGetChildByName(self, "Image_defendBg")
	self.Text_defend = SoraDGetChildByName(self.Image_defendBg, "Text_defend")
	self.Text_defend:setString(i18n("common_text_126"))
	self.Node_attackName = SoraDGetChildByName(self, "Node_attackName")
	self.Attack_name = SoraDGetChildByName(self.Node_attackName, "Text_name")
	self.Node_defendName = SoraDGetChildByName(self, "Node_defendName")
	self.Defend_name = SoraDGetChildByName(self.Node_defendName, "Text_name")
	self.Image_single = SoraDGetChildByName(self, "Image_single")
	self.Image_single:setVisible(false)
	self.Button_attribute = SoraDGetChildByName(self, "Button_attribute")
	self.Button_attribute:setTitleText(i18n("hero_title_01"))
	self.Button_attribute:addTouchEventListener(handler(self, self.btnAttributeClick))
	self.Button_fightDetail = SoraDGetChildByName(self, "Button_fightDetail")
	self.Button_fightDetail:setTitleText(i18n("common_text_122"))
	self.Button_fightDetail:addTouchEventListener(handler(self, self.btnFightDetailClick))
	self.Button_fightDetail:setVisible(false)
end
function epicBattleMailDetail:initData(data, bossID, playerHeroInfo)
	self.data = data
	dump(playerHeroInfo, "self.data=============", 10)
	self.bossID = bossID
	local height = 187
	local lordBaseInfo = lordInfoCtrl:getBaseInfo()
	self.Attack_name:setString(lordBaseInfo.nickName)
	local heroID = epicWarltCtrl.getBossHeroID(self.bossID)
	local defendName = i18n(epicWarltCtrl.getBossHeroName(heroID))
	self.Defend_name:setString(defendName)
	if not self.data.attackerDetail then
		_ENV = self.data.attackerDetail
	end
	self.testAttackArmyData = self.data.attackerDetail
	height = height + #self.testAttackArmyData * self.singleH
	if not self.data.defenderDetail then
		_ENV = self.data.defenderDetail
	end
	self.testDefendArmyData = self.data.defenderDetail
	height = height + #self.testDefendArmyData * self.singleH
	if self.data.fightDetail and (userSDKManager.isBeta() or device.platform == "mac") then
		self.Button_fightDetail:setVisible(true)
		height = height + 80
	end
	height = height + 155 + math.max(0, #self.testAttackArmyData - 1) * 5 + (#self.testDefendArmyData - 1) * 5 + 80
	self.size = cc.size(640, height)
	self:suitView()
	if playerHeroInfo and next(playerHeroInfo) then
		self.heros, self.lieuTenantHeros = SoraDGetCtrl("heroCtrl"):getHeroAndLieutenant(playerHeroInfo)
	end
end
function epicBattleMailDetail:suitView()
	self.imgbg:setContentSize(cc.size(616, self.size.height - 86))
	self.border:setContentSize(cc.size(640, self.size.height - 62))
	self.Image_title:setPositionY(self.size.height - 62)
	self.Image_instruction:setPositionY(self.size.height - 107)
	self.Image_attackBg:setPositionY(self.Image_instruction:getPositionY() - 50)
	self.Node_attackName:setPositionY(self.Image_attackBg:getPositionY() - 60)
	for k, v in ipairs(self.testAttackArmyData) do
		local single
		if k == 1 then
			single = self.Image_single
		else
			single = self.Image_single:clone()
			single:addTo(self, 9)
		end
		single:setVisible(true)
		self:setSingleData(single, v)
		single:setPosition(320, self.Node_attackName:getPositionY() - (self.singleH / 2 + 5) - (self.singleH + 5) * (k - 1))
	end
	self.Image_defendBg:setPositionY(self.Node_attackName:getPositionY() - (self.singleH + 5) * #self.testAttackArmyData - 30)
	self.Node_defendName:setPositionY(self.Image_defendBg:getPositionY() - 60)
	for k, v in ipairs(self.testDefendArmyData) do
		local single = self.Image_single:clone()
		single:addTo(self, 9)
		single:setVisible(true)
		self:setSingleData(single, v)
		single:setPosition(320, self.Node_defendName:getPositionY() - (self.singleH / 2 + 5) - (self.singleH + 5) * (k - 1))
	end
	if self.Button_fightDetail:isVisible() then
		self.Button_attribute:setPositionY(140)
		self.Button_fightDetail:setPositionY(60)
	else
		self.Button_attribute:setPositionY(60)
	end
end
function epicBattleMailDetail:setSingleData(single, data)
	SoraDGetChildByName(single, "Sprite_armyHead"):setSpriteFrame(armyDesRead.getIcon(data.battleItemId))
	SoraDGetChildByName(single, "Sprite_armyLevel"):setSpriteFrame(armyDesRead.getLvImg(data.battleItemId))
	SoraDGetChildByName(single, "Text_lose"):setString(string.formatnumberthousands(data.lost))
	SoraDGetChildByName(single, "Text_wound"):setString(string.formatnumberthousands(data.wounded))
	SoraDGetChildByName(single, "Text_kill"):setString(string.formatnumberthousands(data.kill))
	SoraDGetChildByName(single, "Text_remain"):setString(string.formatnumberthousands(data.survive))
	local spriteWarLv = SoraDGetChildByName(single, "Sprite_warLv")
	spriteWarLv:setVisible(armyDesRead.getWarLv(data.battleItemId) > 0)
	local labelWarLv = SoraDGetChildByName(single, "Text_warLv")
	labelWarLv:setVisible(armyDesRead.getWarLv(data.battleItemId) > 0)
	labelWarLv:setString(armyDesRead.getWarLv(data.battleItemId))
end
function epicBattleMailDetail:btnFightDetailClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("mailItemDetailFightDefense")
		_ENV = nil
		;(nil).fightDetail = self.data.fightDetail
		panel:initWithFightDetail(nil)
		panel:show(nil, 2)
	end
end
function epicBattleMailDetail:btnAttributeClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicBattleAttribute")
		panel:initData(self.bossID, self.heros, self.lieuTenantHeros)
		panel:show(nil, 2)
	end
end
function epicBattleMailDetail:getContentSize()
	return self.size
end
return epicBattleMailDetail

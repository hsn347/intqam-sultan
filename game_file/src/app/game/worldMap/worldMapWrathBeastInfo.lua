local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local publicRead = include("publicRead")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl", gametop)
local worldMapWrathBeastInfo = class("worldMapWrathBeastInfo", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapWrathBeastInfo")
	end
	return target
end)
function worldMapWrathBeastInfo:ctor()
	self.boss = nil
	self.bossState = nil
	self.tilePoint = nil
	self:initWidget()
end
function worldMapWrathBeastInfo:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WRATH_BEAST_REFRESH", handler(self, self.refreshAttackNum))
end
function worldMapWrathBeastInfo:initWidget(...)
	self.isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	self.massButton = SoraDGetChildByName(self, "Button_mass")
	self.massButton:setTitleText(i18n("common_text_2079"))
	self.massButton:addTouchEventListener(handler(self, self.massButtonCallFun))
	SoraDAutoSizeButtonText(self.massButton)
	self.attackButton = SoraDGetChildByName(self, "Button_attack")
	self.attackButton:setTitleText(i18n("common_text_008"))
	self.attackButton:addTouchEventListener(handler(self, self.atttackButtonCallFun))
	SoraDAutoSizeButtonText(self.attackButton)
	self.rewards, gametop, self.text_Name = SoraDGetChildByName(self, "Text_bossName"), SoraDGetChildByName(self, "Text_bossName"), SoraDGetChildByName(self, "Text_bossName")
	for i = 1, 4 do
		self.rewards[i] = SoraDGetChildByName(self, "image_kuang_" .. i)
	end
	self.progress_blood = SoraDGetChildByName(self, "LoadingBar_progress")
	self.text_progress = SoraDGetChildByName(self, "Text_progress")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	local rewardItemName4 = SoraDGetChildByName(self, "Text_item_name_4")
	rewardItemName4:setString(i18n("common_text_486"))
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.text_talk:setString(i18n("common_text_2080"))
	self.text_Info = SoraDGetChildByName(self, "Text_info")
	if self.text_Info then
		self.text_Info:setVisible(false)
	end
	self.imgBoss = SoraDGetChildByName(self, "Image_boss")
	local randomInfoLabel = SoraDGetChildByName(self, "Text_random")
	randomInfoLabel:setString(i18n("common_text_488"))
	self.Node_attackNum = SoraDGetChildByName(self, "Node_attackNum")
	local Button_add = SoraDGetChildByName(self.Node_attackNum, "Button_add")
	Button_add:addTouchEventListener(function(ref, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if wrathBeastCtrl:getLeftBuyTimes() <= 0 then
				SoraDShowMsgBox(i18n("god_beast_text_26"), i18n("common_text_204"))
			else
				SoraDCreatePanel("worldMapWrathBeastBuy"):show()
			end
		end
	end)
	local atkConfig = wrathBeastCtrl:getAtkTimesConfig()
	Button_add:setVisible(0 < #atkConfig)
	self.Text_attackNum = SoraDGetChildByName(self.Node_attackNum, "Text_attackNum")
	self.Text_attackNum = SoraDChangeTextToHtml(self.Text_attackNum)
	if not self.isSelfKindom or worldMapDefine.isInKingdomBattle() then
		self.massButton:setVisible(false)
		self.attackButton:setVisible(false)
		self.Node_attackNum:setVisible(false)
	else
		wrathBeastCtrl:sendReqInitMsg()
	end
end
function worldMapWrathBeastInfo:initData(mapInstance)
	self.boss = mapInstance
	self.leftLife = self.boss.leftLife
	self.text_Name:setString(self.boss.bossName .. " LV." .. self.boss.bossLevel)
	self.bossData = worldMapDefine.getWorldBossShow(self.boss:getBossClassID())
	self.imgBoss:setSpriteFrame(self.bossData.image)
	local reward = worldMapDefine.getWorldBossReward(self.boss:getBossClassID(), self.boss.bossLevel)
	if reward then
		for i = 1, 3 do
			SoraDGetChildByName(self.rewards[i], "Sprite_item"):setSpriteFrame(publicRead.getIcon(reward[i]))
			SoraDGetChildByName(self, "Text_item_name_" .. i):setString(publicRead.getName(reward[i]))
		end
	end
	self.progress_blood:setPercent(self.leftLife)
	self.text_progress:setString(SoraDFValueSuit(self.leftLife, "%"))
	self.Text_num:setString(SoraDFValueSuit("x", self.boss.lifeNum))
	self:refreshAttackNum()
end
function worldMapWrathBeastInfo:refreshAttackNum(...)

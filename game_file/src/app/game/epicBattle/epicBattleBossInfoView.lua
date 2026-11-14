local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
local publicRead = include("publicRead")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local epicBattleBossInfoView = class("epicBattleBossInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleBossInfoView")
	end
	return target
end)
function epicBattleBossInfoView:ctor()
	self.showItem, _ENV, self.bossData, _ENV = nil, nil, nil, nil
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setTouchEnabled(true)
	self.Panel_touch:addTouchEventListener(handler(self, self.onBossClick))
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.text_Name = SoraDGetChildByName(self, "Text_bossName")
	self.Text_type = SoraDGetChildByName(self, "Text_type")
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.Text_random = SoraDGetChildByName(self, "Text_random")
	self.Text_random:setString(i18n("common_text_488"))
	self.warningLabel = SoraDGetChildByName(self, "Text_warning")
	self.warningLabel:setString(i18n("epicbattle_text_38"))
	self.warningLabel:setVisible(false)
	self.Button_attack = SoraDGetChildByName(self, "Button_attack")
	self.Button_attack:setTitleText(i18n("arena_btn_04"))
	self.Button_attack:addTouchEventListener(handler(self, self.onBtnAttackClick))
	self.Text_warn = SoraDGetChildByName(self, "Text_warn")
	self.Text_warn:setString(i18n("epic_war_NoSoldier_desc"))
	self.Text_warn:setVisible(false)
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Panel_cut:setSwallowTouches(false)
	self.Node_awardShow = SoraDGetChildByName(self, "Node_awardShow")
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.showItem[1] = self.Node_award
end
function epicBattleBossInfoView:checkBossGuide()
	if epicWarCtrl:getCurGateID() == 1500101 and guideCtrl:isGuideNotCompleted(gGuideModule.NEW_EPIC_WAR_BOSS) and epicWarCtrl:isFinalBoss(self.pos) then
		epicWarCtrl = epicWarCtrl
		epicWarCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
		epicWarCtrl.step = 81001
		SoraDSendMessage(epicWarCtrl)
	end
end
function epicBattleBossInfoView:initData(data, pos)
	self.bossData = data
	self.pos = pos
	local index = self.bossData.eventData.eventParam.bossId
	local heroID = epicWarltCtrl.getBossHeroID(index)
	self.text_Name:setString(i18n(epicWarltCtrl.getBossHeroName(heroID)))
	self.text_talk:setString(i18n(epicWarltCtrl.getBossHeroTalk(heroID)))
	local isBoss = epicWarCtrl:isFinalBoss(self.pos)
	self.Text_type:setString(isBoss and i18n("epic_war_guard_name02") or i18n("epic_war_guard_name01"))
	self.Text_type:setColor(isBoss and cc.c3b(232, 186, 104) or cc.c3b(184, 184, 184))
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(heroID)
	if cfg then
		local atlas = string.gsub(spineCfg, "%.%w+$", ".atlas")
		self.spine_hero = sp.SkeletonAnimation:create(spineCfg, atlas, 0.5)
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:setPosition(cc.p(0, -100))
		self.spine_hero:addTo(self.Node_spine)
	end
	local award = epicWarltCtrl.getStageDropInfo(epicWarCtrl:getCurGateID(), index)
	for k, v in ipairs(award) do
		if not self.showItem[k] then
			self.showItem[k] = self.Node_award:clone()
			self.showItem[k]:setPosition(0, 0)
			self.showItem[k]:addTo(self.Node_awardShow)
		end
		local sprite_item = SoraDGetChildByName(self.showItem[k], "sprite_item")
		local Text_ItemName = SoraDGetChildByName(self.showItem[k], "Text_ItemName")
		sprite_item:setSpriteFrame(publicRead.getIcon(v))
		Text_ItemName:setString(publicRead.getName(v))
		sprite_item:setScale(95.03999999999999 / sprite_item:getContentSize().width)
	end
	if #award < 4 then
		local addItem = self.Node_award:clone()
		addItem:setPosition(0, 0)
		addItem:addTo(self.Node_awardShow)
		local sprite_item = SoraDGetChildByName(addItem, "sprite_item")
		local Text_ItemName = SoraDGetChildByName(addItem, "Text_ItemName")
		sprite_item:setSpriteFrame("bless_dropShow.png")
		sprite_item:setScale(95.03999999999999 / sprite_item:getContentSize().width)
		Text_ItemName:setString(i18n("epic_war_soldierBless_name"))
		self.showItem[#self.showItem + 1] = addItem
	end
	SoraDToCenter(self.Node_awardShow, 150)
	local _, curNum = epicWarCtrl:getCurArmyInfo()
	self.Text_warn:setVisible(curNum <= 0)
	self:checkBossGuide()
end
function epicBattleBossInfoView:onBossClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicBattleArmyDetailView")
		panel:initData(self.bossData)
		panel:show()
	end
end
function epicBattleBossInfoView:onBtnAttackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowLoading(nil, nil, nil, true)
		epicWarCtrl:sendReqTriggerEvent(self.pos)
		self:removeFromParent()
	end
end
function epicBattleBossInfoView:gameGuide_getTarget(itemName, parameters)
	return SoraDGetChildByName(self, itemName)
end
return epicBattleBossInfoView

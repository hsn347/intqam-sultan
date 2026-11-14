local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local heroNormalItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/heroNormalItem", heroNormalItem)
function heroNormalItem:onInit()
	self.isOwn = false
	self.fields.Btn_touch:addClickListener(handler(self, self.onBtnClick))
end
function heroNormalItem:onShow()
end
function heroNormalItem:onBtnClick()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound[gHeroNormalItemStyle.noHaveAndHaveCon] = true
	local SoraDPlaySound[gHeroNormalItemStyle.noHaveAndNoCon], config = true, SoraDPlaySound
	if config[self.myClickType] and not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	if gHeroNormalItemStyle.noHaveAndHaveCon == self.myClickType then
		SoraDShowHeroDetailView(self.heroID, self.heroClass)
	elseif gHeroNormalItemStyle.noHaveAndNoCon == self.myClickType then
		SoraDShowHeroDetailView(self.heroID, self.heroClass)
	elseif gHeroNormalItemStyle.haveAndFree == self.myClickType then
		SoraDShowHeroDetailView(self.heroID, self.heroClass)
	elseif gHeroNormalItemStyle.haveAndJail == self.myClickType then
		_ENV = nil
		;(nil).heroID = self.heroID
		uiManager:show("HeroJailDetail", nil)
	end
end
function heroNormalItem:initData(heroID, heroClass)
	self.heroID = tonumber(heroID)
	if heroClass and 0 < heroClass then
		self.heroClass = heroClass
	else
		self.heroClass = nil
	end
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	if self.heroInfo then
		self.isOwn = true
		self.controllers.c2:setSelectedIndex(0)
		self.controllers.c4:setSelectedIndex(1)
		self:initView()
	else
		self.isOwn = false
		self.controllers.c2:setSelectedIndex(1)
		self.controllers.c4:setSelectedIndex(0)
		self:initNoView()
	end
	self:updateReddot()
end
function heroNormalItem:initCommon()
	self.fields.bg:setSpriteFrame(heroltCtrl.getHeroCardBg(self.heroID))
	self.fields.Sprite_head:setSpriteFrame(self.heroDesInfo.heroCard)
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID, self.heroClass)
	if heroClassInfo then
		self.fields.Sprite_class:setSpriteFrame(heroClassInfo.cardIcon)
	end
	self.fields.Sprite_quality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	self.fields.Sprite_heroname:setSpriteFrame(heroltCtrl.getHeroNamePng(self.heroID))
	self.fields.Sprite_ownDress:setVisible(heroltCtrl:isOwnMoreDress(self.heroID))
	self.controllers.c1:setSelectedIndex(self.isOwn and self.heroDesInfo.rarity >= gHeroQuality.PURPLE and 1 or 0)
	self:showEffect()
end
function heroNormalItem:initView()
	self:initCommon()
	self.fields.Node_noActive:setVisible(false)
	self.fields.Text_lv:setString(self.heroInfo.level)
	if self.heroDesInfo.rarity >= gHeroQuality.PURPLE and gHeroState.HERO_STATE_DEAD ~= self.heroInfo.state then
		self.fields.Panel_head:initData(self.heroID)
	elseif gHeroState.HERO_STATE_DEAD == self.heroInfo.state then
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.frame_quality_frm:setSpriteFrame(heroltCtrl.getCardFrmBg(self.heroInfo.quality))
	self:initUpBar()
	self.controllers.c3:setSelectedIndex(self.heroInfo.isAwake and 1 or 0)
	self.fields.icon_state:setVisible(false)
	self.fields.Node_state:setVisible(false)
	if gHeroState.HERO_STATE_NORMAL == self.heroInfo.state then
		self.myClickType = gHeroNormalItemStyle.haveAndFree
	elseif gHeroState.HERO_STATE_DEAD == self.heroInfo.state then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.icon_state:setVisible(true)
		self.fields.icon_state:setSpriteFrame("icon_hero_death.png")
		self.myClickType = gHeroNormalItemStyle.haveAndFree
	elseif gHeroState.HERO_STATE_CAPTURED == self.heroInfo.state then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.icon_state:setVisible(true)
		self.fields.icon_state:setSpriteFrame("icon_hero_captivity.png")
		self.myClickType = gHeroNormalItemStyle.haveAndJail
	elseif gHeroState.HERO_STATE_BATTLE == self.heroInfo.state then
		self.fields.Node_state:setVisible(true)
		self.fields.Node_state:setTitle(i18n("hero_text_37"))
		self.myClickType = gHeroNormalItemStyle.haveAndFree
	elseif gHeroState.HERO_STATE_DEFEND == self.heroInfo.state then
		self.fields.Node_state:setVisible(true)
		self.fields.Node_state:setTitle(i18n("hero_text_38"))
		self.myClickType = gHeroNormalItemStyle.haveAndFree
	elseif gHeroState.HERO_STATE_ESCAPE == self.heroInfo.state then
		self.fields.icon_state:setVisible(true)
		self.fields.icon_state:setSpriteFrame("icon_hero_runaway.png")
		self.myClickType = gHeroNormalItemStyle.haveAndFree
	end
end
function heroNormalItem:initNoView()
	self:initCommon()
	self.fields.frame_quality_frm:setSpriteFrame(heroltCtrl.getCardFrmBg(gHeroQuality.WHITE))
	self.fields.upBar:setVisible(false)
	self.controllers.c3:setSelectedIndex(0)
	self.fields.icon_state:setVisible(false)
	self.fields.Node_state:setVisible(false)
	local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(self.heroID)
	heroltCtrl = heroltCtrl.getCardFrmBg(gHeroQuality.WHITE)
	heroltCtrl.getCardFrmBg(gHeroQuality.WHITE).member = itemNum
	heroltCtrl.getCardFrmBg(gHeroQuality.WHITE).total = needNum
	self.fields.Node_chip:setText(i18n("common_text_155", heroltCtrl.getCardFrmBg(gHeroQuality.WHITE)))
	self.fields.Node_chip:setTitleColor(needNum <= itemNum and cc.c3b(0, 190, 30) or cc.c3b(190, 40, 40))
	self.fields.Node_chip:setIcon(heroltCtrl.getHeroChip(self.heroID))
	if needNum <= itemNum then
		self.myClickType = gHeroNormalItemStyle.noHaveAndHaveCon
	else
		self.myClickType = gHeroNormalItemStyle.noHaveAndNoCon
	end
	local activeTime = heroltCtrl:getUpgradeActiveTime(self.heroID)
	if activeTime and 0 < activeTime and activeTime > serviceFunctions.systemTime() then
		self.fields.Node_noActive:setVisible(true)
		self.fields.Node_noActive:setTime(activeTime - serviceFunctions.systemTime())
	else
		self.fields.Node_noActive:setVisible(false)
	end
end
function heroNormalItem:initUpBar()
	local queue = heroCtrl:getUpgradeQueue(self.heroID)
	if queue then
		self.fields.upBar:setVisible(true)
		self.fields.upBar:initData(queue)
	else
		self.fields.upBar:setVisible(false)
	end
end
function heroNormalItem:showEffect()
	self.fields.Effect_kzm:setVisible(false)
	self.fields.Effect_spz:setVisible(false)
	self.fields.Effect_ksp:setVisible(false)
	if self.isOwn then
		local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(self.heroID)
		local upgradingHeroID = heroCtrl:getUpgradeQueue()
		if upgradingHeroID and upgradingHeroID == self.heroID then
			self.fields.Effect_spz:setVisible(true)
		elseif maxQuality > self.heroInfo.quality then
			local itemNum, needNum = heroltCtrl:judgeUpgradeItem(self.heroID, self.heroInfo.quality + 1)
			self.fields.Effect_ksp:setVisible(needNum <= itemNum)
		elseif maxQuality <= self.heroInfo.quality then
			local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
			if not self.heroInfo.isAwake and backpackCtrl:getItemCount(awakeInfo.item) >= awakeInfo.itemCount and self.heroInfo.level >= gHeroMaxLevel then
				self.fields.Effect_ksp:setVisible(true)
			end
		end
	else
		local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(self.heroID)
		self.fields.Effect_kzm:setVisible(needNum <= itemNum)
	end
	local img, rarity = heroltCtrl:getCardRareImg(self.heroID)
	local isRarity = rarity > gHeroRarity.BLUE
	if isRarity then
		local cardBg = heroltCtrl.getHeroCardBg(self.heroID)
		self.fields.Panel_head:showEffect(cardBg == "frame_YX_xiaobeijing20.png")
	end
end
function heroNormalItem:getHeroID()
	return self.heroID
end
function heroNormalItem:getTouchBtn()
	return self.fields.Btn_touch
end
function heroNormalItem:updateReddot(...)
	if self.heroInfo then
		local redNum = heroltCtrl:getHeroNormalItemRedNum(self.heroID)
		self.fields.Label_reddot:initData(0 < redNum, redNum)
	else
		local redNum = heroltCtrl:getHeroLockItemRedNum(self.heroID)
		self.fields.Label_reddot:initData(0 < redNum, redNum)
	end
end
return heroNormalItem

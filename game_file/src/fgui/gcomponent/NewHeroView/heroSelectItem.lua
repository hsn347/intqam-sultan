local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local baseComponent = require("fgui.base.baseComponent")
local heroSelectItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/heroSelectItem", heroSelectItem)
function heroSelectItem:onInit()
	self.fields.Text_Status:setString(i18n("fortress_text_29"))
	self.fields.key:setVisible(false)
	self.fields.Text_key:setString(i18n("hero_text_86"))
	self.fields.Text_key:setVisible(false)
	self:addClickListener(handler(self, self.btnSelfClick))
end
function heroSelectItem:onShow()
end
function heroSelectItem:initData(heroID)
	self.fields.Usm_1:setVisible(false)
	self.heroID = tonumber(heroID)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function heroSelectItem:initView(...)
	self.fields.Sprite_head:setURL(self.heroDesInfo.herIcon)
	local heroName = heroltCtrl.getHeroNamePng(self.heroID)
	if heroName then
		self.fields.Text_Name:setVisible(false)
		self.fields.sprite_name:setVisible(true)
		self.fields.sprite_name:setURL(heroName)
	else
		self.fields.Text_Name:setVisible(true)
		self.fields.sprite_name:setVisible(false)
		self.fields.Text_Name:setString(i18n(self.heroDesInfo.herName))
	end
	self.fields.Sprite_class:setURL(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.fields.Text_Lv:setString(self.heroInfo.level)
	self.fields.Sprite_headBg:setURL(heroltCtrl.getBg(self.heroInfo.quality))
	local isCanEscape = self.heroInfo.state == gHeroState.HERO_STATE_CAPTURED
	if not self.stateList[self.heroInfo.state] then
		self:setGray(true)
	else
		self:setGray(false)
	end
	self.fields.key:setVisible(isCanEscape)
	self.fields.Text_key:setVisible(isCanEscape)
	if self.stateList[gHeroState.HERO_STATE_GARRISON] and militaryFortressCtrl:isHeroInGarrison(self.heroID) then
		self.fields.Text_Status:setVisible(true)
	else
		self.fields.Text_Status:setVisible(false)
	end
	local rarity = heroltCtrl:getRarity(self.heroID)
	local iconName, _, _ = heroltCtrl:getCardRareImg(self.heroID)
	self.fields.Sprite_quality:setURL(iconName)
end
function heroSelectItem:setGray(isGray)
	self.fields.Sprite_headBg:setGrayed(isGray)
	self.fields.Sprite_head:setGrayed(isGray)
end
function heroSelectItem:setClickCallBack(handle)
	self.handle = handle
end
function heroSelectItem:setFilteHeroState(states)
	self.stateList = states
end
function heroSelectItem:btnSelfClick()
	SoraDPlaySound(nil, nil, 0.04)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if self.heroInfo.state == gHeroState.HERO_STATE_CAPTURED then
		local keyNum = backpackCtrl:getItemCount(gHeroSpecialItems.breakKey)
		if 0 < keyNum then
			_ENV = nil
			;(nil).heroID = self.heroID
			uiManager:show("HeroEscapeBox", nil)
		else
			SoraDShowMsgTip(i18n("hero_text_91"))
		end
	elseif self.stateList[self.heroInfo.state] then
		heroltCtrl:playHeroSound(self.heroID)
		if self.handle then
			self.handle(self.heroID)
		end
	else
		_ENV = i18n("hero_text_91")
		i18n("hero_text_91").state = heroltCtrl.getStateDes(self.heroInfo.state)
		SoraDShowMsgTip(i18n("hero_text_92", i18n("hero_text_91")))
	end
end
function heroSelectItem:showLieutenantEffect(isVisible)
	self.fields.Usm_1:setVisible(isVisible)
end
return heroSelectItem

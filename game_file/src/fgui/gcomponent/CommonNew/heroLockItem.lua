local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
_ENV = "backpackCtrl"
;("backpackCtrl")[gHeroState.HERO_STATE_DEAD] = "fortress_text_22"
;("backpackCtrl")[gHeroState.HERO_STATE_CAPTURED] = "fortress_text_21"
;("backpackCtrl")[gHeroState.HERO_STATE_BATTLE] = "formation_hero_notInCity_name"
;("backpackCtrl")[gHeroState.HERO_STATE_DEFEND] = "fortress_text_23"
local ("backpackCtrl")[gHeroState.HERO_STATE_ESCAPE], statueText = "fortress_text_21", "backpackCtrl"
local baseComponent = require("fgui.base.baseComponent")
local heroLockItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/heroLockItem", heroLockItem)
function heroLockItem:onInit()
	self.stateList, _ENV = nil, nil
	self.fields.text_inWar:setVisible(false)
	self.fields.sheer_inWar:setVisible(false)
	self.fields.Image_shadow:setVisible(false)
	self.fields.Text_name:setVisible(false)
	self.fields.Node_LieutenantEffect:setVisible(false)
	self.fields.key:setVisible(false)
	self.fields.Text_key:setString(i18n("hero_text_86"))
	self.fields.Text_key:setVisible(false)
	self.fields.Button_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
	self.fields.Sprite_class:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Sprite_quality:fixPos()
	self.fields.Button_remove:fixPos()
end
function heroLockItem:onShow()
end
function heroLockItem:initData(state, heroID, isCopy)
	self.curState = tonumber(state)
	self.heroID = tonumber(heroID)
	self.isCopy = isCopy or false
	self.isCanEscape = false
	print("self.curState,self.heroID====", self.curState, self.heroID)
	self:initView()
end
function heroLockItem:initView()
	self.controllers.c1:setSelectedIndex(self.curState)
	if gHeroItemLockStyle.have == self.curState then
		self:showHeroInfo()
	else
		self.fields.text_inWar:setVisible(false)
		self.fields.sheer_inWar:setVisible(false)
		self.fields.Image_shadow:setVisible(false)
		self.fields.key:setVisible(false)
		self.fields.Text_key:setVisible(false)
	end
end
function heroLockItem:showHeroInfo()
	print("showHeroInfo=====", self.heroID)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if heroInfo == nil then
		return
	end
	local heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.fields.Sprite_head:setSpriteFrame(heroDesInfo.herIcon)
	self.fields.Sprite_class:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.fields.Text_lv:setString(heroInfo.level)
	self.fields.Sprite_headBg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
	self.fields.text_inWar:setVisible(false)
	self.fields.sheer_inWar:setVisible(false)
	if heroInfo.state > 1 and not self.isCopy and not self.stateList[heroInfo.state] then
		self.fields.text_inWar:setVisible(true)
		self.fields.text_inWar:setString(i18n(statueText[heroInfo.state]))
		self.fields.Image_shadow:setVisible(true)
		self.fields.sheer_inWar:setVisible(true)
	end
	if self.showMilitaryStatus and SoraDIsMilitaryFOpen() and heroInfo.state == 1 and militaryFortressCtrl:isHeroInGarrison(self.heroID) then
		self.fields.text_inWar:setVisible(true)
		self.fields.text_inWar:setString(i18n("fortress_text_29"))
		self.fields.sheer_inWar:setVisible(true)
	end
	local rarity = heroltCtrl:getRarity(self.heroID)
	self.fields.Sprite_quality:setVisible(true)
	self.fields.Sprite_quality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	self.isCanEscape = heroInfo.state == gHeroState.HERO_STATE_CAPTURED
	if self.isCanEscape then
		self.fields.text_inWar:setVisible(false)
		self.fields.sheer_inWar:setVisible(false)
	end
	self:setGray(self.isCanEscape)
	self.fields.key:setVisible(self.isCanEscape)
	self.fields.Text_key:setVisible(self.isCanEscape)
end
function heroLockItem:setGray(isGray)
	self.fields.Sprite_headBg:setGrayed(isGray)
	self.fields.Sprite_head:setGrayed(isGray)
end
function heroLockItem:setRemoveClick(handle)
	self.fRemoveHandl = handle
end
function heroLockItem:setAddClick(handle)
	self.fAddHandl = handle
end
function heroLockItem:btnAddClick()
	if self.isCanEscape then
		local keyNum = backpackCtrl:getItemCount(gHeroSpecialItems.breakKey)
		if 0 < keyNum then
			backpackCtrl = nil
			;(nil).heroID = self.heroID
			uiManager:show("HeroEscapeBox", nil)
		else
			SoraDShowMsgTip(i18n("hero_text_91"))
		end
		return
	end
	if self.fAddHandl then
		SoraDPlaySound()
		self.fAddHandl()
	end
end
function heroLockItem:btnRemoveClick()
	if self.fRemoveHandl then
		SoraDPlaySound()
		self.fRemoveHandl(self.heroID)
	end
end
function heroLockItem:addNameText(str)
	self.fields.Text_name:setVisible(true)
	self.fields.Text_name:setString(str)
end
function heroLockItem:setShowMilitaryStatus(status)
	self.showMilitaryStatus = status
end
function heroLockItem:hideBtnRemove()
	self.fields.Button_remove:setVisible(false)
end
function heroLockItem:setFilteHeroState(states)
	self.stateList = states
end
function heroLockItem:showLieutenantEffect(isVisible)
	self.fields.Node_LieutenantEffect:setVisible(isVisible)
	if isVisible then
		self.fields.Node_LieutenantEffect:setVisible(true)
		self.fields.Node_LieutenantEffect:play(true)
	end
end
return heroLockItem

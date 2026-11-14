local militaryFortressRead = include("militaryFortressRead")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local militaryHeroItem = class("militaryHeroItem", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("militaryHeroItem")
end)
_ENV = "militaryHeroItem"
;("militaryHeroItem")[gHeroState.HERO_STATE_DEAD] = "fortress_text_22"
;("militaryHeroItem")[gHeroState.HERO_STATE_CAPTURED] = "fortress_text_21"
;("militaryHeroItem")[gHeroState.HERO_STATE_BATTLE] = "fortress_text_20"
;("militaryHeroItem")[gHeroState.HERO_STATE_DEFEND] = "fortress_text_23"
local ("militaryHeroItem")[gHeroState.HERO_STATE_ESCAPE], statueText = "fortress_text_21", "militaryHeroItem"
function militaryHeroItem:ctor(properties)
	self.canShowStatus = false
	self.spHeadBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHead = SoraDGetChildByName(self, "Sprite_head")
	self.spQuality = SoraDGetChildByName(self, "Sprite_quality")
	self.imgSelect = SoraDGetChildByName(self, "Image_select")
	self.imgSelect:setVisible(false)
	self.spLock = SoraDGetChildByName(self, "Sprite_lock")
	self.spLock:setVisible(false)
	self.spState = SoraDGetChildByName(self, "Sprite_state")
	self.textLv = SoraDGetChildByName(self.spState, "Text_lv")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.btnRemove = SoraDGetChildByName(self, "Button_remove")
	self.btnRemove:addTouchEventListener(handler(self, self.btnRemoveClick))
	self.btnRemove:setVisible(false)
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.btnAdd:setSwallowTouches(false)
	self.spNone = SoraDGetChildByName(self, "Sprite_None")
	self.spNone:setVisible(false)
	self.frameHszz = SoraDGetChildByName(self, "frame_lmrfd_hszz")
	self.frameHszz:setVisible(false)
	self.textStatus = SoraDGetChildByName(self, "Text_Status")
	self.textStatus:setVisible(false)
	self.textStatus:setString(i18n("fortress_text_10"))
	self.questIcon = SoraDGetChildByName(self, "icon_jctz_wh")
	self.questIcon:setVisible(false)
end
function militaryHeroItem:setNoneHero(visible)
	self.spHead:setVisible(visible)
	self.spClass:setVisible(visible)
	self.textLv:setVisible(visible)
	self.spHeadBg:setVisible(visible)
	self.spQuality:setVisible(visible)
	self.spState:setVisible(visible)
	self.questIcon:setVisible(not visible)
end
function militaryHeroItem:initData(heroID, otherData)
	self.heroID = tonumber(heroID)
	if self.heroID then
		self:setNoneHero(true)
	else
		self:setNoneHero(false)
		return
	end
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroState = self.heroInfo.state
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	if otherData then
		if otherData.scale then
			self:setScale(otherData.scale)
		end
		if otherData.canShowStatus then
			self.canShowStatus = otherData.canShowStatus
		end
		if otherData.addHandler then
			self.addHandler = otherData.addHandler
		end
	end
	self:initView()
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function militaryHeroItem:initView(...)
	self.spHead:setSpriteFrame(self.heroDesInfo.herIcon)
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.textLv:setString(self.heroInfo.level)
	self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(self.heroInfo.quality))
	local rarity = heroltCtrl:getRarity(self.heroID)
	if 4 <= rarity then
		self.spQuality:setPositionX(125)
	else
		self.spQuality:setPositionX(134)
	end
	self.spQuality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
	self.isChoosedBefore = militaryFortressCtrl:isHeroInGarrison(self.heroID)
	self.frameHszz:setVisible(self.isChoosedBefore and self.canShowStatus)
	self.textStatus:setVisible(self.isChoosedBefore and self.canShowStatus)
	if statueText[self.heroState] then
		self.frameHszz:setVisible(self.canShowStatus)
		self.textStatus:setVisible(self.canShowStatus)
		SoraDGetChildByName(self, "Node_Gray"):setColor(colorGray)
		self.textStatus:setString(i18n(statueText[self.heroState]))
	end
end
function militaryHeroItem:setChoosed(isChoosed)
	self.isChoosed = isChoosed
	self.spNone:setVisible(isChoosed)
	if isChoosed or self.isChoosedBefore and self.canShowStatus then
		SoraDGetChildByName(self, "Node_Gray"):setColor(colorGray)
	else
		SoraDGetChildByName(self, "Node_Gray"):setColor(colorNormal)
	end
end
function militaryHeroItem:btnRemoveClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
	end
end
function militaryHeroItem:btnAddClick(target, eventType)
	if eventType == ccui.TouchEventType.ended and self.addHandler then
		SoraDPlaySound()
		if self.isChoosed then
			return
		end
		if statueText[self.heroState] then
			_ENV = nil
			;(nil).var = i18n(statueText[self.heroState])
			SoraDShowMsgTip(i18n("fortress_text_24", nil))
			return
		end
		self.addHandler(self.heroID)
		self:setChoosed(true)
	end
end
return militaryHeroItem

local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroSelectItem = class("heroSelectItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroSelectItem")
	end
	return target
end)
function HeroSelectItem:ctor()
	self.stateList, _ENV = nil, nil
	self.spHeroBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHeroHead = SoraDGetChildByName(self, "Sprite_head")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.spriteName = SoraDGetChildByName(self, "sprite_name")
	self.btnClick = SoraDGetChildByName(self, "Button_click")
	self.btnClick:setSwallowTouches(false)
	self.btnClick:addTouchEventListener(handler(self, self.btnSelfClick))
	self.spQuality = SoraDGetChildByName(self, "Sprite_quality")
	self.frameHszz = SoraDGetChildByName(self, "frame_lmrfd_hszz")
	self.frameHszz:setVisible(false)
	self.textStatus = SoraDGetChildByName(self, "Text_Status")
	self.textStatus:setVisible(false)
	self.textStatus:setString(i18n("fortress_text_29"))
	self.nodeLieutenantEffect = SoraDGetChildByName(self, "Node_LieutenantEffect")
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function HeroSelectItem:setFilteHeroState(states)
	self.stateList = states
end
function HeroSelectItem:initData(heroID)
	self.nodeLieutenantEffect:setVisible(false)
	self.heroID = tonumber(heroID)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function HeroSelectItem:initView(...)
	self.spHeroHead:setSpriteFrame(self.heroDesInfo.herIcon)
	local heroName = heroltCtrl.getHeroNamePng(self.heroID)
	if heroName then
		self.txtName:setVisible(false)
		self.spriteName:setVisible(true)
		self.spriteName:setSpriteFrame(heroName)
		local scale = 0.35
		local spriteH = self.spriteName:getContentSize().height
		if 100 < spriteH then
			scale = 100 / spriteH * scale
		end
		self.spriteName:setScale(scale)
	else
		self.txtName:setVisible(true)
		self.spriteName:setVisible(false)
		self.txtName:setString(i18n(self.heroDesInfo.herName))
	end
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.txtLv:setString(self.heroInfo.level)
	self.spHeroBg:setSpriteFrame(heroltCtrl.getBg(self.heroInfo.quality))
	if not self.stateList[self.heroInfo.state] then
		SoraDGetCSBFather(self):setColor(colorGray)
	else
		SoraDGetCSBFather(self):setColor(colorNormal)
	end
	if self.stateList[gHeroState.HERO_STATE_GARRISON] and militaryFortressCtrl:isHeroInGarrison(self.heroID) then
		self.textStatus:setVisible(true)
		self.frameHszz:setVisible(true)
	else
		self.textStatus:setVisible(false)
		self.frameHszz:setVisible(false)
	end
	local rarity = heroltCtrl:getRarity(self.heroID)
	if 4 <= rarity then
		self.spQuality:setPositionX(SoraDFIsRA() and -55 or 58)
	else
		self.spQuality:setPositionX(SoraDFIsRA() and -60 or 63)
	end
	self.spQuality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
end
function HeroSelectItem:setClickCallBack(handle)
	self.handle = handle
end
function HeroSelectItem:setScroll(scroll)
	self.scroll = scroll
end
function HeroSelectItem:btnSelfClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound(nil, nil, 0.04)
		self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		if self.stateList[self.heroInfo.state] then
			heroltCtrl:playHeroSound(self.heroID)
			if self.handle then
				self.handle(self.heroID)
			end
		else
			_ENV = 0.04
			;(0.04).state = heroltCtrl.getStateDes(self.heroInfo.state)
			SoraDShowMsgTip(i18n("hero_text_92", 0.04))
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function HeroSelectItem:showLieutenantEffect(isVisible)
	self.nodeLieutenantEffect:setVisible(isVisible)
	if isVisible and not self.criSprite then
		self.criSprite = cc.criSprite.createCriSprite("xzfj.usm", false, true, nil)
		self.criSprite:addTo(self.nodeLieutenantEffect, 6)
		self.criSprite:setPosition(0, 0)
	end
end
return HeroSelectItem

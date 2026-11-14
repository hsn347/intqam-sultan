local HeroLockItem = class("heroLockItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroLockItem")
	end
	return target
end)
function HeroLockItem:ctor()
	self.stateList, _ENV = nil, nil
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.spHeadBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHead = SoraDGetChildByName(self, "Sprite_head")
	self.spLock = SoraDGetChildByName(self, "Sprite_lock")
	self.spAdd = SoraDGetChildByName(self, "Sprite_add")
	self.spState = SoraDGetChildByName(self, "Sprite_state")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.txtInWar = SoraDGetChildByName(self, "text_inWar")
	self.txtInWar:setVisible(false)
	self.Image_shadow = SoraDGetChildByName(self, "Image_shadow")
	self.Image_shadow:setVisible(false)
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.btnRemove = SoraDGetChildByName(self, "Button_remove")
	self.btnRemove:addTouchEventListener(handler(self, self.btnRemoveClick))
	self.spQuality = SoraDGetChildByName(self, "Sprite_quality")
	self.spQualityBg = SoraDGetChildByName(self, "Image_QualitySheer")
	self.frameHszz = SoraDGetChildByName(self, "frame_lmrfd_hszz")
	_UPVALUE11_, self.nodeLieutenantEffect = SoraDGetChildByName(self, "Node_LieutenantEffect"), SoraDGetChildByName(self, "Node_LieutenantEffect")
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[1] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.nodeLieutenantEffect
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[2] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spHeadBg
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[3] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spHead
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[4] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spLock
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[5] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spAdd
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[6] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spState
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[7] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spClass
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[8] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.btnRemove
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[9] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.frameHszz
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[10] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spQuality
	self.ocxTbl, SoraDGetChildByName(self, "Node_LieutenantEffect")[11] = SoraDGetChildByName(self, "Node_LieutenantEffect"), self.spQualityBg
end
function HeroLockItem:initData(state, heroID, isCopy)
	self.curState = state
	self.isCopy = isCopy or false
	self.heroID = tonumber(heroID)
	self.txtInWar:setVisible(false)
	self.Image_shadow:setVisible(false)
	self:initView()
end
_ENV, HeroLockItem.initView = function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end, function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end
;(function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end)[gHeroState.HERO_STATE_DEAD] = "fortress_text_22"
;(function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end)[gHeroState.HERO_STATE_CAPTURED] = "fortress_text_21"
;(function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end)[gHeroState.HERO_STATE_BATTLE] = "formation_hero_notInCity_name"
;(function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end)[gHeroState.HERO_STATE_DEFEND] = "fortress_text_23"
local (function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end)[gHeroState.HERO_STATE_ESCAPE], statueText = "fortress_text_21", function(self, ...)
	for k, v in pairs(self.ocxTbl) do
		v:setVisible(false)
	end
	if gHeroItemLockStyle.none == self.curState then
		self.spAdd:setVisible(true)
	elseif gHeroItemLockStyle.have == self.curState then
		self.spHeadBg:setVisible(true)
		self.spHead:setVisible(true)
		self.spState:setVisible(true)
		self.spClass:setVisible(true)
		self.btnRemove:setVisible(true)
		self.spQuality:setVisible(true)
		self.spQualityBg:setVisible(true)
		self:showHeroInfo()
	elseif gHeroItemLockStyle.lock == self.curState then
		self.spLock:setVisible(true)
	end
end
function HeroLockItem:showHeroInfo(...)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.spHead:setSpriteFrame(heroDesInfo.herIcon)
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.txtLv:setString(heroInfo.level)
	self.spHeadBg:setSpriteFrame(heroltCtrl.getBg(heroInfo.quality))
	if heroInfo.state > 1 and not self.isCopy and not self.stateList[heroInfo.state] then
		self.txtInWar:setVisible(true)
		self.txtInWar:setString(i18n(statueText[heroInfo.state]))
		self.Image_shadow:setVisible(true)
	end
	if self.showMilitaryStatus and SoraDIsMilitaryFOpen() and heroInfo.state == 1 then
		local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
		if militaryFortressCtrl:isHeroInGarrison(self.heroID) then
			self.txtInWar:setVisible(true)
			self.txtInWar:setString(i18n("fortress_text_29"))
			SoraDGetAutoHeightLabelNew(self.txtInWar, 130)
			self.frameHszz:setVisible(true)
		end
	end
	local rarity = heroltCtrl:getRarity(self.heroID)
	if 4 <= rarity then
		self.spQuality:setPositionX(SoraDFIsRA() and -55 or 58)
	else
		self.spQuality:setPositionX(SoraDFIsRA() and -60 or 63)
	end
	self.spQuality:setVisible(true)
	self.spQuality:setSpriteFrame(heroltCtrl:getCardRareImg(self.heroID))
end
function HeroLockItem:setRemoveClick(handle)
	self.fRemoveHandl = handle
end
function HeroLockItem:setAddClick(handle)
	self.fAddHandl = handle
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
end
function HeroLockItem:btnAddClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound(nil, nil, 0.04)
		if self.fAddHandl then
			self.fAddHandl()
		end
	end
end
function HeroLockItem:btnRemoveClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound(nil, nil, 0.04)
		if self.fRemoveHandl then
			self.fRemoveHandl(self.heroID)
		end
	end
end
function HeroLockItem:addNameText(str)
	if not self.textName then
		self.textName = ccui.Text:create(str, nil, 20)
		self.textName:addTo(self)
		self.textName:setPosition(0, -80)
		self.textName:setColor(cc.c3b(215, 195, 155))
	else
		self.textName:setString(str)
	end
end
function HeroLockItem:setShowMilitaryStatus(status)
	self.showMilitaryStatus = status
end
function HeroLockItem:hideBtnRemove()
	self.btnRemove:setVisible(false)
end
function HeroLockItem:showLieutenantEffect(isVisible)
	self.nodeLieutenantEffect:setVisible(isVisible)
	if isVisible and not self.criSprite then
		self.criSprite = cc.criSprite.createCriSprite("xzfj.usm", false, true, nil)
		self.criSprite:addTo(self.nodeLieutenantEffect, 6)
		self.criSprite:setPosition(0, 0)
	end
end
function HeroLockItem:setFilteHeroState(states)
	self.stateList = states
end
return HeroLockItem

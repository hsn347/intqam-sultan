local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsMainAwardSingle = class("royalSummonsMainAwardSingle", function(target)
	return target
end)
local royalSummonsUtil = include("royalSummonsUtil")
local ROYAL_SUMMONS_AWARD_TYPE = royalSummonsUtil.ROYAL_SUMMONS_AWARD_TYPE
local ROYAL_SUMMONS_ITEM_TYPE = royalSummonsUtil.ROYAL_SUMMONS_ITEM_TYPE
function royalSummonsMainAwardSingle:ctor()
	self.data, _ENV, self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil, nil, nil
	self.nodeInfo = SoraDGetExtendChildFromCCSByName(self, "Node_single_info")
	self.txtTip = SoraDGetChildByName(self, "Text_single_tip")
	self.txtLevel = SoraDGetChildByName(self, "Text_award_lv")
	self.frameBg = SoraDGetChildByName(self, "frame_bg")
	self.txtTip:setString(i18n("summoned_text_45"))
	SoraDSetTextWidthHeight(self.txtTip, cc.size(360, 40))
	self:initEffect()
end
function royalSummonsMainAwardSingle:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
	end
	self.activityType = SoraDGetCtrl("royalSummonsCtrl"):getClassType()
	self.isLast = otherData.isLast
	self:recycleSingle()
	self:setAward()
end
function royalSummonsMainAwardSingle:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self:createItem()
	end
	single:setVisible(true)
	return single
end
function royalSummonsMainAwardSingle:createCacheNode()
	for _ = 1, 4 do
		local single = self:createItem()
		single:setVisible(false)
		table.insert(self.listNode, single)
	end
end
function royalSummonsMainAwardSingle:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function royalSummonsMainAwardSingle:createItem()
	local single = include("royalSummonsItem").new()
	single:setScale(0.7)
	single:setBaseScale(1.0)
	single:setOwnView(self.view)
	single:setOwnScroll(self.ownScroll)
	single:addTo(self, 100)
	return single
end
function royalSummonsMainAwardSingle:setAward_imp(award, posX, awardType, lv)
	local itemType = royalSummonsCtrl:getAwardItemStatus(awardType, lv)
	local offset = (#award + 1) % 2 * 45
	local posY = self.activityType == 1 and 40 or 50
	local totalWidth = self.activityType == 1 and 640 or 640
	for k, v in ipairs(award) do
		local single = self:getSingle()
		single:setPosition(SoraDFPosX(totalWidth - (posX - (k % 2 == 0 and 1 or -1) * offset), totalWidth), posY)
		single:initData(v.id, v.count)
		single:setItemStatus(itemType, royalSummonsCtrl:isActiveGold(), awardType)
		table.insert(self.scrollItems, single)
	end
	_UPVALUE2_ = posX
	posX[1] = self.spScrollTitleNormal
	posX[2] = self.txtScrollTitleNormal
	_ENV = self.txtScrollTitleNormal
	self.txtScrollTitleNormal[1] = 5
	_G.SoraDAlignNodeArrayOnCenterX(SoraDFPosX(posX, 0), posX, SoraDFIsRA(), self.txtScrollTitleNormal)
end
function royalSummonsMainAwardSingle:setAward()
	local nodeTexture = SoraDGetChildByName(self, "Node_Texture")
	if nodeTexture then
		nodeTexture:setVisible(false)
	end
	local leftFrame = SoraDGetChildByName(self, "frame_bg_left")
	local rightFrame = SoraDGetChildByName(self, "frame_bg_right")
	if not self.isLast and leftFrame then
		rightFrame:setVisible(false)
		leftFrame:setVisible(false)
	end
	if self.data.award then
		dump(self.data, "self.data", 10)
		self:showEffect(true, true, self.data.index)
		self:setAward_imp(self.data.award, self.activityType == 1 and 175 or 240, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_SUPER)
		self.txtTip:setVisible(true)
		self.txtTip:setPositionX(SoraDFPosX(self.activityType == 1 and 350 or 350, self.activityType == 1 and 640 or 640))
		if rightFrame then
			rightFrame:setVisible(true)
			if self.activityType == 1 then
				rightFrame:loadTexture("bg_jwzjlyh_tsjhsd.png", ccui.TextureResType.plistType)
			end
		end
		local tmpRightFrame = SoraDGetChildByName(self, "frame_bg_right_1")
		if tmpRightFrame then
			tmpRightFrame:setColor(cc.c3b(106, 85, 28))
		end
		if leftFrame then
			leftFrame:setVisible(true)
		end
		self.txtLevel:setString("50+")
		local centerLine = SoraDGetChildByName(self, "Size_Image_line")
		if centerLine then
			centerLine:setVisible(false)
		end
	else
		local tmpRightFrame = SoraDGetChildByName(self, "frame_bg_right_1")
		if tmpRightFrame then
			tmpRightFrame:setColor(cc.c3b(0, 71, 100))
		end
		local lv = self.data.lv
		self:showEffect(false, 0 < #self.data.bronzeAward, lv)
		self.txtTip:setVisible(false)
		self:setAward_imp(self.data.bronzeAward, self.activityType == 1 and 220 or 240, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL, lv)
		self:setAward_imp(self.data.goldAward, self.activityType == 1 and 500 or 510, ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD, lv)
		if rightFrame then
			if self.activityType == 1 then
				rightFrame:loadTexture("bg_jwzjlyh_tslsd.png", ccui.TextureResType.plistType)
			else
				rightFrame:setVisible(true)
			end
		end
		local centerLine = SoraDGetChildByName(self, "Size_Image_line")
		if centerLine then
			centerLine:setVisible(true)
		end
		self.txtLevel:setString(lv)
	end
end
function royalSummonsMainAwardSingle:showEffect(fromLast, showNormalEffect, lv)
	local blue = SoraDGetChildByName(self, "blue")
	local orange = SoraDGetChildByName(self, "orange")
	if not blue then
		return
	end
	local itemType = royalSummonsCtrl:getAwardItemStatus(ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL, lv)
	blue:setVisible(itemType == ROYAL_SUMMONS_ITEM_TYPE.ROYAL_SUMMONS_ITEM_TYPE_AWARD)
	orange:setVisible(showNormalEffect and itemType == ROYAL_SUMMONS_ITEM_TYPE.ROYAL_SUMMONS_ITEM_TYPE_AWARD)
	SoraDGetChildByName(blue, "Sprite_36"):stopAllActions()
	SoraDGetChildByName(blue, "dh_csyxn5_00_7"):setScaleX(2.03)
	local frames_2 = display.newFrames("dh_csyxn4_%.2d.png", 0, 14)
	local animation_2 = display.newAnimation(frames_2, 1.25 / #frames_2)
	SoraDGetChildByName(blue, "Sprite_36"):playAnimationForever(animation_2)
	SoraDGetChildByName(orange, "Sprite_36"):stopAllActions()
	if fromLast then
		SoraDGetChildByName(orange, "dh_csyxn5_00_7"):setVisible(false)
		SoraDGetChildByName(blue, "dh_csyxn5_00_7"):setScaleX(4.06)
		SoraDGetChildByName(orange, "dh_csyxn5_00_7"):setColor(cc.c3b(105, 156, 255))
		SoraDGetChildByName(orange, "Sprite_36"):playAnimationForever(animation_2)
	else
		SoraDGetChildByName(orange, "dh_csyxn5_00_7"):setColor(cc.c3b(255, 194, 105))
		local frames_2 = display.newFrames("dh_csyxn_%.2d.png", 0, 14)
		local animation_2 = display.newAnimation(frames_2, 1.25 / #frames_2)
		SoraDGetChildByName(orange, "Sprite_36"):playAnimationForever(animation_2)
	end
end
function royalSummonsMainAwardSingle:initEffect()
	local blue = SoraDGetChildByName(self, "blue")
	local orange = SoraDGetChildByName(self, "orange")
	if not blue then
		return
	end
	SoraDGetChildByName(blue, "dh_csyxn5_00_7"):setOpacity(255)
	SoraDGetChildByName(blue, "dh_csyxn5_00_7"):stopAllActions()
	_UPVALUE3_ = nil
	;(nil)[1] = cca.fadeTo(0.7666666666666667, 0.49)
	;(nil)[2] = cca.fadeTo(0.65, 1)
	;(nil)[3] = cca.fadeTo(0.31666666666666665, 0.63)
	;(nil)[4] = cca.fadeTo(0.6833333333333333, 1)
	;(nil)[5] = cca.fadeTo(0.6833333333333333, 1)
	;(nil)[6] = cca.fadeTo(0.6833333333333333, 1)
	SoraDGetChildByName(blue, "dh_csyxn5_00_7"):runAction(cca.repeatForever(cca.seq(nil)))
	SoraDGetChildByName(orange, "dh_csyxn5_00_7"):setOpacity(255)
	SoraDGetChildByName(orange, "dh_csyxn5_00_7"):stopAllActions()
	_UPVALUE3_ = cca.repeatForever(cca.seq(nil))
	cca.repeatForever(cca.seq(nil))[1] = cca.fadeTo(0.7666666666666667, 0.49)
	cca.repeatForever(cca.seq(nil))[2] = cca.fadeTo(0.65, 1)
	cca.repeatForever(cca.seq(nil))[3] = cca.fadeTo(0.31666666666666665, 0.63)
	cca.repeatForever(cca.seq(nil))[4] = cca.fadeTo(0.6833333333333333, 1)
	cca.repeatForever(cca.seq(nil))[5] = cca.fadeTo(0.6833333333333333, 1)
	cca.repeatForever(cca.seq(nil))[6] = cca.fadeTo(0.6833333333333333, 1)
	SoraDGetChildByName(orange, "dh_csyxn5_00_7"):runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
end
return royalSummonsMainAwardSingle

local publicRead = include("publicRead")
local buffDesRead = include("buffDesRead")
local itemDesRead = include("itemDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local commonItemAward = class("commonItemAward", function(target)
	if "userdata" == type(target) then
		return target
	else
		local view = SoraDCreateBasePanel("commonItemAward")
		return view
	end
end)
function commonItemAward:ctor()
	self.itemID = nil
	self.itemNum = nil
	self.handle = nil
	self.showCool = false
	self.scale = self:getScale()
	self.Node_particle = SoraDGetChildByName(self, "Node_particle")
	if self.Node_particle then
		self.Node_particle:setVisible(false)
	end
	self.Image_itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Image_icon = SoraDGetChildByName(self, "Image_icon")
	self.Image_itemBar = SoraDGetChildByName(self, "Image_itemBar")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Text_name = SoraDGetChildByName(self, "Text_Name")
	self.Image_frm = SoraDGetChildByName(self, "Image_frm")
	self.icon_arrowUp = SoraDGetChildByName(self, "icon_arrowUp")
	if self.icon_arrowUp then
		self.icon_arrowUp:setVisible(false)
	end
	self.Button_item = SoraDGetChildByName(self, "Button_item")
	if self.Button_item then
		self.Button_item:setSwallowTouches(false)
		self.Button_item:setTouchEnabled(true)
		self.Button_item = include("commonBtnInstance").new(self.Button_item)
	end
	self.dhTexture = SoraDGetChildByName(self, "dh_Texture_bbsyzy_001")
	self.Image_select = SoraDGetChildByName(self, "Image_select")
	if self.Image_select then
		self.Image_select:setVisible(false)
	end
	self.labNum = SoraDGetChildByName(self, "Text_LabNum")
	self.spriteNumBg = SoraDGetChildByName(self, "frame_sheer_black")
	self.img_warpattern = SoraDGetChildByName(self, "img_warpattern")
	if self.img_warpattern then
		self.img_warpattern:setVisible(false)
	end
end
function commonItemAward:initData(itemID, itemNum)
	self.itemID = itemID
	self.itemNum = itemNum
	self:initView()
	if self.Button_item then
		self.Button_item:setItemInfo(self.ownView or self.scroll, self.itemID, self.itemNum)
	end
end
function commonItemAward:getData()
	return self.itemID, self.itemNum
end
function commonItemAward:initView()
	local baseWH = 94
	local sType = serviceFunctions.getIDType(self.itemID)
	if self.itemID == gBuffEffect.LEV_29_INSTANT_BUILD_SPEED_BOOST then
		local princeGiftRead = include("princeGiftRead")
		local levelInfo = princeGiftRead.getTaskInfoByLevel(1)
		self.Image_icon:loadTexture(levelInfo.buffStrengthenIcon, ccui.TextureResType.plistType)
		self.Image_itemBar:setVisible(false)
		self.Text_num:setVisible(false)
		if self.labNum then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
		return
	end
	if sType == gIDType.PACKAGE then
		self.Image_quality:loadTexture(publicRead.getBg(self.itemID), ccui.TextureResType.plistType)
		self.Image_icon:loadTexture("icon_item_more.png", ccui.TextureResType.plistType)
		self.Button_item:setTouchEnabled(true)
		self.Image_itemBar:setVisible(false)
		self.Text_num:setVisible(false)
	elseif sType ~= gIDType.ITEM and sType ~= gIDType.TROOP and buffDesRead.isBuff(self.itemID) then
		self.Image_quality:loadTexture("frame_item_base_01.png", ccui.TextureResType.plistType)
		self.Image_icon:loadTexture(buffDesRead.getBuffIcon(self.itemID) or "icon_item_more.png", ccui.TextureResType.plistType)
		self.Button_item:setTouchEnabled(true)
		self.Image_itemBar:setVisible(self.itemNum ~= nil)
		self.Text_num:setVisible(self.itemNum ~= nil)
		if self.itemNum then
			local isGood = buffDesRead.isGoodBuff(self.itemID)
			local value = buffDesRead.addSign(self.itemNum / 10, isGood and 1 or 2, false)
			self.Text_num:setString(string.format("%d%%", value))
		end
		if self.labNum then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	elseif sType == gIDType.ENCHANTMENT_SCROLL then
		local wargemResRead = include("wargemResRead")
		local warGemltCtrl = include("warGemltCtrl")
		local info = warGemltCtrl:getGemCfg(self.itemID)
		self.Image_itemBar:setVisible(true)
		self.Text_num:setVisible(true)
		self.Text_num:setString(string.formatnumberthousands(self.itemNum))
		self.Image_quality:loadTexture(wargemResRead.getColorBg(info.color), ccui.TextureResType.plistType)
		self.Image_icon:loadTexture(wargemResRead.getIcon(self.itemID), ccui.TextureResType.plistType)
		if self.labNum then
			self.spriteNumBg:setVisible(false)
			self.labNum:setVisible(false)
		end
	else
		if self.Image_quality then
			self.Image_quality:loadTexture(publicRead.getBg(self.itemID), ccui.TextureResType.plistType)
		end
		if self.Image_icon then
			self.Image_icon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
			self.Image_icon:ignoreContentAdaptWithSize(true)
			self.Image_icon:setScale(self.scale * baseWH / self.Image_icon:getContentSize().width)
		end
		if self.Image_itemBar then
			self.Image_itemBar:setVisible(self.itemNum ~= nil)
		end
		if self.Text_num then
			self.Text_num:setVisible(self.itemNum ~= nil)
			if self.itemNum then
				if type(self.itemNum) == "number" then
					self.Text_num:setString(string.formatnumberthousands(self.itemNum))
				else
					self.Text_num:setString("x" .. string.formatnumberthousands(tonumber(self.itemNum)))
				end
			end
		end
		if self.Text_name then
			self.Text_name:setString(publicRead.getName(self.itemID))
		end
		if self.showCool and not self.coolSquare then
			local effectUI = include("effectUI")
			self.coolSquare = effectUI.getCoolSuqare()
			self.coolSquare:setPosition(-1, 4)
			self.coolSquare:setScale(1.2)
			self.coolSquare:addTo(self, 9)
		end
		if self.labNum then
			local num = itemDesRead.getNumByID(self.itemID)
			if num then
				self.spriteNumBg:setVisible(true)
				self.labNum:setVisible(true)
				self.labNum:setString(num)
			else
				self.spriteNumBg:setVisible(false)
				self.labNum:setVisible(false)
			end
		end
	end
	if self.img_warpattern then
		local itemType = backpackltCtrl:getItemType(self.itemID)
		local idType = serviceFunctions.getIDType(self.itemID)
		self.img_warpattern:setVisible(false)
		if itemType == gItemType.WAR_PARTERN_FRAGMENT then
			local mergeID = backpackltCtrl:getItemIDByMaterial(self.itemID)
			if mergeID then
				local subscript = include("artifactRuneRead").getRuneSubscript(mergeID)
				if subscript then
					self.img_warpattern:setVisible(true)
					self.img_warpattern:setSpriteFrame(subscript)
				end
			end
		end
		if idType == gIDType.GOD_ARMS_RUNE then
			local subscript = include("artifactRuneRead").getRuneSubscript(self.itemID)
			if subscript then
				self.img_warpattern:setVisible(true)
				self.img_warpattern:setSpriteFrame(subscript)
			end
		end
	end
end
function commonItemAward:setSpecialQualityBg()
	if self.Image_quality then
		local quality = publicRead.getQuality(self.itemID)
		local realQuality = quality + 1
		self.Image_quality:loadTexture(string.format("bg_jztbz_pz%.2d.png", realQuality), ccui.TextureResType.plistType)
	end
end
function commonItemAward:setUpVisible(ret)
	if self.icon_arrowUp then
		self.icon_arrowUp:setVisible(ret)
	end
end
function commonItemAward:showEffect()
	if self.Node_particle then
		self.Node_particle:setVisible(true)
		local children = self.Node_particle:getChildren()
		for _, v in pairs(children) do
			v:setVisible(true)
		end
		SoraDResetEffectNode(self.Node_particle)
	end
end
function commonItemAward:showLightEffect()
	if self.dhTexture then
		self.dhTexture:setVisible(true)
		self.dhTexture:setOpacity(0)
		self.dhTexture:setScale(1.6)
		self.dhTexture:setBlendFunc(gl.ONE, gl.ONE)
		_UPVALUE3_ = gl.ONE
		gl.ONE[1] = cca.fadeTo(0.03333333333333333, 1)
		gl.ONE[2] = cca.scaleTo(0.1, 1.85)
		gl.ONE[3] = cca.delay(0.11666666666666667)
		gl.ONE[4] = cca.fadeTo(0.16666666666666666, 0)
		gl.ONE[5] = cca.fadeTo(0.16666666666666666, 0)
		gl.ONE[6] = cca.fadeTo(0.16666666666666666, 0)
		self.dhTexture:runAction(cca.seq(gl.ONE))
	end
end
function commonItemAward:setPyramidModel()
	self:setBaseBg("frame_jzttm_kuang.png")
	self.Image_itemBg:setContentSize(cc.size(100, 100))
	if self.Image_frm then
		self.Image_frm:setVisible(false)
	end
end
function commonItemAward:setPresentgiftModel()
	self:setBaseBg("frame_kzhlhd_yp.png")
	self.Image_itemBg:setContentSize(cc.size(115, 115))
	self.Image_itemBg:setPositionY(-2)
	if self.Image_frm then
		self.Image_frm:setVisible(false)
	end
end
function commonItemAward:setNewRiseModel()
	self:setBaseBg("frame_king_10.png")
	self.Image_itemBg:setContentSize(cc.size(115, 115))
	if self.Image_frm then
		self.Image_frm:setVisible(false)
	end
end
function commonItemAward:hideNum()
	if self.Image_itemBar then
		self.Image_itemBar:setVisible(false)
	end
	if self.Text_num then
		self.Text_num:setVisible(false)
	end
end
function commonItemAward:copy()
	return SoraDCreatePanelByCloneNode(self:clone(), "commonItemAward")
end
function commonItemAward:setHandle(handle)
	self.handle = handle
	self.Button_item:setHandle(self.handle)
end
function commonItemAward:setCoolSquare()
	self.showCool = true
end
function commonItemAward:hideCoolSquare()
	if self.coolSquare then
		self.coolSquare:setVisible(false)
	end
end
function commonItemAward:removeCoolSquare()
	if self.coolSquare then
		self.coolSquare:removeFromParent()
		self.coolSquare = nil
	end
end
function commonItemAward:showCoolSquare()
	if not self.coolSquare then
		local effectUI = include("effectUI")
		self.coolSquare = effectUI.getCoolSuqare()
		self.coolSquare:setPosition(-1, 4)
		self.coolSquare:setScale(1.2)
		self.coolSquare:addTo(self, 9)
	else
		self.coolSquare:setVisible(true)
	end
end
function commonItemAward:showNewCoolSquare()
	if not self.coolSquare then
		self.coolSquare = SoraDCreatAnimation("gemGoodsCoolSuqare")
		self.coolSquare:setPosition(-1, 1)
		self.coolSquare:addTo(self, 9)
		self.coolSquare:setScale(0.99)
	else
		self.coolSquare:setVisible(true)
	end
end
function commonItemAward:showCrazyYellowCoolSquare()
	if not self.coolSquare then
		self.coolSquare = display.newSprite("#dh_chuanqijunwang_1.png")
		local frames = display.newFrames("dh_chuanqijunwang_%.2d.png", 1, 12)
		local animation = display.newAnimation(frames, 0.1)
		self.coolSquare:playAnimationForever(animation)
		self.coolSquare:setPosition(0, 3)
		self.coolSquare:addTo(self, 9)
		self.coolSquare:setScale(1.16)
		SoraDMixtureGLONE(self.coolSquare)
	else
		self.coolSquare:setVisible(true)
	end
end
function commonItemAward:showCrazyRedCoolSquare()
	if not self.coolSquare then
		self.coolSquare = display.newSprite("#dh_qichongzou_GW_wupingkuang_01.png")
		local frames = display.newFrames("dh_qichongzou_GW_wupingkuang_%.2d.png", 1, 12)
		local animation = display.newAnimation(frames, 0.1)
		self.coolSquare:playAnimationForever(animation)
		self.coolSquare:setPosition(0, 1)
		self.coolSquare:addTo(self, 9)
		self.coolSquare:setScale(1.16)
		SoraDMixtureGLONE(self.coolSquare)
	else
		self.coolSquare:setVisible(true)
	end
end
function commonItemAward:setCoolSquareScale(scale)
	if self.coolSquare then
		self.coolSquare:setScale(scale)
	end
end
function commonItemAward:getCoolSquare()
	return self.coolSquare
end
function commonItemAward:setCoolSquareEffect(effect)
	self.coolSquare = effect
end
function commonItemAward:setOwnView(view)
	self.ownView = view
end
function commonItemAward:setScroll(scroll)
	self.scroll = scroll
end
function commonItemAward:setOffsetX(offsetX)
	self.Button_item:setOffsetX(offsetX)
end
function commonItemAward:setOwnScroll(scroll)
	self.ownScroll = scroll
	self.Button_item:setScroll(self.ownScroll)
end
function commonItemAward:setSwallowTouches(ret)
	self.Button_item:setSwallowTouches(ret or false)
end
function commonItemAward:setTouchEnabled(enable)
	self.Button_item:setTouchSwitch(enable)
end
function commonItemAward:setGray(isGray)
	local emnuType = isGray and 1 or 0
	local emnuType_not = isGray and 0 or 1
	self.Image_quality:getVirtualRenderer():setState(emnuType_not)
	self.Image_icon:getVirtualRenderer():setState(emnuType_not)
	self.Image_quality:getVirtualRenderer():setState(emnuType)
	self.Image_icon:getVirtualRenderer():setState(emnuType)
end
function commonItemAward:setShade(color)
	local color = color or cc.c3b(120, 120, 120)
	self.Image_quality:setColor(color)
	self.Image_icon:setColor(color)
end
function commonItemAward:setIconScale(scale)
	self.Image_icon:setScale(scale)
end
function commonItemAward:setTextColor(color)
	self.Text_num:setColor(color or cc.c3b(255, 255, 255))
end
function commonItemAward:setTextString(text)
	self.Text_num:setString(text)
end
function commonItemAward:setHtmlString(text)
	self.Text_num = SoraDChangeTextToHtml(self.Text_num)
	self.Text_num:setString(text)
end
function commonItemAward:setTextWidthHeight(size)
end
function commonItemAward:setTextFont(fSize)
	self.Text_num:setFontSize(fSize)
end
function commonItemAward:setBaseBg(png)
	local png = png or "frame_LegendaryKing_head_base.png"
	self.Image_itemBg:loadTexture(png, ccui.TextureResType.plistType)
end
function commonItemAward:setFrm(png)
	local png = png or "frame_square_15.png"
	if self.Image_frm then
		self.Image_frm:loadTexture(png, ccui.TextureResType.plistType)
	end
end
function commonItemAward:setBaseScale(scale)
	self.scale = scale or 1
	self:setContentSize()
end
function commonItemAward:setContentSize()
	local baseWH = 94
	local baseBarH = 29
	local baseFrmWH = 100
	self.Image_itemBg:setContentSize(cc.size(baseWH * self.scale, baseWH * self.scale))
	self.Image_quality:setContentSize(cc.size(baseWH * self.scale, baseWH * self.scale))
	self.Image_icon:ignoreContentAdaptWithSize(true)
	self.Image_icon:setScale(self.scale * baseWH / self.Image_icon:getContentSize().width)
	self.Image_itemBar:setContentSize(cc.size(baseWH * self.scale, baseBarH * self.scale))
	self.Image_itemBar:setPositionY(-baseWH * self.scale / 2)
	self.Text_num:setPositionY(baseBarH * self.scale / 2 - baseWH * self.scale / 2)
	self.Text_num:setPositionX(SoraDFPosX(-baseWH * self.scale / 2 + 7, 0))
	if self.Image_frm then
		self.Image_frm:setContentSize(cc.size(baseFrmWH * self.scale, baseFrmWH * self.scale))
	end
	if self.Image_select then
		self.Image_select:setContentSize(cc.size((baseFrmWH + 18) * self.scale, (baseFrmWH + 16) * self.scale))
	end
	self.Button_item:setContentSize(cc.size(baseWH * self.scale, baseWH * self.scale))
end
function commonItemAward:getContentSize()
	return self.Button_item:getContentSize()
end
function commonItemAward:setRealScale(scale)
	self:setScale(scale or 1)
end
function commonItemAward:setSelect(ret)
	self.Image_select:setVisible(ret)
end
function commonItemAward:setGot(isGet)
	self:setGray(isGet)
	if not self._getIcon and isGet then
		self._getIcon = display.newSprite("#icon_czhl_g.png")
		self._getIcon:setPosition(0, 3)
		self._getIcon:addTo(self, 10)
		self._getIcon:setScale(0.5)
	elseif self._getIcon then
		self._getIcon:setVisible(isGet)
	end
end
function commonItemAward:setGroupOn()
	self.isGroupOn = true
	local mainUIDef = include("mainUIDef")
	for i, v in ipairs(self._ccsView:getChildren()) do
		v:setGroupID(mainUIDef.uiGroupID.group_award_item + i)
		v:setGroupAuto(true)
	end
end
function commonItemAward:setGroupOff()
	if not self.isGroupOn then
		return
	end
	self.isGroupOn = false
	local mainUIDef = include("mainUIDef")
	for i, v in ipairs(self._ccsView:getChildren()) do
		v:setGroupID(0)
		v:setGroupAuto(false)
	end
end
function commonItemAward:cleanNode()
	self.Image_icon:loadTexture("1006.png", ccui.TextureResType.plistType)
	self:setVisible(true)
	self.Image_frm:setVisible(true)
	self.Image_itemBg:setVisible(true)
	self.Image_quality:setVisible(true)
	self.Image_icon:setVisible(true)
	self:setColor(cc.c3b(255, 255, 255))
	self:setScale(1.0)
	self:setGroupOff()
	self:setHandle(nil)
	self:setScroll(nil)
	self:setOwnView(nil)
	self:setOwnScroll(nil)
	if self.Button_item and tolua.isnull(self.Button_item.pFloor) then
		self.Button_item.pFloor = nil
	end
end
function commonItemAward:runFadeIn(time, delay)
	for k, v in ipairs(self:getChildren()) do
		v:setOpacity(0)
		_UPVALUE1_ = self:getChildren()
		self:getChildren()[1] = cca.delay(delay or 0)
		self:getChildren()[2] = cca.fadeIn(time or 1)
		self:getChildren()[3] = cca.fadeIn(time or 1)
		v:runAction(cca.seq(self:getChildren()))
	end
end
function commonItemAward:getImageSelect(...)
	return self.Image_select
end
function commonItemAward:setImgIcon(icon)
	self.Image_icon:loadTexture(icon or "frame_square_36.png", ccui.TextureResType.plistType)
end
function commonItemAward:hideNumExtra()
	self.spriteNumBg:setVisible(false)
	self.labNum:setVisible(false)
end
function commonItemAward:onExitPanel()
	if self.isFromeCache then
		SoraDPushItemAward(self)
	end
end
return commonItemAward

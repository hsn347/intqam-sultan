local buildLogic = include("buildLogic")
local allianceDesRead = include("allianceDesRead")
local lordLocalData = include("lordLocalData")
local HalloweenSendSingle = class("halloweenSendSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("halloweenSendSingle")
	end
	return target
end)
function HalloweenSendSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.handle = nil
	self.scroll = nil
	self.isSelect = false
	self.isLock = false
	self.singleIsMoved = false
	self.imgFlg = SoraDGetChildByName(self, "Image_flg")
	self.spriteCrown = SoraDGetChildByName(self, "Sprite_crown")
	self.imgPortrait = SoraDGetChildByName(self, "Image_portrait")
	self.spriteCastle = SoraDGetChildByName(self, "Sprite_castle")
	self.labelLastTime = SoraDGetChildByName(self, "Text_lastTime")
	self.lockSheer = ccui.ImageView:create("frame_sheer_red_01.png", ccui.TextureResType.plistType)
	self.lockSheer:ignoreContentAdaptWithSize(false)
	self.lockSheer:setContentSize(cc.size(240, 34))
	self.lockSheer:setAnchorPoint(cc.p(0.5, 0.5))
	self.lockSheer:setPosition(0, -125)
	self.lockTxt = ccui.Text:create("cccccc", "", 20)
	self.lockTxt:setColor(display.COLOR_RED)
	self.lockTxt:addTo(self.lockSheer)
	self.lockTxt:setAnchorPoint(cc.p(0.5, 0.5))
	self.lockTxt:setPosition(120, 17)
	self.lockSheer:addTo(self, 30)
	self.lockSheer:setVisible(false)
	self.labelCastleLv = SoraDGetChildByName(self, "Text_castleLv")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.btnCheck = ccui.CheckBox:create("frame_LegendaryKing_xz.png", "icon_g.png")
	self.btnCheck:setPosition(SoraDFPoint(-138, -55, 0))
	self.btnCheck:addTo(self, 99)
	self.btnCheck:setTouchEnabled(false)
	self:setCheck(self.isSelect)
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch:setSwallowTouches(false)
	if self.nodeTouch then
		self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.Image_official = SoraDGetChildByName(self, "Image_official")
	self.Image_official:setVisible(false)
	self.Node_have = SoraDGetChildByName(self, "Node_have")
	self.Node_none = SoraDGetChildByName(self, "Node_none")
	self.Node_none:setVisible(false)
	self.Node_officialName = SoraDGetChildByName(self, "Node_officialName")
	self.Node_officialName:setVisible(false)
	self:hiddleOther()
	SoraDAddMessage(self, "MESSAGE_HALLOWEEN_LOCK", handler(self, self.lockSingle))
end
function HalloweenSendSingle:setCheck(isCheck)
	self.btnCheck:setSelected(isCheck)
	self.isSelect = isCheck
end
function HalloweenSendSingle:lockSingle(target, data)
	self.isLock = data.isLock
	self.btnCheck:setVisible(self.isSelect or not self.isLock)
	if target then
		self:setlimitCon()
	end
end
function HalloweenSendSingle:setScroll(scroll)
	self.scroll = scroll
end
function HalloweenSendSingle:setHandle(handle)
	self.handle = handle
end
function HalloweenSendSingle:initData(singleData)
	self.tableSingleData = singleData
	self:showPublic()
end
function HalloweenSendSingle:setlimitCon(limitCon)
	if limitCon then
		self.limitCon = limitCon
	end
	if self.limitCon and next(self.limitCon) and self.limitCon.cityLevelLimit then
		local myCityLv
		if self.tableSingleData.iconID then
			myCityLv = self.tableSingleData.cityLevel
		else
			myCityLv = self.tableSingleData:getProperty("cityLevel")
		end
		if myCityLv and myCityLv < self.limitCon.cityLevelLimit then
			self.lockSheer:setVisible(true)
			_ENV = nil
			;(nil).lv = self.limitCon.cityLevelLimit
			self.lockTxt:setString(i18n("common_text_3655", nil))
			self.nodeTouch:setTouchEnabled(false)
			self.btnCheck:setVisible(false)
		else
			self.lockSheer:setVisible(false)
			self.nodeTouch:setTouchEnabled(true)
			self.btnCheck:setVisible(self.isSelect or not self.isLock)
		end
	end
end
function HalloweenSendSingle:showPublic()
	self.imgFlg:loadTexture(allianceDesRead.getFlg(gAllianceRank.R2), ccui.TextureResType.plistType)
	if self.tableSingleData.iconID then
		self.imgPortrait:loadTexture(lordLocalData.getBust(self.tableSingleData.iconID), ccui.TextureResType.plistType)
		self.labelPower:setString(string.formatnumberthousands(self.tableSingleData.totalFc))
		self:setCastleLv(self.tableSingleData.cityLevel)
		self.labelName:setString(self.tableSingleData.nickName)
	else
		self.imgPortrait:loadTexture(lordLocalData.getBust(self.tableSingleData:getProperty("iconID")), ccui.TextureResType.plistType)
		self.labelPower:setString(string.formatnumberthousands(self.tableSingleData:getProperty("totalFc")))
		self:setCastleLv(self.tableSingleData:getProperty("cityLevel"))
		self.labelName:setString(self.tableSingleData:getProperty("nickName"))
	end
end
function HalloweenSendSingle:setCastleLv(clv)
	local warLv = clv == nil and "" or buildLogic.transformBuildLvToWarLv(clv)
	local castleImg = "icon_castle.png"
	if type(warLv) == "number" and warLv >= CASTLE_MIN_WARLV then
		clv = warLv
		castleImg = "301101.png"
	end
	self.spriteCastle:setSpriteFrame(castleImg)
	self.spriteCastle:setScale(35 / self.spriteCastle:getContentSize().width)
	self.labelCastleLv:setString(tostring(math.min(clv, CASTLE_MAXLV_NOWAR)))
end
function HalloweenSendSingle:hiddleOther()
	self.spriteCrown:setVisible(false)
	self.labelLastTime:setVisible(false)
end
function HalloweenSendSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			if not self.isLock or self.isSelect then
				self:setCheck(not self.isSelect)
			end
			_ENV = not self.isSelect
			;(not self.isSelect).isSelect = self.isSelect
			;(not self.isSelect).data = self.tableSingleData
			self.handle(self, not self.isSelect)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return HalloweenSendSingle

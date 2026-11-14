local RechargePopMsgView = class("rechargePopMsgView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargePopMsgView")
	end
	return target
end)
function RechargePopMsgView:ctor()
	self.isHidePrePanel = false
	self:setBackGround(204.0)
	self.itemList, _ENV = self.setBackGround, self.setBackGround
	self.scroll = SoraDGetChildByName(self, "ScrollView_items")
	self.txtGiftGold = SoraDGetChildByName(self, "BitmapFontLabel_giftGold")
	self.txtGoldGold = SoraDGetChildByName(self, "BitmapFontLabel_goldGold")
	self.btnGiftGain = SoraDGetChildByName(self, "Button_giftGain")
	self.btnGoldGain = SoraDGetChildByName(self, "Button_goldGain")
	self.imgItem = SoraDGetChildByName(self, "Image_itemCopy")
	self.imgGiftMain = SoraDGetChildByName(self, "Center_Image_mainGift")
	self.imgGoldMain = SoraDGetChildByName(self, "Center_Image_mainGold")
	self.imgGoldBg = SoraDGetChildByName(self, "Image_goldBg")
	SoraDGetChildByName(self, "Text_tipGift"):setString(i18n("common_text_2665"))
	SoraDGetChildByName(self, "Text_titleGift"):setString(i18n("common_text_2666"))
	SoraDGetChildByName(self, "Text_tipGold"):setString(i18n("common_text_2667"))
	SoraDGetChildByName(self, "Text_titleGold"):setString(i18n("common_text_2666"))
	self.btnGiftGain:setTitleText(i18n("common_text_1146"))
	self.btnGoldGain:setTitleText(i18n("common_text_204"))
	self.imgGoldMain:setTouchEnabled(true)
	self.imgGoldMain:setFillType(1)
	self.imgGiftMain:setTouchEnabled(true)
	self.imgGiftMain:setFillType(1)
	self.btnGiftGain:addTouchEventListener(handler(self, self.btnGiftGainClick))
	self.btnGoldGain:addTouchEventListener(handler(self, self.btnGoldGainClick))
end
function RechargePopMsgView:initData(itemList, mailID, popType)
	print("popType = ", popType)
	self.itemList = SoraDIntArr2Table(itemList)
	self.mailID = mailID
	self.popType = popType
	self:initView()
end
function RechargePopMsgView:initDetailData(itemList, mailID, popType)
	print("popType = ", popType)
	self.itemList = itemList
	self.mailID = mailID
	self.popType = popType
	self:initDetailView()
end
function RechargePopMsgView:initView(...)
	if 1 == self.popType then
		self.imgGiftMain:setPositionX(320)
		self.imgGoldMain:setPositionX(-320)
		self.defaultMain = self.imgGiftMain
	elseif 2 == self.popType then
		self.imgGiftMain:setPositionX(-320)
		self.imgGoldMain:setPositionX(320)
		self.defaultMain = self.imgGoldMain
	end
	if self.itemList[gIDDef.GOLD] and self.itemList[gIDDef.GOLD] > 0 then
		self.txtGiftGold:setString(string.formatnumberthousands(self.itemList[gIDDef.GOLD]))
		self.txtGoldGold:setString(string.formatnumberthousands(self.itemList[gIDDef.GOLD]))
	else
		self.txtGiftGold:setString("0")
		self.txtGoldGold:setString("0")
		self.imgGoldBg:setVisible(false)
		SoraDGetChildByName(self, "frame_fight_lace_04_3"):setPositionY(567)
		self.scroll:setPositionY(567)
		self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 455))
	end
	self.itemList[gIDDef.GOLD] = nil
	local itemClick = function(btn, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if self.pFloor then
				self.pFloor:removeFromParent()
				self.pFloor = nil
			end
		elseif eventType == ccui.TouchEventType.began and not self.pFloor then
			local pos = self:convertToNodeSpace(btn:getTouchBeganPosition())
			self.pFloor = SoraDCreatePanel("commonItemTips")
			self.pFloor:initData(btn:getTag(), btn.equipQuality)
			if SoraDFIsRA() then
				if pos.x < 280 then
					self.pFloor:setPosition(pos.x + 280, pos.y)
				else
					self.pFloor:setPosition(pos.x, pos.y)
				end
			elseif pos.x > 360 then
				self.pFloor:setPosition(pos.x - 280, pos.y)
			else
				self.pFloor:setPosition(pos.x, pos.y)
			end
			self.pFloor:addTo(self, 100)
		end
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, math.ceil(table.nums(self.itemList) / 5) * 100)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local publicRead = include("publicRead")
	local itemids = table.keys(self.itemList)
	dump(self.itemList, "self.itemList")
	for i, v in ipairs(itemids) do
		print("itemids = ", v)
		local item = self.imgItem:clone()
		local count = self.itemList[v]
		item:loadTexture(publicRead.getBg(v), ccui.TextureResType.plistType)
		if tonumber(v) >= 40000091 and tonumber(v) <= 40003102 then
			item.equipQuality = equipDesRead.getEquipQuality(tonumber(v.id))
			v.id = equipDesRead.getEquipQualityCfgID(tonumber(v.id))
		end
		item:getChildByName("Image_item"):loadTexture(publicRead.getIcon(v), ccui.TextureResType.plistType)
		item:getChildByName("Text_count"):setString("x" .. count)
		item:setTouchEnabled(true)
		item:setTag(v)
		item:addTouchEventListener(itemClick)
		item:addTo(self.scroll)
		local per = sSize.width / 5
		local _x = sSize.width - (i - 1) % 5 * per - per / 2
		local _y = sH - (math.ceil(i / 5) - 1) * 100 - 50.0
		if not SoraDFIsRA() then
			_x = (i - 1) % 5 * per + per / 2
		end
		item:setPosition(_x, _y)
	end
	self.defaultMain:setScale(0.1)
end
function RechargePopMsgView:initDetailView(...)
	if 1 == self.popType then
		self.imgGiftMain:setPositionX(320)
		self.imgGoldMain:setPositionX(-320)
		self.defaultMain = self.imgGiftMain
	elseif 2 == self.popType then
		self.imgGiftMain:setPositionX(-320)
		self.imgGoldMain:setPositionX(320)
		self.defaultMain = self.imgGoldMain
	end
	for k, v in pairs(self.itemList) do
		if v.id == gIDDef.GOLD then
			self.txtGiftGold:setString(string.formatnumberthousands(v.count))
			self.txtGoldGold:setString(string.formatnumberthousands(v.count))
			table.remove(self.itemList, k)
			break
		end
	end
	local itemClick = function(btn, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if self.pFloor then
				self.pFloor:removeFromParent()
				self.pFloor = nil
			end
		elseif eventType == ccui.TouchEventType.began and not self.pFloor then
			local pos = self:convertToNodeSpace(btn:getTouchBeganPosition())
			self.pFloor = SoraDCreatePanel("commonItemTips")
			local publicRead = include("publicRead")
			self.pFloor:customData(publicRead.getName(btn._goodID), publicRead.getDes(btn._goodID, btn._goodQuality))
			if SoraDFIsRA() then
				if pos.x < 280 then
					self.pFloor:setPosition(pos.x + 280, pos.y)
				else
					self.pFloor:setPosition(pos.x, pos.y)
				end
			elseif pos.x > 360 then
				self.pFloor:setPosition(pos.x - 280, pos.y)
			else
				self.pFloor:setPosition(pos.x, pos.y)
			end
			self.pFloor:addTo(self, 100)
		end
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, math.ceil(table.nums(self.itemList) / 5) * 100)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local publicRead = include("publicRead")
	dump(self.itemList, "self.itemList")
	for i, v in ipairs(self.itemList) do
		print("itemids = ", v.id)
		local item = self.imgItem:clone()
		local bg = v.quality and publicRead.getBgByQuality(v.quality) or publicRead.getBg(v.id)
		item:loadTexture(bg, ccui.TextureResType.plistType)
		item:getChildByName("Image_item"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
		item:getChildByName("Text_count"):setString("x" .. v.count)
		item:setTouchEnabled(true)
		item._goodID = v.id
		item._goodQuality = v.quality
		item:addTouchEventListener(itemClick)
		item:addTo(self.scroll)
		local per = sSize.width / 5
		local _x = sSize.width - (i - 1) % 5 * per - per / 2
		local _y = sH - (math.ceil(i / 5) - 1) * 100 - 50.0
		if not SoraDFIsRA() then
			_x = (i - 1) % 5 * per + per / 2
		end
		item:setPosition(_x, _y)
	end
	self.defaultMain:setScale(0.1)
end
function RechargePopMsgView:popAction(...)
	local scaleTo = cc.EaseBackOut:create(cca.scaleTo(0.5, 1))
	self.defaultMain:runAction(scaleTo)
end
function RechargePopMsgView:btnGiftGainClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local mailCtrl = gametop.playertop_:getModule("mailCtrl")
		mailCtrl:getExtraOfMail(self.mailID)
		button:setBright(false)
		button:setEnabled(false)
		self:removeFromParent()
	end
end
function RechargePopMsgView:btnGoldGainClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		button:setBright(false)
		button:setEnabled(false)
		self:removeFromParent()
	end
end
return RechargePopMsgView

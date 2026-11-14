local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local worldKingdomLvItem = class("worldKingdomLvItem", function(target)
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("worldKingdomLvItem")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "worldKingdomLvItem")
	else
		return target
	end
end)
function worldKingdomLvItem:ctor()
	self.txtValue = SoraDGetChildByName(self, "Text_ItemValue")
	self.imgIcon = SoraDGetChildByName(self, "Image_ItemIcon")
	self.txtDesc = SoraDGetChildByName(self, "Text_ItemDes")
	self.imgArrow = SoraDGetChildByName(self, "Image_ItemArrow")
	self.imgValueIcon = SoraDGetChildByName(self, "Image_ItemValue_Icon")
	self.txtValuePos = cc.p(self.txtValue:getPosition())
end
function worldKingdomLvItem:setItemValue()
	local rs = ""
	local value = self.itemInfo.isBig and self.itemInfo.value or self.itemInfo.value1
	self.imgValueIcon:setVisible(false)
	local isShowValueIcon = false
	if self.itemInfo.effectType == 1 then
		rs = "+" .. value / 10 .. "%"
	elseif self.itemInfo.effectType == 2 then
		if self.itemInfo.buffType == 113 then
			local isShowWarLv, textLv = SoraDGetBuildWarLv(value)
			if isShowWarLv then
				rs = textLv
				self.imgValueIcon:setVisible(true)
				isShowValueIcon = true
			else
				rs = value
			end
		elseif self.itemInfo.buffType == 112 or self.itemInfo.buffType == 111 then
			rs = value
		else
			rs = "+" .. value
		end
	elseif self.itemInfo.effectType == 3 then
		rs = value / 60 .. i18n("common_text_545")
	elseif self.itemInfo.effectType == 4 then
		rs = value == 0 and "" or i18n("common_text_246")
	else
		rs = value
	end
	if isShowValueIcon == true then
		self.txtValue:ignoreContentAdaptWithSize(true)
		self.txtValue:setTextAreaSize(cc.size(0, 0))
		self.txtValue:setString(rs)
		if self.txtValue:getContentSize().width > 115 then
			SoraDGetAutoHeightLabel(self.txtValue, 115)
		end
		self.imgValueIcon:setPositionX(SoraDFIsRA() and 138 or 135)
		_UPVALUE2_ = self.imgValueIcon
		self.imgValueIcon[1] = self.imgValueIcon
		self.imgValueIcon[2] = self.txtValue
		_UPVALUE1_ = self.txtValue
		self.txtValue[1] = 5
		SoraDAlignNodeArray(self.imgValueIcon, SoraDFIsRA(), self.txtValue)
	else
		self.txtValue:setPositionX(self.txtValuePos.x)
		SoraDSetTextWidthHeight(self.txtValue, cc.size(115, 35))
		self.txtValue:setString(rs)
	end
end
function worldKingdomLvItem:setPasteCallBackHandle(panel)
	self.parentPanel = panel
end
function worldKingdomLvItem:openItem(content, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:customData(content.name, content.des)
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y + 120)
		else
			self.pFloor:setPosition(pos.x, pos.y + 120)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 120)
	else
		self.pFloor:setPosition(pos.x, pos.y + 120)
	end
	self.pFloor:addTo(self.parentPanel, 100)
end
function worldKingdomLvItem:translate2Touch(ocx, fun)
	ocx:setTouchEnabled(true)
	ocx:setSwallowTouches(false)
	ocx:addTouchEventListener(fun)
end
function worldKingdomLvItem:setMeGray(bool)
	if bool then
		self.txtValue:setColor(cc.c3b(75, 75, 75))
		self.imgIcon:getVirtualRenderer():setState(1)
		self.txtDesc:setColor(cc.c3b(75, 75, 75))
	else
		self.txtValue:setColor(cc.c3b(0, 255, 0))
		self.imgIcon:getVirtualRenderer():setState(0)
		self.txtDesc:setColor(cc.c3b(205, 180, 140))
	end
end
function worldKingdomLvItem:initData(itemData)
	self.itemInfo = itemData
	self:setItemValue()
	local buffName = ""
	local imgIcon = worldKingdomLvDesRead.getBuffIcon(self.itemInfo.buffType)
	local realImg = SoraDCheckPNG(imgIcon, "icon_item_common.png")
	self.imgIcon:loadTexture(realImg, ccui.TextureResType.plistType)
	if self.itemInfo.isBig then
		if self.itemInfo.value == self.itemInfo.value1 then
			self.imgArrow:setVisible(false)
		else
			self.imgArrow:setVisible(true)
		end
		self:setMeGray(false)
		buffName = worldKingdomLvDesRead.getDes(self.itemInfo.buffType, self.itemInfo.condition)
	else
		self.imgArrow:setVisible(false)
		local value = self.itemInfo.isBig and self.itemInfo.value or self.itemInfo.value1
		if value and value <= 0 then
			self:setMeGray(true)
		else
			self:setMeGray(false)
		end
		buffName = worldKingdomLvDesRead.getDes(self.itemInfo.buffType, self.itemInfo.condition1)
	end
	self.txtDesc:setString(buffName)
end
return worldKingdomLvItem

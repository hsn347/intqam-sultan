local propParser = include("propParser")
local attrltCtrl = include("attrltCtrl")
local buffDesRead = include("buffDesRead")
local militaryFortressRead = include("militaryFortressRead")
local buffScrollView = class("buffScrollView", function(target)
	return include("commonAutoScrollList").new(target)
end)
function buffScrollView:ctor()
	self.buffNameColor = cc.c3b(215, 195, 155)
	self.buffValueColor = cc.c3b(230, 180, 110)
	self.valueUpColor = cc.c3b(92, 181, 77)
	self.valueDownColor = cc.c3b(190, 40, 40)
	self.valueUpSpName = "icon_battle_arrow.png"
	self.valueDownSpName = "icon_jjys_arrow_01.png"
	self.fontSize = 18
	self.isCenter = false
	self.isStrAlign = true
	self.offsetX = 5
	self.proportion = 0.5
	self:setSingleCreate(handler(self, self.createSingle))
	self:setSingleRefresh(handler(self, self.refreshSingle))
	self:setSwallowTouches(false)
end
function buffScrollView:createSingle()
	local single = display.newNode()
	local buffName = ccui.Text:create("", "", self.fontSize)
	buffName:setName("Text_BuffName")
	buffName:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	buffName:addTo(single)
	buffName:setPositionY(self.childSize.height / 2)
	buffName:setColor(self.buffNameColor)
	local buffValue = ccui.Text:create("", "", self.fontSize)
	buffValue:setName("Text_BuffValue")
	buffValue:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	buffValue:addTo(single)
	buffValue:setPositionY(self.childSize.height / 2)
	buffValue:setColor(self.buffValueColor)
	local spValueStatu = display.newSprite("#" .. self.valueUpSpName)
	spValueStatu:setName("Sprite_UpDown")
	spValueStatu:setVisible(false)
	spValueStatu:addTo(single)
	spValueStatu:setPosition(cc.p(SoraDFPosX(10, self.childSize.width), self.childSize.height / 2))
	if self.isCenter then
		if self.isStrAlign then
			buffName:setAnchorPoint(cc.p(SoraDFPosX(0, 1), 0.5))
			buffName:setTextHorizontalAlignment(SoraDFLabelL())
			buffValue:setAnchorPoint(cc.p(SoraDFPosX(1, 1), 0.5))
			buffValue:setTextHorizontalAlignment(SoraDFLabelR())
		else
			buffName:setAnchorPoint(cc.p(0.5, 0.5))
			buffName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			buffValue:setAnchorPoint(cc.p(0.5, 0.5))
			buffValue:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		end
	else
		buffName:setAnchorPoint(cc.p(SoraDFPosX(1, 1), 0.5))
		buffName:setTextHorizontalAlignment(SoraDFLabelR())
		buffValue:setAnchorPoint(cc.p(SoraDFPosX(1, 1), 0.5))
		buffValue:setTextHorizontalAlignment(SoraDFLabelR())
	end
	return single
end
function buffScrollView:refreshSingle(parent, data, otherData)
	local titleStr, valueStr = ""
	titleStr, valueStr = militaryFortressRead.getTitleAndValueStr(data.attrID, data.attrValue)
	print(titleStr, valueStr)
	local buffName = parent:getChildByName("Text_BuffName")
	local buffValue = parent:getChildByName("Text_BuffValue")
	buffName:setString(titleStr)
	buffValue:setString(valueStr)
	local spValueStatu = parent:getChildByName("Sprite_UpDown")
	local spWidth = 0
	if data.isUp ~= nil then
		spValueStatu:setVisible(true)
		spValueStatu:setSpriteFrame(data.isUp and self.valueUpSpName or self.valueDownSpName)
		spValueStatu:setFlippedY(data.isUp)
		buffValue:setColor(data.isUp and self.valueUpColor or self.valueDownColor)
		spWidth = 20
	else
		spValueStatu:setVisible(false)
		buffValue:setColor(self.buffValueColor)
	end
	if self.isCenter then
		if self.isStrAlign then
			SoraDSetTextWidthHeight(buffName, cc.size(self.childSize.width / 2 - self.offsetX * 2, self.childSize.height))
			buffName:setPositionX(self.childSize.width / 2 + SoraDFPosX(self.offsetX, 0))
			buffValue:setPositionX(self.childSize.width / 2 - SoraDFPosX(self.offsetX, 0))
		else
			local nameWidth = SoraDGetTextLen(buffName)
			local valueWidth = SoraDGetTextLen(buffValue)
			if nameWidth + valueWidth + spWidth > self.childSize.width - 4 * self.offsetX then
				SoraDSetTextWidthHeight(buffName, cc.size(self.childSize.width - 4 * self.offsetX - valueWidth - spWidth, self.childSize.height))
			end
			buffName:setPositionX(self.childSize.width / 2 + SoraDFPosX(valueWidth + self.offsetX, 0))
			buffValue:setPositionX(self.childSize.width / 2 - SoraDFPosX(valueWidth + self.offsetX, 0))
		end
	elseif self.isStrAlign then
		SoraDSetTextWidthHeight(buffName, cc.size(self.childSize.width * self.proportion - self.offsetX * 2, self.childSize.height))
		buffName:setPositionX(SoraDFPosX(self.childSize.width - self.offsetX, self.childSize.width))
		buffValue:setPositionX(SoraDFPosX(self.childSize.width * (1 - self.proportion) + self.offsetX, self.childSize.width))
	else
		local nameWidth = SoraDGetTextLen(buffName)
		local valueWidth = SoraDGetTextLen(buffValue)
		if nameWidth + valueWidth + spWidth > self.childSize.width - 4 * self.offsetX then
			SoraDSetTextWidthHeight(buffName, cc.size(self.childSize.width - 4 * self.offsetX - valueWidth - spWidth, self.childSize.height))
		end
		buffName:setPositionX(SoraDFPosX(self.childSize.width - self.offsetX, self.childSize.width))
		buffValue:setPositionX(SoraDFPosX(buffName:getContentSize().width + 3 * self.offsetX, self.childSize.width))
	end
end
function buffScrollView:setOffsetX(offsetX)
	self.offsetX = offsetX
end
function buffScrollView:setProportion(proportion)
	self.proportion = proportion
end
function buffScrollView:getTitleAndValueStr(attrID, attrValue)
	local titleStr = attrltCtrl.getAttrDes(attrID)
	local attrType = attrltCtrl.getAttrType(attrID)
	local valueStr = propParser.getFormatByAttrTypeAndValue(attrType, attrValue, attrltCtrl.getShowValueType(attrType))
	return titleStr, valueStr
end
function buffScrollView:setBuffFontSize(fontSize)
	self.fontSize = fontSize
end
return buffScrollView

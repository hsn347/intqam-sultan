local chatSkinRead = include("chatSkinRead")
local chatBubbleNode = include("chatBubbleNode")
local chatRedPacketNode = class("chatRedPacketNode", function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end)
_ENV = "chatRedPacketNode"
;("chatRedPacketNode").fileIcon = "icon_redpacket_bag_02.png"
;("chatRedPacketNode").fileIconGold = "icon_recharge_wallet_02.png"
;("chatRedPacketNode").fileIconDropBox = "icon_tjbx_bx06.png"
_UPVALUE4_, ("chatRedPacketNode").iconWidth = function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end, 41
;("chatRedPacketNode").iconPadding, (function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end)[1] = function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end, 10
;("chatRedPacketNode").iconPadding, (function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end)[2] = function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end, 10
;("chatRedPacketNode").iconPadding, (function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end)[3] = function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end, 5
;("chatRedPacketNode").iconPadding, (function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end)[4] = function(target)
	local target = include("chatBaseNode").new("chatRedPacketNode")
	return target
end, 5
;("chatRedPacketNode").iconHeight = 62
;("chatRedPacketNode").bottomcolor = cc.c3b(125, 125, 125)
;("chatRedPacketNode").bottomfontsize = 20
;("chatRedPacketNode").fontsize = 22
;("chatRedPacketNode").minContentW = 100
;("chatRedPacketNode").maxContentW = 230
;("chatRedPacketNode").maxtextw = 300
local ("chatRedPacketNode").bottomsepw, _defaultParam = 10, "chatRedPacketNode"
_defaultParam.maxtextw = _defaultParam.maxtextw - _defaultParam.iconWidth - _defaultParam.iconPadding[gPadding.left] - _defaultParam.iconPadding[gPadding.right]
function chatRedPacketNode:ctor()
	self.bubble = include("chatBubbleNode").new()
	self.bubble:addTo(self)
	self.spriteIcon = display.newSprite("#" .. _defaultParam.fileIcon)
	self.spriteIcon:setAnchorPoint(cc.p(0.5, 0.5))
	self.spriteIcon:addTo(self, 1)
	self.text = HtmlRichText:create("", "", 20)
	self.text.__title:setTouchable(false)
	self.text:setIsHtml(true)
	self.text:addTo(self, 1)
	self.text:setAnchorPoint(cc.p(0.5, 0.5))
end
function chatRedPacketNode:init(data)
	self.data = data
	dump(data, "chatRedPacketNode:init(data")
	self:initContent(data)
	self.bubble:init(data)
	self:alignContent()
end
function chatRedPacketNode.getPackageText(data)
	if data.customData and data.customData.redPacketInfo and data.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
		data.bottomText = nil
		data.bottomTextTip = nil
		if data.customData.redPacketInfo.endTime <= serviceFunctions.systemTime() then
			return i18n("Frosty_Carnival_text_08")
		end
		_ENV = "item_name_874701"
		;("item_name_874701").color = "#FFFFFF"
		;("item_name_874701").size = 24
		local str1 = SoraDWrapHtmlTagByStyle(i18n("item_name_874701"), "item_name_874701")
		_ENV = "Frosty_Carnival_text_07"
		;("Frosty_Carnival_text_07").color = "#183E5B"
		;("Frosty_Carnival_text_07").size = 20
		local str2 = SoraDWrapHtmlTagByStyle(i18n("Frosty_Carnival_text_07"), "Frosty_Carnival_text_07")
		return string.format([[
%s
%s]], str1, str2)
	else
		return data.text
	end
end
function chatRedPacketNode:initContent(data)
	self:reset()
	local bubbleId = data.bubbleId
	local fontSize = _defaultParam.fontsize
	local textColor = _defaultParam.fontcolor
	local textBottomColor = _defaultParam.bottomcolor
	local bottomFontSize = _defaultParam.bottomfontsize
	local textAlign = data.textAlign or SoraDFLabelR()
	data.text = chatRedPacketNode.getPackageText(data)
	if bubbleId == gBubbleId.BUBBLE_ID_SUPER_PACKET then
		self.spriteIcon:setSpriteFrame(_defaultParam.fileIconGold)
	elseif data.customData and data.customData.redPacketInfo and data.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
		self.spriteIcon:setSpriteFrame(_defaultParam.fileIconDropBox)
	elseif data.customData and data.customData.redPacketInfo and data.customData.redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET then
		self.spriteIcon:setSpriteFrame("frame_9001687_bxjnh_libao2.png")
		if data.customData.redPacketInfo.endTime <= serviceFunctions.systemTime() then
			self:setGrayed(true)
			self:setIsClaimed(false)
			self.isGrayStatus = true
		end
	else
		self.spriteIcon:setSpriteFrame(_defaultParam.fileIcon)
	end
	if bubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
		if bubbleCfg then
			textColor = bubbleCfg.fontcolor_rgb
			textBottomColor = bubbleCfg.bottomcolor_rgb
		end
	end
	if data.text then
		self.text:setTextHorizontalAlignment(textAlign)
		self.text:setTextColor(textColor)
		self.text:setString(data.text)
		local measureSize
		if data.textContentSize then
			self.text:setTextAreaSize(data.textContentSize)
			measureSize = data.textContentSize
		else
			_defaultParam = self.text.setTextAreaSize
			self.text.setTextAreaSize.fontName = ""
			self.text.setTextAreaSize.fontSize = fontSize
			self.text.setTextAreaSize.fontAlignmentH = textAlign
			self.text.setTextAreaSize.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
			self.text.setTextAreaSize.fontDimensions = cc.size(0, 0)
			local self.text.setTextAreaSize.isHtml, txtContentInfo = true, self.text.setTextAreaSize
			measureSize = cc.Device:measureText(data.text, txtContentInfo)
			dump(measureSize, "第一次测量的结果")
			if measureSize.width > _defaultParam.maxtextw then
				SoraDGetAutoHeightLabelNew(self.text, _defaultParam.maxtextw, true)
			else
				self.text:ignoreContentAdaptWithSize(false)
				self.text:setTextAreaSize(measureSize)
			end
			data.textContentSize = self.text:getContentSize()
			dump(data.contentSize, "data.contentSize")
			measureSize = self.text:getContentSize()
		end
		local contentWidth = measureSize.width + _defaultParam.iconWidth + _defaultParam.iconPadding[gPadding.left] + _defaultParam.iconPadding[gPadding.right]
		local contentHeight = _defaultParam.iconHeight + _defaultParam.iconPadding[gPadding.top] + _defaultParam.iconPadding[gPadding.bottom]
		contentHeight = math.max(measureSize.height, contentHeight)
		local contentSize = cc.size(contentWidth, contentHeight)
		data.contentSize = contentSize
	else
		local contentWidth = _defaultParam.iconWidth + _defaultParam.iconPadding[gPadding.left] + _defaultParam.iconPadding[gPadding.right]
		local contentHeight = _defaultParam.iconHeight + _defaultParam.iconPadding[gPadding.top] + _defaultParam.iconPadding[gPadding.bottom]
		data.contentSize = cc.size(contentWidth, contentHeight)
	end
	local bottomSize, bottomTextSize, bottomTipSize
	if data.bottomText then
		if not self.bottomText then
			self.bottomText = HtmlRichText:create("", "", 20)
			self.bottomText:addTo(self, 1)
		else
			self.bottomText:setVisible(true)
		end
		self.bottomText:setFontSize(bottomFontSize)
		self.bottomText:setTextColor(textBottomColor)
		self.bottomText:setTextHorizontalAlignment(textAlign)
		self.bottomText:setString(data.bottomText)
		bottomTextSize = self.bottomText:getContentSize()
		data.bottomSize = bottomTextSize
	end
	if data.bottomTextTip then
		if not self.bottomTextTip then
			self.bottomTextTip = HtmlRichText:create("", "", 20)
			self.bottomTextTip:addTo(self, 1)
		else
			self.bottomTextTip:setVisible(true)
		end
		self.bottomTextTip:setFontSize(bottomFontSize)
		self.bottomTextTip:setTextColor(textBottomColor)
		self.bottomTextTip:setTextHorizontalAlignment(textAlign)
		self.bottomTextTip:setString(data.bottomTextTip)
		bottomTipSize = self.bottomTextTip:getContentSize()
		data.bottomTipSize = bottomTipSize
		if not data.bottomSepw then
			data.bottomSepw = _defaultParam.bottomsepw
		end
	end
end
function chatRedPacketNode:reset()
	self.isGrayStatus = false
	self:setGrayed(false)
	if self.bottomText then
		self.bottomText:setVisible(false)
	end
	if self.bottomTextTip then
		self.bottomTextTip:setVisible(false)
	end
	self:setColor(cc.c3b(255, 255, 255))
end
function chatRedPacketNode:setIsClaimed(isClaimed)
	if self.isClaimed == isClaimed and isClaimed == false then
		return
	end
	if isClaimed and not self.isGrayStatus then
		self.bubble:setCascadeColorEnabled(true)
		self:setCascadeColorEnabled(true)
		self:setCascadeOpacityEnabled(true)
		self.bubble:setCascadeOpacityEnabled(true)
		self:setColor(cc.c3b(180, 180, 180))
		self:setOpacity(180)
	else
		self.bubble:setCascadeColorEnabled(false)
		self:setCascadeColorEnabled(false)
		self:setCascadeOpacityEnabled(false)
		self.bubble:setCascadeOpacityEnabled(false)
		self:setColor(cc.c3b(255, 255, 255))
		self:setOpacity(255)
	end
	self.isClaimed = isClaimed
end
function chatRedPacketNode:alignContent()
	self:setContentSize(cc.size(self.bubble.width, self.bubble.height))
	self.width = self.bubble.width
	self.height = self.bubble.height
	local contentPos = self.bubble:getContentPos()
	local contentPosrb = self.bubble:getContentPosRB()
	local textSize = self.text:getContentSize()
	if self.data.isRA then
		local iconpw = _defaultParam.iconPadding[gPadding.right]
		self.spriteIcon:setPosition(cc.p(contentPosrb.x - _defaultParam.iconWidth / 2 - iconpw, contentPosrb.y + self.data.contentSize.height / 2))
		self.text:setPosition(cc.p(contentPos.x + textSize.width / 2, contentPos.y + self.data.contentSize.height / 2))
	else
		local iconpw = _defaultParam.iconPadding[gPadding.left]
		self.spriteIcon:setPosition(cc.p(contentPos.x + _defaultParam.iconWidth / 2 + iconpw, contentPos.y + self.data.contentSize.height / 2))
		self.text:setPosition(cc.p(contentPosrb.x - textSize.width / 2, contentPos.y + self.data.contentSize.height / 2))
	end
	if self.data.bottomText and self.bottomText then
		self.bottomText:setAnchorPoint(cc.p(0, 0))
		self.bottomText:setPosition(self.bubble:getBottomPos())
	end
	if self.data.bottomTextTip and self.bottomTextTip then
		self.bottomTextTip:setAnchorPoint(cc.p(0, 0))
		self.bottomTextTip:setPosition(self.bubble:getBottomTipPos())
	end
end
function chatRedPacketNode.measureSize(data, target)
	local str = chatRedPacketNode.getPackageText(data)
	local isHtml = false
	if data.isHtml then
		isHtml = true
	end
	local fontSize = _defaultParam.fontsize
	local bottomFontSize = _defaultParam.bottomfontsize
	local bubbleId = data.bubbleId
	if bubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
		if bubbleCfg then
		end
	end
	local contentSize = cc.size(1, 1)
	local textContentSize = cc.size(1, 1)
	chatRedPacketNode = 1
	;(1).fontName = ""
	;(1).fontSize = fontSize
	;(1).fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
	;(1).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	;(1).fontDimensions = cc.size(0, 0)
	local (1).isHtml, txtContentInfo = true, 1
	local measureSize = cc.Device:measureText(str, txtContentInfo)
	if measureSize.width < _defaultParam.maxtextw then
	else
		txtContentInfo.fontDimensions.width = _defaultParam.maxtextw
		measureSize = cc.Device:measureText(str, txtContentInfo)
	end
	textContentSize = measureSize
	data.textContentSize = textContentSize
	local contentWidth = measureSize.width + _defaultParam.iconWidth + _defaultParam.iconPadding[gPadding.left] + _defaultParam.iconPadding[gPadding.right]
	local contentHeight = _defaultParam.iconHeight + _defaultParam.iconPadding[gPadding.top] + _defaultParam.iconPadding[gPadding.bottom]
	contentHeight = math.max(measureSize.height, contentHeight)
	contentSize = cc.size(contentWidth, contentHeight)
	data.contentSize = contentSize
	local bottomTextSize
	if data.bottomText then
		txtContentInfo.fontDimensions.width = 0
		txtContentInfo.fontSize = bottomFontSize
		local measureSize = cc.Device:measureText(data.bottomText, txtContentInfo)
		bottomTextSize = measureSize
		data.bottomSize = bottomTextSize
	end
	if data.bottomTextTip then
		txtContentInfo.fontDimensions.width = 0
		local measureSize = cc.Device:measureText(data.bottomTextTip, txtContentInfo)
		data.bottomTipSize = measureSize
		if not data.bottomSepw then
			data.bottomSepw = _defaultParam.bottomsepw
		end
	end
	local retSize = chatBubbleNode.measureSize(data, target)
	retSize.contentSize = contentSize
	retSize.textContentSize = textContentSize
	retSize.bottomTextSize = data.bottomSize
	retSize.bottomTipSize = data.bottomTipSize
	if target then
		target.width = retSize.width
		target.height = retSize.height
	end
	return retSize
end
return chatRedPacketNode

local chatSkinRead = include("chatSkinRead")
local publicRead = include("publicRead")
local chatBubbleNode = include("chatBubbleNode")
local chatTextNode = class("chatTextNode", function(target)
	local target = include("chatBaseNode").new("chatTextNode")
	return target
end)
_ENV = "chatTextNode"
;("chatTextNode").maxtextw = 300
;("chatTextNode").fontcolor = cc.c3b(65, 35, 15, 1)
;("chatTextNode").bottomcolor = cc.c3b(125, 125, 125)
;("chatTextNode").topcolor = cc.c3b(125, 125, 125)
;("chatTextNode").fontsize = 22
;("chatTextNode").bottomfontsize = 20
;("chatTextNode").topfontsize = 18
;("chatTextNode").bottomsepw = 10
local ("chatTextNode").topsepw, _defaultParam = 10, "chatTextNode"
function chatTextNode:ctor()
	self.text = HtmlRichText:create("", "", 22)
	self.text:setIsHtml(true)
	self.text:addTo(self, 1)
	self.text:setIsDebugEnable(gChatDebug)
	self.bubble = include("chatBubbleNode").new()
	self.bubble:addTo(self)
	self.text:setTouchEnabled(true)
	self.text:setSwallowTouches(false)
	if G_IS_UNITY then
		SoraDSetupEmojies(self.text.__title)
		self.text:setTouchable(true)
		self.text.__title:setSwallowTouches(false)
		self.text.__title:addEventListener(fgui.UIEventType.ClickLink, handler(self, self.onClickText))
	else
		self.text:addTouchEventListener(handler(self, self.onTextEvent))
	end
	self.text:setFontSize(_defaultParam.fontsize)
	self.text:enableCache(true)
end
function chatTextNode:enableCache(bEnable)
	self.text:enableCache(bEnable)
end
function chatTextNode:init(data)
	self.data = data
	self:initContent(data)
	self.bubble:init(data)
	if data.customData and data.customData.chatSysMsgType == gChatSysMsgType.frosty_market_share then
		self.bubble:updateBgBubble("frame_9001678_liaotiandi.png", cc.rect(15, 15, 30, 30))
	end
	self:alignContent()
end
function chatTextNode:reset()
	if self.bottomText then
		self.bottomText:setVisible(false)
	end
	if self.bottomTextTip then
		self.bottomTextTip:setVisible(false)
	end
	if self.topText then
		self.topText:setVisible(false)
	end
end
function chatTextNode:initContent(data)
	self:reset()
	local bubbleId = data.bubbleId
	local fontSize = _defaultParam.fontsize
	local textColor = _defaultParam.fontcolor
	local textBottomColor = _defaultParam.bottomcolor
	local bottomFontSize = _defaultParam.bottomfontsize
	local textAlign = data.textAlign or SoraDFLabelR()
	local showBubbleId
	if data.noCheckShowBubbleId then
		showBubbleId = data.bubbleId
	else
		_defaultParam = "chatFunctions"
		;("chatFunctions").data = data
		;("chatFunctions").checkRes = true
		showBubbleId = include("chatFunctions").getShowBubbleId("chatFunctions")
	end
	if showBubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(showBubbleId)
		if bubbleCfg then
			textColor = bubbleCfg.fontcolor_rgb
			textBottomColor = bubbleCfg.bottomcolor_rgb
			fontSize = bubbleCfg.fontsize
			bottomFontSize = bubbleCfg.bottomfontsize
		end
	end
	if data.customData and data.customData.chatSysMsgType == gChatSysMsgType.frosty_market_share then
		textColor = cc.c3b(255, 255, 255)
	end
	if data.text then
		self.text:setTextHorizontalAlignment(textAlign)
		self.text:setTextColor(textColor)
		local labelRender = self.text:getVirtualRenderer()
		labelRender:setDimensions(0, 0)
		labelRender:setString(data.text)
		local isNeedSaveMetaInfo = false
		if data.contentSize then
			if self.text:isEnableCache() then
				local isGenerateMetaInfo = true
				if data.isShowTranslate and data.tMetaInfo then
					isGenerateMetaInfo = false
					self.text:setMetaInfos(data.tMetaInfo)
				elseif not data.isShowTranslate and data.metaInfo then
					isGenerateMetaInfo = false
					self.text:setMetaInfos(data.metaInfo)
				else
					self.text:setMetaInfos(nil)
					isNeedSaveMetaInfo = true
				end
				self.text:setIsGenerateMetaInfo(isGenerateMetaInfo)
			end
			self.text:setTextAreaSize(data.contentSize)
		else
			isNeedSaveMetaInfo = true
			if self.text:isEnableCache() then
				self.text:setMetaInfos(nil)
				self.text:setIsGenerateMetaInfo(true)
			end
			if self.text.__title and self.text.__title.setAutoSize then
				self.text.__title:setAutoSize(fgui.AutoSizeType.Both)
			elseif self.text.setAutoSize then
				self.text:setAutoSize(fgui.AutoSizeType.Both)
			end
			_defaultParam = self.text.setAutoSize
			self.text.setAutoSize.fontName = ""
			self.text.setAutoSize.fontSize = fontSize
			self.text.setAutoSize.fontAlignmentH = textAlign
			self.text.setAutoSize.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
			self.text.setAutoSize.fontDimensions = cc.size(0, 0)
			local self.text.setAutoSize.isHtml, txtContentInfo = true, self.text.setAutoSize
			local measureSize = cc.Device:measureText(data.text, txtContentInfo)
			if measureSize.width == 0 or measureSize.width > _defaultParam.maxtextw or self.maxTextw and measureSize.width > self.maxTextw then
				if self.maxTextw then
					SoraDGetAutoHeightLabelNew(self.text, self.maxTextw, true)
				else
					SoraDGetAutoHeightLabelNew(self.text, _defaultParam.maxtextw, true)
				end
				data.contentSize = self.text:getContentSize()
			else
				self.text:ignoreContentAdaptWithSize(false)
				self.text:setTextAreaSize(measureSize)
				data.contentSize = cc.size(measureSize.width, measureSize.height)
			end
		end
		if isNeedSaveMetaInfo then
			local metaInfo = self.text:getVirtualRendererMetaInfos()
			if metaInfo then
				if not data.isShowTranslate then
					data.metaInfo = metaInfo
				elseif data.isShowTranslate then
					data.tMetaInfo = metaInfo
				end
				self.text:setMetaInfos(metaInfo)
			end
		end
	end
	local bottomSize, bottomTextSize, bottomTipSize
	if data.bottomText then
		if not self.bottomText then
			self.bottomText = HtmlRichText:create("", "", 20)
			self.bottomText:addTo(self, 1)
			self.bottomText:setIsGenerateMetaInfo(false)
			self.bottomText:setFontSize(_defaultParam.bottomfontsize)
		end
		self.bottomText:setTextColor(textBottomColor)
		self.bottomText:setTextHorizontalAlignment(textAlign)
		self.bottomText:setString(data.bottomText)
		bottomTextSize = self.bottomText:getContentSize()
		data.bottomSize = bottomTextSize
		self.bottomText:setVisible(true)
		if data.customData and data.customData.chatSysMsgType == gChatSysMsgType.frosty_market_share then
			self.bottomText:setTextColor(cc.c3b(255, 255, 255))
		end
	end
	if data.bottomTextTip then
		if not self.bottomTextTip then
			self.bottomTextTip = HtmlRichText:create("", "", 20)
			self.bottomTextTip:addTo(self, 1)
			self.bottomTextTip:setIsGenerateMetaInfo(false)
			self.bottomTextTip:setFontSize(_defaultParam.bottomfontsize)
		end
		self.bottomTextTip:setVisible(true)
		self.bottomTextTip:setTextColor(textBottomColor)
		self.bottomTextTip:setTextHorizontalAlignment(textAlign)
		self.bottomTextTip:setString(data.bottomTextTip)
		bottomTipSize = self.bottomTextTip:getContentSize()
		data.bottomTipSize = bottomTipSize
		if not data.bottomSepw then
			data.bottomSepw = _defaultParam.bottomsepw
		end
	end
	local topTextSize
	if data.topText then
		if not self.topText then
			_defaultParam = data.bottomTextTip
			data.bottomTextTip.size = 20
			self.topText = display.newTTFLabel(data.bottomTextTip)
			self.topText:addTo(self, 1)
			self.topText:setFontSize(_defaultParam.topfontsize)
			self.topText:setTouchEnabled(true)
			self.topText:setTouchable(true)
			self.topText:addTouchEventListener(handler(self, self.onTopTextEvent))
		end
		self.topText:setVisible(true)
		if data.replyMsg then
			self.topText:setSwallowTouches(true)
		else
			self.topText:setSwallowTouches(false)
		end
		self.topText:setTextColor(_defaultParam.topcolor)
		self.topText:setTextHorizontalAlignment(textAlign)
		local topMaxW = self.maxTextw or _defaultParam.maxtextw
		if self.topText.__title and self.topText.__title.setAutoSize then
			self.topText.__title:setAutoSize(fgui.AutoSizeType.Both)
		elseif self.topText.setAutoSize then
			self.topText:setAutoSize(fgui.AutoSizeType.Both)
		end
		local showText = SoraDConvertOmissionText(topMaxW, data.topText, _defaultParam.topfontsize)
		self.topText:setString(showText)
		topTextSize = self.topText:getContentSize()
		data.topTextSize = topTextSize
		data.topSize = topTextSize
		if data.contentSize and topTextSize.width > data.contentSize.width then
			data.contentSize = cc.size(topTextSize.width, data.contentSize.height)
			if data.text then
				self.text:setTextAreaSize(data.contentSize)
			end
		end
		if not data.topsepw then
			data.topsepw = _defaultParam.topsepw
		end
	end
end
function chatTextNode:dispatchTopTextRichHandle()
	if not self.data or not self.data.replyMsg then
		return
	end
	include("chatFunctions").navigateToReplyMsg(self.data.chatChannel, self.data.chatSet, self.data.key, self.data.replyMsg.msgID)
end
function chatTextNode:onTopTextEvent(target, event)
	print("chatTextNode:onTopTextEvent(target, event)", event)
	if not self.data or not self.data.replyMsg then
		return
	end
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		self:dispatchTopTextRichHandle()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatTextNode:setMaxtextw(_param)
	self.maxTextw = _param
end
function chatTextNode:alignContent()
	self:setContentSize(cc.size(self.bubble.width, self.bubble.height))
	self.width = self.bubble.width
	self.height = self.bubble.height
	self.text:setAnchorPoint(cc.p(0, 0))
	self.text:setPosition(self.bubble:getContentPos())
	if self.data.bottomText and self.bottomText then
		self.bottomText:setAnchorPoint(cc.p(0, 0))
		self.bottomText:setPosition(self.bubble:getBottomPos())
	end
	if self.data.bottomTextTip and self.bottomTextTip then
		self.bottomTextTip:setAnchorPoint(cc.p(0, 0))
		self.bottomTextTip:setPosition(self.bubble:getBottomTipPos())
	end
	if self.data.topText and self.topText then
		self.topText:setAnchorPoint(cc.p(0, 0))
		self.topText:setPosition(self.bubble:getTopPos())
	end
end
function chatTextNode:setRichHandle(handle)
	self.richHandle = handle
end
function chatTextNode:getRichHandle()
	return self.richHandle
end
function chatTextNode.measureSize(data, target)
	if data.customData then
		if data.customData.chatSysMsgType == gChatSysMsgType.bubble_carnival_exchange_post then
			local need = data.customData.values.need
			local offer = data.customData.values.offer
			if data.playerId == SoraDGetPlayerID() then
				_ENV = nil
				;(nil).item1 = publicRead.getName(offer)
				_ENV, _ENV, (nil).item2 = need, publicRead.getName(need), publicRead.getName(need)
				_ENV, publicRead.getName(need).item1, need.color = need, need, "#BE2828"
				publicRead.getName(need).item2, need.color = need, "#BE2828"
				data.text = i18n_html("bubble_party_text_32", nil, (publicRead.getName(need)))
			else
				_ENV = i18n_html("bubble_party_text_32", nil, (publicRead.getName(need)))
				i18n_html("bubble_party_text_32", nil, (publicRead.getName(need))).c = true
				i18n_html("bubble_party_text_32", nil, (publicRead.getName(need))).color = "#00BFFF"
				i18n_html("bubble_party_text_32", nil, (publicRead.getName(need))).name = "dataType_bubble_post"
				local i18n_html("bubble_party_text_32", nil, (publicRead.getName(need))).custom, style = tostring(gChatDataType.dataType_bubble_post), i18n_html("bubble_party_text_32", nil, (publicRead.getName(need)))
				_ENV = publicRead.getName(need)
				publicRead.getName(need).item1 = publicRead.getName(offer)
				_ENV, _ENV, publicRead.getName(need).item2 = need, publicRead.getName(need), publicRead.getName(need)
				_ENV, publicRead.getName(need).item1, need.color = need, need, "#BE2828"
				publicRead.getName(need).item2, need.color = need, "#BE2828"
				data.text = i18n_html("bubble_party_text_32", publicRead.getName(need), (publicRead.getName(need))) .. SoraDWrapHtmlTagByStyle(i18n("bubble_party_text_28"), style)
			end
		elseif data.customData.chatSysMsgType == gChatSysMsgType.frosty_market_share then
			_ENV = data.customData.chatSysMsgType
			data.customData.chatSysMsgType.c = true
			data.customData.chatSysMsgType.u = true
			data.customData.chatSysMsgType.color = "#E2C53D"
			data.customData.chatSysMsgType.name = "frosty_market_share"
			local data.customData.chatSysMsgType.custom, style = tostring(gChatDataType.frosty_market_share), data.customData.chatSysMsgType
			local goodId = data.customData.values.goodId
			local activity_9001678_Read = include("activity_9001678_Read")
			local cfg = activity_9001678_Read.getFrostyMarketCfg(goodId)
			local id = cfg and cfg.goodCfg.id
			local itemIcon = id and publicRead.getIcon(id) or "icon_item_common.png"
			if id then
				_ENV = need
				need.param = "#" .. itemIcon
				need.width = 70
				need.height = 70
				need.custom = "Sprite"
				need.offsety = 20
				need.scale = 1.0
				data.text = SoraDWrapReplaceTag(need) .. i18n_html("Frosty_Market_text_15") .. SoraDWrapHtmlTagByStyle(i18n("Frosty_Market_text_26"), style)
			else
				data.text = i18n("Frosty_Market_text_9")
			end
		end
	end
	local str = data.text
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
	_ENV = 1
	;(1).fontName = ""
	;(1).fontSize = fontSize
	;(1).fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
	;(1).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	;(1).fontDimensions = cc.size(0, 0)
	local (1).isHtml, txtContentInfo = true, 1
	local measureSize = cc.Device:measureText(str, txtContentInfo)
	if measureSize.width < _defaultParam.maxtextw then
		if measureSize.width + 1 < _defaultParam.maxtextw then
			measureSize.width = measureSize.width + 1
		end
	else
		txtContentInfo.fontDimensions.width = _defaultParam.maxtextw
		measureSize = cc.Device:measureText(str, txtContentInfo)
	end
	contentSize = measureSize
	data.contentSize = contentSize
	local bottomTextSize, topTextSize
	if data.bottomText then
		txtContentInfo.fontDimensions.width = 0
		txtContentInfo.fontSize = bottomFontSize
		local measureSize = cc.Device:measureText(data.bottomText, txtContentInfo)
		bottomTextSize = measureSize
		data.bottomSize = bottomTextSize
	end
	if data.topText then
		local topMaxW = target and target.maxTextw or _defaultParam.maxtextw
		local showText = SoraDConvertOmissionText(topMaxW, data.topText, _defaultParam.topfontsize)
		txtContentInfo.fontDimensions.width = 0
		txtContentInfo.fontSize = _defaultParam.topfontsize
		txtContentInfo.isHtml = false
		local measureSize = cc.Device:measureText(showText, txtContentInfo)
		topTextSize = measureSize
		data.topSize = topTextSize
		data.topsepw = _defaultParam.topsepw
		if data.contentSize and topTextSize.width > data.contentSize.width then
			data.contentSize = cc.size(topTextSize.width, data.contentSize.height)
		end
	end
	if data.bottomTextTip then
		txtContentInfo.fontDimensions.width = 0
		local measureSize = cc.Device:measureText(data.bottomTextTip, txtContentInfo)
		data.bottomTipSize = measureSize
		if not data.bottomSepw then
			data.bottomSepw = _defaultParam.bottomsepw
		end
	end
	local retSize = chatBubbleNode.measureSize(data)
	retSize.contentSize = contentSize
	retSize.bottomTextSize = data.bottomSize
	retSize.bottomTipSize = data.bottomTipSize
	if target then
		target.width = retSize.width
		target.height = retSize.height
	end
	return retSize
end
function chatTextNode:onTextEvent(target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		if self.richHandle then
			self.richHandle(target, event)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function chatTextNode:onClickText(eventContext)
	if self.scroll and not SoraDIsNodeVisibleOnScroll(self.text, self.scroll) then
		return
	end
	local htmlElement = eventContext:getData()
	if self.richHandle and htmlElement then
		local values
		if self.data and self.data.customData then
			values = self.data.customData.values
		end
		_ENV = self.data.customData
		self.data.customData.metatype = htmlElement:getMetaType()
		self.data.customData.name = htmlElement:GetString("name")
		self.data.customData.custom = htmlElement:GetString("custom")
		local self.data.customData.values, metaInfo = values, self.data.customData
		self.richHandle(self.text, metaInfo)
	end
end
return chatTextNode

local chatSkinRead = include("chatSkinRead")
local chatBubbleNode = include("chatBubbleNode")
local DjChatTextNode = class("djChatTextNode", function(target)
	local target = include("chatBaseNode").new("djChatTextNode")
	return target
end)
_ENV = "djChatTextNode"
;("djChatTextNode").maxtextw = 620
;("djChatTextNode").textcolor = cc.c3b(50, 20, 0)
;("djChatTextNode").namecolor = cc.c3b(25, 23, 26)
;("djChatTextNode").nightcolor = cc.c3b(255, 255, 255)
;("djChatTextNode").menuOffsetY = 10
local ("djChatTextNode").fontsize, _defaultParam = 22, "djChatTextNode"
function DjChatTextNode:ctor()
	self.text = HtmlRichText:create("", "", 22)
	self.text:setIsHtml(true)
	self.text:addTo(self, 1)
	self.text:setIsDebugEnable(gChatDebug)
	self.text:setTouchEnabled(true)
	self.text:setSwallowTouches(false)
	self.text:addTouchEventListener(handler(self, self.onTextEvent))
	self.text:setFontSize(_defaultParam.fontsize)
	self.text:enableCache(true)
end
function DjChatTextNode:enableCache(bEnable)
	self.text:enableCache(bEnable)
end
function DjChatTextNode:reInit(ignoreUpdateScroll)
	self.data.itemWidth = 0
	self.data.itemHeight = 0
	self.data.contentSize = nil
	self.data.textContentSize = nil
	self.data.bottomTipSize = nil
	self:init(self.data)
	self.data.itemWidth = self.width
	self.data.itemHeight = self.height + 10
	local chatChannel = self.data.chatChannel
	local chatSet = self.data.chatSet
	local key = self.data.key
	if not ignoreUpdateScroll then
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		;(nil).chatChannel = chatChannel
		;(nil).chatSet = chatSet
		;(nil).key = key
		SoraDSendMessage(nil)
	end
end
function DjChatTextNode:init(data)
	self.data = data
	self:initContent(data)
	self:alignContent()
end
function DjChatTextNode:reset()
end
function DjChatTextNode:initContent(data)
	self:reset()
	local bubbleId = data.bubbleId
	local fontSize = _defaultParam.fontsize
	local textColor = _defaultParam.textcolor
	local theme = data.theme
	theme = theme or gCurrentChatTheme
	local textAlign = data.textAlign or SoraDFLabelR()
	if data.text then
		self.text:setTextHorizontalAlignment(textAlign)
		if theme == gChatTheme.normal then
			print("普通配色")
			self.text:setTextColor(_defaultParam.textcolor)
		else
			print("夜晚配色")
			self.text:setTextColor(_defaultParam.nightcolor)
		end
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
			dump(data.contentSize, "缓存的测量高度")
		else
			isNeedSaveMetaInfo = true
			if self.text:isEnableCache() then
				self.text:setMetaInfos(nil)
				self.text:setIsGenerateMetaInfo(true)
			end
			_defaultParam = self.text.setIsGenerateMetaInfo
			self.text.setIsGenerateMetaInfo.fontName = ""
			self.text.setIsGenerateMetaInfo.fontSize = fontSize
			self.text.setIsGenerateMetaInfo.fontAlignmentH = textAlign
			self.text.setIsGenerateMetaInfo.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
			self.text.setIsGenerateMetaInfo.fontDimensions = cc.size(0, 0)
			local self.text.setIsGenerateMetaInfo.isHtml, txtContentInfo = true, self.text.setIsGenerateMetaInfo
			local measureSize = cc.Device:measureText(data.text, txtContentInfo)
			if measureSize.width == 0 or measureSize.width > _defaultParam.maxtextw or self.maxTextw and measureSize.width > self.maxTextw then
				if self.maxTextw then
					SoraDGetAutoHeightLabelNew(self.text, self.maxTextw, true)
				else
					SoraDGetAutoHeightLabelNew(self.text, _defaultParam.maxtextw, true)
				end
			else
				self.text:ignoreContentAdaptWithSize(false)
				self.text:setTextAreaSize(measureSize)
			end
			data.contentSize = self.text:getContentSize()
		end
		if isNeedSaveMetaInfo then
			local metaInfo = self.text:getVirtualRendererMetaInfos()
			if metaInfo == nil then
				metaInfo, _defaultParam = self.text, self.text
			end
			if not data.isShowTranslate then
				data.metaInfo = metaInfo
			elseif data.isShowTranslate then
				data.tMetaInfo = metaInfo
			end
			self.text:setMetaInfos(metaInfo)
		end
	end
end
function DjChatTextNode:onThemeUpdate()
	print("DjChatTextNode:onThemeUpdate")
	local theme = self.data.theme
	theme = theme or gCurrentChatTheme
	if theme == gChatTheme.normal then
		self.text:setTextColor(_defaultParam.textcolor)
	else
		self.text:setTextColor(_defaultParam.nightcolor)
	end
end
function DjChatTextNode:setMaxtextw(_param)
	self.maxTextw = _param
end
function DjChatTextNode:alignContent()
	self.width = self.text:getContentSize().width
	self.height = self.text:getContentSize().height
	self:setContentSize(cc.size(self.width, self.height))
	self.text:setAnchorPoint(SoraDFAP(1, 0))
	self.text:setPosition(SoraDFPoint(320 + 0.5 * _defaultParam.maxtextw, 10, 640))
end
function DjChatTextNode:setRichHandle(handle)
	self.richHandle = handle
end
function DjChatTextNode:getRichHandle()
	return self.richHandle
end
function DjChatTextNode.measureSize(data, target)
	local str = data.text
	local isHtml = false
	if data.isHtml then
		isHtml = true
	end
	local fontSize = _defaultParam.fontsize
	local contentSize = cc.size(1, 1)
	_defaultParam = 1
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
	contentSize = measureSize
	data.contentSize = contentSize
	local bottomTextSize
	local retSize = chatBubbleNode.measureSize(data)
	retSize.contentSize = contentSize
	retSize.bottomTextSize = data.bottomSize
	retSize.bottomTipSize = data.bottomTipSize
	retSize.width = contentSize.width
	retSize.height = contentSize.height + 10
	if target then
		target.width = retSize.width
		target.height = retSize.height
	end
	return retSize
end
function DjChatTextNode:showMenu(target, event)
	local metaInfo = target:getTouchMetaInfo(target:getTouchEndPosition())
	if metaInfo then
		if metaInfo.metatype == ccui.RichTextMetaType.REPLACE then
			self:onRichReplace(richText, metaInfo)
		elseif metaInfo.metatype == ccui.RichTextMetaType.LINK then
			print("点击了超链接")
			self:onRichLink(richText, metaInfo)
		end
	else
		local chatMenuMgr = gChatMgrs:getMgr("chatMenuMgr")
		local menus, menuData = chatMenuMgr:getMenus(self.data)
		if next(menus) == nil then
			return
		end
		local chatMenu = include("chatMenu")
		local menuNode = chatMenu.new()
		menuNode:show()
		local worldPos, alignv = self:getMenuWorldPos(target)
		_ENV = target
		target.menus = menus
		target.menuData = menuData
		target.worldPos = worldPos
		target.alignv = alignv
		local target.customData, data = self.data, target
		menuNode:init(data)
	end
end
function DjChatTextNode:getMenuWorldPos(target)
	local bottomPos = target:convertToWorldSpace(cc.p(target:getContentSize().width / 2, _defaultParam.menuOffsetY))
	if bottomPos.y > display.cy then
		return bottomPos, gMenuAlignVType.bottom
	end
	local topPos = target:convertToWorldSpace(cc.p(target:getContentSize().width / 2, target:getContentSize().height - _defaultParam.menuOffsetY))
	return topPos, gMenuAlignVType.top
end
function DjChatTextNode:onRichLink(richText, metaInfo)
	local funcName = "onRichLink_" .. metaInfo.name
	local func = DjChatTextNode[funcName]
	if func then
		return func(self, richText, metaInfo)
	else
		return self:onRichClickCommonView(richText, metaInfo)
	end
end
function DjChatTextNode:onRichReplace(richText, metaInfo)
	local funcName = "onRichReplace_" .. metaInfo.name
	local func = DjChatTextNode[funcName]
	if func then
		return func(self, richText, metaInfo)
	else
		return self:onRichClickCommonView(richText, metaInfo)
	end
end
function DjChatTextNode:onRichReplace_iconSys(richText, metaInfo)
	return false
end
function DjChatTextNode:onRichLink_coordinate(richText, metaInfo)
	local chatDataParser = include("chatDataParser")
	local coordinate = chatDataParser.parseCoordinate(metaInfo.custom)
	if coordinate then
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(coordinate, true, coordinate.k)
		SoraDRemoveAllPanelFromManager()
		return false
	end
	return true
end
function DjChatTextNode:onRichClickCommonView(richText, metaInfo)
	local chatMenuHandlerMgr = gChatMgrs:getMgr("chatMenuHandlerMgr")
	local chatConst = include("chatConst")
	_ENV = nil
	;(nil).customData = self.data
	chatMenuHandlerMgr:onMenuCommonView(self, chatConst.OpId.OpCommonView, nil)
	return true
end
_ENV, DjChatTextNode.onTextEvent = function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
end, function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
_ENV, DjChatTextNode.richLinkFuncs, (function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
end)[gChatLinkName.coordinate] = function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
end, function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
end, DjChatTextNode.onRichLink_Coordinate
DjChatTextNode.richReplaceFuncs, (function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
end)[gChatReplaceName.iconSys] = function(self, target, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		end
		SoraDPlaySound()
		self:showMenu(target, event)
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
end, DjChatTextNode.onRichReplace_iconSys
return DjChatTextNode

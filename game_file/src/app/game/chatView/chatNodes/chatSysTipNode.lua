local chatSysTipNode = class("chatSysTipNode", function(target)
	local target = include("chatBaseNode").new("chatSysTipNode")
	return target
end)
_ENV = "chatSysTipNode"
;("chatSysTipNode").width = 640
;("chatSysTipNode").height = 90
;("chatSysTipNode").maxtextw = 400
;("chatSysTipNode").imgWidthDelta = 32
;("chatSysTipNode").imgHeightDelta = 12
;("chatSysTipNode").heightDelta = 20
local ("chatSysTipNode").fontSize, _defaultParam = 20, "chatSysTipNode"
function chatSysTipNode:ctor()
	self.isDebug = gChatDebug
	self.imgSysBg = ccui.ImageView:create("frame_mailinfo_10.png", ccui.TextureResType.plistType)
	self.imgSysBg:setPosition(cc.p(300, 40))
	self.imgSysBg:setScale9Enabled(true)
	self.imgSysBg:setCapInsets(cc.rect(10, 10, 72, 14))
	self.imgSysBg:setContentSize(cc.size(160, 34))
	self.imgSysBg:addTo(self)
	self.textContent = HtmlRichText:create("", "", 20)
	self.textContent:setIsHtml(true)
	self.textContent:setTextHorizontalAlignment(SoraDFLabelR())
	self.textContent:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.textContent:setTextColor(cc.c3b(255, 255, 255))
	self.textContent:setPosition(cc.p(300, 40))
	self.textContent:setAnchorPoint(SoraDFAP(0.5, 0.5, 1))
	self.textContent:addTo(self.imgSysBg)
	self.textContent:setFontSize(_defaultParam.fontSize)
	self.textContent:ignoreContentAdaptWithSize(true)
	self.width = _defaultParam.width
	self.height = _defaultParam.height
end
function chatSysTipNode:init(data)
	if data.isDebug ~= nil then
		self.isDebug = data.isDebug
	end
	self.data = data
	local isRA = data.isRA
	local textAlign = isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	self.textContent:setTextHorizontalAlignment(textAlign)
	local labelRender = self.textContent:getVirtualRenderer()
	labelRender:setDimensions(0, 0)
	labelRender:setString(data.content)
	if data.contentSize then
		self.textContent:setTextAreaSize(data.contentSize)
	else
		local autoSize = labelRender:getContentSize()
		self.textContent:setTextAreaSize(autoSize)
		local measureSize = self.textContent:getContentSize()
		if measureSize.width == 0 and measureSize.height == 0 then
			_ENV = measureSize.height
			measureSize.height.fontName = ""
			measureSize.height.fontSize = _defaultParam.fontSize
			measureSize.height.fontAlignmentH = textAlign
			measureSize.height.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
			measureSize.height.fontDimensions = cc.size(0, 0)
			local measureSize.height.isHtml, txtContentInfo = true, measureSize.height
			measureSize = cc.Device:measureText(data.content, txtContentInfo)
		end
		if measureSize.width > _defaultParam.maxtextw then
			SoraDGetAutoHeightLabel(self.textContent, _defaultParam.maxtextw)
		else
		end
		data.contentSize = self.textContent:getContentSize()
	end
	local imgWidth = self.textContent:getContentSize().width + _defaultParam.imgWidthDelta
	local imgHeight = self.textContent:getContentSize().height + _defaultParam.imgHeightDelta
	self.imgSysBg:setContentSize(cc.size(imgWidth, imgHeight))
	self.textContent:setAnchorPoint(cc.p(0.5, 0.5))
	self.textContent:setPosition(cc.p(imgWidth / 2, imgHeight / 2))
	self.height = self.imgSysBg:getContentSize().height + _defaultParam.heightDelta
	self.imgSysBg:setPosition(cc.p(self.width / 2, self.height / 2))
	self:setContentSize(cc.size(self.width, self.height))
	self:initDebugView()
end
function chatSysTipNode.measureSize(data, target)
	local str = data.content
	local contentSize
	local isRA = data.isRA
	local _ENV, textAlign = nil, isRA and cc.TEXT_ALIGNMENT_RIGHT or cc.TEXT_ALIGNMENT_LEFT
	;(nil).fontName = ""
	;(nil).fontSize = _defaultParam.fontSize
	;(nil).fontAlignmentH = textAlign
	;(nil).fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	;(nil).fontDimensions = cc.size(0, 0)
	local (nil).isHtml, txtContentInfo = true, nil
	local measureSize = cc.Device:measureText(str, txtContentInfo)
	if measureSize.width < _defaultParam.maxtextw then
	else
		txtContentInfo.fontDimensions.width = _defaultParam.maxtextw
		measureSize = cc.Device:measureText(str, txtContentInfo)
	end
	contentSize = measureSize
	data.contentSize = contentSize
	local imgHeight = contentSize.height + _defaultParam.imgHeightDelta
	local height = imgHeight + _defaultParam.heightDelta
	return cc.size(_defaultParam.width, height)
end
function chatSysTipNode:initDebugView()
	if not self.isDebug then
		return
	end
	if not self._debugNode then
		local drawNode = cc.DrawNode:create()
		drawNode:setName("debugNode")
		drawNode:addTo(self, 2)
		drawNode:setPosition(cc.p(0, 0))
		self._debugNode = drawNode
	end
	self._debugNode:clear()
	local lb = cc.p(0, 0)
	local lt = cc.p(0, self.height)
	local rt = cc.p(self.width, self.height)
	local rb = cc.p(self.width, 0)
	_UPVALUE4_ = self.width
	self.width[1] = lb
	self.width[2] = lt
	self.width[3] = rt
	local self.width[4], tbPoints = rb, self.width
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 0, 1))
end
function chatSysTipNode:setIsDebug(isDebug)
	self.isDebug = isDebug
end
return chatSysTipNode

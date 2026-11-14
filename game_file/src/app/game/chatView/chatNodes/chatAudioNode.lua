local chatBubbleNode = include("chatBubbleNode")
local chatSkinRead = include("chatSkinRead")
local chatAudioNode = class("chatAudioNode", function(target)
	local target = include("chatBaseNode").new("chatAudioNode")
	return target
end)
_ENV = "chatAudioNode"
;("chatAudioNode").fileAudio = "et_laba_display03.png"
;("chatAudioNode").iconWidth = 24
;("chatAudioNode").iconHeight = 32
;("chatAudioNode").fontcolor = cc.c3b(255, 255, 255)
;("chatAudioNode").bottomcolor = cc.c3b(125, 125, 125)
;("chatAudioNode").fontsize = 22
;("chatAudioNode").bottomfontsize = 20
;("chatAudioNode").minContentW = 100
;("chatAudioNode").maxContentW = 230
;("chatAudioNode").audiocolor = cc.c3b(54, 54, 54)
local ("chatAudioNode").audioplaycolor, _defaultParam = cc.c3b(127, 255, 0), "chatAudioNode"
function chatAudioNode:ctor()
	self.bubble = include("chatBubbleNode").new()
	self.bubble:addTo(self)
	self.spriteAudio = display.newSprite("#" .. _defaultParam.fileAudio)
	self.spriteAudio:setAnchorPoint(cc.p(0.5, 0))
	self.spriteAudio:addTo(self, 1)
	self.text = HtmlRichText:create("", "", _defaultParam.fontsize)
	self.text:addTo(self, 1)
	self.text:setAnchorPoint(cc.p(0.5, 0.5))
end
function chatAudioNode:init(data)
	self.data = data
	self:initContent(data)
	self.bubble:init(data)
	self:alignContent()
end
function chatAudioNode:initContent(data)
	local bubbleId = data.bubbleId
	local fontSize = _defaultParam.fontsize
	local textColor = _defaultParam.fontcolor
	local textBottomColor = _defaultParam.bottomcolor
	local bottomFontSize = _defaultParam.bottomfontsize
	local textAlign = data.textAlign or SoraDFLabelR()
	local audiocolor = _defaultParam.audiocolor
	local audioplaycolor = _defaultParam.audioplaycolor
	if bubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
		if bubbleCfg then
			textColor = bubbleCfg.fontcolor_rgb
			textBottomColor = bubbleCfg.bottomcolor_rgb
			audiocolor = bubbleCfg.audiocolor_rgb
			audioplaycolor = bubbleCfg.audioplaycolor_rgb
		end
	end
	self.audiocolor = audiocolor
	self.audioplaycolor = audioplaycolor
	local audioLen = data.audioLen
	local t = math.min(1, audioLen / 60)
	local contentW = SoraDLerpNumber(_defaultParam.minContentW, _defaultParam.maxContentW, t)
	local contentSize = cc.size(contentW, _defaultParam.iconHeight)
	data.contentSize = contentSize
	local strAudio = audioLen .. "'"
	self.text:setTextColor(textColor)
	self.text:setString(strAudio)
	if data.bottomText then
		if not self.bottomText then
			self.bottomText = HtmlRichText:create("", "", 20)
			self.bottomText:addTo(self, 1)
		end
		self.bottomText:setFontSize(bottomFontSize)
		self.bottomText:setTextColor(textBottomColor)
		self.bottomText:setTextHorizontalAlignment(textAlign)
		self.bottomText:setString(data.bottomText)
		local bottomTextSize = self.bottomText:getContentSize()
		data.bottomSize = bottomTextSize
	end
	self.spriteAudio:setColor(audiocolor)
	self:setPlayStatus(data.playStatus or gPlayStatus.normal)
end
function chatAudioNode:alignContent()
	self:setContentSize(cc.size(self.bubble.width, self.bubble.height))
	self.width = self.bubble.width
	self.height = self.bubble.height
	local contentPos = self.bubble:getContentPos()
	local contentPosrb = self.bubble:getContentPosRB()
	local textSize = self.text:getContentSize()
	if self.data.isRA then
		self.spriteAudio:setPosition(cc.p(contentPosrb.x - _defaultParam.iconWidth / 2, contentPosrb.y))
		self.text:setPosition(cc.p(contentPos.x + textSize.width / 2, contentPos.y + self.data.contentSize.height / 2))
	else
		self.spriteAudio:setPosition(cc.p(contentPos.x + _defaultParam.iconWidth / 2, contentPos.y))
		self.text:setPosition(cc.p(contentPosrb.x - textSize.width / 2, contentPos.y + self.data.contentSize.height / 2))
	end
	if self.data.direction == gChatDirection.right then
		self.spriteAudio:setFlippedX(false)
	else
		self.spriteAudio:setFlippedX(true)
	end
	if self.data.bottomText and self.bottomText then
		self.bottomText:setAnchorPoint(cc.p(0, 0))
		self.bottomText:setPosition(self.bubble:getBottomPos())
	end
end
function chatAudioNode.measureSize(data, target)
	local bubbleId = data.bubbleId
	local fontSize = _defaultParam.fontsize
	local bottomFontSize = _defaultParam.bottomfontsize
	if bubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
		if bubbleCfg then
			fontSize = bubbleCfg.fontsize
			bottomFontSize = bubbleCfg.bottomfontsize
		end
	end
	local audioLen = data.audioLen
	local t = math.min(1, audioLen / 60)
	local contentW = SoraDLerpNumber(_defaultParam.minContentW, _defaultParam.maxContentW, t)
	local contentSize = cc.size(contentW, _defaultParam.iconHeight)
	_defaultParam, data.contentSize = contentW, contentSize
	contentW.fontName = ""
	contentW.fontSize = fontSize
	contentW.fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
	contentW.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	contentW.fontDimensions = cc.size(0, 0)
	local contentW.isHtml, txtContentInfo = false, contentW
	if data.bottomText then
		txtContentInfo.fontDimensions.width = 0
		txtContentInfo.fontSize = bottomFontSize
		local measureSize = cc.Device:measureText(data.bottomText, txtContentInfo)
		data.bottomSize = measureSize
	end
	local retSize = chatBubbleNode.measureSize(data, target)
	retSize.bottomSize = data.bottomSize
	if target then
		target.width = retSize.width
		target.height = retSize.height
	end
	return retSize
end
function chatAudioNode:showPlayAudioAnim()
	if self.spriteAudio then
		local frames = display.newFrames("et_laba_display%02d.png", 1, 3)
		if not frames then
			return
		end
		local frame4 = display.newSpriteFrame("et_laba_display01.png")
		frames[#frames + 1] = frame4
		local animation = display.newAnimation(frames, 0.25)
		self.spriteAudio:stopAllActions()
		self.spriteAudio:playAnimationForever(animation)
		self.spriteAudio:setColor(self.audioplaycolor)
	end
end
function chatAudioNode:stopPlayAudioAnim()
	if self.spriteAudio then
		self.spriteAudio:stopAllActions()
		local spriteFrameAudio = display.newSpriteFrame("et_laba_display03.png")
		if spriteFrameAudio then
			self.spriteAudio:setSpriteFrame(spriteFrameAudio)
		end
		self.spriteAudio:setColor(self.audiocolor)
	end
end
function chatAudioNode:setPlayStatus(playStatus)
	self.playStatus = playStatus
	if playStatus == gPlayStatus.playing_audio then
		self:showPlayAudioAnim()
	elseif playStatus == gPlayStatus.normal then
		self:stopPlayAudioAnim()
	end
end
return chatAudioNode

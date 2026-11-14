local chatBubbleNode = include("chatBubbleNode")
local chatSkinRead = include("chatSkinRead")
local chatEmoticonNode = class("chatEmoticonNode", function(target)
	local target = include("chatBaseNode").new("chatEmoticonNode")
	return target
end)
_ENV = "chatEmoticonNode"
;("chatEmoticonNode").width = 94
;("chatEmoticonNode").height = 94
;("chatEmoticonNode").bottomcolor = cc.c3b(125, 125, 125)
;("chatEmoticonNode").topcolor = cc.c3b(125, 125, 125)
;("chatEmoticonNode").fontsize = 22
;("chatEmoticonNode").bottomfontsize = 20
;("chatEmoticonNode").topfontsize = 18
;("chatEmoticonNode").topsepw = 10
;("chatEmoticonNode").maxtextw = 300
local ("chatEmoticonNode").linkcolor, _defaultParam = cc.c3b(0, 0, 200), "chatEmoticonNode"
local chatResMgr = gChatMgrs:getMgr("chatResMgr")
function chatEmoticonNode:ctor()
	self.bubble = include("chatBubbleNode").new()
	self.bubble:addTo(self)
	self.imgEmoticon = ccui.ImageView:create("chat_face_1.png", ccui.TextureResType.plistType)
	self.imgEmoticon:addTo(self, 1)
	self.sprite = display.newSprite()
	self.sprite:setPosition(cc.p(_defaultParam.width / 2, _defaultParam.height / 2))
	self.imgEmoticon:addChild(self.sprite, 1)
end
function chatEmoticonNode:init(data)
	self.data = data
	self:initContent(data)
	self.bubble:init(data)
	self:alignContent()
end
function chatEmoticonNode:reset()
	if self.addContentText then
		self.addContentText:setVisible(false)
	end
	if self.topText then
		self.topText:setVisible(false)
	end
end
function chatEmoticonNode:initContent(data)
	self:reset()
	local bubbleId = data.bubbleId
	local textBottomColor = _defaultParam.bottomcolor
	local fontSize = _defaultParam.fontsize
	local bottomFontSize = _defaultParam.bottomfontsize
	local textAlign = data.textAlign or SoraDFLabelR()
	local linkcolor = _defaultParam.linkcolor
	if bubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
		if bubbleCfg then
			linkcolor = bubbleCfg.linkcolor_rgb
			textBottomColor = bubbleCfg.bottomcolor_rgb
		end
	end
	local chatDesRead = include("chatDesRead")
	local filename = chatDesRead.getEmotionImgByName(data.packetId or _G.gDefaultPackageId, data.emoticonId)
	print("chatEmoticonNode:initContent(data) data.packetId, data.emoticonId = filename = ", data.packetId, data.emoticonId, filename)
	local packageid = chatDesRead.getPackageIdByName(data.packetId)
	local packagecfg = chatDesRead.getEmotionListCfg(packageid)
	if packagecfg.emoticontype == gChatEmoticonType.normal then
		self.imgEmoticon:loadTexture(filename, ccui.TextureResType.plistType)
		self.sprite:setVisible(false)
	elseif packagecfg.emoticontype == gChatEmoticonType.animation then
		print("chatEmoticonNode:表情")
		self.imgEmoticon:loadTexture("chat_icon_img_loading.png", ccui.TextureResType.plistType)
		local emoticoncfg = chatDesRead.getEmotionCfgById(packageid, data.emoticonId)
		local reskey = emoticoncfg.reskey
		local hasKeyRes = chatResMgr:hasKeyRes(reskey)
		if hasKeyRes then
			local res = string.format("Common/%s", reskey)
			local plistName = res .. ".plist"
			local imageName = getImageFileNameByPlatform(res)
			display.addSpriteFrames(plistName, imageName)
			if not self.data or not self.sprite then
				return
			end
			local imgformat = emoticoncfg.imgformat
			local firstImg = string.format(imgformat, emoticoncfg.astart)
			self.sprite:setSpriteFrame(firstImg)
			self.imgEmoticon:loadTexture("bg_transparent.png", ccui.TextureResType.plistType)
			local frames = display.newFrames(imgformat, emoticoncfg.astart, emoticoncfg.aend - emoticoncfg.astart + 1)
			local animation = display.newAnimation(frames, 0.16666666666666666)
			self.sprite:setVisible(true)
			self.sprite:stopAllActions()
			local delay = 0
			self:playAnimationForever(self.sprite, animation, delay)
		else
			print("不存在，则进行加载等待-------")
			chatResMgr:addKeyFileListener(data, reskey, gChatFileType.emo_animation)
		end
	end
	local contentSize = cc.size(_defaultParam.width, _defaultParam.height)
	if data.imgwidth then
		contentSize.width = data.imgwidth
	end
	if data.imgheight then
		contentSize.height = data.imgheight
	end
	local addContentSize = cc.size(0, 0)
	data.addContentSize = addContentSize
	contentSize = cc.size(math.max(contentSize.width, addContentSize.width), contentSize.height + addContentSize.height)
	data.contentSize = contentSize
	if data.bottomText then
		if not self.bottomText then
			self.bottomText = HtmlRichText:create("", "", _defaultParam.bottomfontsize)
			self.bottomText:addTo(self, 1)
		end
		self.bottomText:setTextColor(textBottomColor)
		self.bottomText:setTextHorizontalAlignment(textAlign)
		self.bottomText:setString(data.bottomText)
		local bottomTextSize = self.bottomText:getContentSize()
		data.bottomSize = bottomTextSize
	end
	if data.topText then
		if not self.topText then
			_defaultParam = self.bottomText
			self.bottomText.size = 20
			self.topText = display.newTTFLabel(self.bottomText)
			self.topText:addTo(self, 1)
			self.topText:setFontSize(_defaultParam.topfontsize)
			self.topText:setTouchEnabled(true)
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
		local topMaxW = _defaultParam.maxtextw
		if self.topText.__title and self.topText.__title.setAutoSize then
			self.topText.__title:setAutoSize(fgui.AutoSizeType.Both)
		elseif self.topText.setAutoSize then
			self.topText:setAutoSize(fgui.AutoSizeType.Both)
		end
		local showText = SoraDConvertOmissionText(topMaxW, data.topText, _defaultParam.topfontsize)
		self.topText:setString(showText)
		local topTextSize = self.topText:getContentSize()
		data.topTextSize = topTextSize
		data.topSize = topTextSize
		if data.contentSize and topTextSize.width > data.contentSize.width then
			data.contentSize = cc.size(topTextSize.width, data.contentSize.height)
		end
		data.topsepw = _defaultParam.topsepw
	end
end
function chatEmoticonNode:setRichHandle(handle)
	self.richHandle = handle
end
function chatEmoticonNode:getRichHandle()
	return self.richHandle
end
function chatEmoticonNode:dispatchTopTextRichHandle()
	if not self.data or not self.data.replyMsg then
		return
	end
	include("chatFunctions").navigateToReplyMsg(self.data.chatChannel, self.data.chatSet, self.data.key, self.data.replyMsg.msgID)
end
function chatEmoticonNode:onTopTextEvent(target, event)
	print("chatEmoticonNode:onTopTextEvent(target, event)")
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
function chatEmoticonNode:playAnimationForever(target, animation, delay)
	local animate = cc.Animate:create(animation)
	local action
	if type(delay) == "number" and 0 < delay then
		_UPVALUE3_ = delay
		delay[1] = cc.DelayTime:create(delay)
		delay[2] = cc.Show:create()
		delay[3] = animate
		local sequence = transition.sequence(delay)
		action = cc.RepeatForever:create(sequence)
	else
		action = cc.RepeatForever:create(animate)
	end
	target:runAction(action)
	return action
end
function chatEmoticonNode:alignContent()
	self:setContentSize(cc.size(self.bubble.width, self.bubble.height))
	self.width = self.bubble.width
	self.height = self.bubble.height
	if self.imgEmoticon then
		self.imgEmoticon:setAnchorPoint(cc.p(0, 0))
		local contentPos = self.bubble:getContentPos()
		local addContentSize = self.data.addContentSize or cc.size(0, 0)
		self.imgEmoticon:setPosition(cc.p(contentPos.x, contentPos.y + addContentSize.height))
		self.imgEmoticon:ignoreContentAdaptWithSize(false)
		if self.addContentText then
			self.addContentText:setAnchorPoint(cc.p(0, 0))
			self.addContentText:setPosition(contentPos)
		end
		local contentSize = cc.size(_defaultParam.width, _defaultParam.height)
		if self.data.imgwidth then
			contentSize.width = self.data.imgwidth
		end
		if self.data.imgheight then
			contentSize.height = self.data.imgheight
		end
		self.imgEmoticon:setContentSize(contentSize)
	end
	if self.data.bottomText and self.bottomText then
		self.bottomText:setAnchorPoint(cc.p(0, 0))
		self.bottomText:setPosition(self.bubble:getBottomPos())
	end
	if self.data.topText and self.topText then
		self.topText:setAnchorPoint(cc.p(0, 0))
		self.topText:setPosition(self.bubble:getTopPos())
	end
end
function chatEmoticonNode.measureSize(data, target)
	if data.dataType == gChatDataType.dataType_emotion then
		data.contentAlign = gChatContentAlign.center
	end
	local bubbleId = data.bubbleId
	local fontSize = _defaultParam.fontsize
	local bottomFontSize = _defaultParam.bottomfontsize
	if bubbleId then
		local bubbleCfg = chatSkinRead.getBubbleCfg(bubbleId)
		if bubbleCfg then
		end
	end
	local contentSize = cc.size(_defaultParam.width, _defaultParam.height)
	if data.imgwidth then
		contentSize.width = data.imgwidth
	end
	if data.imgheight then
		contentSize.height = data.imgheight
	end
	_ENV = data.imgheight
	data.imgheight.fontName = ""
	data.imgheight.fontSize = fontSize
	data.imgheight.fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
	data.imgheight.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	data.imgheight.fontDimensions = cc.size(0, 0)
	local data.imgheight.isHtml, txtContentInfo = false, data.imgheight
	local addContentSize = cc.size(0, 0)
	data.contentSize = cc.size(math.max(contentSize.width, addContentSize.width), contentSize.height + addContentSize.height)
	if data.bottomText then
		txtContentInfo.fontDimensions.width = 0
		txtContentInfo.fontSize = bottomFontSize
		local measureSize = cc.Device:measureText(data.bottomText, txtContentInfo)
		data.bottomSize = measureSize
	end
	if data.topText then
		local topMaxW = _defaultParam.maxtextw
		local showText = SoraDConvertOmissionText(topMaxW, data.topText, _defaultParam.topfontsize)
		txtContentInfo.fontDimensions.width = 0
		txtContentInfo.fontSize = _defaultParam.topfontsize
		txtContentInfo.isHtml = false
		local measureSize = cc.Device:measureText(showText, txtContentInfo)
		data.topSize = measureSize
		data.topsepw = _defaultParam.topsepw
		if data.contentSize and measureSize.width > data.contentSize.width then
			data.contentSize = cc.size(measureSize.width, data.contentSize.height)
		end
	end
	local retSize = chatBubbleNode.measureSize(data, target)
	retSize.bottomSize = data.bottomSize
	if target then
		target.width = retSize.width
		target.height = retSize.height
	end
	return retSize
end
return chatEmoticonNode

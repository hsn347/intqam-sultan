local chatSkinRead = include("chatSkinRead")
local chatBubbleNode = class("chatBubbleNode", function(target)
	local target = include("chatBaseNode").new("chatBubbleNode")
	return target
end)
_ENV = "chatBubbleNode"
;("chatBubbleNode").minbgW = 220
;("chatBubbleNode").minbgH = 112
;("chatBubbleNode").deltaLong = 0.3
local ("chatBubbleNode").menuOffsetY, _defaultParam = 10, "chatBubbleNode"
function chatBubbleNode:ctor()
	self.isDebug = gChatDebug
	self.bubbleId = 1
end
function chatBubbleNode:reset()
end
function chatBubbleNode:init(data)
	self:reset()
	if data.isDebug ~= nil then
		self:setIsDebug(data.isDebug)
	end
	self.data = data
	self.isRA = data.isRA
	if self.isRA == nil then
		self.isRA = SoraDFIsRA()
	end
	chatBubbleNode.measureSize(data, self)
	self:initView()
end
function chatBubbleNode:setIsDebug(isDebug)
	self.isDebug = isDebug
end
function chatBubbleNode:updateBgBubble(filename, capRect)
	self.bg:loadTexture(filename, ccui.TextureResType.plistType)
	self.bg:setCapInsets(capRect)
end
function chatBubbleNode:initView()
	local direction = self.data.direction or gChatDirection.right
	local cfg = self.cfg
	if not self.bg then
		local bg = ccui.ImageView:create()
		bg:ignoreContentAdaptWithSize(false)
		bg:setAnchorPoint(cc.p(0.5, 0.5))
		bg:setScale9Enabled(true)
		bg:addTo(self)
		self.bg = bg
	end
	local filename = self.cfg.rightbg
	local isNeedFlip = false
	if direction == gChatDirection.left then
		if self.cfg.leftbg == "" or self.cfg.leftbg == nil then
			isNeedFlip = true
		else
			filename = self.cfg.leftbg
		end
	end
	self.bg:loadTexture(filename, ccui.TextureResType.plistType)
	print("filename  =", filename)
	local spriteFrame = self.bg:getVirtualRenderer():getSprite():getSpriteFrame()
	local spriteSize = spriteFrame:getOriginalSize()
	self.spriteSize = spriteSize
	local bgSize = cc.size(self.bgWidth, self.bgHeight)
	local bgx = self.cfg.margin[gMargin.left]
	local contentx = 0
	local bottomx = 0
	local bottomtipx = 0
	local topx = 0
	local contentAlign = self.data.contentAlign
	if not contentAlign then
		if self.isRA then
			contentAlign = gChatContentAlign.right
		else
			contentAlign = gChatContentAlign.left
		end
	end
	if contentAlign == gChatContentAlign.right then
		contentx = bgx + self.bgWidth - self.cfg.padding[gPadding.right] - self.data.contentSize.width
	elseif contentAlign == gChatContentAlign.left then
		contentx = bgx + self.cfg.padding[gPadding.left]
	elseif contentAlign == gChatContentAlign.center then
		contentx = bgx + self.cfg.padding[gPadding.left] + (self.bgWidth - self.cfg.padding[gPadding.left] - self.cfg.padding[gPadding.right] - self.data.contentSize.width) / 2
	end
	bottomx = bgx + self.cfg.bottompadding[gPadding.left]
	if self.data.topSize then
		if contentAlign == gChatContentAlign.right then
			topx = bgx + self.bgWidth - self.cfg.bottompadding[gPadding.right] - self.data.topSize.width
		elseif contentAlign == gChatContentAlign.center then
			topx = bgx + self.cfg.bottompadding[gPadding.left] + (self.bgWidth - self.cfg.bottompadding[gPadding.left] - self.cfg.bottompadding[gPadding.right] - self.data.topSize.width) / 2
		else
			topx = bgx + self.cfg.bottompadding[gPadding.left]
		end
	else
		topx = bottomx
	end
	if self.data.bottomTipSize then
		bottomtipx = bgx + self.bgWidth - self.cfg.bottompadding[gPadding.right] - self.data.bottomTipSize.width
	end
	if direction == gChatDirection.left then
		bgx = self.cfg.margin[gMargin.right]
		if contentAlign == gChatContentAlign.right then
			contentx = bgx + self.bgWidth - self.cfg.padding[gPadding.left] - self.data.contentSize.width
		elseif contentAlign == gChatContentAlign.left then
			contentx = bgx + self.cfg.padding[gPadding.right]
		elseif contentAlign == gChatContentAlign.center then
			contentx = bgx + self.cfg.padding[gPadding.right] + (self.bgWidth - self.cfg.padding[gPadding.left] - self.cfg.padding[gPadding.right] - self.data.contentSize.width) / 2
		end
		if self.data.bottomSize then
			bottomx = bgx + self.bgWidth - self.cfg.bottompadding[gPadding.left] - self.data.bottomSize.width
		end
		if self.data.topSize then
			if contentAlign == gChatContentAlign.right then
				topx = bgx + self.bgWidth - self.cfg.bottompadding[gPadding.left] - self.data.topSize.width
			elseif contentAlign == gChatContentAlign.center then
				topx = bgx + self.cfg.bottompadding[gPadding.right] + (self.bgWidth - self.cfg.bottompadding[gPadding.left] - self.cfg.bottompadding[gPadding.right] - self.data.topSize.width) / 2
			else
				topx = bgx + self.cfg.bottompadding[gPadding.right]
			end
		end
		if self.data.bottomTipSize then
			bottomtipx = bgx + self.cfg.bottompadding[gPadding.right]
		end
	end
	self.contentx = contentx
	self.bottomx = bottomx
	self.topx = topx
	self.bottomtipx = bottomtipx
	self.contentxr = contentx + self.data.contentSize.width
	if not self.data.bottomSize then
		local contentyt = self.height - cfg.margin[gMargin.top] - cfg.padding[gPadding.top]
		local contenty = contentyt - self.data.contentSize.height
		self.contenty = contenty
		self.contentyt = contentyt
	else
		self.bottomxr = bottomx + self.data.bottomSize.width
		local bottomy = cfg.margin[gMargin.bottom] + cfg.bottompadding[gPadding.bottom]
		local bottomyt = bottomy + self.data.bottomSize.height
		local contentyt = self.height - cfg.margin[gMargin.top] - cfg.padding[gPadding.top]
		if self.data.topSize then
			contentyt = contentyt - self.data.topSize.height
			self.topy = contentyt + self.data.topsepw
		end
		local contenty = contentyt - self.data.contentSize.height
		self.bottomy = bottomy
		self.contenty = contenty
		self.bottomyt = bottomyt
		self.contentyt = contentyt
		if self.data.bottomTipSize then
			self.bottomtipxr = bottomtipx + self.data.bottomTipSize.width
			local bottomtipy = bottomy
			local bottomtipyt = bottomyt
			self.bottomtipy = bottomtipy
			self.bottomtipyt = bottomtipyt
		end
	end
	local bgy = self.cfg.margin[gMargin.bottom]
	if self.data.bgContentSize then
		self.bg:setPosition(cc.p(self.data.bgContentSize.width / 2 + bgx, self.data.bgContentSize.height / 2 + bgy))
	else
		self.bg:setPosition(cc.p(bgSize.width / 2 + bgx, bgSize.height / 2 + bgy))
	end
	self.bgx = bgx
	self.bgy = bgy
	if isNeedFlip then
		if not self.bg:isFlippedX() then
			self.bg:setFlippedX(true)
		end
		local capRect = cc.rect(cfg.capinsets[gCapInsets.x], cfg.capinsets[gCapInsets.y], cfg.capinsets[gCapInsets.width], cfg.capinsets[gCapInsets.height])
		self.capRect = capRect
		self.bg:setCapInsets(capRect)
	else
		if self.bg:isFlippedX() then
			self.bg:setFlippedX(false)
		end
		if direction == gChatDirection.left then
			local x = self.spriteSize.width - cfg.capinsets[gCapInsets.x] - cfg.capinsets[gCapInsets.width]
			local capRect = cc.rect(x, cfg.capinsets[gCapInsets.y], cfg.capinsets[gCapInsets.width], cfg.capinsets[gCapInsets.height])
			self.capRect = capRect
			self.bg:setCapInsets(capRect)
		else
			local capRect = cc.rect(cfg.capinsets[gCapInsets.x], cfg.capinsets[gCapInsets.y], cfg.capinsets[gCapInsets.width], cfg.capinsets[gCapInsets.height])
			self.capRect = capRect
			self.bg:setCapInsets(capRect)
		end
	end
	if self.data.bgContentSize then
		self.bg:setContentSize(self.data.bgContentSize)
	else
		self.bg:setContentSize(bgSize)
	end
	local nodeSize = cc.size(self.width, self.height)
	self:setContentSize(nodeSize)
	self:initWidgets()
	if self.isDebug then
		self:initDebugView()
	end
	self.bg:removeAllChildren()
	if self.cfg.index == 115 then
		local et_lu = self:createAniNode("dh_zyltzp_zs_")
		et_lu:setPosition(30, self.bg:getContentSize().height - 17)
		et_lu:addTo(self.bg)
		local et_ld = self:createAniNode("dh_zyltzp_zx_")
		et_ld:setPosition(25, 24)
		et_ld:addTo(self.bg)
		local et_ru = self:createAniNode("dh_zyltzp_ys_")
		et_ru:setPosition(self.bg:getContentSize().width - 17, self.bg:getContentSize().height - 17)
		et_ru:addTo(self.bg)
		local et_rd = self:createAniNode("dh_zyltzp_yx_")
		et_rd:setPosition(self.bg:getContentSize().width - 23, 24)
		et_rd:addTo(self.bg)
	end
	if self.cfg.index == 118 then
		local et_lu = self:createAniNode("dh_yqzcltzb_ltkzs_")
		et_lu:setPosition(60, self.bg:getContentSize().height - 20)
		et_lu:addTo(self.bg)
		local et_ld = self:createAniNode("dh_yqzcltzb_ltkzx_")
		et_ld:setPosition(35, 30)
		et_ld:addTo(self.bg)
		local et_ru = self:createAniNode("dh_yqzcltzb_ltkys_")
		et_ru:setPosition(self.bg:getContentSize().width - 17, self.bg:getContentSize().height - 30)
		et_ru:addTo(self.bg)
		local et_rd = self:createAniNode("dh_yqzcltzb_ltkyx_")
		et_rd:setPosition(self.bg:getContentSize().width - 38, 26)
		et_rd:addTo(self.bg)
	end
end
function chatBubbleNode:createAniNode(frameStr)
	local et_ani = display.newSprite("#" .. frameStr .. "01" .. ".png")
	SoraDMixtureGLONE(et_ani)
	local frames = display.newFrames(frameStr .. "%.2d.png", 1, 24)
	local animation = display.newAnimation(frames, 2 / #frames)
	et_ani:playAnimationForever(animation)
	return et_ani
end
function chatBubbleNode:initDebugView()
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
	local lb = cc.p(self.contentx, self.contenty)
	local lt = cc.p(self.contentx, self.contentyt)
	local rt = cc.p(self.contentxr, self.contentyt)
	local rb = cc.p(self.contentxr, self.contenty)
	_UPVALUE4_ = self.contentxr
	self.contentxr[1] = lb
	self.contentxr[2] = lt
	self.contentxr[3] = rt
	local self.contentxr[4], tbPoints = rb, self.contentxr
	_UPVALUE4_ = rt
	rt[1] = lb
	rt[2] = lt
	rt[3] = rt
	rt[4] = rb
	self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 0, 1))
	if self.data.bottomSize then
		local lb = cc.p(self.bottomx, self.bottomy)
		local lt = cc.p(self.bottomx, self.bottomyt)
		local rt = cc.p(self.bottomxr, self.bottomyt)
		local rb = cc.p(self.bottomxr, self.bottomy)
		_UPVALUE4_ = self.bottomxr
		self.bottomxr[1] = lb
		self.bottomxr[2] = lt
		self.bottomxr[3] = rt
		local self.bottomxr[4], tbPoints = rb, self.bottomxr
		_UPVALUE4_ = rt
		rt[1] = lb
		rt[2] = lt
		rt[3] = rt
		rt[4] = rb
		self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 0, 1, 1))
		if self.data.bottomTipSize then
			local lb = cc.p(self.bottomtipx, self.bottomtipy)
			local lt = cc.p(self.bottomtipx, self.bottomtipyt)
			local rt = cc.p(self.bottomtipxr, self.bottomtipyt)
			local rb = cc.p(self.bottomtipxr, self.bottomtipy)
			_UPVALUE4_ = self.bottomtipxr
			self.bottomtipxr[1] = lb
			self.bottomtipxr[2] = lt
			self.bottomtipxr[3] = rt
			local self.bottomtipxr[4], tbPoints = rb, self.bottomtipxr
			_UPVALUE4_ = rt
			rt[1] = lb
			rt[2] = lt
			rt[3] = rt
			rt[4] = rb
			self._debugNode:drawPoly(rt, 4, true, cc.c4f(0, 1, 1, 1))
		end
	end
	do
		local lb = cc.p(self.bgx, self.bgy)
		local lt = cc.p(self.bgx, self.bgy + self.bgHeight)
		local rt = cc.p(self.bgx + self.bgWidth, self.bgy + self.bgHeight)
		local rb = cc.p(self.bgx + self.bgWidth, self.bgy)
		_UPVALUE4_ = cc.p(self.bottomtipx, self.bottomtipyt)
		cc.p(self.bottomtipx, self.bottomtipyt)[1] = lb
		cc.p(self.bottomtipx, self.bottomtipyt)[2] = lt
		cc.p(self.bottomtipx, self.bottomtipyt)[3] = rt
		cc.p(self.bottomtipx, self.bottomtipyt)[4] = rb
		self._debugNode:drawPoly(cc.p(self.bottomtipx, self.bottomtipyt), 4, true, cc.c4f(1, 1, 0, 1))
	end
	do
		local lb = cc.p(0, 0)
		local lt = cc.p(0, self.height)
		local rt = cc.p(self.width, self.height)
		local rb = cc.p(self.width, 0)
		_UPVALUE4_ = cc.p(self.bottomtipx, self.bottomtipyt)
		cc.p(self.bottomtipx, self.bottomtipyt)[1] = lb
		cc.p(self.bottomtipx, self.bottomtipyt)[2] = lt
		cc.p(self.bottomtipx, self.bottomtipyt)[3] = rt
		cc.p(self.bottomtipx, self.bottomtipyt)[4] = rb
		self._debugNode:drawPoly(cc.p(self.bottomtipx, self.bottomtipyt), 4, true, cc.c4f(1, 0, 0, 1))
	end
end
function chatBubbleNode.measureSize(data, target)
	if not target then
		target, _ENV = nil, nil
	end
	local self = target
	_ENV = nil
	;(nil).data = data
	local (nil).checkRes, bubbleParam = true, nil
	local chatFunctions = include("chatFunctions")
	local showBubbleId
	if data.noCheckShowBubbleId then
		showBubbleId = data.bubbleId
	else
		showBubbleId = chatFunctions.getShowBubbleId(bubbleParam)
	end
	data.showBubbleId = showBubbleId
	local cfg = chatSkinRead.getBubbleCfg(showBubbleId)
	self.cfg = cfg
	local contentW = data.contentSize.width
	local paddingW = cfg.padding[gPadding.left] + cfg.padding[gPadding.right]
	local maxContentW = contentW + paddingW
	self.bgWidth = maxContentW
	if data.bottomSize then
		local bottomW = data.bottomSize.width
		if data.bottomTipSize then
			bottomW = bottomW + data.bottomTipSize.width + (data.bottomSepw or 0)
		end
		local bottompaddingW = cfg.bottompadding[gPadding.left] + cfg.bottompadding[gPadding.right]
		local maxBottomW = bottompaddingW + bottomW
		self.bgWidth = math.max(self.bgWidth, maxBottomW)
	end
	if data.topSize then
		local topW = data.topSize.width
		local toppaddingW = cfg.bottompadding[gPadding.left] + cfg.bottompadding[gPadding.right]
		local maxTopW = toppaddingW + topW
		self.bgWidth = math.max(self.bgWidth, maxTopW)
	end
	if data.btnSize then
		self.bgWidth = math.max(self.bgWidth, data.btnSize.width)
	end
	local marginW = cfg.margin[gMargin.left] + cfg.margin[gMargin.right]
	self.bgWidth = math.max(self.bgWidth, _defaultParam.minbgW)
	self.width = self.bgWidth + marginW
	local maxContentH = data.contentSize.height
	if data.bottomSize then
		maxContentH = maxContentH + data.bottomSize.height
	end
	if data.topSize then
		maxContentH = maxContentH + data.topSize.height
	end
	if data.btnSize then
		maxContentH = maxContentH + data.btnSize.height
	end
	if not data.bottomSize then
		local paddingH = cfg.padding[gPadding.top] + cfg.padding[gPadding.bottom]
		local marginH = cfg.margin[gMargin.top] + cfg.margin[gMargin.bottom]
		self.bgHeight = paddingH + maxContentH
		self.bgHeight = math.max(self.bgHeight, _defaultParam.minbgH)
		self.height = self.bgHeight + marginH
	else
		local paddingH = cfg.padding[gPadding.top] + cfg.bottompadding[gPadding.top] + cfg.bottompadding[gPadding.bottom]
		local marginH = cfg.margin[gMargin.top] + cfg.margin[gMargin.bottom]
		self.bgHeight = paddingH + maxContentH
		self.bgHeight = math.max(self.bgHeight, _defaultParam.minbgH)
		self.height = self.bgHeight + marginH
	end
	return cc.size(self.width, self.height)
end
function chatBubbleNode:initWidgets()
	local widgets = self.cfg.widgets
	if next(widgets) == nil then
		self:removeAllWigets()
		return
	end
	if not self.widgetRoot then
		self.widgetRoot = display.newNode()
		self.widgetRoot:addTo(self)
		self.widgetRoot:setPosition(cc.p(0, 0))
	end
	for _, v in ipairs(widgets) do
		self:createWidget(v)
	end
end
function chatBubbleNode:removeAllWigets()
	if not self.widgetRoot then
		return
	end
	self.widgetRoot:removeAllChildren(true)
end
function chatBubbleNode:createWidget(widgetId)
	local widgetCfg = chatSkinRead.getBubbleWidget(self.data.bubbleId, widgetId)
	if not widgetCfg then
		return
	end
	local widgetfucName = "createWidget_" .. widgetCfg.widgettype
	local widgetfunc = self[widgetfucName]
	if widgetfunc then
		widgetfunc(self, widgetCfg)
	end
end
function chatBubbleNode:getWidgetPos(widgetCfg)
	local posx = 0
	local posy = 0
	local padding = widgetCfg.padding
	if self.data.direction == gChatDirection.left then
		if padding[gPadding.left] ~= 0 then
			posx = self.width - padding[gPadding.left]
		elseif padding[gPadding.right] ~= 0 then
			posx = padding[gPadding.right]
		end
	elseif padding[gPadding.left] ~= 0 then
		posx = padding[gPadding.left]
	elseif padding[gPadding.right] ~= 0 then
		posx = self.width - padding[gPadding.right]
	end
	if padding[gPadding.top] ~= 0 then
		posy = self.height - padding[gPadding.top]
	elseif padding[gPadding.bottom] ~= 0 then
		posy = padding[gPadding.bottom]
	end
	return cc.p(posx, posy)
end
function chatBubbleNode:createWidget_Sprite(widgetCfg)
	local filename = widgetCfg.rightbg
	local isNeedFlip = false
	if self.data.direction == gChatDirection.left and widgetCfg.leftbg ~= "" then
		filename = widgetCfg.leftbg
	elseif self.data.direction == gChatDirection.left then
		isNeedFlip = true
	end
	filename = "#" .. filename
	local sprite = display.newSprite(filename)
	local scale = widgetCfg.param.scale or 1.0
	sprite:setScale(scale)
	sprite:addTo(self.widgetRoot)
	local pos = self:getWidgetPos(widgetCfg)
	sprite:setPosition(pos)
	if isNeedFlip then
		sprite:setFlippedX(true)
	end
end
function chatBubbleNode:createWidget_Animation(widgetCfg)
	local param = widgetCfg.param
	local filename = widgetCfg.rightbg
	local isNeedFlip = false
	if self.data.direction == gChatDirection.left and widgetCfg.leftbg ~= "" then
		filename = widgetCfg.leftbg
	elseif self.data.direction == gChatDirection.left then
		isNeedFlip = true
	end
	local spriteName = string.format(filename, param.astart)
	spriteName = "#" .. spriteName
	local sprite = display.newSprite(spriteName)
	local scale = widgetCfg.param.scale or 1.0
	sprite:setScale(scale)
	sprite:addTo(self.widgetRoot)
	local pos = self:getWidgetPos(widgetCfg)
	sprite:setPosition(pos)
	local frames = display.newFrames(filename, param.astart, param.aend)
	local animation = display.newAnimation(frames, 0.16666666666666666)
	sprite:playAnimationForever(animation)
	if isNeedFlip then
		sprite:setFlippedX(true)
	end
end
function chatBubbleNode:getContentX()
	return self.contentx
end
function chatBubbleNode:getContentTopY()
	return self.contentyt
end
function chatBubbleNode:getContentY()
	return self.contenty
end
function chatBubbleNode:getContentPos()
	return cc.p(self.contentx, self.contenty)
end
function chatBubbleNode:getTopPos()
	return cc.p(self.topx, self.topy or 0)
end
function chatBubbleNode:getContentPosRB()
	return cc.p(self.contentxr, self.contenty)
end
function chatBubbleNode:getBottomX()
	return self.bottomx
end
function chatBubbleNode:getBottomY()
	return self.bottomy
end
function chatBubbleNode:getBottomPos()
	return cc.p(self.bottomx, self.bottomy)
end
function chatBubbleNode:getBottomTipPos()
	return cc.p(self.bottomtipx, self.bottomtipy)
end
function chatBubbleNode:checkBgTouchEnable()
	if not self.bg:isTouchEnabled() then
		self.bg:setTouchEnabled(true)
		self.bg:setSwallowTouches(false)
		self.bg:addTouchEventListener(handler(self, self.onTouchBg))
	end
end
function chatBubbleNode:setClickHandle(clickHandle)
	self:checkBgTouchEnable()
	self.clickHandle = clickHandle
end
function chatBubbleNode:getClickHandle()
	return self.clickHandle
end
function chatBubbleNode:setLongClickHandle(longClickHandle)
	self:checkBgTouchEnable()
	self.longClickHandle = longClickHandle
end
function chatBubbleNode:getLongClickHandle()
	return self.longClickHandle
end
function chatBubbleNode:onTouchBg(target, event)
	if event == ccui.TouchEventType.began then
		self.tBegin = SoraDGetSocketTime()
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			return
		else
		end
		goto lbl_32
		::lbl_32::
		self.tEnd = SoraDGetSocketTime()
		local dt = self.tEnd - self.tBegin
		local isLongClick = dt > _defaultParam.deltaLong
		print("按下时长:", dt, ", 判断为:", isLongClick and "长按" or "短按")
		if isLongClick and self.longClickHandle then
			self.longClickHandle(target)
		elseif self.clickHandle then
			self.clickHandle(target)
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
function chatBubbleNode:getMenuWorldPos()
	local bottomPos = self.bg:convertToWorldSpace(cc.p(self.bg:getContentSize().width / 2, _defaultParam.menuOffsetY))
	if bottomPos.y > display.cy then
		return bottomPos, gMenuAlignVType.bottom
	end
	local topPos = self.bg:convertToWorldSpace(cc.p(self.bg:getContentSize().width / 2, self.bg:getContentSize().height - _defaultParam.menuOffsetY))
	return topPos, gMenuAlignVType.top
end
return chatBubbleNode

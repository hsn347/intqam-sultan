local cityBuildConstDef = include("cityBuildConstDef")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local cityBuildTipBox = class("cityBuildTipBox", function()
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
function cityBuildTipBox:ctor()
	self:setSwallowTouches(false)
	self.singleIsMoved = false
	self:setAnchorPoint(cc.p(0.5, 0))
	self.deltaHContent = 30
	self.deltaWContent = 32
	self.deltaYContent = 13
	self.deltaSideContent = 18
	self.colorText = cc.c3b(215, 195, 155)
	self.minWBg = 125
	self.minHBg = 75
	self.deltaWBottom = 12
	self.deltaHBottom = 3
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if currentView then
			local scale = currentView:getZoomScale(true)
			_ENV = cc.p(0.5, 0)
			cc.p(0.5, 0).scale = scale
			self:updateNameScale(nil, cc.p(0.5, 0))
		end
	end
end
function cityBuildTipBox:onExitOther()
	self:stopTimer()
end
function cityBuildTipBox:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SCALE_CHANGE", handler(self, self.updateNameScale))
end
function cityBuildTipBox:updateNameScale(target, data)
	local scale = 1
	if data.scale and data.scale < MAINCITY_DEFAULT_SCALE then
		scale = 1 + 0.5 * (MAINCITY_DEFAULT_SCALE - data.scale) / (MAINCITY_DEFAULT_SCALE - 0.35)
	end
	self:setScale(scale)
end
function cityBuildTipBox:startTimer()
	if not self.timerKey then
		self:stopTimer()
		self.timerKey = scheduler.scheduleGlobal(handler(self, self.updateTime), 0.02)
	end
end
function cityBuildTipBox:stopTimer()
	if self.timerKey then
		scheduler.unscheduleGlobal(self.timerKey)
		self.timerKey = nil
	end
end
function cityBuildTipBox:updateTime()
	if self.follow and not tolua.isnull(self.follow) and self.follow:getName() == "soldier_guard_2" then
		local x, y = self.follow:getPosition()
		self:setPosition(cc.p(x + 4, y + 17))
	end
end
function cityBuildTipBox:initWithData(data)
	self.boxType = data.boxType
	self.content = data.content
	self.handler = data.handler
	self.maxWidth = data.maxWidth or self.minWBg
	self.needFade = data.needFade or false
	self.tag = data.tag
	self.needCenter = data.needCenter
	self.autoDelete = data.autoDelete
	self.imgSize = data.imgSize
	self.follow = data.follow
	self.delayTime = data.delayTime
	self.jumpData = data.jumpData
	if self.follow then
		self:startTimer()
	end
	if self.btn == nil then
		local btn = ccui.Layout:create()
		btn:setTouchEnabled(true)
		btn:setSwallowTouches(false)
		btn:setAnchorPoint(cc.p(0, 0))
		btn:addTouchEventListener(handler(self, self.onBtnCall))
		self:addChild(btn)
		self.btn = btn
	end
	if self.img_bg == nil then
		local img_bg = ccui.ImageView:create()
		img_bg:loadTexture("frame_shijiebei_kuang1.png", ccui.TextureResType.plistType)
		img_bg:setScale9Enabled(true)
		img_bg:setAnchorPoint(cc.p(0, 0))
		local contentSize = img_bg:getContentSize()
		img_bg:setCapInsets(cc.rect(17, 17, contentSize.width - 34, contentSize.height - 34))
		self:addChild(img_bg)
		self.img_bg = img_bg
	end
	if self.img_bg_bottom == nil then
		local img_bg_bottom = ccui.ImageView:create()
		img_bg_bottom:loadTexture("frame_lace_arrow.png", ccui.TextureResType.plistType)
		img_bg_bottom:setAnchorPoint(cc.p(0.5, 0))
		img_bg_bottom:setFlippedY(true)
		self:addChild(img_bg_bottom)
		self.img_bg_bottom = img_bg_bottom
	end
	if self.boxType == cityBuildConstDef.TipBoxType.IMG then
		if self.img_icon == nil then
			local img_icon = ccui.ImageView:create()
			self.img_bg:addChild(img_icon)
			self.img_icon = img_icon
		end
		self.img_icon:setPosition(cc.p(self.img_bg:getContentSize().width / 2, self.img_bg:getContentSize().height / 2 + self.deltaYContent))
		self.img_icon:loadTexture(self.content, ccui.TextureResType.plistType)
		local iconSize = self.imgSize or self.img_icon:getContentSize()
		local bgSize = cc.size(iconSize.width + self.deltaWContent, iconSize.height + self.deltaHContent - 10)
		self.img_bg:setContentSize(bgSize)
		self.img_icon:setPosition(cc.p(bgSize.width / 2, bgSize.height / 2))
		self.img_bg:setPosition(cc.p(0, 0))
		self.btn:setContentSize(cc.size(bgSize.width, bgSize.height))
		self.btn:setPosition(cc.p(0, 0))
		self.img_bg_bottom:setPosition(cc.p(bgSize.width / 2 + self.deltaWBottom, self.deltaHBottom))
		self:setContentSize(cc.size(bgSize.width, bgSize.height))
	elseif self.boxType == cityBuildConstDef.TipBoxType.TEXT_TYPE_1 then
		if self.textContent == nil then
			local textContent = ccui.Text:create()
			textContent:setFontSize(20)
			textContent:setColor(self.colorText)
			self.textContent = textContent
			self.img_bg:addChild(self.textContent, 10)
		end
		self.textContent:setString(self.content)
		local width = self.textContent:getContentSize().width
		local height = self.textContent:getContentSize().height
		if width > self.maxWidth then
			height = SoraDGetAutoHeightLabel(self.textContent, self.maxWidth)
			width = self.textContent:getContentSize().width
		else
			SoraDSetTextWidthHeight(self.textContent, self.textContent:getContentSize())
		end
		local bgWidth = math.max(self.minWBg, width + self.deltaWContent)
		local bgHeight = math.max(self.minHBg, height + self.deltaHContent)
		local bgContentSize = cc.size(bgWidth, bgHeight)
		self.img_bg:setContentSize(bgContentSize)
		if self.needCenter then
			self.textContent:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			self.textContent:setAnchorPoint(cc.p(0.5, 0.5))
			self.textContent:setPosition(cc.p(bgContentSize.width / 2, bgContentSize.height / 2))
		else
			self.textContent:setPosition(cc.p(bgContentSize.width - self.deltaSideContent, self.deltaYContent))
			self.textContent:setTextHorizontalAlignment(SoraDFLabelR())
			self.textContent:setAnchorPoint(SoraDFAP(1, 0))
			self.textContent:setPosition(SoraDFPoint(bgContentSize.width - self.deltaSideContent, self.deltaYContent, bgContentSize.width))
		end
		self.img_bg_bottom:setPosition(cc.p(bgContentSize.width / 2 + self.deltaWBottom, self.deltaHBottom))
		self:setContentSize(cc.size(bgContentSize.width, bgContentSize.height))
		self.btn:setContentSize(cc.size(bgContentSize.width, bgContentSize.height))
		self.btn:setPosition(cc.p(0, 0))
	elseif self.boxType == cityBuildConstDef.TipBoxType.TEXT_TYPE_2 then
		local textContent = ccui.Text:create()
		textContent:setString(self.content)
		textContent:setFontSize(20)
		textContent:setColor(self.colorText)
		local height = SoraDGetAutoHeightLabel(textContent, self.maxWidth)
		textContent:setContentSize(cc.size(self.maxWidth, height))
		img_bg:addChild(textContent)
		self.textContent = textContent
		img_bg:setContentSize(self.maxWidth + 60, height + 60)
		textContent:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		textContent:setAnchorPoint(cc.p(1, 0))
		textContent:setPosition(cc.p(self.maxWidth + 30, 30))
	end
	if self.needFade then
		self:showFadeAct()
	end
	if self.autoDelete then
		self:stopAllActions()
		local delayTime = self.delayTime or math.random(3, 6)
		local actDelay = cca.delay(delayTime)
		local actCallFunc = cca.callFunc(function()
			self:setVisible(false)
			self:stopTimer()
		end)
		_UPVALUE2_ = cc.p(self.maxWidth + 30, 30)
		cc.p(self.maxWidth + 30, 30)[1] = actDelay
		cc.p(self.maxWidth + 30, 30)[2] = actCallFunc
		local seq = cca.seq(cc.p(self.maxWidth + 30, 30))
		self:runAction(seq)
	end
end
function cityBuildTipBox:showFadeAct()
	_UPVALUE3_ = nil
	;(nil)[1] = self.img_bg
	;(nil)[2] = self.img_bg_bottom
	local (nil)[3], tableFadeNodes = self.img_icon, nil
	for i, v in ipairs(tableFadeNodes) do
		if v then
			local fadeTo1 = cca.fadeTo(0.8, 0.7)
			local fadeTo2 = cca.fadeTo(0.4, 1.0)
			_UPVALUE2_ = 1.0
			;(1.0)[1] = fadeTo1
			;(1.0)[2] = fadeTo2
			local actSeq = cca.seq(1.0)
			local actRepeat = cca.repeatForever(actSeq)
			v:runAction(actRepeat)
		end
	end
end
function cityBuildTipBox:onBtnCall(ref, type)
	if type == ccui.TouchEventType.began then
	elseif type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.handler then
			self.handler(self.tag, self.jumpData)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = ref:getTouchBeganPosition()
		local touchmovePoint = ref:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return cityBuildTipBox

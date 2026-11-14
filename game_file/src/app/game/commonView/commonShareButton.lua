local CommonShareButton = class("commonShareButton", function(target)
	if target == nil then
		target = display.newNode()
		target:setNodeEventEnabled(true)
	end
	return target
end)
function CommonShareButton:ctor()
	self.hiddleModel = 0.5
	self.btnBg = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnBg:ignoreContentAdaptWithSize(false)
	self.btnBg:setAnchorPoint(cc.p(0, 0))
	self.btnBg:setPosition(0, 0)
	self.btnBg:setContentSize(display.size)
	self.btnBg:addTo(self)
	self.btnBg:setVisible(false)
	self.imgBg = ccui.ImageView:create("frame_jt_bjd.png", ccui.TextureResType.plistType)
	self.imgBg:ignoreContentAdaptWithSize(false)
	self.imgBg:setAnchorPoint(cc.p(0.5, 0.5))
	self.imgBg:setPosition(cc.p(320, 480))
	self.imgBg:setScale9Enabled(true)
	self.imgBg:setCapInsets(cc.rect(5, 5, 45, 45))
	self.imgBg:setOpacity(191.25)
	self.imgBg:setVisible(false)
	self.imgBg:addTo(self)
	self.btnMain = ccui.Button:create("icon_jt_ps.png", "icon_jt_ps.png", "icon_jt_ps.png", ccui.TextureResType.plistType)
	self.btnWidth = 0.5 * self.btnMain:getContentSize().width
	self.btnMain:setPressedActionEnabled(false)
	self.btnMain:setAnchorPoint(cc.p(0.5, 0.5))
	self.btnMain:setPosition(display.width - 5 - self.btnWidth, 480)
	self.btnMain:setOpacity(self.hiddleModel * 255)
	self.btnMain:addTo(self)
	_ENV, _ENV = self.btnMain, self.btnMain.addTo
	self.btnMain.icon = "icon_jt_kz.png"
	self.btnMain.key = "screen_btn_02"
	_ENV, self.btnMain.addTo[1], self.btnMain.tag = self.btnMain, self.btnMain, 2
	self.btnMain.icon = "icon_jt_sz.png"
	self.btnMain.key = "common_text_713"
	self.tableBtn, self.btnMain.addTo[2], self.btnMain.tag = self.btnMain.addTo, self.btnMain, 3
	if userSDKManager.isSupportReplay() then
		_ENV = 480
		;(480).icon = "icon_jt_lz.png"
		;(480).key = "screen_btn_01"
		;(480).tag = 1
		table.insert(self.tableBtn, 1, 480)
	end
	for i, v in ipairs(self.tableBtn) do
		local btn = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
		btn:setPressedActionEnabled(false)
		btn:setVisible(false)
		btn:addTo(self)
		btn:setTag(v.tag)
		btn:ignoreContentAdaptWithSize(false)
		btn:setContentSize(cc.size(100, 120))
		btn:addTouchEventListener(handler(self, self.btnClickCallBack))
		btn:setSwallowTouches(true)
		local sprite = display.newSprite("#" .. v.icon)
		sprite:addTo(btn)
		sprite:setName("Sprite_icon")
		sprite:setPosition(50, 80)
		sprite = display.newSprite("#icon_jt_5.png")
		sprite:addTo(btn)
		sprite:setName("Sprite_frame")
		sprite:setPosition(50, 80)
		local label = ccui.Text:create()
		label:setFontSize(22)
		label:setColor(display.COLOR_WHITE)
		label:setAnchorPoint(cc.p(0.5, 0))
		label:setName("Text_name")
		label:setPosition(cc.p(50, 5))
		label:ignoreContentAdaptWithSize(false)
		label:setTextAreaSize(cc.size(100, 45))
		label:setContentSize(cc.size(100, 45))
		label:setString(i18n(v.key))
		label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		label:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		label:addTo(btn)
		v.btn = btn
	end
	self.btnBg:addTouchEventListener(handler(self, self.btnBgClickCallBack))
	self.btnMain:addTouchEventListener(handler(self, self.btnMainClickCallBack))
	self:showGuideAction()
	SoraDAddMessage(self, "MESSAGE_MAIN_RECORD_SCREEN", handler(self, self.startRecordScreen))
	SoraDAddMessage(self, "MESSAGE_MAIN_STOP_RECORD_SCREEN", handler(self, self.stopRecordScreen))
end
function CommonShareButton:startRecordScreen(target, data)
	local btn = self.tableBtn[1].btn
	local _ENV, actSprite
	actSprite[1] = btn:getChildByName("Sprite_icon")
	actSprite[2] = btn:getChildByName("Sprite_frame")
	for i, v in ipairs(actSprite) do
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeOut(0.5)
		;(nil)[2] = cca.fadeIn(0.5)
		;(nil)[3] = cca.fadeIn(0.5)
		v:runAction(cca.repeatForever(cca.seq(nil)))
	end
	if self.timer == nil then
		self:recordTimeTick()
		self.timer = SoradCreateTimer(self, handler(self, self.recordTimeTick))
	end
	btn:setTag(4)
	_ENV = 4
	userSDKManager.logEvent(gSDKDef.TDonEvent.share_button_record_open, 4)
end
function CommonShareButton:stopRecordScreen()
	local btn = self.tableBtn[1].btn
	local _ENV, actSprite
	actSprite[1] = btn:getChildByName("Sprite_icon")
	actSprite[2] = btn:getChildByName("Sprite_frame")
	for i, v in ipairs(actSprite) do
		v:stopAllActions()
		v:setOpacity(255)
	end
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	btn:setTag(1)
	self.tableBtn[1].btn:getChildByName("Text_name"):setString(i18n("screen_btn_01"))
	_ENV = i18n("screen_btn_01")
	userSDKManager.logEvent(gSDKDef.TDonEvent.share_button_record_stop, i18n("screen_btn_01"))
end
function CommonShareButton:recordTimeTick()
	self.tableBtn[1].btn:getChildByName("Text_name"):setString(SoraDConvertSecondToString(gSDKDef.GAME_RECORD_TIME))
end
function CommonShareButton:foldBG()
	self.imgBg:setContentSize(self.btnMain:getContentSize())
	self.btnBg:setVisible(false)
	self.imgBg:setVisible(false)
	self.btnMain:setVisible(true)
	for i, v in ipairs(self.tableBtn) do
		v.btn:setVisible(false)
	end
	self:starMainBtnOpacity()
end
function CommonShareButton:unfoldBG()
	self:updateAP()
	self.btnMain:setVisible(false)
	self.imgBg:setVisible(true)
	self.imgBg:setContentSize(cc.size(100 * #self.tableBtn, 120))
	self.btnBg:setVisible(true)
end
function CommonShareButton:updateAP()
	local x, y = self.btnMain:getPosition()
	local ax, ay, vec = 0, 0, 1
	local size = self.imgBg:getContentSize()
	if x > display.cx then
		ax = 1
		vec = -1
		x = x + size.width * 0.5
	else
		x = x - size.width * 0.5
	end
	if y > display.cy then
		ay = 1
		y = y + size.height * 0.5
	else
		y = y - size.height * 0.5
	end
	self.imgBg:setAnchorPoint(cc.p(ax, ay))
	self.imgBg:setPosition(x, y)
	for i, v in ipairs(self.tableBtn) do
		v.btn:setAnchorPoint(cc.p(ax, ay))
		v.btn:setPosition(x + vec * (i - 1) * 100, y)
		v.btn:setVisible(true)
	end
end
function CommonShareButton:btnBgClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self:foldBG()
	end
end
function CommonShareButton:showGuideAction()
	_ENV = nil
	;(nil).byUID = true
	if SoraDConfigGet("Game:Guide:shareButtonFirstShow~bool", nil) then
		self.btnMain:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeTo(1, self.hiddleModel * 0.75)
		;(nil)[2] = cca.fadeTo(0.5, 1)
		;(nil)[3] = cca.fadeTo(0.5, 1)
		;(nil)[4] = cca.fadeTo(0.5, 1)
		self.btnMain:runAction(cca.repeatForever(cca.seq(nil)))
	end
end
function CommonShareButton:starMainBtnOpacity(isTouch)
	self.btnMain:stopAllActions()
	self.btnMain:setOpacity(255)
	if not isTouch then
		local x, y = self.btnMain:getPosition()
		local size = self.btnMain:getContentSize()
		if y + 0.5 * size.height >= display.height - size.height then
			y = display.height - 0.5 * size.height - 5
		elseif y - 0.5 * size.height <= size.height then
			y = 0.5 * size.height + 5
		elseif x >= display.cx then
			x = display.width - 0.5 * size.width - 5
		else
			x = 0.5 * size.width + 5
		end
		if x + 0.5 * size.width + 5 > display.width then
			x = display.width - 0.5 * size.width - 5
		elseif x - 0.5 * size.width - 5 < 0 then
			x = 0.5 * size.width + 5
		end
		if y + 0.5 * size.height + 5 > display.height then
			y = display.height - 0.5 * size.height - 5
		elseif y - 0.5 * size.height - 5 < 0 then
			y = 0.5 * size.height + 5
		end
		self:showGuideAction()
		_UPVALUE2_ = nil
		;(nil)[1] = cca.moveTo(0.2, x, y)
		;(nil)[2] = cca.delay(3.8)
		;(nil)[3] = cca.fadeTo(0.1, self.hiddleModel)
		;(nil)[4] = cca.fadeTo(0.1, self.hiddleModel)
		;(nil)[5] = cca.fadeTo(0.1, self.hiddleModel)
		self.btnMain:runAction(cca.seq(nil))
	end
end
function CommonShareButton:btnMainClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			self:starMainBtnOpacity()
			return
		end
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:Guide:shareButtonFirstShow~bool", false, nil)
		SoraDPlaySound()
		self:unfoldBG()
		_ENV = false
		userSDKManager.logEvent(gSDKDef.TDonEvent.share_button_main, false)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
		if self.singleIsMoved then
			local prolong = 0.5 * self.btnWidth
			local posX = math.max(self.btnWidth - prolong, math.min(touchmovePoint.x, display.width - self.btnWidth + prolong))
			local posY = math.max(self.btnWidth - prolong, math.min(touchmovePoint.y, display.height - self.btnWidth + prolong))
			local pos = self:convertToNodeSpace(cc.p(posX, posY))
			self.btnMain:setPosition(pos)
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self:starMainBtnOpacity()
	elseif type == ccui.TouchEventType.began then
		self:starMainBtnOpacity(true)
	end
end
function CommonShareButton:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self:foldBG()
		local tag = button:getTag()
		if tag == 1 then
			SoraDPlaySound()
			userSDKManager.startRecording()
		elseif tag == 2 then
			self.btnMain:setVisible(false)
			local panel = SoraDCreatePanel("commonSharePic")
			panel:initData(SoraDCreateScreenShot(), 1)
			panel:show(self)
			self.btnMain:setVisible(true)
			local view = ccui.Layout:create()
			view:setContentSize(display.size)
			view:setBackGroundColorType(1)
			view:setBackGroundColor(display.COLOR_WHITE)
			view:setBackGroundColorOpacity(255)
			view:setAnchorPoint(0.5, 0.5)
			view:setPosition(display.cx, display.cy)
			view:addTo(self, 1)
			_UPVALUE2_ = 1
			;(1)[1] = cca.delay(0.2)
			;(1)[2] = cca.fadeOut(0.2)
			;(1)[3] = cca.callFunc(function(...)
				view:removeFromParent()
			end)
			;(1)[4] = cca.callFunc(function(...)
				view:removeFromParent()
			end)
			view:runAction(cca.seq(1))
		elseif tag == 3 then
			SoraDPlaySound()
			_ENV = view
			view.jumpName = "photo"
			uiManager:show("gameOptions", view)
			_ENV = "gameOptions"
			userSDKManager.logEvent(gSDKDef.TDonEvent.share_button_set, "gameOptions")
		elseif tag == 4 then
			SoraDPlaySound()
			_ENV = gSDKDef.TDonEvent.share_button_set
			gSDKDef.TDonEvent.share_button_set.msg = "MESSAGE_MAIN_STOP_RECORD_SCREEN"
			SoraDSendMessage(gSDKDef.TDonEvent.share_button_set)
		end
	end
end
function CommonShareButton.createSnapshootButton(bigDataType, fromTarget, preCallBack, postCallBack, closeCallBack)
	local btn = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	btn:setPressedActionEnabled(false)
	btn:setAnchorPoint(cc.p(0.5, 0.5))
	btn:ignoreContentAdaptWithSize(false)
	btn:setContentSize(cc.size(70, 70))
	btn:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			button:setVisible(false)
			if preCallBack then
				preCallBack()
			end
			_ENV = button
			button.msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
			button.otherPic = false
			SoraDSendMessage(button)
			local panel = SoraDCreatePanel("commonSharePic")
			panel:initData(SoraDCreateScreenShot(), bigDataType, closeCallBack)
			panel:show()
			if fromTarget then
				panel:setLocalZOrder(fromTarget:getLocalZOrder())
			end
			button:setVisible(true)
			if postCallBack then
				postCallBack()
			end
			_ENV = button
			button.msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
			button.otherPic = true
			SoraDSendMessage(button)
			local view = ccui.Layout:create()
			view:setContentSize(display.size)
			view:setBackGroundColorType(1)
			view:setBackGroundColor(display.COLOR_WHITE)
			view:setBackGroundColorOpacity(255)
			view:setAnchorPoint(0.5, 0.5)
			view:setPosition(display.cx, display.cy)
			view:addTo(panel:getParent(), 1)
			bigDataType = 1
			;(1)[1] = cca.delay(0.2)
			;(1)[2] = cca.fadeOut(0.2)
			;(1)[3] = cca.callFunc(function(...)
				view:removeFromParent()
			end)
			;(1)[4] = cca.callFunc(function(...)
				view:removeFromParent()
			end)
			view:runAction(cca.seq(1))
		end
	end)
	btn:setSwallowTouches(true)
	local sprite = display.newSprite("#frame_main_common.png")
	sprite:addTo(btn)
	sprite:setScale(0.7)
	sprite:setPosition(35, 35)
	sprite = display.newSprite("#icon_jt_kz.png")
	sprite:addTo(btn)
	sprite:setPosition(35, 35)
	return btn
end
function CommonShareButton.createSnapshootWithButton(button, bigDataType, fromTarget, preCallBack, postCallBack, closeCallBack)
	print("·feaawefawwfawe·", button, bigDataType)
	button:addTouchEventListener(function(button, type)
		print("自定义拍照按钮")
		if type == ccui.TouchEventType.ended then
			if preCallBack then
				preCallBack()
			end
			_ENV = "自定义拍照按钮"
			;("自定义拍照按钮").msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
			;("自定义拍照按钮").otherPic = false
			SoraDSendMessage("自定义拍照按钮")
			local panel = SoraDCreatePanel("commonSharePic")
			panel:initData(SoraDCreateScreenShot(), bigDataType, closeCallBack)
			panel:show()
			if fromTarget then
				panel:setLocalZOrder(fromTarget:getLocalZOrder())
			end
			if postCallBack then
				postCallBack()
			end
			_ENV = panel
			panel.msg = "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE"
			panel.otherPic = true
			SoraDSendMessage(panel)
			local view = ccui.Layout:create()
			view:setContentSize(display.size)
			view:setBackGroundColorType(1)
			view:setBackGroundColor(display.COLOR_WHITE)
			view:setBackGroundColorOpacity(255)
			view:setAnchorPoint(0.5, 0.5)
			view:setPosition(display.cx, display.cy)
			view:addTo(panel:getParent(), 1)
			bigDataType = 1
			;(1)[1] = cca.delay(0.2)
			;(1)[2] = cca.fadeOut(0.2)
			;(1)[3] = cca.callFunc(function(...)
				view:removeFromParent()
			end)
			;(1)[4] = cca.callFunc(function(...)
				view:removeFromParent()
			end)
			view:runAction(cca.seq(1))
		end
	end)
end
function CommonShareButton:onExit()
	print(self.__cname, " exit")
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
return CommonShareButton

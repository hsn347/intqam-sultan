local voiceChatFloatButton = class("voiceChatFloatButton", function(target)
	if target == nil then
		target = display.newNode()
		target:setNodeEventEnabled(true)
	end
	return target
end)
function voiceChatFloatButton:ctor()
	self.hiddleModel = 0.4
	self.btnBg = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.btnBg:ignoreContentAdaptWithSize(false)
	self.btnBg:setAnchorPoint(cc.p(0, 0))
	self.btnBg:setPosition(0, 0)
	self.btnBg:setContentSize(display.size)
	self.btnBg:addTo(self)
	self.btnBg:setVisible(false)
	self.imgBg = ccui.ImageView:create("frame_jt_bjd.png", ccui.TextureResType.plistType)
	self.imgBg:setContentSize(cc.size(70, 70))
	self.btnWidth = 0.5 * self.imgBg:getContentSize().width
	self.imgBg:ignoreContentAdaptWithSize(false)
	self.imgBg:setAnchorPoint(cc.p(0.5, 0.5))
	self.imgBg:setPosition(display.width - 5 - self.btnWidth, 480)
	self.imgBg:setScale9Enabled(true)
	self.imgBg:setCapInsets(cc.rect(5, 5, 45, 45))
	self.imgBg:setOpacity(self.hiddleModel * 255)
	self.imgBg:addTo(self)
	self.btnMain = ccui.Button:create("icon_voice_speak_hold.png", "icon_voice_speak_hold.png", "icon_voice_speak_hold.png", ccui.TextureResType.plistType)
	self.btnMain:setPressedActionEnabled(false)
	self.btnMain:setAnchorPoint(cc.p(0.5, 0.5))
	self.btnMain:setPosition(35.0, 35.0)
	self.btnMain:addTo(self.imgBg)
	self.btnMain:addTouchEventListener(handler(self, self.btnMainClickCallBack))
	self:speakStyleChange()
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_SPEAKSTYLE_REFRESH", handler(self, self.speakStyleChange))
	SoraDAddMessage(self, "MESSAGE_VOICECHAT_PRELEAVECHANNEL", handler(self, self.disabelSpeakBtn))
end
function voiceChatFloatButton:updateAP()
	local x, y = self.imgBg:getPosition()
	local ax, ay, vec = 0, 0, 1
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
	for i, v in ipairs(self.tableBtn) do
		v.btn:setAnchorPoint(cc.p(ax, ay))
		v.btn:setPosition(x + vec * (i - 1) * 100, y)
		v.btn:setVisible(true)
	end
end
function voiceChatFloatButton:starMainBtnOpacity(isTouch)
	self.imgBg:stopAllActions()
	self.imgBg:setOpacity(178.5)
	if not isTouch then
		local x, y = self.imgBg:getPosition()
		local size = self.imgBg:getContentSize()
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
		_UPVALUE2_ = nil
		;(nil)[1] = cca.moveTo(0.2, x, y)
		;(nil)[2] = cca.delay(3.8)
		;(nil)[3] = cca.fadeTo(0.1, self.hiddleModel)
		;(nil)[4] = cca.fadeTo(0.1, self.hiddleModel)
		;(nil)[5] = cca.fadeTo(0.1, self.hiddleModel)
		self.imgBg:runAction(cca.seq(nil))
	end
end
function voiceChatFloatButton:btnMainClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if gSpeakStyle.hold == self.speakStyle then
			self:end2Speak()
			self:showHoldView(false)
		else
			SoraDPlaySound()
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			self:starMainBtnOpacity()
			return
		end
		print("voiceChatFloatButton:btnMainClickCallBack")
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
			self.imgBg:setPosition(pos)
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self:starMainBtnOpacity()
		if gSpeakStyle.hold == self.speakStyle then
			self:end2Speak()
			self:showHoldView(false)
		end
	elseif type == ccui.TouchEventType.began then
		self:starMainBtnOpacity(true)
		if gSpeakStyle.hold == self.speakStyle then
			self:start2Speak()
			self:showHoldView(true)
			SoraDPlaySound("worldmap", 5)
		end
	end
end
function voiceChatFloatButton:showHoldView(bool)
	local cleanPanel = function(...)
		if not tolua.isnull(self.holdView) and self.holdView then
			self.holdView:removeFromParent()
			self.holdView = nil
		end
	end
	if bool then
		cleanPanel()
		self.holdView = SoraDCreatePanel("voiceChatHoldPopView")
		self.holdView:show()
	else
		cleanPanel()
	end
end
function voiceChatFloatButton:disabelSpeakBtn(...)
	self.btnMain:setTouchEnabled(false)
end
function voiceChatFloatButton:speakStyleChange(...)
	print("voiceChatFloatButton:speakStyleChange")
	self.speakStyle = VoiceChatSDKManager:getInstance().speakStyle
	if gSpeakStyle.hold == self.speakStyle then
		self.btnMain:loadTextures("icon_voice_speak_hold.png", "icon_voice_speak_hold.png", "icon_voice_speak_hold.png", ccui.TextureResType.plistType)
		self:end2Speak()
	elseif gSpeakStyle.free == self.speakStyle then
		self.btnMain:loadTextures("icon_voice_speak_free.png", "icon_voice_speak_free.png", "icon_voice_speak_free.png", ccui.TextureResType.plistType)
		self:start2Speak()
	elseif gSpeakStyle.mute == self.speakStyle then
		self.btnMain:loadTextures("icon_voice_speak_forbid.png", "icon_voice_speak_forbid.png", "icon_voice_speak_forbid.png", ccui.TextureResType.plistType)
		self:end2Speak()
	end
end
function voiceChatFloatButton:start2Speak(...)
	print("开始说话")
	VoiceChatSDKManager:getInstance():start2Speak()
end
function voiceChatFloatButton:end2Speak(...)
	print("停止说话")
	VoiceChatSDKManager:getInstance():end2Speak()
end
function voiceChatFloatButton:onExit()
	self:showHoldView(false)
	print(self.__cname, " exit")
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
return voiceChatFloatButton

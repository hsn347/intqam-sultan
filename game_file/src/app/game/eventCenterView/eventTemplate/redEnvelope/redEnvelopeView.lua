local gametop = gModuleMgr.getObject("gametop")
local redEnvelopeCtrl = gametop.playertop_:getModule("redEnvelopeCtrl")
local redEnvelopeView = class("redEnvelopeView", function(target)
	if type(target) == "userData" then
		return target
	end
	return SoraDCreateTouchPanel("redEnvelopeView")
end)
function redEnvelopeView:ctor()
	local panel = SoraDGetChildByName(self, "Center_Panel_4")
	self.ccs_Title = SoraDGetChildByName(self, "Text_Title")
	self.ccs_Title:setString(i18n("activity_name_08"))
	SoraDGetChildByName(self, "Image_Bg"):setFillType(1)
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips = SoraDCreateTimerLabel(self, self.textTips)
	self.btnOpen = SoraDGetChildByName(self, "btn_Open")
	self.btnLog = SoraDGetChildByName(self, "btn_Log")
	self.btnOpen:addTouchEventListener(handler(self, self.btnOpenClick))
	self.btnOpen:setTitleText(i18n("rebag_text_12"))
	self.btnLog:addTouchEventListener(handler(self, self.btnLogClick))
	self.textInput = ccui.EditBox:create(cc.size(250, 35), "frame_alliance_input.png", ccui.TextureResType.plistType)
	self.textInput:setAnchorPoint(0.5, 0.5)
	self.textInput:setPosition(cc.p(271, 196))
	self.textInput:setFontColor(cc.c3b(150, 150, 150))
	self.textInput:setPlaceholderFontColor(cc.c3b(150, 150, 150))
	self.textInput:setPlaceholderFontSize(22)
	self.textInput:setMaxLength(100)
	self.textInput:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.textInput:setTouchEnabled(true)
	self.textInput:addTouchEventListener(handler(self, self.OnEditBoxTouch))
	self.textInput:registerScriptEditBoxHandler(handler(self, self.onInputPsd))
	if device.platform ~= "mac" then
		self.textInput:setTextHorizontalAlignment(SoraDFLabelR())
	end
	self.textInput:setSwallowTouches(false)
	self.textInput:addTo(panel)
	self.totalGold = SoraDGetChildByName(self, "Text_Num")
	self.goldTip = SoraDGetChildByName(self, "Text_RedTip")
	self.btnQuestion = SoraDGetChildByName(self, "btn_question")
	self.goldTip:setString(i18n("rebag_text_10"))
	self.btnQuestion:setTouchEnabled(true)
	self.btnQuestion:addTouchEventListener(handler(self, self.btnQuestionClick))
	redEnvelopeCtrl:sendReqInitInfo()
	self:addDoubleFireEffect()
end
function redEnvelopeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_REDENVELOPE_UPDATE", handler(self, self.refreshTime))
end
function redEnvelopeView:addDoubleFireEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 48
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 78
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 33
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 48
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "fireBase_Left"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "fireBase_Right"), -2)
end
function redEnvelopeView:btnQuestionClick(target, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("rebag_text_09"))
	end
end
function redEnvelopeView:btnOpenClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if redEnvelopeCtrl:getGroupStatu() == gActivityState.OPEN then
			if redEnvelopeCtrl:getLeftEnvelope() == 0 then
				SoraDShowMsgTip(i18n("rebag_text_06"))
			elseif redEnvelopeCtrl:alreadyReceive() then
				SoraDShowMsgTip(i18n("rebag_text_08"))
			else
				_ENV = i18n("rebag_text_08")
				i18n("rebag_text_08").psd = self.strInput
				redEnvelopeCtrl:sendReqInput(i18n("rebag_text_08"))
			end
		elseif redEnvelopeCtrl:getGroupStatu() == gActivityState.PREPARE then
			SoraDShowMsgTip(i18n("rebag_text_05"))
		else
			SoraDShowMsgTip(i18n("rebag_text_13"))
		end
	end
end
function redEnvelopeView:OnEditBoxTouch(target, event)
	if event == ccui.TouchEventType.ended then
		target:touchDownAction(target, event)
	end
end
function redEnvelopeView:btnLogClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("redEnvelopeLogView")
		panel:show()
	end
end
function redEnvelopeView:onInputPsd(eventType, textFiled)
	if eventType == "began" then
	elseif eventType == "changed" then
	elseif eventType == "ended" or eventType == "return" then
		self.strInput = textFiled:getText()
		redEnvelopeCtrl:setLastInput(self.strInput)
	end
end
function redEnvelopeView:refreshTime()
	self.totalGold:setString(string.formatnumberthousands(redEnvelopeCtrl:getTotalGold()))
	if redEnvelopeCtrl:getGroupStatu() == gActivityState.OPEN then
		self.textTips:endTime()
		if redEnvelopeCtrl:getLeftEnvelope() == 0 then
			self.textTips:setString(i18n("rebag_text_06"))
			self.btnOpen:loadTextures("btn_lmslc2.png", "btn_lmslc2.png", "btn_lmslc2.png", ccui.TextureResType.plistType)
		else
			self.textTips:setString(i18n("rebag_text_03"))
			if redEnvelopeCtrl:alreadyReceive() then
				self.btnOpen:loadTextures("btn_lmslc2.png", "btn_lmslc2.png", "btn_lmslc2.png", ccui.TextureResType.plistType)
			else
				self.btnOpen:loadTextures("btn_lmslc.png", "btn_lmslc3.png", "btn_lmslc2.png", ccui.TextureResType.plistType)
			end
		end
	elseif redEnvelopeCtrl:getGroupStatu() == gActivityState.PREPARE then
		self.btnOpen:loadTextures("btn_lmslc2.png", "btn_lmslc2.png", "btn_lmslc2.png", ccui.TextureResType.plistType)
		self.textTips:setTimeEndListener(function()
			self.textTips:setString(i18n("rebag_text_03"))
		end)
		self.textTips:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("rebag_text_01", nil)
		end)
		self.textTips:beginTime(redEnvelopeCtrl:getLeftTime())
	else
		self.textTips:setString(i18n("rebag_text_13"))
		self.btnOpen:loadTextures("btn_lmslc2.png", "btn_lmslc2.png", "btn_lmslc2.png", ccui.TextureResType.plistType)
	end
	self.btnQuestion:setPositionX(self.textTips:getPositionX() + self.textTips:getContentSize().width / 2 + 30)
	local lastStr = redEnvelopeCtrl:getLastInput()
	if lastStr and lastStr ~= "" then
		self.textInput:setText(lastStr)
		self.strInput = lastStr
	else
		self.textInput:setPlaceHolder(i18n("rebag_text_04"))
	end
	local width = (self.goldTip:getContentSize().width + self.totalGold:getContentSize().width + 50) / 2
	self.goldTip:setPositionX(210 - width + self.goldTip:getContentSize().width)
	self.totalGold:setPositionX(self.goldTip:getPositionX() + 50)
	SoraDGetChildByName(self, "Image_1"):setPositionX(self.goldTip:getPositionX() + 27)
end
function redEnvelopeView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PSD_RED_PACKAGE_ACTIVITY) or not redEnvelopeCtrl:getIsOPen() then
		self:layerClickCallBack(self, ccui.TouchEventType.ended)
	end
end
return redEnvelopeView

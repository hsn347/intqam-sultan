local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatConst = include("chatConst")
local chatFunctions = include("chatFunctions")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatThemeMgr = gChatMgrs:getMgr("chatThemeMgr")
local chatBottomView = class("chatBottomView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
_ENV = "chatBottomView"
;("chatBottomView").noticeItemId = 502001
;("chatBottomView").notceShopItemId = 1000059
;("chatBottomView").inputHeight = 64
_ENV, ("chatBottomView").editboxHeight = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 55
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 15
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = 15
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).top = 0
_ENV, ("chatBottomView").paddingEditbox, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).bottom = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 0
_ENV = nil
;(nil).width = 560
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text], (nil).height = nil, 64
_ENV = nil
;(nil).width = 496
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Emo], (nil).height = nil, 64
_ENV = nil
;(nil).width = 424
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Emo_Horn], (nil).height = nil, 64
_ENV = nil
;(nil).width = 496
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Emo_Audio], (nil).height = nil, 64
_ENV = nil
;(nil).width = 560
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Audio], (nil).height = nil, 64
_ENV = nil
;(nil).width = 490
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Horn], (nil).height = nil, 64
_ENV = nil
;(nil).width = 424
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Emo_Audio_Horn], (nil).height = nil, 64
_ENV = nil
;(nil).width = 424
_ENV, ("chatBottomView").inputBgCfg, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Emo_Quick], (nil).height = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, nil, 64
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).normal = "frame_LT_shurukuang01.png"
_ENV, ("chatBottomView").inputBgImage, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).notice = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, "frame_LT_shurukuang02.png"
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 8
_ENV, ("chatBottomView").paddingBtnSend, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 6
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 8
_ENV, ("chatBottomView").paddingBtnAudio, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 6
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 6
_ENV, ("chatBottomView").paddingInput, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 6
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 4
;("chatBottomView").paddingBtnEmoticon, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("chatBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 4
local ("chatBottomView").inputFontSize, _defaultParam = 24, "chatBottomView"
function chatBottomView:ctor()
	self.maxCharCount = gChatMaxLength.normalChatLength
	self.isChangeDirty = false
	self.isShowBtnKNotice = false
	self.isKNotice = false
	self.isShowBtnEmotion = false
	self.isEmotionBtnShow = true
	self.oldStr = ""
	self.replyMsg = nil
	self.quoteBarHeight = 48
	self.nodeBg = SoraDGetChildByName(self, "node_bg")
	self.buttonSend = SoraDGetChildByName(self, "Button_Send")
	self.buttonEmotion = SoraDGetChildByName(self, "Button_Emotion")
	self.buttonEmotion:setSwallowTouches(false)
	self.btnAudio = SoraDGetChildByName(self, "Button_audio")
	self.bottomBg = SoraDGetChildByName(self, "BottomBg")
	self.btn_k_notice = SoraDGetChildByName(self, "CheckBox_k_notice")
	self.btn_k_notice:setSelected(false)
	self.btnKeypad = SoraDGetChildByName(self, "Button_Keypad")
	self.btnTheme = SoraDGetChildByName(self, "Button_theme")
	self.btnTheme:setVisible(false)
	self.btn_quick_send = SoraDGetChildByName(self, "btn_quick_send")
	self.text_char_count = SoraDGetChildByName(self, "text_char_count")
	self.textBg = SoraDGetChildByName(self, "textBg")
	self.textField = SoraDGetChildByName(self, "textField")
	self.textField = ccui.EditBox:create(cc.size(394, 60), "bg_transparent.png", ccui.TextureResType.plistType)
	self.textField.__title:setSingleLine(true)
	self.textField.__title:setNoToolBar(true)
	self.textField.__title:addEventListener(fgui.UIEventType.Submit, function()
		self:hideKeyPad()
	end)
	self.bgBlack = display.newSprite("#frame_sheer_black_03.png")
	self.bgBlack:addTo(self.bottomBg, -1)
	self.bgBlack:setPosition(320, -10)
	self.bgBlack:setOpacity(153.0)
	self.bgBlack:setContentSize(cc.size(640, 180))
	self.bgBlack:setRotation(180)
	self.textBg:addChild(self.textField)
	self.textField:setName("textField")
	if self.textField.setControlType then
		self.textField:setControlType(1)
	end
	self.textField:setAnchorPoint(cc.p(0, 0))
	self.textField:setPosition(cc.p(0, 0))
	self.textField:setFontColor(cc.c3b(0, 0, 0))
	self.textField:setTextHorizontalAlignment(SoraDFLabelR())
	self.textField:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.textField:setFontSize(_defaultParam.inputFontSize)
	self.textField:setPlaceholderFontSize(_defaultParam.inputFontSize)
	function self.textField:getCharCount()
		return string.utf8len(self:getText())
	end
	function self.textField:getString()
		return RemoveStringSpecial(self:getText())
	end
	self.textField:setPlaceholderFontColor(cc.c3b(115, 99, 68))
	self.textField:setPlaceHolder(i18n("common_text_072"))
	self.textField:setText("")
	if self.btn_k_notice then
		self.btn_k_notice:addEventListener(handler(self, self.onBtnKNotice))
	end
	if self.btn_quick_send then
		self.btn_quick_send:addTouchEventListener(handler(self, self.onBtnQuickSend))
		self.btn_quick_send:setVisible(false)
	end
	if self.btnTheme then
		self.btnTheme:addTouchEventListener(handler(self, self.onBtnTheme))
	end
	self.buttonSend:setTouchEnabled(true)
	self.buttonSend:addTouchEventListener(handler(self, self.OnBtnSendEvent))
	self.buttonEmotion:addTouchEventListener(handler(self, self.OnBtnEmotionEvent))
	self.buttonEmotion:setPressedActionEnabled(true)
	self.btnKeypad:addTouchEventListener(handler(self, self.OnBtnKeypadEvent))
	self.btnKeypad:setPressedActionEnabled(true)
	SoraDGetChildByName(self, "Panel_Personal"):setVisible(false)
	self.btnFriend = SoraDGetChildByName(self, "Button_Friend")
	self.btnGroup = SoraDGetChildByName(self, "Button_Group")
	self.btnFriend:setTitleText(i18n("friend_name_01"))
	self.btnFriend:addTouchEventListener(handler(self, self.btnFriendClick))
	self.btnGroup:setTitleText(i18n("common_text_3526"))
	self.btnGroup:addTouchEventListener(handler(self, self.btnGroupClick))
	SoraDAutoSizeButtonText(self.btnGroup, cc.size(216, 70))
	if self.btnAudio then
		self.btnAudio:addTouchEventListener(handler(self, self.onBtnAudio))
	end
	self.textField:registerScriptEditBoxHandler(handler(self, self.editBoxTextEvent))
	self.img_red_point = SoraDGetChildByName(self, "img_red_point")
	self.text_record_time = SoraDGetChildByName(self, "text_record_time")
	self.img_arrow_record = SoraDGetChildByName(self, "img_arrow_record")
	self.text_op_tip = SoraDGetChildByName(self, "text_op_tip")
	self.text_op_tip:setString(i18n("common_text_2053"))
	local posArrowX = SoraDFIsRA() and 320 + self.text_op_tip:getContentSize().width / 2 + 20 or 320 - self.text_op_tip:getContentSize().width / 2 - 20
	self.img_arrow_record:setPositionX(posArrowX)
	self.targetPos_text_op_tip = cc.p(self.text_op_tip:getPosition())
	self.targetPos_img_arrow_record = cc.p(self.img_arrow_record:getPosition())
	self.targetPos_img_red_point = cc.p(self.img_red_point:getPosition())
	self.targetPos_text_record_time = cc.p(self.text_record_time:getPosition())
	self.text_record_time:setString("00:59")
	if SoraDFIsRA() then
		self.oriPos_text_op_tip = cc.p(0 - self.text_op_tip:getContentSize().width / 2, self.targetPos_text_op_tip.y)
		self.oriPos_img_arrow_record = cc.p(0 - self.img_arrow_record:getContentSize().width / 2, self.targetPos_img_arrow_record.y)
		self.oriPos_img_red_point = cc.p(640 + self.img_red_point:getContentSize().width / 2, self.targetPos_img_red_point.y)
		self.oriPos_text_record_time = cc.p(640 + self.text_record_time:getContentSize().width / 2, self.targetPos_text_record_time.y)
		self.cancelAudioDist = math.abs(640 - self.targetPos_img_arrow_record.x)
		self.deltaArrowRedPoint = math.abs(self.targetPos_img_red_point.x - self.targetPos_img_arrow_record.x) - 25
	else
		self.oriPos_text_op_tip = cc.p(640 + self.text_op_tip:getContentSize().width / 2, self.targetPos_text_op_tip.y)
		self.oriPos_img_arrow_record = cc.p(640 + self.img_arrow_record:getContentSize().width / 2, self.targetPos_img_arrow_record.y)
		self.oriPos_img_red_point = cc.p(0 - self.img_red_point:getContentSize().width / 2, self.targetPos_img_red_point.y)
		self.oriPos_text_record_time = cc.p(0 - self.text_record_time:getContentSize().width / 2, self.targetPos_text_record_time.y)
		self.deltaArrowRedPoint = math.abs(self.targetPos_img_red_point.x - self.targetPos_img_arrow_record.x) - 25
		self.cancelAudioDist = math.abs(self.targetPos_img_arrow_record.x)
	end
	print("cancelAudioDist = ", self.cancelAudioDist)
	self.oriTextBgPos = cc.p(self.textBg:getPosition())
	self.oriBtnKNotice = cc.p(self.btn_quick_send:getPosition())
	self.text_op_tip:setPosition(self.oriPos_text_op_tip)
	self.img_arrow_record:setPosition(self.oriPos_img_arrow_record)
	self.img_red_point:setPosition(self.oriPos_img_red_point)
	self.text_record_time:setPosition(self.oriPos_text_record_time)
	dump(self.oriPos_text_record_time, "oriPos_text_record_time = ", 10)
	chatAudioMgr:pushAudioTarget(self)
	self.text_char_count:setVisible(false)
	self:setAudioElementsVisible(false)
	self:updateTheme()
end
function chatBottomView:onEnterOther()
	self:showBtnKNotice(false)
	self:startTimer()
	self:updateBtnSend()
	self:updateTime()
end
function chatBottomView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_SEND_ONE_MESSAGE_BACK", handler(self, self.sMsgSendOneMessageBack))
	SoraDAddMessage(self, "MESSAGE_CHAT_CLOSE_IME", handler(self, self.msgCloseIME))
	SoraDAddMessage(self, "MESSAGE_CHAT_THEME_CHANGED", handler(self, self.msgThemeChanged))
	SoraDAddMessage(self, "MESSAGE_CHAT_SET_REPLY_MSG", handler(self, self.msgSetReplyMsg))
	SoraDAddMessage(self, "MESSAGE_CHAT_CLEAR_REPLY_MSG", handler(self, self.msgClearReplyMsg))
end
function chatBottomView:ensureQuoteBar()
	if self.quoteBar then
		return self.quoteBar
	end
	self.quoteBar = fguiHelper.createObject("ChatAtSelect", "Com_Chat_Quote")
	self:addChild(self.quoteBar)
	self.quoteBar:setCancelCallback(handler(self, self.clearReplyMsg))
	self.quoteBar:hide()
	self:layoutQuoteBar()
	return self.quoteBar
end
function chatBottomView:layoutQuoteBar()
	if self.quoteBar then
		self.quoteBar:setPosition(0, -126)
	end
end
function chatBottomView:setReplyMsg(replyMsg)
	if not replyMsg then
		self:clearReplyMsg()
		return
	end
	self.replyMsg = replyMsg
	local quoteBar = self:ensureQuoteBar()
	quoteBar:setReplyMsg(replyMsg)
	quoteBar:show()
	self:layoutQuoteBar()
end
function chatBottomView:getReplyMsg()
	return self.replyMsg
end
function chatBottomView:clearReplyMsg()
	self.replyMsg = nil
	if self.quoteBar then
		self.quoteBar:setReplyMsg(nil)
		self.quoteBar:hide()
	end
	self:layoutQuoteBar()
end
function chatBottomView:msgSetReplyMsg(target, data)
	if data and data.replyMsg then
		self:setReplyMsg(data.replyMsg)
	end
end
function chatBottomView:msgClearReplyMsg()
	self:clearReplyMsg()
end
function chatBottomView:takeReplyMsg()
	local replyMsg = self.replyMsg
	self:clearReplyMsg()
	return replyMsg
end
function chatBottomView:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
	function self.chatDelegate.onKebordHideDelegate()
		self:fitUnityEditBox(false)
	end
end
function chatBottomView:sendAudio(data)
	print("发送语音----------------")
	dump(data, "chatBottomView:sendAudio")
	if self.chatDelegate then
		_ENV = nil
		;(nil).message = data
		;(nil).messageType = gChatTypeDef.chat_content_audio
		self.chatDelegate:chatSendOneMessage(self, nil)
	end
end
function chatBottomView:checkTextSend(chatChannel, subType)
	local interval = gChatChannel2MsgInterval[chatChannel]
	if type(interval) == "table" then
		interval = interval[subType]
	end
	local canSend = chatSendMgr:checkIntervalTime(interval)
	return canSend
end
function chatBottomView:checkSendNotice()
	local kingdomSettingAPI = include("kingdomSettingAPI")
	local canChat, lv = kingdomSettingAPI:canUseKingdomBugle()
	if not canChat then
		_ENV = nil
		;(nil).lv = lv
		SoraDShowMsgTip(i18n("common_text_3670", nil))
		return
	end
	local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
	if activity_9001573_Ctrl:getIsInBattle() and activity_9001573_Ctrl:getIsCommander() then
		self:confirmUseItemCallBack(MSGBOX_CALLBACK_YES)
		return
	end
	self:hideKeyPad()
	local itemCount = self:getItemCount()
	if 1 <= itemCount then
		_ENV = i18n("common_text_3670", nil)
		i18n("common_text_3670", nil).num = 1
		i18n("common_text_3670", nil).itemName = self:getItemName()
		local strMsg = i18n("common_text_505", i18n("common_text_3670", nil))
		SoraDShowMsgBox(strMsg, i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmUseItemCallBack))
		return
	else
		_ENV = strMsg
		strMsg.itemName = self:getItemName()
		local strMsg = i18n("common_text_506", strMsg)
		local needGold = self:getItemPrice()
		print("needGold:", needGold)
		SoraDShowBuyBox(strMsg, needGold, i18n("common_text_054"), handler(self, self.useGoldCallBack), true)
		return
	end
end
function chatBottomView:OnBtnSendEvent(button, type)
	if type == ccui.TouchEventType.ended then
		print("发送按钮: Send Click")
		SoraDPlaySound()
		local isCanChat = chatCtrl:canChat()
		local curChannel = chatDataMgr:getChatChannel()
		if self:checkForbidChat(curChannel) and not isCanChat then
			SoraDShowMsgTip(i18n("commom_text_4306"))
			return
		end
		if self.isKNotice == true then
			if curChannel == gChatChannel.CAMP then
			else
				self:checkSendNotice()
			end
			return
		end
		local textContent = self.textField:getString()
		if textContent and string.len(textContent) > 0 then
			if not chatroomCtrl:checkChatRoomState(curChannel) then
				SoraDShowMsgTip(i18n("common_text_2213"))
				return
			end
			if not self:checkTextSend(curChannel) then
				return
			end
			if self.chatDelegate then
				_ENV = self.chatDelegate
				self.chatDelegate.message = textContent
				local self.chatDelegate.messageType, param = gChatTypeDef.chat_content_text, self.chatDelegate
				if self.isAtAll then
					if string.find(textContent, i18n("alliance_office_title_04"), 1, true) then
						param.isAtAll = true
					end
					self.isAtAll = nil
				end
				if self.atUserMap then
					for k, atName in pairs(self.atUserMap) do
						if string.find(textContent, atName, 1, true) then
							self.atUserMap[k] = true
						else
							self.atUserMap[k] = nil
						end
					end
					if next(self.atUserMap) then
						param.atUserMap = self.atUserMap
					end
					self.atUserMap = nil
				end
				if self.replyMsg then
					param.replyMsg = self.replyMsg
				end
				self.chatDelegate:chatSendOneMessage(self, param)
			end
		end
		self.textField:setText("")
	end
end
function chatBottomView:OnBtnEmotionEvent(button, type)
	if type == ccui.TouchEventType.ended then
		print("点击了表情按钮")
		SoraDPlaySound()
		local curChannel = chatDataMgr:getChatChannel()
		local isCanChat = chatCtrl:canChat()
		if self:checkForbidChat(curChannel) and not isCanChat then
			SoraDShowMsgTip(i18n("commom_text_4306"))
			return
		end
		_ENV = i18n("commom_text_4306")
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_emoticon_btn, i18n("commom_text_4306"))
		if self.chatDelegate then
			self:hideKeyPad()
			self.chatDelegate:openEmotionUI()
			self.isEmotionBtnShow = false
			self.btnKeypad:setVisible(true)
			self.buttonEmotion:setVisible(false)
		end
	end
end
function chatBottomView:OnBtnKeypadEvent(button, type)
	if type == ccui.TouchEventType.ended then
		print("点击键盘按钮")
		SoraDPlaySound()
		local isCanChat = chatCtrl:canChat()
		if not isCanChat then
			SoraDShowMsgTip(i18n("commom_text_4306"))
			return
		end
		if self.chatDelegate then
			_ENV = i18n("commom_text_4306")
			i18n("commom_text_4306").delay = 0.3
			i18n("commom_text_4306").onComplete = function()
				self:showKeyPad()
			end
			transition.execute(self.textField, nil, i18n("commom_text_4306"))
			self.chatDelegate:hideEmotionUI()
			self.isEmotionBtnShow = true
			self.btnKeypad:setVisible(false)
			self.buttonEmotion:setVisible(true)
		end
	end
end
function chatBottomView:switchBtn(bool)
	self.btnKeypad:setVisible(bool)
	self.buttonEmotion:setVisible(not bool)
end
function chatBottomView:showKeyPad(...)
	self.textField:touchDownAction(self.textField, ccui.TouchEventType.ended)
	if self.chatDelegate then
		self.chatDelegate:showKeyboardMask()
	end
	self:fitUnityEditBox(true)
end
function chatBottomView:hideKeyPad(...)
	self.textField:closeKeyboard()
	if self.chatDelegate then
		_UPVALUE0_ = nil
		self.chatDelegate:hideKeyboardMask(nil, nil)
	end
	self:fitUnityEditBox(false)
end
function chatBottomView:fitUnityEditBox(isKeyBoardShow)
	print("chatBottomView:fitUnityEditBox")
	local inputTypeIndex = SoraDConfigGet("System:GameOptionsView:inputBox~integer") or 2
	if inputTypeIndex == 2 then
		return
	end
	local devicePerformanceUtil = require("app.devicePerformanceUtil")
	if G_IS_UNITY and (device.platform == "ios" or device.platform == "android") and not devicePerformanceUtil.isGooglePlayGamePC() then
		if self.nodeBg then
			self.nodeBg:setVisible(not isKeyBoardShow)
		end
		self.textBg:setOpacity(not isKeyBoardShow and 255 or 0)
		self.textField.__title:setOpacity(not isKeyBoardShow and 255 or 0)
	end
end
function chatBottomView:startTimer()
	print("----------startTimer()-----")
	self:stopTimer()
	self.timerKey = SoraDCreateTimerEx(self, handler(self, self.updateTime), 0.05)
end
function chatBottomView:stopTimer()
	if self.timerKey then
		SoraDManagerRemoveTimer(self, self.timerKey)
		self.timerKey = nil
	end
end
function chatBottomView:updateTime()
	if tolua.isnull(self) or tolua.isnull(self.textField) then
		SoraDManagerRemoveTimerByTarget(self)
		return
	end
	local newStr = self.textField:getString()
	if self.isChangeDirty == false and self.oldStr == newStr then
		return
	elseif self.isChangeDirty == true then
		self.isChangeDirty = false
	end
	self.oldStr = newStr
	self:updateBtnSend()
end
function chatBottomView:onExitOther()
	local audioTips = display.getRunningScene():getChildByName("chatAudioTip")
	if audioTips then
		audioTips:removeFromParent()
	end
	chatAudioMgr:setIsCapture(false)
	userSDKManager.cancelCapture()
	chatAudioMgr:resumeMusic()
	if self.audioTimeHandler then
		SoraDManagerRemoveTimer(self, self.audioTimeHandler)
		self.audioTimeHandler = nil
	end
	local curTarget, nextTarget = chatAudioMgr:popAudioTarget()
	self:stopTimer()
	self:closeIME()
end
function chatBottomView:onCleanup()
	SoraDManagerRemoveTimerByTarget(self)
end
function chatBottomView:btnFriendClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			uiManager:show("friendView")
		else
			_ENV = nil
			;(nil).build = i18n("buildDes_name_101")
			;(nil).lv = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("overview_text_01", nil))
		end
	end
end
function chatBottomView:btnGroupClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
			local chatRoomSelPlayers = SoraDCreatePanel("chatRoomSelPlayers")
			chatRoomSelPlayers:show()
			local selfId = chatFunctions:getSelfId()
			_ENV = chatFunctions
			chatFunctions, chatFunctions.selPlayerOpType = chatConst.selPlayerOpType.selPlayerCreateChatRoom, chatConst.selPlayerOpType.selPlayerCreateChatRoom
			chatFunctions.members, chatConst.selPlayerOpType.selPlayerCreateChatRoom[1] = chatConst.selPlayerOpType.selPlayerCreateChatRoom, selfId
			local chatFunctions.owner, data = selfId, chatFunctions
			chatRoomSelPlayers:initWithData(data)
		else
			_ENV = chatFunctions:getSelfId()
			chatFunctions:getSelfId().msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
			chatFunctions:getSelfId().info = "From MAIL"
			SoraDSendMessage((chatFunctions:getSelfId()))
		end
	end
end
function chatBottomView:onBtnKNotice(target, eventType)
	SoraDPlaySound()
	print("onBtnKNotice", eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		local curChannel = chatDataMgr:getChatChannel()
		if curChannel == gChatChannel.CAMP then
		end
		self:changeKNotice(true)
		self:setMaxCharCount(gChatMaxLength.kongdomNoticeChatLength)
		self:setChatInputType(chatConst.ChatInputType.Input_Text_Horn)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		self:changeKNotice(false)
		self:setMaxCharCount(gChatMaxLength.normalChatLength)
		self:setChatInputType(chatConst.ChatInputType.Input_Text_Emo_Horn)
	end
end
function chatBottomView:onBtnQuickSend(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.chatDelegate then
			self.chatDelegate:toogleSelectBottomUI()
		end
		self:hideKeyPad()
	end
end
function chatBottomView:updateTheme()
	local btnImg = gCurrentChatTheme == gChatTheme.normal and "btn_yejianmoshiqihuan_01.png" or "btn_yejianmoshiqihuan_02.png"
	print("chatBottomView: btnImg = ", btnImg)
	self.btnTheme:loadTextures(btnImg, btnImg, btnImg, ccui.TextureResType.plistType)
end
function chatBottomView:onBtnTheme(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		print("-----点击了切换夜景")
		if gCurrentChatTheme == gChatTheme.normal then
			chatThemeMgr:changeToChatTheme(gChatTheme.dark)
		else
			chatThemeMgr:changeToChatTheme(gChatTheme.normal)
		end
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	end
end
function chatBottomView:changeKNotice(isKNotice)
	if isKNotice == true then
		self.isKNotice = true
	else
		self.isKNotice = false
	end
end
function chatBottomView:getItemCount()
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemId = _defaultParam.noticeItemId
	local itemCount = backpackCtrl:getItemCount(itemId)
	return itemCount
end
function chatBottomView:getItemName()
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemId = _defaultParam.noticeItemId
	local itemDesRead = include("itemDesRead")
	local itemName = itemDesRead.getName(itemId)
	return itemName
end
function chatBottomView:getItemPrice()
	local shopItemID = IsArClient and 1000059 or 1000151
	local needGod = gModuleMgr.sharedMgr("shopltCtrl"):getPrice(shopItemID)
	return needGod
end
function chatBottomView:confirmUseItemCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		if tolua.isnull(self.textField) then
			return
		end
		local textContent = self.textField:getString()
		if textContent and string.len(textContent) > 0 then
			if string.len(textContent) > gChatMaxLength.kongdomNoticeChatLength then
				textContent = SubStringUTF8(textContent, 1, gChatMaxLength.kongdomNoticeChatLength)
			end
			chatCtrl:sendServiceMessageByProp(textContent)
		end
		self.textField:setText("")
	end
end
function chatBottomView:useGoldCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		local textContent = self.textField:getString()
		if textContent and string.len(textContent) > 0 then
			if string.len(textContent) > gChatMaxLength.kongdomNoticeChatLength then
				textContent = SubStringUTF8(textContent, 1, gChatMaxLength.kongdomNoticeChatLength)
			end
			chatCtrl:sendServiceMessageByGold(textContent)
		end
		self.textField:setText("")
	end
end
function chatBottomView:sendCampHornMessage()
end
function chatBottomView:sMsgSendOneMessageBack(target, data)
	local chatMsgContent = data.content
	if chatMsgContent.data.consumeType == gChatTypeDef.chat_send_message_prop then
	elseif chatMsgContent.chatType == gChatTypeDef.chat_send_message_gold then
	end
end
function chatBottomView:getBottomViewHeight()
	local height = self.textBg:getContentSize().height
	if self.quoteBar and self.quoteBar:isVisible() then
		height = height + self.quoteBarHeight
	end
	return height
end
function chatBottomView:closeIME()
	self:hideKeyPad()
end
function chatBottomView:msgCloseIME(target, data)
	local viewType = data.viewType
	if viewType == nil then
		return
	end
	if viewType ~= self.viewType then
		print("检测到不相等的类型: ", self.viewType, "目标" .. viewType)
		return
	end
	print("调用close IME, 类型" .. self.viewType)
	self:closeIME()
end
function chatBottomView:setViewType(viewType, isPersonal)
	self.viewType = viewType
	if self.viewType == "chatView" then
		self.isCanChat = chatCtrl:canChat()
		if not self.isCanChat and isPersonal then
			self.textField:setPlaceHolder(i18n("common_text_1039"))
		else
			self.textField:setPlaceHolder(i18n("common_text_072"))
		end
	end
end
function chatBottomView:getViewType()
	return self.viewType
end
function chatBottomView:setMaxCharCount(maxCharCount)
	if self.textField then
		self.maxCharCount = maxCharCount
		self.textField:setMaxLength(self.maxCharCount)
		local charCount = self.textField:getCharCount()
		local strCount = string.format("%d/%d", charCount, self.maxCharCount)
		self.text_char_count:setString(strCount)
	end
end
function chatBottomView:getLTrimTextCount()
	local strText = self.textField:getString()
	strText = string.ltrim(strText)
	if strText == nil then
		strText = ""
	end
	return string.utf8len(strText)
end
function chatBottomView:updateBtnSend()
	local charCount = self.textField:getCharCount()
	if charCount == 0 then
		self.buttonSend:setEnabled(false)
		self.buttonSend:setBright(false)
		if self.chatInputType == chatConst.ChatInputType.Input_Text_Emo_Audio or self.chatInputType == chatConst.ChatInputType.Input_Text_Emo_Audio_Horn then
			self.buttonSend:setVisible(false)
			self.btnAudio:setVisible(true)
		end
	else
		if self.chatInputType == chatConst.ChatInputType.Input_Text_Emo_Audio or self.chatInputType == chatConst.ChatInputType.Input_Text_Emo_Audio_Horn then
			self.buttonSend:setVisible(true)
			self.btnAudio:setVisible(false)
		end
		if 0 < self:getLTrimTextCount() then
			print("启用-----")
			self.buttonSend:setEnabled(true)
			self.buttonSend:setBright(true)
		else
			self.buttonSend:setEnabled(false)
			self.buttonSend:setBright(false)
		end
	end
end
function chatBottomView:setTargetType(targetType)
	self.targetType = targetType
end
function chatBottomView:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	local strFmt
	if strEventName == "began" then
		strFmt = string.format("editBox   DidBegin !", edit)
		print(strFmt)
		if self.btnKeypad:isVisible() then
			self.btnKeypad:setVisible(false)
			self.buttonEmotion:setVisible(true)
			self.isEmotionBtnShow = true
		end
		if self.chatDelegate then
			self.chatDelegate:showKeyboardMask()
		end
		self:fitUnityEditBox(true)
	elseif strEventName == "ended" then
		strFmt = string.format("editBox   DidEnd !", edit)
		print(strFmt)
	elseif strEventName == "return" then
		strFmt = string.format("editBox   was returned !", edit)
		print(strFmt)
	elseif strEventName == "changed" then
		strFmt = string.format("editBox   TextChanged, text: %s  ", edit:getString())
		print(strFmt)
		self:checkOpenSelectView(edit)
	end
end
function chatBottomView:checkOpenSelectView(editBox)
	local curChannel = chatDataMgr:getChatChannel()
	if not chatCtrl:checkUnreadAtSelfChannel(curChannel) then
		return
	end
	if not chatroomCtrl:checkChatRoomState(curChannel) then
		return
	end
	local editStr = editBox:getString()
	if string.sub(editStr, -1) == "@" then
		self:hideKeyPad()
		chatDataMgr = nil
		;(nil).chatChannel = curChannel
		;(nil).callback = function(param)
			dump(param, "==param==")
			local atName = ""
			if param.isAtAll then
				atName = i18n("alliance_office_title_04")
				self.isAtAll = true
			else
				atName = param.nickName
				if not self.atUserMap then
					_ENV = self.atUserMap
				end
				self.atUserMap = self.atUserMap
				self.atUserMap[tostring(param.uid)] = atName
			end
			editBox:setString(editStr .. atName .. " ")
		end
		uiManager:show("ChatAtSelect", nil)
	end
end
function chatBottomView:setAudioElementsVisible(visible)
	_UPVALUE1_ = nil
	;(nil)[1] = self.btnAudio
	SoraDSetNodeArrayVisible(nil, visible)
	_UPVALUE4_ = nil
	;(nil)[1] = self.img_red_point
	;(nil)[2] = self.text_record_time
	;(nil)[3] = self.img_arrow_record
	;(nil)[4] = self.text_op_tip
	SoraDSetNodeArrayVisible(nil, false)
end
function chatBottomView:showBtnKNotice(visible)
end
function chatBottomView:setChatInputType(chatInputType)
	if self.chatInputType == chatInputType then
		return
	end
	self.chatInputType = chatInputType
	local textBgSize = _defaultParam.inputBgCfg[chatInputType]
	self.textBg:setContentSize(cc.size(textBgSize.width, textBgSize.height))
	local textFieldSize = cc.size(textBgSize.width - _defaultParam.paddingEditbox.left - _defaultParam.paddingEditbox.right, textBgSize.height - _defaultParam.paddingEditbox.top - _defaultParam.paddingEditbox.bottom)
	self.textField:setContentSize(textFieldSize)
	self.textField:setPositionY(_defaultParam.paddingEditbox.bottom)
	self.textField:setPositionX(_defaultParam.paddingEditbox.left)
	local _defaultParam, tbShowNodes = self.textField.setPositionX, self.textField.setPositionX
	local _defaultParam, tbHideNodes = self.textField, self.textField
	local _defaultParam, tbPadding = _defaultParam.paddingEditbox.left, _defaultParam.paddingEditbox.left
	self.btnKeypad:setVisible(false)
	self.btn_quick_send:setVisible(false)
	if chatInputType == chatConst.ChatInputType.Input_Text then
		self:showBtnKNotice(false)
		self:setAudioElementsVisible(false)
		chatConst = self.setAudioElementsVisible
		_UPVALUE3_, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonSend
		_UPVALUE3_, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.buttonEmotion
		tbHideNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.btnAudio
		tbHideNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.btn_k_notice
		_ENV = self.btnAudio
		self.btnAudio[1] = _defaultParam.paddingBtnSend.right
		table.insertto(tbPadding, self.btnAudio)
	elseif chatInputType == chatConst.ChatInputType.Input_Text_Emo then
		self:showBtnKNotice(false)
		self:setAudioElementsVisible(false)
		_UPVALUE3_ = self.setAudioElementsVisible
		chatConst, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonSend
		chatConst, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonEmotion
		chatConst, tbShowNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.btnAudio
		tbHideNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.btn_k_notice
		chatConst = self.btn_k_notice
		self.btn_k_notice[1] = _defaultParam.paddingBtnSend.right
		self.btn_k_notice[2] = _defaultParam.paddingBtnEmoticon.right
		table.insertto(tbPadding, self.btn_k_notice)
	elseif chatInputType == chatConst.ChatInputType.Input_Text_Emo_Horn then
		self:showBtnKNotice(false)
		self:setAudioElementsVisible(false)
		_UPVALUE4_ = self.setAudioElementsVisible
		chatConst, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonSend
		chatConst, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonEmotion
		chatConst, tbShowNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		chatConst, tbShowNodes, self.setAudioElementsVisible[4] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.btn_k_notice
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.btnAudio
		tbHideNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.btnKeyPad
		print("self.btnAudio =", self.btnAudio, ", self.btnKeypad = ", self.btnKeypad)
		_UPVALUE3_ = self.btnAudio
		self.btnAudio[1] = _defaultParam.paddingBtnSend.right
		self.btnAudio[2] = _defaultParam.paddingBtnEmoticon.right
		self.btnAudio[3] = _defaultParam.paddingInput.right
		table.insertto(tbPadding, self.btnAudio)
		print("这-----------------------里1111")
	elseif chatInputType == chatConst.ChatInputType.Input_Text_Emo_Audio then
		print("这里是联盟聊天频道")
		self:showBtnKNotice(false)
		self:changeKNotice(false)
		self:setAudioElementsVisible(true)
		_UPVALUE3_ = self.setAudioElementsVisible
		chatConst, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.btnAudio
		chatConst, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonEmotion
		chatConst, tbShowNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.buttonSend
		tbHideNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.btn_k_notice
		chatConst = self.btn_k_notice
		self.btn_k_notice[1] = _defaultParam.paddingBtnAudio.right
		self.btn_k_notice[2] = _defaultParam.paddingBtnEmoticon.right
		table.insertto(tbPadding, self.btn_k_notice)
	elseif chatInputType == chatConst.ChatInputType.Input_Text_Emo_Quick then
		print("这里是魔鬼域联盟聊天频道")
		self:showBtnKNotice(false)
		self:changeKNotice(false)
		self:setAudioElementsVisible(false)
		_UPVALUE4_ = self.setAudioElementsVisible
		chatConst, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonSend
		chatConst, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonEmotion
		chatConst, tbShowNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		chatConst, tbShowNodes, self.setAudioElementsVisible[4] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.btn_quick_send
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.btn_k_notice
		tbHideNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.btnAudio
		_UPVALUE3_ = self.btnAudio
		self.btnAudio[1] = _defaultParam.paddingBtnAudio.right
		self.btnAudio[2] = _defaultParam.paddingBtnEmoticon.right
		self.btnAudio[3] = _defaultParam.paddingInput.right
		table.insertto(tbPadding, self.btnAudio)
	elseif chatInputType == chatConst.ChatInputType.Input_Text_Audio then
		self:showBtnKNotice(false)
		self:changeKNotice(false)
		self:setAudioElementsVisible(true)
		chatConst = self.setAudioElementsVisible
		_ENV, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.btnAudio
		_ENV, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.buttonSend
		_UPVALUE3_ = self.textBg
		self.textBg[1] = _defaultParam.paddingBtnAudio.right
		self.textBg[2] = _defaultParam.paddingBtnEmoticon.right
		self.textBg[3] = _defaultParam.paddingInput.right
		table.insertto(tbPadding, self.textBg)
	elseif chatInputType == chatConst.ChatInputType.Input_Text_Horn then
		self:showBtnKNotice(true)
		self:setAudioElementsVisible(false)
		_UPVALUE3_ = self.setAudioElementsVisible
		_UPVALUE3_, tbShowNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.buttonSend
		_UPVALUE3_, tbShowNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.textBg
		_UPVALUE3_, tbShowNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.setAudioElementsVisible, self.btn_k_notice
		tbHideNodes, self.setAudioElementsVisible[1] = self.setAudioElementsVisible, self.btnAudio
		tbHideNodes, self.setAudioElementsVisible[2] = self.setAudioElementsVisible, self.buttonEmotion
		tbHideNodes, self.setAudioElementsVisible[3] = self.setAudioElementsVisible, self.btnKeyPad
		print("self.btnAudio =", self.btnAudio, ", self.btnKeypad = ", self.btnKeypad)
		chatConst = self.btnAudio
		self.btnAudio[1] = _defaultParam.paddingBtnSend.right
		self.btnAudio[2] = _defaultParam.paddingInput.right
		table.insertto(tbPadding, self.btnAudio)
		print("这-----------------------里1111")
	end
	SoraDSetNodeArrayVisible(tbShowNodes, true)
	SoraDSetNodeArrayVisible(tbHideNodes, false)
	if tbShowNodes[1] then
		tbShowNodes[1]:setPositionX(SoraDFPosX(38, 640))
		SoraDAlignNodeArray(tbShowNodes, not SoraDFIsRA(), tbPadding)
	end
	self.isChangeDirty = true
	self:updateTime()
	self:setAudioTimeVisible(false)
end
function chatBottomView:checkForbidChat(chatChannel)
	_ENV = nil
	;(nil)[gChatChannel.KINGDOM] = true
	;(nil)[gChatChannel.TEAM] = true
	;(nil)[gChatChannel.ALLIANCE] = true
	;(nil)[gChatChannel.CAMP] = true
	local (nil)[gChatChannel.VIEWER], config = true, nil
	return config[chatChannel]
end
function chatBottomView:onBtnAudio(target, event)
	print("onBtnAudio", event)
	if event == ccui.TouchEventType.began then
		self.audioTime = 0
		self.isForbidAudio = false
		self.needResetMask = false
		local curChannel = chatDataMgr:getChatChannel()
		if self:checkForbidChat(curChannel) and false == chatCtrl:canChat() then
			SoraDShowMsgTip(i18n("common_text_1039"), "#icon_mail_lock.png")
			self.isForbidAudio = true
			return
		end
		if curChannel == gChatChannel.ALLIANCE then
			local kingdomSettingAPI = include("kingdomSettingAPI")
			local canChat, lv = kingdomSettingAPI:canChatInAlliance()
			if not canChat then
				_ENV = nil
				;(nil).lv = lv
				SoraDShowMsgTip(i18n("common_text_3667", nil))
				self.isForbidAudio = true
				return
			end
			local allianceMsg = gametop.playertop_:getModule("allianceMsg")
			local playerId = chatFunctions:getSelfId()
			local isForbid = allianceMsg:isLordInShieldList(playerId)
			if true == isForbid then
				SoraDShowMsgTip(i18n("common_text_2766"), "#icon_mail_lock.png")
				self.isForbidAudio = true
				return
			end
		elseif curChannel == gChatChannel.MAIL then
			local kingdomSettingAPI = include("kingdomSettingAPI")
			local canChat, lv = kingdomSettingAPI:canSendChatMail()
			print(" canChat, lv", canChat, lv)
			if not canChat then
				_ENV = lv
				lv.lv = lv
				SoraDShowMsgTip(i18n("common_text_3668", lv))
				self.isForbidAudio = true
				return
			end
		end
		if curChannel == gChatChannel.CHATROOM then
			local kingdomSettingAPI = include("kingdomSettingAPI")
			local canChat, lv = kingdomSettingAPI:canSendChatMail()
			print(" canChat, lv", canChat, lv)
			if not canChat then
				_ENV = lv
				lv.lv = lv
				SoraDShowMsgTip(i18n("common_text_3668", lv))
				self.isForbidAudio = true
				return
			end
			local curChatChannelInfo = chatDataMgr:getChatChannelInfo()
			local crid = curChatChannelInfo.target
			local chatRoom = chatroomCtrl.chatroomMgr:getChatRoom(crid)
			if chatRoom and chatRoom.state == gChatRoomState.KICKED then
				SoraDShowMsgTip(i18n("common_text_2213"))
				self.isForbidAudio = true
				return
			end
		end
		if not chatAudioMgr:hasAudioPermission(true) then
			return
		end
		if self.chatDelegate then
			self.chatDelegate:setCapturing(true)
		end
		self.isCancelAudio = false
		self.isAudioForceStopped = false
		chatAudioMgr:resetCurrentAudioLen()
		self.audioTime = 0
		chatAudioMgr:setIsCapture(true)
		self.audioTips = include("chatAudioTip").new()
		self.audioTips:show()
		self.audioTips:initData(1, self)
		self:updateAudioTimeStr()
		self:runActionAudioBegin()
		local touchBeganPoint = target:getTouchBeganPosition()
		self.touchBeganPoint = touchBeganPoint
	elseif event == ccui.TouchEventType.ended then
		if self.chatDelegate ~= nil then
			self.chatDelegate:setCapturing(false)
		end
		if self.isForbidAudio == true then
			return
		end
		print("--------ccui.TouchEventType.ended")
		if self.isAudioForceStopped == true then
			print("录制时间超过了59s ，已经自动停止了------")
			return
		end
		self:runActionAudioReset()
		if self.isCancelAudio then
			print("---------------取消录音了----------------------")
			return
		end
		chatAudioMgr:setIsCapture(false)
		if self.audioTime < 1 then
			userSDKManager.cancelCapture()
			if not self.audioTips then
				self.audioTips = include("chatAudioTip").new()
			end
			self.audioTips:initData(2, self)
			chatAudioMgr:resumeMusic()
			return
		end
		chatAudioMgr:setCurrentAudioLen(self.audioTime)
		if device.platform ~= "ios" and device.platform ~= "android" then
			local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
			self:simulateSendAudioOnMac()
			chatAudioMgr:resumeMusic()
			return
		end
		userSDKManager.stopCapture()
		chatAudioMgr:resumeMusic()
	elseif event == ccui.TouchEventType.moved then
		if self.isForbidAudio == true then
			return
		end
		if self.isCancelAudio then
			return
		end
		if not self.touchBeganPoint then
			return
		end
		local touchMovePoint = target:getTouchMovePosition()
		self.touchMovePoint = touchMovePoint
		local deltaX = self.touchMovePoint.y - self.touchBeganPoint.y
		print("onBtnAudio-deltaX", deltaX)
		if deltaX > self.cancelAudioDist then
			self.isCancelAudio = true
			chatAudioMgr:setIsCapture(false)
			userSDKManager.cancelCapture()
			self:runActionAudioReset()
			chatAudioMgr:resumeMusic()
		elseif 0 < deltaX and deltaX <= self.deltaArrowRedPoint then
			self.img_arrow_record:setPositionX(self.targetPos_img_arrow_record.x + deltaX)
			self.text_op_tip:setPositionX(self.targetPos_text_op_tip.x + deltaX)
		elseif deltaX > self.deltaArrowRedPoint and deltaX <= self.cancelAudioDist then
			self.img_arrow_record:setPositionX(self.targetPos_img_arrow_record.x + deltaX)
			self.text_op_tip:setPositionX(self.targetPos_text_op_tip.x + deltaX)
			self.img_red_point:setPositionX(self.targetPos_img_red_point.x + (deltaX - self.deltaArrowRedPoint))
			self.text_record_time:setPositionX(self.targetPos_text_record_time.x + (deltaX - self.deltaArrowRedPoint))
		end
	elseif event == ccui.TouchEventType.canceled then
		if self.chatDelegate then
			self.chatDelegate:setCapturing(false)
		end
		if self.isForbidAudio == true then
			return
		end
		print("----------ccui.TouchEventType.canceled---------------")
		if self.isAudioForceStopped == true then
			print("录制时间超过了59s ，已经自动停止了------")
			return
		end
		if self.isCancelAudio then
			self.buttonEmotion:setVisible(true)
			print("---------------取消录音了----------------------")
			return
		end
		chatAudioMgr:setIsCapture(false)
		self:runActionAudioReset()
		if self.audioTime < 1 then
			userSDKManager.cancelCapture()
			if not self.audioTips then
				self.audioTips = include("chatAudioTip").new()
			end
			self.audioTips:initData(2, self)
			chatAudioMgr:resumeMusic()
			return
		end
		chatAudioMgr:setCurrentAudioLen(self.audioTime)
		if device.platform ~= "ios" and device.platform ~= "android" then
			local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
			self:simulateSendAudioOnMac()
			chatAudioMgr:resumeMusic()
			return
		end
		userSDKManager.stopCapture()
		chatAudioMgr:resumeMusic()
	end
end
function chatBottomView:forceStopCatpureAudio()
	self.isAudioForceStopped = true
	self:runActionAudioReset()
	if self.audioTips then
		self.audioTips:initData(3, self)
	end
	chatAudioMgr:setIsCapture(false)
	if device.platform ~= "ios" and device.platform ~= "android" then
		local iconSprite = display.newSprite("#icon_liaotian_yuyin.png")
		self:simulateSendAudioOnMac()
		return
	end
	chatAudioMgr:setCurrentAudioLen(self.audioTime)
	userSDKManager.stopCapture()
	chatAudioMgr:resumeMusic()
end
function chatBottomView:simulateSendAudioOnMac()
	local curChannel = chatDataMgr:getChatChannel()
	if curChannel == gChatChannel.ALLIANCE then
		local rank
		if not worldMapDefine.isInTeamStatus() then
			local memberMgr = gametop.playertop_:getModule("memberMgr")
			local member = memberMgr:getOwnMember()
			rank = member:getProperty("rank")
		end
		chatDataMgr = memberMgr
		gametop.playertop_:getModule("memberMgr").audioId = tostring(os.time())
		local gametop.playertop_:getModule("memberMgr").audioLen, message = self.audioTime, gametop.playertop_:getModule("memberMgr")
		local messageType = gChatTypeDef.chat_content_audio
		local newChatIndex = chatSendMgr:getNewChatIndex()
		local chatChannel = curChannel
		local chatSet = gChatSet.TOTAL
		chatDataMgr = os.time()
		os.time().chatChannel = chatChannel
		os.time().chatSet = chatSet
		os.time().messageType = messageType
		os.time().message = message
		os.time().chatIndex = newChatIndex
		local os.time().alv, param = rank, os.time()
		local sendingMessage = chatSendMgr:createSendingMessage(param)
		_ENV, sendingMessage.netStatus = gChatNetStatus.sending, gChatNetStatus.sending
		local gChatNetStatus.sending[1], dataArray = sendingMessage, gChatNetStatus.sending
		chatDataMgr = os.time()
		os.time().data = dataArray
		os.time().isHistory = false
		os.time().chatChannel = chatChannel
		os.time().chatSet = chatSet
		os.time().isWrapped = true
		os.time().isNeedScroll = true
		chatDataMgr:addChatData(os.time())
		chatSendMgr:sendMsgTimeOutManage(newChatIndex, curChannel)
		message = chatAudioMgr:wrapSendAudioContent(message.audioId, message.audioLen, newChatIndex)
		chatCtrl:sendAllianceMessage(message, messageType)
	elseif curChannel == gChatChannel.MAIL then
		local curChatChannelInfo = chatDataMgr:getChatChannelInfo()
		local key = curChatChannelInfo.key
		local target = curChatChannelInfo.target
		local isKing = chatFunctions:getIsSelfKing()
		local isLegendKing = chatFunctions:getIsSelfLegendKing()
		local isKingStar = chatFunctions:getIsSelfKingStar()
		local isHegemon = chatFunctions:getIsSelfHegemon()
		local newChatIndex = chatSendMgr:getNewChatIndex()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		local rank
		local messageType = gChatTypeDef.chat_content_audio
		chatDataMgr = messageType
		messageType.audioId = tostring(os.time())
		local messageType.audioLen, message = self.audioTime, messageType
		local chatChannel = curChannel
		local chatSet = gChatSet.TOTAL
		chatDataMgr = os.time()
		os.time().chatChannel = chatChannel
		os.time().chatSet = chatSet
		os.time().key = key
		os.time().messageType = messageType
		os.time().message = message
		os.time().chatIndex = newChatIndex
		local os.time().alv, param = rank, os.time()
		local sendingMessage = chatSendMgr:createSendingMessage(param)
		chatDataMgr, sendingMessage.netStatus = gChatNetStatus.sending, gChatNetStatus.sending
		_ENV, sendingMessage.otherData, gChatNetStatus.sending.target = gChatNetStatus.sending, gChatNetStatus.sending, target
		local gChatNetStatus.sending[1], dataArray = sendingMessage, gChatNetStatus.sending
		chatDataMgr = os.time()
		os.time().data = dataArray
		os.time().isHistory = false
		os.time().chatChannel = gChatChannel.MAIL
		os.time().chatSet = gChatSet.TOTAL
		os.time().isWrapped = true
		os.time().key = key
		os.time().isNeedScroll = true
		chatDataMgr:addChatData(os.time())
		local dressCtrl = gametop.playertop_:getModule("dressCtrl")
		local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		chatSendMgr:sendMsgTimeOutManage(newChatIndex, curChannel, chatSet, key)
		chatDataMgr = chatSendMgr.sendMsgTimeOutManage
		chatSendMgr.sendMsgTimeOutManage.contentType = gChatMailContentType.content_audio
		chatSendMgr.sendMsgTimeOutManage.content = tostring(message.audioLen) .. "''"
		chatSendMgr.sendMsgTimeOutManage.audioLen = message.audioLen
		chatSendMgr.sendMsgTimeOutManage.audioId = message.audioId
		chatSendMgr.sendMsgTimeOutManage.isRead = false
		chatSendMgr.sendMsgTimeOutManage.isSendToAll = false
		chatSendMgr.sendMsgTimeOutManage.isKing = isKing
		chatSendMgr.sendMsgTimeOutManage.isLegendKing = isLegendKing
		chatSendMgr.sendMsgTimeOutManage.isLegendForSepKing = isKingStar
		chatSendMgr.sendMsgTimeOutManage.isHegemon = isHegemon
		chatSendMgr.sendMsgTimeOutManage.chatIndex = newChatIndex
		chatSendMgr.sendMsgTimeOutManage.bubbleId = bubbleId
		chatSendMgr.sendMsgTimeOutManage.headWearId = headWearId
		local chatSendMgr.sendMsgTimeOutManage.avatarFrameId, content = avatarFrameId, chatSendMgr.sendMsgTimeOutManage
		local mailCtrl = gametop.playertop_:getModule("mailCtrl")
		mailCtrl:sendChatMail(target, content)
	elseif curChannel == gChatChannel.CHATROOM then
		local curChatChannelInfo = chatDataMgr:getChatChannelInfo()
		local crid = curChatChannelInfo.target
		local key = curChatChannelInfo.key
		local isKing = chatFunctions:getIsSelfKing()
		local isLegendKing = chatFunctions:getIsSelfLegendKing()
		local isKingStar = chatFunctions:getIsSelfKingStar()
		local isHegemon = chatFunctions:getIsSelfHegemon()
		local newChatIndex = chatSendMgr:getNewChatIndex()
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local member = memberMgr:getOwnMember()
		local rank
		local messageType = gChatTypeDef.chat_content_audio
		chatDataMgr = messageType
		messageType.audioId = tostring(os.time())
		local messageType.audioLen, message = self.audioTime, messageType
		local chatChannel = curChannel
		local chatSet = gChatSet.TOTAL
		chatDataMgr = os.time()
		os.time().chatChannel = chatChannel
		os.time().chatSet = chatSet
		os.time().messageType = messageType
		os.time().message = message
		os.time().chatIndex = newChatIndex
		local os.time().alv, param = rank, os.time()
		local sendingMessage = chatSendMgr:createSendingMessage(param)
		chatDataMgr, sendingMessage.netStatus = gChatNetStatus.sending, gChatNetStatus.sending
		_ENV, sendingMessage.otherData, gChatNetStatus.sending.crid = gChatNetStatus.sending, gChatNetStatus.sending, crid
		local gChatNetStatus.sending[1], dataArray = sendingMessage, gChatNetStatus.sending
		print("进行消息添加-------------")
		chatDataMgr = os.time()
		os.time().data = dataArray
		os.time().isHistory = false
		os.time().chatChannel = gChatChannel.CHATROOM
		os.time().chatSet = gChatSet.TOTAL
		os.time().key = key
		os.time().isWrapped = true
		os.time().isNeedScroll = true
		chatDataMgr:addChatData(os.time())
		chatSendMgr:sendMsgTimeOutManage(newChatIndex, curChannel, chatSet, key)
		local dressCtrl = gametop.playertop_:getModule("dressCtrl")
		local bubbleId = dressCtrl:getCurDressID(gDressType.CHAT_TEXT_FRAME)
		local avatarFrameId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_FRAME)
		local headWearId = dressCtrl:getCurDressID(gDressType.CHAT_AVATAR_CROWN)
		chatDataMgr = dressCtrl
		chatDataMgr, dressCtrl.chatType = gChatRoomChatType.VOICE, gChatRoomChatType.VOICE
		gChatRoomChatType.VOICE.audioLen = message.audioLen
		gChatRoomChatType.VOICE.audioId = message.audioId
		dressCtrl.content, gChatRoomChatType.VOICE.chatIndex = gChatRoomChatType.VOICE, newChatIndex
		dressCtrl.isKing = isKing
		dressCtrl.isLegendKing = isLegendKing
		dressCtrl.isLegendForSepKing = isKingStar
		dressCtrl.isHegemon = isHegemon
		dressCtrl.bubbleId = bubbleId
		dressCtrl.headWearId = headWearId
		local dressCtrl.avatarFrameId, msgData = avatarFrameId, dressCtrl
		chatroomCtrl:reqChatRoomSendMsg(crid, msgData)
	end
	return
end
function chatBottomView:runActionAudioReset()
	self:stopAudioTimer()
	if tolua.isnull(self) then
		return
	end
	if self.audioTips and not tolua.isnull(self.audioTips) then
		self.audioTips:setVisible(false)
	else
		self.audioTips = nil
	end
	local dtMove = 0.15
	do
		local dtDelay = 0.0
		if not self.btnAudio or tolua.isnull(self.btnAudio) then
			return
		end
		self.btnAudio:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.15)
		;(nil)[2] = cca.callFunc(function()
			print("设置隐藏语音控件回调")
			if tolua.isnull(self) then
				return
			end
			self:setAudioTimeVisible(false)
		end)
		;(nil)[3] = cca.callFunc(function()
			print("设置隐藏语音控件回调")
			if tolua.isnull(self) then
				return
			end
			self:setAudioTimeVisible(false)
		end)
		self.btnAudio:runAction(cca.seq(nil))
	end
end
function chatBottomView:runActionAudioBegin()
	local dtMove = 0.15
	print("显示语音控件")
	self:setAudioTimeVisible(true)
	do
		local dtDelay = 0.3
		local beginCapture = function()
			print("----------------------停止播放当前语音---------------------------------------")
			chatAudioMgr:stopCurPlayAudio()
			print("----------------------启动录音----------------------------------------------")
			chatAudioMgr:pauseMusic()
			self:beginAudioTimer()
			print("----------------------启动录音---------------------------- capture--- begin-----------------")
			userSDKManager.capture()
			print("----------------------启动录音---------------------------- capture---- end  ----------------")
		end
		self.btnAudio:stopAllActions()
		chatAudioMgr = nil
		;(nil)[1] = cca.delay(0.01)
		;(nil)[2] = cca.callFunc(beginCapture)
		;(nil)[3] = cca.callFunc(beginCapture)
		self.btnAudio:runAction(cca.seq(nil))
	end
end
function chatBottomView:beginAudioTimer()
	print("开始计时器---------------------chatBottomView:beginAudioTimer()")
	self.audioTime = 0
	self:updateAudioTimeStr()
	if self.audioTimeHandler then
		SoraDManagerRemoveTimer(self, self.audioTimeHandler)
		self.audioTimeHandler = nil
	end
	self.audioTimeHandler = SoradCreateTimer(self, handler(self, self.updateAudioTime))
end
function chatBottomView:stopAudioTimer()
	if self.audioTimeHandler then
		SoraDManagerRemoveTimer(self, self.audioTimeHandler)
	end
end
function chatBottomView:updateAudioTime()
	self.audioTime = self.audioTime + 1
	if self.audioTips then
		self.audioTips:updateAudioTime(self.audioTime)
	end
	print("update ----------------", self.audioTime)
	if self.audioTime >= 59 then
		self.audioTime = 59
		self:updateAudioTimeStr()
		self:forceStopCatpureAudio()
		return
	end
	self:updateAudioTimeStr()
end
function chatBottomView:updateAudioTimeStr()
	if self.audioTime == nil then
		self.audioTime = 0
	end
	local timeStr = self:convertSecondToString(self.audioTime)
	if self.audioTips then
		self.audioTips:setTimeStr(timeStr)
	end
end
function chatBottomView:convertSecondToString(second)
	if second < 0 then
		second = 0
	end
	local mNum = math.floor(second % 3600 / 60)
	if mNum < 10 then
		mNum = "0" .. mNum
	end
	local sNum = math.floor(second % 60)
	if sNum < 10 then
		sNum = "0" .. sNum
	end
	local text = mNum .. ":" .. sNum
	return text
end
function chatBottomView:msgThemeChanged(target, data)
	self:updateTheme()
end
function chatBottomView:setAudioTimeVisible(isVisible)
	if self.img_red_point and not tolua.isnull(self.img_red_point) then
		self.img_red_point:setVisible(isVisible)
	end
	if self.text_record_time and not tolua.isnull(self.text_record_time) then
		self.text_record_time:setVisible(isVisible)
	end
end
function chatBottomView:checkNonePersonlHide(isHide)
	SoraDGetChildByName(self, "Panel_Personal"):setVisible(isHide)
end
return chatBottomView

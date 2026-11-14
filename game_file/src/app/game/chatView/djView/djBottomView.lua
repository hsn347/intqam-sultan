local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local djCtrl = gametop.playertop_:getModule("djCtrl")
local chatConst = include("chatConst")
local chatFunctions = include("chatFunctions")
local itemDesRead = include("itemDesRead")
local chatroomCtrl = gametop.playertop_:getModule("chatroomCtrl")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatThemeMgr = gChatMgrs:getMgr("chatThemeMgr")
local DjBottomView = class("djBottomView", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
_ENV = "djBottomView"
;("djBottomView").noticeItemId = 502001
;("djBottomView").notceShopItemId = 1000059
;("djBottomView").inputHeight = 64
_ENV, ("djBottomView").editboxHeight = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
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
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).top = 12
_ENV, ("djBottomView").paddingEditbox, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).bottom = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 12
_ENV = nil
;(nil).width = 560
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text], (nil).height = nil, 64
_ENV = nil
;(nil).width = 504
;(function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
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
		return view.new("djBottomView")
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
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Horn], (nil).height = nil, 64
_ENV = nil
;(nil).width = 424
_ENV, ("djBottomView").inputBgCfg, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)[chatConst.ChatInputType.Input_Text_Emo_Audio_Horn], (nil).height = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).normal = "frame_LT_shurukuang01.png"
_ENV, ("djBottomView").inputBgImage, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).notice = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 8
_ENV, ("djBottomView").paddingBtnSend, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 8
_ENV, ("djBottomView").paddingBtnAudio, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 6
_ENV, ("djBottomView").paddingInput, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
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
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).left = 4
;("djBottomView").paddingBtnEmoticon, (function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end).right = function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new("djBottomView")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end, 4
local ("djBottomView").inputFontSize, _defaultParam = 24, "djBottomView"
function DjBottomView:ctor()
	self.showType = gChatDJShowType.CHAT_VIEW
	self.maxCharCount = gChatMaxLength.normalChatLength
	self.isChangeDirty = false
	self.isShowBtnKNotice = false
	self.isShowBtnEmotion = false
	self.isPrizeShow = false
	self.isPrizeInit = false
	self.prizeData, _ENV, self.oldStr = gChatMaxLength.normalChatLength, gChatMaxLength.normalChatLength, ""
	self.prizeIndex = 1
	self.bottomBg = SoraDGetChildByName(self, "BottomBg")
	self.nodeTopic = SoraDGetChildByName(self, "Node_topic")
	self.labelTopic = SoraDGetChildByName(self, "Text_topic")
	self.layerCut = SoraDGetChildByName(self, "Panel_cut")
	self.imgBgL = SoraDGetChildByName(self, "Image_bgL")
	self.imgBgR = SoraDGetChildByName(self, "Image_bgR")
	self.nodeChat = SoraDGetChildByName(self, "Node_chat")
	self.btnTheme1 = SoraDGetChildByName(self.nodeChat, "Button_theme")
	self.buttonSend = SoraDGetChildByName(self, "Button_Send")
	self.btnPrize = SoraDGetChildByName(self, "Button_prize")
	self.btnReceive = SoraDGetChildByName(self, "Button_receive")
	self.btnReceive:setVisible(false)
	self.nodeDj = SoraDGetChildByName(self, "Node_dj")
	self.btnTheme2 = SoraDGetChildByName(self.nodeDj, "Button_theme")
	self.btnTopic = SoraDGetChildByName(self, "Button_topic")
	self.btnStart = SoraDGetChildByName(self, "Button_start")
	self.btnScreen = SoraDGetChildByName(self, "Button_screen")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.nodePrize = SoraDGetChildByName(self, "Node_prize")
	self.scrollPrize = SoraDGetChildByName(self, "ScrollView_prize")
	self.btnGiving = SoraDGetChildByName(self, "Button_giving")
	self.btnLeft = SoraDGetChildByName(self, "Button_left")
	self.btnRight = SoraDGetChildByName(self, "Button_right")
	self.btnGiving:setTitleText(i18n("common_text_3644"))
	self.labelTotalGold = SoraDGetChildByName(self, "Text_totalGold")
	self.labelTotalGold = SoraDChangeTextToHtml(self.labelTotalGold)
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.textBg = SoraDGetChildByName(self, "textBg")
	self.textBg = SoraDGetChildByName(self, "textBg")
	self.textField = ccui.EditBox:create(cc.size(394, 40), "bg_transparent.png", ccui.TextureResType.plistType)
	self.textField:setName("textField")
	if self.textField.setControlType then
		self.textField:setControlType(1)
	end
	self.textField:setAnchorPoint(cc.p(0, 0))
	self.textField:setPosition(cc.p(0, 0))
	self.textField:setFontColor(cc.c3b(0, 0, 0))
	self.textField:setTextHorizontalAlignment(SoraDFLabelR())
	self.textField:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_SENTENCE)
	self.textField:addTo(self.textBg)
	self.textField:setFontSize(_defaultParam.inputFontSize)
	self.textField:setPlaceholderFontSize(_defaultParam.inputFontSize)
	function self.textField:getCharCount()
		return string.utf8len(self:getText())
	end
	function self.textField:getString()
		return RemoveStringSpecial(self:getText())
	end
	self.textField:setPlaceHolder(i18n("common_text_072"))
	self.textField:registerScriptEditBoxHandler(handler(self, self.editBoxTextEvent))
	self.btnPrize:addTouchEventListener(handler(self, self.onBtnPrize))
	self.buttonSend:setTouchEnabled(true)
	self.buttonSend:addTouchEventListener(handler(self, self.OnBtnSendEvent))
	self.btnGiving:addTouchEventListener(handler(self, self.OnBtnSendGiftEvent))
	self.btnTopic:addTouchEventListener(handler(self, self.OnBtnTopicEvent))
	self.btnStart:addTouchEventListener(handler(self, self.OnBtnStartEvent))
	self.btnScreen:addTouchEventListener(handler(self, self.OnBtnScreenEvent))
	self.btnReceive:addTouchEventListener(handler(self, self.OnBtnReceiveFreeProp))
	self.btnTheme1:addTouchEventListener(handler(self, self.onBtnTheme))
	self.btnTheme2:addTouchEventListener(handler(self, self.onBtnTheme))
	self.nodeTopic:setVisible(false)
	self.nodeDj:setVisible(false)
	self:initKNotice()
	self:updateBtnSend()
	SoraDCreatAnimation(self.__cname, self, true)
end
function DjBottomView:initKNotice()
	self:setMaxCharCount(gChatMaxLength.normalChatLength)
	self:setChatInputType(chatConst.ChatInputType.Input_Text)
end
function DjBottomView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_CLOSE_IME", handler(self, self.msgCloseIME))
	SoraDAddMessage(self, "MESSAGE_CHAT_THEME_CHANGED", handler(self, self.msgThemeChanged))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateGold))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_SHOW_EFFECT", handler(self, self.showPrivilegeDebut))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(...)
		if self.prizeData[2] then
			for i, v in ipairs(self.prizeData) do
				if v.data.shopItemID then
					local count = self:getItemCount(v.data.itemId)
					if 0 < count then
						self = nil
						;(nil).count = string.formatnumberthousands(count)
						v.point.labelGold:setString(i18n("common_text_1377", nil))
					else
						self = i18n("common_text_1377", nil)
						i18n("common_text_1377", nil).num = string.formatnumberthousands(v.data.price)
						v.point.labelGold:setString(i18n("item_name_02", i18n("common_text_1377", nil)))
					end
				end
			end
		end
	end)
end
function DjBottomView:initData(showType)
	self.showType = showType
	self:updateView()
end
function DjBottomView:updateGold()
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local haveGold = lordInfoCtrl:getBaseInfo().gold
	local numColor = display.CORLOR_YELLOW
	gametop = nil
	gametop, gametop, (nil).gold = haveGold, string.formatnumberthousands(haveGold), string.formatnumberthousands(haveGold)
	string.formatnumberthousands(haveGold).gold, haveGold.color = haveGold, numColor
	self.labelTotalGold:setString(i18n_html("Anchor_text_67", nil, (string.formatnumberthousands(haveGold))))
end
function DjBottomView:updateView()
	if self.showType == gChatDJShowType.CHAT_VIEW then
		self.nodeDj:setVisible(false)
		self:startTimer(0.05)
		self:updateTime()
		self.textField:setPlaceHolder(djCtrl.isBroadcast and i18n("common_text_072") or i18n("Anchor_text_24"))
		self.textField:setTouchEnabled(djCtrl.isBroadcast)
		self.btnPrize:setVisible(djCtrl.isBroadcast)
		self:refreshReceiveBtn()
		self.btnTheme = self.btnTheme1
	elseif self.showType == gChatDJShowType.DJ_VIEW then
		self.nodeDj:setVisible(true)
		self.nodeChat:setVisible(false)
		self.nodePrize:setPositionY(-30)
		self.btnTheme = self.btnTheme2
		self:updateDJNode()
	end
	self:updateTheme()
	self:publicView()
end
function DjBottomView:updateDJNode()
	if djCtrl.topic ~= nil then
		self.btnTopic:setTitleText(i18n("Anchor_text_31"))
	else
		self.btnTopic:setTitleText(i18n("Anchor_text_29"))
	end
	if djCtrl.isBroadcastDJ then
		self.btnStart:setTitleText(i18n("Anchor_text_66"))
		self.btnStart:loadTextures("btn_red_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.labelTime:setVisible(true)
		if self.timerKey == nil then
			self:startTimer(1)
			self:updateTime()
		end
		if VoiceChatSDKManager:getInstance().voiceState == gVoiceState.onLine then
			if VoiceChatSDKManager:getInstance().vociePermission then
				if djCtrl:getCurDJInfo().uniqueChannel and djCtrl:getCurDJInfo().uniqueChannel ~= 0 then
					VoiceChatSDKManager:getInstance():joinChannel(djCtrl:getCurDJInfo().uniqueChannel, true)
				end
			else
				SoraDShowMsgTip(i18n("chat_text_55"))
			end
		end
	else
		if VoiceChatSDKManager:getInstance().voiceState == gVoiceState.inRoom then
			print("创建:", roomid)
			if djCtrl.uniqueChannel then
				VoiceChatSDKManager:getInstance():leaveChannel(djCtrl.uniqueChannel)
			end
		end
		self:stopTimer()
		self.btnStart:setTitleText(i18n("Anchor_text_65"))
		self.btnStart:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.labelTime:setVisible(false)
	end
end
function DjBottomView:publicView()
	if djCtrl.topic ~= nil then
		self.labelTopic:setString(djCtrl.topic)
	end
	self.nodeTopic:setVisible(djCtrl.topic ~= nil)
end
function DjBottomView:updatePrizeView()
	local data = djCtrl:getPrizeList()
	for i, v in ipairs(data) do
		djCtrl = nil
		;(nil).data = v
		;(nil).point = self:createPrizeNode(v, i)
		table.insert(self.prizeData, nil)
	end
	local scrollW = math.max(210 * #self.prizeData, 640)
	self.scrollPrize:setInnerContainerSize(cc.size(scrollW, 255))
	for i, v in ipairs(self.prizeData) do
		v.point:setPosition(SoraDFPosX(scrollW - 210 * (i - 0.5), scrollW), 250)
	end
	if SoraDFIsRA() then
		self.scrollPrize:jumpToRight()
	else
		self.scrollPrize:jumpToLeft()
	end
	self:updateZanNode()
	self:updateGold()
end
function DjBottomView:createPrizeNode(data, index)
	local single = self.nodeClone:clone()
	single.labelPoint = SoraDGetChildByName(single, "Text_point")
	single.nodeZan = SoraDGetChildByName(single, "Node_zan")
	single.btnMinus = SoraDGetChildByName(single, "Button_minus")
	single.btnAdd = SoraDGetChildByName(single, "Button_add")
	single.labelGold = SoraDGetChildByName(single, "Text_gold")
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.imgPrize = SoraDGetChildByName(single, "Image_prize")
	single.imgPrizeBg = SoraDGetChildByName(single, "Image_prizeBg")
	single.imgPrizeBg.imgLight = SoraDGetChildByName(single, "Image_light")
	single.imgPrize:loadTexture(itemDesRead.getIcon(data.itemId), ccui.TextureResType.plistType)
	single.labelName:setString(itemDesRead.getName(data.itemId))
	if data.shopItemID then
		single.nodeZan:setVisible(false)
		single.labelGold:setColor(display.COLOR_WHITE)
		local count = self:getItemCount(data.itemId)
		if 0 < count then
			_ENV = itemDesRead.getName(data.itemId)
			itemDesRead.getName(data.itemId).count = string.formatnumberthousands(count)
			single.labelGold:setString(i18n("common_text_1377", itemDesRead.getName(data.itemId)))
		else
			_ENV = i18n("common_text_1377", itemDesRead.getName(data.itemId))
			i18n("common_text_1377", itemDesRead.getName(data.itemId)).num = string.formatnumberthousands(data.price)
			single.labelGold:setString(i18n("item_name_02", i18n("common_text_1377", itemDesRead.getName(data.itemId))))
		end
		_ENV = i18n("item_name_02", i18n("common_text_1377", itemDesRead.getName(data.itemId)))
		i18n("item_name_02", i18n("common_text_1377", itemDesRead.getName(data.itemId))).num = data.point
		single.labelPoint:setString(i18n("Anchor_text_61", i18n("item_name_02", i18n("common_text_1377", itemDesRead.getName(data.itemId)))))
		single.imgPrizeBg.imgLight:setVisible(false)
	else
		single.nodeZan:setVisible(true)
		single.btnMinus:setTag(1)
		single.btnAdd:setTag(2)
		single.btnMinus:setSwallowTouches(false)
		single.btnAdd:setSwallowTouches(false)
		single.btnMinus:addTouchEventListener(handler(self, self.onBtnPrizeZanSingle))
		single.btnAdd:addTouchEventListener(handler(self, self.onBtnPrizeZanSingle))
		_ENV = single.btnAdd.addTouchEventListener
		_ENV, single.btnAdd.addTouchEventListener.point = single.btnAdd, single
		single.btnAdd[1] = 9
		single.btnAdd[2] = 44
		single.btnAdd[3] = 77
		single.btnAdd[4] = 444
		single.btnAdd[5] = 777
		single.btnAdd[6] = 999
		single.btnAdd[7] = 4444
		single.btnAdd[8] = 7777
		single.btnAdd.addTouchEventListener.nums, single.btnAdd[9] = single.btnAdd, 9999
		self.zanData, single.btnAdd.addTouchEventListener.numIndex = single.btnAdd.addTouchEventListener, 1
		self.curLight = single.imgPrizeBg.imgLight
	end
	single.imgPrizeBg:setTouchEnabled(true)
	single.imgPrizeBg:setSwallowTouches(false)
	single.imgPrizeBg:setTag(index)
	single.imgPrizeBg:addTouchEventListener(handler(self, self.onBtnPrizeSingle))
	single:addTo(self.scrollPrize)
	return single
end
function DjBottomView:updateZanNode()
	local data = self.prizeData[1].data
	local num = self.zanData.nums[self.zanData.numIndex]
	_ENV = nil
	;(nil).num = string.formatnumberthousands(data.point * num)
	self.zanData.point.labelPoint:setString(i18n("Anchor_text_61", nil))
	self.zanData.point.labelGold:setString(tostring(num))
end
function DjBottomView:onBtnPrizeZanSingle(button, type)
	if type == ccui.TouchEventType.ended then
		print("点击了礼物按钮")
		SoraDPlaySound()
		local offset = 1
		if button:getTag() == 1 then
			offset = -1
		end
		self.zanData.numIndex = math.max(1, math.min(self.zanData.numIndex + offset, 9))
		self:updateZanNode()
	end
end
function DjBottomView:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function DjBottomView:checkTextSend(chatChannel, subType)
	local interval = gChatChannel2MsgInterval[chatChannel]
	if type(interval) == "table" then
		interval = interval[subType]
	end
	local canSend = chatSendMgr:checkIntervalTime(interval)
	return canSend
end
function DjBottomView:OnBtnSendGiftEvent(button, type)
	if type == ccui.TouchEventType.ended then
		print("发送按钮: Send Click")
		SoraDPlaySound()
		if djCtrl.isBroadcastDJ then
			SoraDShowMsgTip(i18n("Anchor_text_55"))
			return
		end
		local curChannel = chatDataMgr:getChatChannel()
		if self.prizeData[self.prizeIndex] then
			if not djCtrl.isBroadcast then
				SoraDShowMsgTip(i18n("Anchor_text_26"))
				if self.chatDelegate then
					self.chatDelegate:hidePrizeUI()
					self.chatDelegate.maskArea:setVisible(false)
					self.chatDelegate.isOpenPrize = false
				end
				return
			end
			local data = self.prizeData[self.prizeIndex].data
			local shopItemID
			local itemID = data.itemId
			local count = 1
			local canSend = true
			if self.prizeIndex == 1 then
				count = self.zanData.nums[self.zanData.numIndex]
				print("itemID", itemID)
				canSend = count <= self:getItemCount(itemID)
			else
				local haveCount = self:getItemCount(itemID)
				if haveCount <= 0 then
					shopItemID = data.shopItemID
				end
			end
			if self.chatDelegate then
				if canSend then
					_ENV = i18n("Anchor_text_26")
					i18n("Anchor_text_26").shopItemID = shopItemID
					i18n("Anchor_text_26").itemID = itemID
					i18n("Anchor_text_26").count = count
					i18n("Anchor_text_26").message = ""
					i18n("Anchor_text_26").messageType = gChatTypeDef.chat_content_dj_gift
					self.chatDelegate:chatSendOneMessage(self, i18n("Anchor_text_26"))
				else
					SoraDShowMsgTip(i18n("Anchor_text_27"))
				end
			end
		end
	end
end
function DjBottomView:OnBtnSendEvent(button, type)
	if type == ccui.TouchEventType.ended then
		print("发送按钮: Send Click")
		SoraDPlaySound()
		local isCanChat = chatCtrl:canChat()
		local curChannel = chatDataMgr:getChatChannel()
		if curChannel == gChatChannel.DJ and not isCanChat then
			SoraDShowMsgTip(i18n("commom_text_4306"))
			return
		end
		local textContent = self.textField:getString()
		if textContent and string.len(textContent) > 0 then
			local subType
			if not self:checkTextSend(curChannel, subType) then
				return
			end
			if self.chatDelegate then
				_ENV = subType
				subType.message = textContent
				subType.messageType = gChatTypeDef.chat_content_dj_text
				self.chatDelegate:chatSendOneMessage(self, subType)
			end
		end
		self.textField:setText("")
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.began then
	end
end
function DjBottomView:onBtnPrizeSingle(button, type)
	if type == ccui.TouchEventType.ended then
		print("点击了礼物按钮")
		SoraDPlaySound()
		if self.curLight then
			self.curLight:setVisible(false)
		end
		self.curLight = button.imgLight
		self.curLight:setVisible(true)
		self.prizeIndex = button:getTag()
	end
end
function DjBottomView:OnBtnTopicEvent(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if djCtrl.topic ~= nil then
			djCtrl:sendChatDJCloseTopic()
			SoraDShowLoading()
		else
			SoraDCreatePanel("djTopicView"):show()
		end
	end
end
function DjBottomView:OnBtnStartEvent(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local fun = function(...)
			if djCtrl.isDJ then
				djCtrl:sendDJOpen()
				SoraDShowLoading(nil, nil, nil, nil, 10)
			else
				SoraDShowMsgTip(i18n("Anchor_text_18"))
				SoraDRemoveAllPanelFromManager()
			end
		end
		if djCtrl.isBroadcastDJ then
			_ENV = nil
			;(nil).time = SoraDConvertSecondToString(djCtrl:getCurDJLiveBeginTime())
			SoraDShowMsgBox(i18n("Anchor_text_33", nil), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					fun()
				end
			end)
		else
			VoiceChatSDKManager:getInstance():req4Permission()
			fun()
		end
	end
end
function DjBottomView:OnBtnScreenEvent(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("djMsgScreenView"):show()
	end
end
function DjBottomView:onBtnPrize(button, type)
	if type == ccui.TouchEventType.ended then
		print("点击了礼包按钮")
		SoraDPlaySound()
		if not self.isPrizeInit then
			self:updatePrizeView()
			self.isPrizeInit = true
		end
		if self.chatDelegate then
			print("self.isPrizeShow", self.isPrizeShow)
			if not self.isPrizeShow then
				self:hideKeyPad()
				self.chatDelegate:openPrizeUI()
			else
				if self.nodeChat:isVisible() then
					_ENV = nil
					;(nil).delay = 0.3
					;(nil).onComplete = function()
						self:showKeyPad()
					end
					transition.execute(self.textField, nil, nil)
				end
				self.chatDelegate:hidePrizeUI()
			end
			self.isPrizeShow = not self.isPrizeShow
		end
	end
end
function DjBottomView:switchBtn(bool)
	self.isPrizeShow = bool
end
function DjBottomView:showKeyPad(...)
	self.textField:touchDownAction(self.textField, ccui.TouchEventType.ended)
	if self.chatDelegate and self.chatDelegate.showKeyboardMask then
		self.chatDelegate:showKeyboardMask()
	end
end
function DjBottomView:hideKeyPad(...)
	self.textField:closeKeyboard()
	if self.chatDelegate and self.chatDelegate.hideKeyboardMask then
		_UPVALUE0_ = nil
		self.chatDelegate:hideKeyboardMask(nil, nil)
	end
end
function DjBottomView:startTimer(delay)
	print("----------startTimer()-----")
	if self.timerKey == nil then
		self.timerKey = SoraDCreateTimerEx(self, handler(self, self.updateTime), delay)
	end
end
function DjBottomView:stopTimer()
	if self.timerKey then
		SoraDManagerRemoveTimer(self, self.timerKey)
		self.timerKey = nil
	end
end
function DjBottomView:updateTime()
	if self.showType == gChatDJShowType.DJ_VIEW then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(djCtrl:getCurDJLiveBeginTime())
		self.labelTime:setString(i18n("Anchor_text_32", nil))
	else
		local newStr = self.textField:getString()
		if self.isChangeDirty == false and self.oldStr == newStr then
			return
		elseif self.isChangeDirty == true then
			self.isChangeDirty = false
		end
		self.oldStr = newStr
		self:updateBtnSend()
	end
end
function DjBottomView:onExitOther()
	local curTarget, nextTarget = chatAudioMgr:popAudioTarget()
	self:stopTimer()
	self:closeIME()
end
function DjBottomView:updateTheme()
	local btnImg = gCurrentChatTheme == gChatTheme.normal and "btn_yejianmoshiqihuan_01.png" or "btn_yejianmoshiqihuan_02.png"
	print("DjBottomView: btnImg = ", btnImg)
	if self.btnTheme then
		self.btnTheme:loadTextures(btnImg, btnImg, btnImg, ccui.TextureResType.plistType)
	end
end
function DjBottomView:onBtnTheme(target, event)
	if event == ccui.TouchEventType.ended then
		print("-----点击了切换夜景")
		if gCurrentChatTheme == gChatTheme.normal then
			chatThemeMgr:changeToChatTheme(gChatTheme.dark)
		else
			chatThemeMgr:changeToChatTheme(gChatTheme.normal)
		end
	end
end
function DjBottomView:getItemCount(itemId)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemCount = backpackCtrl:getItemCount(itemId)
	return itemCount
end
function DjBottomView:confirmUseItemCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
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
function DjBottomView:getBottomViewHeight()
	return self.textBg:getContentSize().height
end
function DjBottomView:closeIME()
	self:hideKeyPad()
end
function DjBottomView:msgCloseIME(target, data)
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
function DjBottomView:setViewType(viewType)
	self.viewType = viewType
	if self.viewType == "chatView" then
		self.isCanChat = chatCtrl:canChat()
		if not self.isCanChat then
			self.textField:setPlaceHolder(i18n("common_text_1039"))
		else
			self.textField:setPlaceHolder(i18n("common_text_072"))
		end
	end
end
function DjBottomView:getViewType()
	return self.viewType
end
function DjBottomView:setMaxCharCount(maxCharCount)
	if self.textField then
		self.maxCharCount = maxCharCount
		self.textField:setMaxLength(self.maxCharCount)
		local charCount = self.textField:getCharCount()
		local strCount = string.format("%d/%d", charCount, self.maxCharCount)
	end
end
function DjBottomView:getLTrimTextCount()
	local strText = self.textField:getString()
	strText = string.ltrim(strText)
	if strText == nil then
		strText = ""
	end
	return string.utf8len(strText)
end
function DjBottomView:updateBtnSend()
	local charCount = self.textField:getCharCount()
	if charCount == 0 then
		self.buttonSend:setEnabled(false)
		self.buttonSend:setBright(false)
	elseif 0 < self:getLTrimTextCount() then
		print("启用-----")
		self.buttonSend:setEnabled(true)
		self.buttonSend:setBright(true)
	else
		self.buttonSend:setEnabled(false)
		self.buttonSend:setBright(false)
	end
end
function DjBottomView:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	local strFmt
	if strEventName == "began" then
		strFmt = string.format("editBox   DidBegin !", edit)
		print(strFmt)
		if self.chatDelegate and self.chatDelegate.showKeyboardMask then
			self.chatDelegate:showKeyboardMask()
		end
	elseif strEventName == "ended" then
		strFmt = string.format("editBox   DidEnd !", edit)
		print(strFmt)
	elseif strEventName == "return" then
		strFmt = string.format("editBox   was returned !", edit)
		print(strFmt)
	elseif strEventName == "changed" then
		strFmt = string.format("editBox   TextChanged, text:   ", edit, edit:getString())
		print(strFmt)
	end
end
function DjBottomView:setChatInputType(chatInputType)
	print("设置chatInputType-------", chatInputType)
	if self.chatInputType == chatInputType then
		return
	end
	self.chatInputType = chatInputType
	local textBgSize = _defaultParam.inputBgCfg[chatInputType]
	self.textBg:setContentSize(cc.size(textBgSize.width, textBgSize.height))
	local textFieldSize = cc.size(textBgSize.width - _defaultParam.paddingEditbox.left - _defaultParam.paddingEditbox.right, textBgSize.height - _defaultParam.paddingEditbox.top - _defaultParam.paddingEditbox.bottom)
	dump(textFieldSize, "textFieldSize")
	self.textField:setContentSize(textFieldSize)
	self.textField:setPositionY(_defaultParam.paddingEditbox.bottom)
	self.textField:setPositionX(_defaultParam.paddingEditbox.left)
	local _ENV, tbShowNodes = self.textField.setPositionX, self.textField.setPositionX
	local _ENV, tbHideNodes = self.textField, self.textField
	local _ENV, tbPadding = _defaultParam.paddingEditbox.left, _defaultParam.paddingEditbox.left
	print("chatInputType = ", chatInputType)
	if chatInputType == chatConst.ChatInputType.Input_Text then
		chatConst = chatConst.ChatInputType.Input_Text
		tbShowNodes, chatConst.ChatInputType.Input_Text[1] = chatConst.ChatInputType.Input_Text, self.buttonSend
		tbShowNodes, chatConst.ChatInputType.Input_Text[2] = chatConst.ChatInputType.Input_Text, self.textBg
		_defaultParam = self.textBg
		self.textBg[1] = _defaultParam.paddingBtnSend.right
		table.insertto(tbPadding, self.textBg)
	end
	SoraDSetNodeArrayVisible(tbShowNodes, true)
	dump(tbShowNodes, "tbShowNodes", 1)
	SoraDSetNodeArrayVisible(tbHideNodes, false)
	dump(tbHideNodes, "tbHideNodes", 10)
	if tbShowNodes[1] then
		tbShowNodes[1]:setPositionX(SoraDFPosX(38, 0))
		SoraDAlignNodeArray(tbShowNodes, not SoraDFIsRA(), tbPadding)
	end
	self.isChangeDirty = true
	self:updateTime()
end
function DjBottomView:msgThemeChanged(target, data)
	self:updateTheme()
end
function DjBottomView:OnBtnReceiveFreeProp(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("commonRewardPopView")
		_ENV = nil
		;(nil).rewards = djCtrl:getReceiveFreeProp()
		;(nil).des = i18n("privilege_text_118")
		;(nil).title = i18n("privilege_text_117")
		;(nil).btnText = i18n("common_text_1146")
		;(nil).handle = function()
			djCtrl:sendReceiveFreeProp()
			self.btnReceive:setVisible(false)
		end
		panel:initData(nil)
		panel:show()
	end
end
function DjBottomView:refreshReceiveBtn(...)
	if djCtrl:checkReceiveFreeProp() then
		self.btnReceive:setVisible(true)
	else
		self.btnReceive:setVisible(false)
	end
end
function DjBottomView:showPrivilegeDebut(...)
	if not self.debutEffect then
		local effect = SoraDCreatAnimation("Node_Effect_ltjm101", nil, false)
		effect:addTo(self, -1)
		effect:setPosition(0, 300)
		_UPVALUE3_ = 300
		;(300)[1] = cca.delay(3.0)
		;(300)[2] = cca.callFunc(function()
			self.debutEffect = nil
		end)
		;(300)[3] = cca.delay(3.0)
		;(300)[4] = cca.callFunc(function()
			effect:removeFromParent()
		end)
		;(300)[5] = cca.callFunc(function()
			effect:removeFromParent()
		end)
		effect:runAction(cca.seq(300))
		self.debutEffect = effect
	end
end
return DjBottomView

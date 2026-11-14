local FACETREASUREVIEW_FBSUCCESS = 1
local FACETREASUREVIEW_FBNOTBIND = 2
local FACETREASUREVIEW_FBNOTLOGIN = 3
local FACETREASUREVIEW_FBFAILD = 4
local GridScrollView = include("GridScrollView")
local FaceTreasureView = class("faceTreasureView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("faceTreasureView")
	end
	return target
end)
function FaceTreasureView:ctor()
	self.playerOCXTbl, _ENV, self.myFaceTreasureData, _ENV, self.friendListKeys, _ENV, self.friendList, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	self.reqRedata = nil
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_faceTitle")
	self.btnHistory = SoraDGetChildByName(self, "Top_Button_history")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node_foot")
	self.scroll = SoraDGetChildByName(self, "ScrollView_friends")
	self.nodeTip = SoraDGetChildByName(self, "Node_tipPanel")
	self.btnFB = SoraDGetChildByName(self, "Button_facebook")
	self.btnCallHelp = SoraDGetChildByName(self, "Button_callHelp")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnBox = SoraDGetChildByName(self, "Button_box")
	self.imgCopy = SoraDGetChildByName(self, "Image_copy")
	self.loadPro = SoraDGetChildByName(self, "LoadingBar_pro")
	self.txtPro = SoraDGetChildByName(self, "Text_pro")
	self.txtTip = SoraDGetChildByName(self, "Text_tips")
	self.txtLv = SoraDGetChildByName(self, "Text_boxLv")
	self.imgCD = SoraDGetChildByName(self, "Center_Image_cd")
	self.txtFaceBtn = SoraDGetChildByName(self, "Text_faceBtn")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.Image_box = SoraDGetChildByName(self, "Image_box")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.btnFB:addTouchEventListener(handler(self, self.btnFBClick))
	self.btnCallHelp:addTouchEventListener(handler(self, self.btnCallHelpClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnBox:addTouchEventListener(handler(self, self.btnBoxClick))
	self.btnHistory:addTouchEventListener(handler(self, self.btnHistoryClick))
	SoraDGetChildByName(self, "Image_tipBg"):setFillType(1)
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Image_topLace1"):setFillType(1)
	SoraDGetChildByName(self, "Image_topLace2"):setFillType(1)
	SoraDGetChildByName(self, "Bottom_Size_Image_downLace"):setFillType(1)
	SoraDGetChildByName(self, "Top_Size_Image_upLace"):setFillType(1)
	SoraDGetChildByName(self, "Text_next"):setString(i18n("common_text_2252"))
	_ENV = i18n("common_text_2252")
	i18n("common_text_2252").platform = "Facebook"
	SoraDGetChildByName(self, "Text_fbTip"):setString(i18n("common_text_2240", i18n("common_text_2252")))
	self.btnCallHelp:setTitleText(i18n("common_text_2245"))
	self.btnHistory:setTitleText(i18n("common_text_836"))
	_ENV = i18n("common_text_836")
	i18n("common_text_836").platform = "Facebook"
	self.txtFaceBtn:setString(i18n("common_text_2240", i18n("common_text_836")))
	self.btnHistory:setVisible(false)
	self.nodeTip:setVisible(false)
	self.btnFB:setVisible(false)
	self.btnCallHelp:setVisible(false)
	self.imgCD:setVisible(false)
	self:addDoubleFireEffect()
	self:chestShow(false)
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_MSGARRIVED", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_OPENVIEWDATA", handler(self, self.receiveGameData))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_REFRESHVIEWDATA", handler(self, self.receiveRefreshGameData))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_TREASUREERROR", handler(self, self.errorRecevive))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_FLAGBACK_TREASUREREAUTHORIZE", handler(self, self.req4Flag))
	SoraDTestButton(self, function(...)
		SoraDInputBox("测试", "a2165", "输入账号", 99, function(str)
			local gametop = gModuleMgr.getObject("gametop")
			local fbTreasureCtrl = gametop.playertop_:getModule("fbTreasureCtrl")
			fbTreasureCtrl:sendHelp(str, nil)
		end)
	end)
	self:req4Flag()
end
function FaceTreasureView:req4Flag(...)
	self.scroll:removeAllChildren()
	self:initScroll()
	self.playerOCXTbl, _ENV = self.initScroll, self.initScroll
	facebookFriendModule.getJoinedFriends()
	SoraDShowLoading(self)
end
function FaceTreasureView:initData(target, redata)
	if redata and redata.redata then
		self.reqRedata = json.decode(redata.redata)
		self.state = tonumber(self.reqRedata.flag)
		if not self.reqRedata.friendList then
			_ENV = self.reqRedata.friendList
		end
		self.friendList = self.reqRedata.friendList
		self:req4gameData()
	end
end
function FaceTreasureView:req4gameData(...)
	local gametop = gModuleMgr.getObject("gametop")
	local fbTreasureCtrl = gametop.playertop_:getModule("fbTreasureCtrl")
	fbTreasureCtrl:sendOpenPage()
end
function FaceTreasureView:receiveGameData(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.retdate then
		self.myFaceTreasureData = redata.retdate
	end
	self:initOtherView()
end
function FaceTreasureView:receiveRefreshGameData(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.retdate then
		self.myFaceTreasureData = redata.retdate
		if redata.getReward then
			self:getReward(redata.getReward)
		end
	end
	self:initView()
end
function FaceTreasureView:initView(...)
	if self.myFaceTreasureData then
		if self.myFaceTreasureData.cdTime and self.myFaceTreasureData.cdTime > 0 then
			self.imgCD:setVisible(true)
			self.txtTime:beginTime(self.myFaceTreasureData.cdTime)
		else
			self.imgCD:setVisible(false)
		end
		self.loadPro:setPercent(self.myFaceTreasureData.cur / self.myFaceTreasureData.total * 100)
		_ENV = nil
		;(nil).total = self.myFaceTreasureData.total
		;(nil).cur = self.myFaceTreasureData.cur
		self.txtPro:setString(i18n("common_text_1641", nil))
		local last = self.myFaceTreasureData.total - self.myFaceTreasureData.cur
		if 0 < last then
			_ENV = i18n("common_text_1641", nil)
			i18n("common_text_1641", nil).num = last
			self.txtTip:setString(i18n("common_text_2244", i18n("common_text_1641", nil)))
			self:chestShow(false)
		else
			self.txtTip:setString(i18n("common_text_2253"))
			self:chestShow(true)
		end
		_ENV = i18n("common_text_2253")
		i18n("common_text_2253").level = self.myFaceTreasureData.lv
		self.txtLv:setString(i18n("common_text_600", i18n("common_text_2253")))
		self:refreshPlayers()
	end
end
function FaceTreasureView:initOtherView(...)
	local setMode = function(bool)
		self.nodeTip:setVisible(bool)
		self.btnFB:setVisible(bool)
		self.btnCallHelp:setVisible(not bool)
		self.btnHistory:setVisible(not bool)
	end
	if FACETREASUREVIEW_FBNOTBIND == self.state then
		setMode(true)
		FACETREASUREVIEW_FBNOTBIND = nil
		;(nil).platform = "Facebook"
		self.txtFaceBtn:setString(i18n("common_text_2241", nil))
	elseif FACETREASUREVIEW_FBNOTLOGIN == self.state then
		setMode(true)
		FACETREASUREVIEW_FBNOTBIND = i18n("common_text_2241", nil)
		i18n("common_text_2241", nil).platform = "Facebook"
		self.txtFaceBtn:setString(i18n("common_text_2242", i18n("common_text_2241", nil)))
	elseif FACETREASUREVIEW_FBSUCCESS == self.state then
		setMode(false)
		self.friendListKeys = table.keys(self.friendList)
		table.insert(self.friendListKeys, "add_flag")
		self:listFriends()
	elseif FACETREASUREVIEW_FBFAILD == self.state then
	end
	self:initView()
end
function FaceTreasureView:getState(...)
	return self.state
end
function FaceTreasureView:test(...)
	_ENV, _ENV = nil, nil
	;(nil).fHead = "https://ss1.baidu.com/70cFfyinKgQFm2e88IuM_a/forum/w%3D580/sign=4cbc213fd009b3deebbfe460fcbe6cd3/c2fdfc039245d688cecd34f3a5c27d1ed31b249d.jpg"
	;(nil).fID = "1247829379237589"
	;(nil).fName = "qq"
	_ENV, (nil)["1247829379237589"], (nil).fUserID = nil, nil, "222"
	;(nil).fHead = "https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=1234019663,3416214151&fm=58&s=8163F41490968792402F90C4030080BA"
	;(nil).fID = "1247853459237589"
	;(nil).fName = "cc"
	_ENV, (nil)["1247853459237589"], (nil).fUserID = nil, nil, "111"
	;(nil).fHead = "https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3952608205,361305390&fm=58&s=D153549285F0DD904CC899500300D0B1"
	;(nil).fID = "12474577677589"
	;(nil).fName = "dd"
	self.friendList, (nil)["12474577677589"], (nil).fUserID = nil, nil, "333"
	self.friendListKeys = table.keys(self.friendList)
	table.insert(self.friendListKeys, "add_flag")
	self:listFriends()
end
function FaceTreasureView:initScroll(...)
	local _ENV, flagTbl
	for i = 1, 5 do
		table.insert(flagTbl, "add_flag")
	end
	local _ENV, headTbl = (for index), 1
	for i, v in ipairs(flagTbl) do
		local headItem = self:createSingle()
		_ENV = nil
		headItem:initData(nil, true)
		headItem:addTo(self.scroll)
		table.insert(headTbl, headItem)
	end
	local sSize = self.scroll:getContentSize()
	local sW = math.max(#headTbl * 120, sSize.width)
	self.scroll:setInnerContainerSize(cc.size(sW, sSize.height))
	for i, v in ipairs(headTbl) do
		local _x = (i - 1) * 120 + 60.0
		v:setPosition(_x, sSize.height / 2)
	end
end
function FaceTreasureView:createSingle(...)
	local headItem = self.imgCopy:clone()
	headItem = include("faceTreasurePlayer").new(headItem)
	headItem:setFarther(self)
	table.insert(self.playerOCXTbl, headItem)
	return headItem
end
function FaceTreasureView:refreshPlayers(...)
	if self.myFaceTreasureData and self.myFaceTreasureData.help and next(self.myFaceTreasureData.help) ~= nil then
		local judgeStr = ""
		for k, v in pairs(self.myFaceTreasureData.help) do
			judgeStr = judgeStr .. v .. ","
		end
		print("judgeStr:", judgeStr)
		for k, v in pairs(self.playerOCXTbl) do
			print("v:returnFID():", v:returnFID())
			if string.find(judgeStr, v:returnFID(), 1, true) then
				v:setWarning(false)
			else
				v:setWarning(true)
			end
		end
	else
		print("暂都没帮助")
	end
end
function FaceTreasureView:listFriends(...)
	local _ENV, headTbl
	for i, v in ipairs(self.friendListKeys) do
		local headItem = self:createSingle()
		if self.friendList[v] then
			headItem:initData(self.friendList[v])
		else
			_ENV = self.friendList[v]
			headItem:initData(self.friendList[v], true)
		end
		headItem:addTo(self.scroll)
		table.insert(headTbl, headItem)
	end
	local sSize = self.scroll:getContentSize()
	local sW = math.max(#headTbl * 120, sSize.width)
	self.scroll:setInnerContainerSize(cc.size(sW, sSize.height))
	for i, v in ipairs(headTbl) do
		local _x = (i - 1) * 120 + 60.0
		v:setPosition(_x, sSize.height / 2)
	end
end
function FaceTreasureView:btnFBClick(button, eventType)
	local recordToBind = function()
		local gametop = gModuleMgr.getObject("gametop")
		local fbTreasureCtrl = gametop.playertop_:getModule("fbTreasureCtrl")
		local gameinfo = fbTreasureCtrl:getData()
		_ENV = fbTreasureCtrl
		fbTreasureCtrl.type = 1
		fbTreasureCtrl.chestlv = gameinfo.lv
		fbTreasureCtrl.chestsc = gameinfo.cur
		fbTreasureCtrl.chestscMax = gameinfo.total
		local fbTreasureCtrl.postNum, postTbl = 0, fbTreasureCtrl
		facebookFriendModule.recordInfo(postTbl)
	end
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if FACETREASUREVIEW_FBNOTBIND == self.state then
			userSDKManager.showUserCenter()
			recordToBind()
		elseif FACETREASUREVIEW_FBNOTLOGIN == self.state then
			facebookFriendModule.authorize4FB()
		end
	end
end
function FaceTreasureView:btnCallHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("btnCallHelpClick click")
		SoraDCreatePanel("faceTreasureInviteView"):show()
	end
end
function FaceTreasureView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("faceTreasureMask"):show()
	end
end
function FaceTreasureView:btnHistoryClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("faceTreasureHistory")
		if not self.myFaceTreasureData.history then
			_ENV = self.myFaceTreasureData.history
		end
		panel:initData(self.myFaceTreasureData.history)
		panel:show()
	end
end
function FaceTreasureView:btnBoxClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("开宝箱")
		if self.myFaceTreasureData then
			if 1 == self.myFaceTreasureData.state then
				local gametop = gModuleMgr.getObject("gametop")
				local fbTreasureCtrl = gametop.playertop_:getModule("fbTreasureCtrl")
				fbTreasureCtrl:sendGetReward()
			elseif 2 == self.myFaceTreasureData.state then
				SoraDShowMsgTip(i18n("common_text_046"))
			else
				_ENV = i18n("common_text_046")
				i18n("common_text_046").num = self.myFaceTreasureData.total - self.myFaceTreasureData.cur
				SoraDShowMsgTip(i18n("common_text_2244", i18n("common_text_046")))
			end
		end
	end
end
function FaceTreasureView:getReward(data)
	local _ENV, rTbl
	for i, v in ipairs(data) do
		rTbl[v.id] = v.count
	end
	SoraDOpenGiftView(rTbl)
	SoraDPlaySound("innercontrol", 7)
end
function FaceTreasureView:errorRecevive(target, redata)
	if redata and redata.err then
		if gErrDef.Err_FB_TREASURE_STATUS_ERROR == redata.err then
			SoraDShowMsgTip(i18n("common_text_046"))
		elseif gErrDef.Err_BACKPACK_IS_FULL == redata.err then
			SoraDShowMsgTip(i18n("notice_0119"))
		elseif gErrDef.Err_FB_TREASURE_LTZDID_ERROR == redata.err then
			SoraDShowMsgTip("could not find the user")
		elseif gErrDef.Err_FB_TREASURE_HELPED == redata.err then
			SoraDShowMsgTip(i18n("common_text_2247"))
		end
		self:refreshPlayers()
	end
end
function FaceTreasureView:chestShow(isOpen)
	if isOpen then
		_UPVALUE2_ = nil
		;(nil)[1] = cca.callFunc(function()
			local frames = display.newFrames("fbchest_%.2d.png", 1, 3)
			local animation = display.newAnimation(frames, 0.2 / #frames)
			self.Image_box:playAnimationOnce(animation)
		end)
		;(nil)[2] = cca.delay(0.2)
		;(nil)[3] = cca.callFunc(function()
			self.Node_effect:setVisible(true)
			SoraDResetEffectNode(self.Node_effect)
		end)
		;(nil)[4] = cca.callFunc(function()
			self.Node_effect:setVisible(true)
			SoraDResetEffectNode(self.Node_effect)
		end)
		local seq = cca.seq(nil)
		self.Image_box:runAction(seq)
	else
		self.Image_box:setSpriteFrame("fbchest_01.png")
		self.Node_effect:setVisible(false)
	end
end
function FaceTreasureView:addDoubleFireEffect(...)
	SoraDCreateFireEffectNode(SoraDGetChildByName(self, "frame_lace_base_23"), SoraDGetChildByName(self, "frame_lace_base_24"))
end
return FaceTreasureView

local pyramidClientModule = include("pyramidClientModule")
local PyramidBattleMainView = class("pyramidBattleMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleMainView")
	end
	return target
end)
function PyramidBattleMainView:ctor()
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_pyramid"):setTitle(i18n("common_text_2517"))
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeEnterTip = SoraDGetChildByName(self, "Node_enterTip")
	self.nodeBtns = SoraDGetChildByName(self, "Node_btns")
	self.nodeSignUp = SoraDGetChildByName(self, "Node_signUp")
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node_center")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.imgBanner = SoraDGetChildByName(self, "Image_banner")
	self.imgBoard = SoraDGetChildByName(self, "Top_Size_Image_brightLBg")
	self.txtTitle = SoraDGetChildByName(self, "Text_centerTitle")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.imgTimeSheer = SoraDGetChildByName(self, "Image_timeSheer")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.txtWarTime = SoraDGetChildByName(self, "Text_warTime")
	self.btnEnter = SoraDGetChildByName(self, "Button_enter")
	self.btnEnterTip = SoraDGetChildByName(self, "Button_enterTip")
	self.btnOppoInfo = SoraDGetChildByName(self, "Button_oppoInfo")
	self.btnManager = SoraDGetChildByName(self, "Button_manager")
	self.btnSignUp = SoraDGetChildByName(self, "Button_signUp")
	self.btnHistory = SoraDGetChildByName(self, "Button_history")
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.btnOtherOppo = SoraDGetChildByName(self, "Button_otherOppo")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnEnter:setPressedActionEnabled(true)
	self.btnOppoInfo:setPressedActionEnabled(true)
	self.btnManager:setPressedActionEnabled(true)
	self.btnSignUp:setPressedActionEnabled(true)
	self.btnOtherOppo:setPressedActionEnabled(true)
	self.btnEnterTip:setTitleText(i18n("common_text_3318"))
	self.btnOppoInfo:setTitleText(i18n("common_text_3319"))
	self.btnManager:setTitleText(i18n("common_text_3317"))
	self.btnSignUp:setTitleText(i18n("common_text_3315"))
	self.btnHistory:setTitleText(i18n("common_text_3032"))
	self.btnPrice:setTitleText(i18n("common_text_2078"))
	self.btnRank:setTitleText(i18n("common_text_851"))
	self.btnOtherOppo:setTitleText(i18n("common_text_3316"))
	self.txtTitle:setString(i18n("common_text_3303"))
	SoraDAutoSizeButtonText(self.btnOtherOppo, cc.size(240, 60))
	self.btnEnter:addTouchEventListener(handler(self, self.btnEnterClick))
	self.btnEnterTip:addTouchEventListener(handler(self, self.btnEnterClick))
	self.btnOppoInfo:addTouchEventListener(handler(self, self.btnOppoInfoClick))
	self.btnManager:addTouchEventListener(handler(self, self.btnManagerClick))
	self.btnSignUp:addTouchEventListener(handler(self, self.btnSignUpClick))
	self.btnHistory:addTouchEventListener(handler(self, self.btnHistoryClick))
	self.btnPrice:addTouchEventListener(handler(self, self.btnPriceClick))
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.btnOtherOppo:addTouchEventListener(handler(self, self.btnOtherOppoClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.imgBanner:loadTexture(SoraDCheckPNG("bg_JZT_qjt01.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	SoraDCreateCSBNode("pyramidEffectTitle"):addTo(self.imgBanner)
	self:initBeforeView()
	self:initData()
end
function PyramidBattleMainView:initBeforeView(...)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(520, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeCenter:setPositionY(sH / 2)
	self.scroll:jumpToTop()
end
function PyramidBattleMainView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ALLIANCEQUIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_ENTERBATTLEFAIL", handler(self, self.closeLoading))
end
function PyramidBattleMainView:initData(...)
	self.myState, self.nowTimeLeft = pyramidClientModule.getShowState()
	print("self.myState = ", self.myState)
	self:initView()
end
function PyramidBattleMainView:initView()
	_ENV = nil
	;(nil).title = self.txtTitle
	;(nil).tip = self.txtTip
	;(nil).time = self.nodeTime
	;(nil).enter = self.btnEnter
	;(nil).enterTip = self.nodeEnterTip
	;(nil).oppo = self.btnOppoInfo
	;(nil).otherOppo = self.btnOtherOppo
	;(nil).manager = self.btnManager
	local (nil).signup, ocxList = self.btnSignUp, nil
	local showOcx = function(tbl)
		self.btnEnter:setColor(cc.c3b(175, 175, 175))
		for _, v in pairs(ocxList) do
			v:setVisible(false)
			for _, val in pairs(tbl) do
				if val == self.btnEnter then
					val:setColor(cc.c3b(255, 255, 255))
				elseif v == val then
					v:setVisible(true)
				end
			end
		end
		self.btnEnter:setVisible(true)
	end
	local fillTimeTicket = function(count, ocx, lang)
		if count then
			ocx:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n(lang, nil)
			end)
			ocx:beginTime(count)
			ocxList.time:setVisible(true)
		else
			ocxList.time:setVisible(false)
		end
	end
	_ENV, _UPVALUE11_ = nil, nil
	;(nil).state = 0
	_ENV, (nil).fun = function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end, function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end
	;(function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end).state = 1
	_ENV, (function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end).fun = function()
		ocxList = nil
		;(nil)[1] = ocxList.title
		showOcx(nil)
	end, function()
		ocxList = nil
		;(nil)[1] = ocxList.title
		showOcx(nil)
	end
	;(function()
		ocxList = nil
		;(nil)[1] = ocxList.title
		showOcx(nil)
	end).state = 2
	_ENV, (function()
		ocxList = nil
		;(nil)[1] = ocxList.title
		showOcx(nil)
	end).fun = function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3304")
	end, function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3304")
	end
	;(function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3304")
	end).state = 3
	_ENV, (function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3304")
	end).fun = function()
		self = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.signup
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3305")
	end, function()
		self = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.signup
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3305")
	end
	;(function()
		self = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.signup
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3305")
	end).state = 4
	_ENV, (function()
		self = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.signup
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3305")
	end).fun = function()
		_UPVALUE4_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.oppo
		;(nil)[4] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3306")
	end, function()
		_UPVALUE4_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.oppo
		;(nil)[4] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3306")
	end
	;(function()
		_UPVALUE4_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.oppo
		;(nil)[4] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3306")
	end).state = 5
	_ENV, (function()
		_UPVALUE4_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.oppo
		;(nil)[4] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3306")
	end).fun = function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			self = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			allianceMgr[4] = ocxList.otherOppo
			showOcx(allianceMgr)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3321"))
		else
			self = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			ocxList.tip[3] = ocxList.tip
			ocxList.tip[4] = ocxList.otherOppo
			showOcx(ocxList.tip)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3322"))
		end
	end, function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			self = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			allianceMgr[4] = ocxList.otherOppo
			showOcx(allianceMgr)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3321"))
		else
			self = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			ocxList.tip[3] = ocxList.tip
			ocxList.tip[4] = ocxList.otherOppo
			showOcx(ocxList.tip)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3322"))
		end
	end
	;(function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			self = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			allianceMgr[4] = ocxList.otherOppo
			showOcx(allianceMgr)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3321"))
		else
			self = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			ocxList.tip[3] = ocxList.tip
			ocxList.tip[4] = ocxList.otherOppo
			showOcx(ocxList.tip)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3322"))
		end
	end).state = 6
	_ENV, (function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			self = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			allianceMgr[4] = ocxList.otherOppo
			showOcx(allianceMgr)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3321"))
		else
			self = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			ocxList.tip[3] = ocxList.tip
			ocxList.tip[4] = ocxList.otherOppo
			showOcx(ocxList.tip)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3322"))
		end
	end).fun = function()
		_ENV = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.tip
		;(nil)[4] = ocxList.otherOppo
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
		ocxList.tip:setString(i18n("common_text_3320"))
	end, function()
		_ENV = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.tip
		;(nil)[4] = ocxList.otherOppo
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
		ocxList.tip:setString(i18n("common_text_3320"))
	end
	;(function()
		_ENV = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.tip
		;(nil)[4] = ocxList.otherOppo
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
		ocxList.tip:setString(i18n("common_text_3320"))
	end).state = 7
	_ENV, (function()
		_ENV = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.tip
		;(nil)[4] = ocxList.otherOppo
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
		ocxList.tip:setString(i18n("common_text_3320"))
	end).fun = function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3308")
	end, function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3308")
	end
	;(function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3308")
	end).state = 8
	_ENV, (function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3308")
	end).fun = function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3309")
	end, function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3309")
	end
	;(function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3309")
	end).state = 9
	_ENV, (function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3309")
	end).fun = function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			fillTimeTicket = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			showOcx(allianceMgr)
			ocxList.tip:setString(i18n("common_text_3322"))
		else
			ocxList = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			showOcx(ocxList.tip)
		end
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end, function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			fillTimeTicket = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			showOcx(allianceMgr)
			ocxList.tip:setString(i18n("common_text_3322"))
		else
			ocxList = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			showOcx(ocxList.tip)
		end
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end
	;(function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			fillTimeTicket = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			showOcx(allianceMgr)
			ocxList.tip:setString(i18n("common_text_3322"))
		else
			ocxList = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			showOcx(ocxList.tip)
		end
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end).state = 10
	;(function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			fillTimeTicket = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			showOcx(allianceMgr)
			ocxList.tip:setString(i18n("common_text_3322"))
		else
			ocxList = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			showOcx(ocxList.tip)
		end
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end).fun = function()
		_ENV = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.tip
		showOcx(nil)
		ocxList.tip:setString(i18n("common_text_3310"))
	end
	;(nil)[1] = nil
	;(nil)[2] = function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end
	;(nil)[3] = function()
		ocxList = nil
		;(nil)[1] = ocxList.title
		showOcx(nil)
	end
	;(nil)[4] = function()
		fillTimeTicket = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3304")
	end
	;(nil)[5] = function()
		self = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.signup
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3305")
	end
	;(nil)[6] = function()
		_UPVALUE4_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.oppo
		;(nil)[4] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3306")
	end
	;(nil)[7] = function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			self = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			allianceMgr[4] = ocxList.otherOppo
			showOcx(allianceMgr)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3321"))
		else
			self = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			ocxList.tip[3] = ocxList.tip
			ocxList.tip[4] = ocxList.otherOppo
			showOcx(ocxList.tip)
			fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
			ocxList.tip:setString(i18n("common_text_3322"))
		end
	end
	;(nil)[8] = function()
		_ENV = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.tip
		;(nil)[4] = ocxList.otherOppo
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
		ocxList.tip:setString(i18n("common_text_3320"))
	end
	;(nil)[9] = function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3308")
	end
	;(nil)[10] = function()
		_UPVALUE6_ = nil
		;(nil)[1] = ocxList.title
		;(nil)[2] = ocxList.time
		;(nil)[3] = ocxList.enter
		;(nil)[4] = ocxList.enterTip
		;(nil)[5] = ocxList.oppo
		;(nil)[6] = ocxList.manager
		showOcx(nil)
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3309")
	end
	local (nil)[11], behaviorList = function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			fillTimeTicket = allianceMgr
			allianceMgr[1] = ocxList.title
			allianceMgr[2] = ocxList.time
			allianceMgr[3] = ocxList.tip
			showOcx(allianceMgr)
			ocxList.tip:setString(i18n("common_text_3322"))
		else
			ocxList = ocxList.tip
			ocxList.tip[1] = ocxList.title
			ocxList.tip[2] = ocxList.time
			showOcx(ocxList.tip)
		end
		fillTimeTicket(self.nowTimeLeft, self.txtTime, "common_text_3307")
	end, nil
	for _, v in pairs(behaviorList) do
		if v.state == self.myState then
			v.fun()
		end
	end
	self:initWarTime()
end
function PyramidBattleMainView:initWarTime()
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local bigState = pyramidWarCtrl.pyramidWarOpenState
	local seasonState = pyramidWarCtrl.regularSeasonState
	if bigState == gPyramidWarOpenState.NOT_OPEN or seasonState == gRegularSeasonState.FINISH then
		self.imgTimeSheer:setVisible(false)
	elseif gPyramidWarOpenState.OPEN == bigState then
		self.imgTimeSheer:setVisible(true)
		local lastTime = pyramidWarCtrl:getRegularEndTime()
		_ENV = nil
		;(nil).time = os.date("!%Y-%m-%d %H:%M:%S", lastTime)
		self.txtWarTime:setString(i18n("common_text_3401", nil))
	end
end
function PyramidBattleMainView:btnEnterClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if 8 == self.myState then
			local enterWarCondition = function(...)
				local gametop = gModuleMgr.getObject("gametop")
				local armyCtrl = gametop.playertop_:getModule("armyCtrl")
				if armyCtrl:getTotalWoundedArmyCount() > 0 then
					SoraDShowMsgBox(i18n("common_text_3261"), i18n("common_text_402"), nil, function(eventType)
						if eventType == MSGBOX_CALLBACK_YES then
							local worldMapWarDef = include("worldMapWarDef")
							worldMapWarDef.openHospitalView()
						end
					end)
					return false
				end
				local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
				if kingdomMapCtrl.kingdomMapCell:hasWoundedQueueArmy() then
					SoraDShowMsgTip(i18n("common_text_3498"))
					return false
				end
				if kingdomMapCtrl:isHasMassQueue() then
					SoraDShowMsgTip(i18n("common_text_3262"))
					return false
				end
				return true
			end
			local enterBattle = function()
				if enterWarCondition() then
					SoraDShowLoading(self)
					local gametop = gModuleMgr.getObject("gametop")
					local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
					pyramidWarCtrl:pyramidwarEnterReq()
					SoraDFabricLog("pyramidwarEnterReq")
				end
			end
			pyramidClientModule.popSelectMenu(enterBattle)
		else
			SoraDShowMsgTip(i18n("common_text_3313"))
		end
	end
end
function PyramidBattleMainView:btnHistoryClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleHistoryView"):show()
	end
end
function PyramidBattleMainView:btnPriceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattlePriceView"):show()
	end
end
function PyramidBattleMainView:btnRankClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleFieldRank"):show()
	end
end
function PyramidBattleMainView:btnOppoInfoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if 4 == self.myState then
			SoraDShowMsgTip(i18n("common_text_2185"))
		else
			SoraDCreatePanel("pyramidBattleOppoInfo"):show()
		end
	end
end
function PyramidBattleMainView:btnOtherOppoClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleOtherOppoView"):show()
	end
end
function PyramidBattleMainView:btnManagerClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleManager"):show()
	end
end
function PyramidBattleMainView:btnSignUpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local useClass = include("pyramidBattleSignUp")
		if useClass.checkRight() then
			SoraDCreatePanel("pyramidBattleSignUp"):show()
		end
	end
end
function PyramidBattleMainView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("faq help")
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
	end
end
function PyramidBattleMainView:closeLoading(target, redata)
	SoraDCloseLoading(self)
end
return PyramidBattleMainView

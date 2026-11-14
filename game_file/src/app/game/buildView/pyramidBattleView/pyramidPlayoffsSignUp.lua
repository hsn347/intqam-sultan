local PyramidPlayoffsSignUp = class("pyramidPlayoffsSignUp", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidPlayoffsSignUp")
	end
	return target
end)
function PyramidPlayoffsSignUp:ctor()
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_signUp")
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	self.btnSignUp = SoraDGetChildByName(self, "Button_signUp")
	self.txtContent = SoraDGetChildByName(self, "Text_content")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	_ENV = nil
	;(nil).count = 3
	self.txtTip:setString(i18n("common_text_4006", nil))
	self.txtContent:setString(i18n("common_text_3324"))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	local titleOCX = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSignUp")
	titleOCX:setTitle(i18n("common_text_3323"))
	titleOCX:setTitleSize()
	self.btnSignUp:setPressedActionEnabled(true)
	self.btnSignUp:setTitleText(i18n("common_text_204"))
	self.btnSignUp:setBright(false)
	self.btnSignUp:addTouchEventListener(handler(self, self.btnSignUpClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SIGNUPSUCCESS", handler(self, self.signUpBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SIGNUPFAIL", handler(self, self.signUpErrBack))
	self:createSingleClass()
	self:initTimeRange()
	self:req4Info()
end
function PyramidPlayoffsSignUp:initTimeRange(...)
	local pyramidWarltCtrl = include("pyramidWarltCtrl")
	local timeList = pyramidWarltCtrl.getMatchtimeList()
	self.selectSingle, _ENV, self.singleTbl, _ENV = nil, nil, nil, nil
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #timeList * 115)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local unSelect = function(target, isSelect)
		if isSelect then
			if self.selectSingle[3] then
				self.selectSingle[3]:setValue(false)
				self.selectSingle[3] = nil
			end
			table.insert(self.selectSingle, 1, target)
		else
			for i, v in ipairs(self.selectSingle) do
				if v == target then
					table.remove(self.selectSingle, i)
					break
				end
			end
		end
		self.btnSignUp:setBright(#self.selectSingle == 3)
	end
	for i = 1, #timeList do
		local single = self.singleClass.new()
		single:setPosition(sSize.width / 2, sH - (i - 1) * 115)
		single:setCallBack(unSelect)
		single:addTo(self.scroll)
		single:initData(timeList[i])
		table.insert(self.singleTbl, single)
	end
end
function PyramidPlayoffsSignUp:req4Info(...)
	self:initData()
end
function PyramidPlayoffsSignUp:endShow()
	self:checkInTime()
end
function PyramidPlayoffsSignUp:initData(target, redata)
	self:initView()
end
function PyramidPlayoffsSignUp:initView(...)
end
function PyramidPlayoffsSignUp:checkInTime(...)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local mainState = pyramidWarCtrl.pinnacleSeasonState
	local allianceState = pyramidWarCtrl.postSeasonAllianceState
	local nowTimeLeft = pyramidWarCtrl:getLeftTime(mainState)
	if gPinnacleSeasonAllianceState.APPLY_ING == mainState and gPinnacleSeasonState.NOT_APPLY == allianceState then
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(nowTimeLeft)
		self.txtTime:setString(i18n("common_text_766", nil))
		self.txtTime:setTimeLast(function(_time)
			_ENV = nil
			;(nil).time = _time
			return i18n("common_text_766", nil)
		end)
		self.txtTime:beginTime(nowTimeLeft)
	else
		self:removeFromParent()
	end
end
function PyramidPlayoffsSignUp:createSingleClass()
	self.singleClass = class("PyramidPlayoffsSignUpSingle", function()
		local target = self.copyItem:clone()
		return target
	end)
	function self.singleClass:ctor()
		self.joinLord = 0
		self.txtNum = self:getChildByName("Text_num")
		self.txtTime = self:getChildByName("Text_rangeTime")
		self.txtAllianceCount = self:getChildByName("Text_allianceCount")
		self.txtAllianceCount:setVisible(false)
		self.imgBanner = self:getChildByName("Image_itembg")
		self.imgSelect = self:getChildByName("Image_light")
		self.imgSelect:setVisible(false)
		self.isMeSelect = false
		self:setSwallowTouches(false)
		self:addTouchEventListener(handler(self, self.itemClick))
	end
	function self.singleClass:initData(dataList)
		self.initData = dataList
		self:initView()
	end
	function self.singleClass:initView()
		self.txtNum:setString(self.initData.number)
		_ENV = self.initData.number
		self.initData.number.sWeek = self.initData.starttime.week
		self.initData.number.sTime = self.initData.starttime.hour .. ":" .. self.initData.starttime.min .. ":" .. self.initData.starttime.sec
		self.initData.number.eWeek = self.initData.endtime.week
		self.initData.number.eTime = self.initData.endtime.hour .. ":" .. self.initData.endtime.min .. ":" .. self.initData.endtime.sec
		local showTime = i18n("common_text_3326", self.initData.number)
		self.txtTime:setString(showTime)
		local imgFile = gSignUpSingleBanner[self.initData.number] or gSignUpSingleBanner[1]
		local _, isDown = SoraDIsFileExistByFileName(imgFile)
		if isDown then
			self.imgBanner:loadTexture(imgFile, ccui.TextureResType.plistType)
		end
	end
	function self.singleClass:setAllianceCount(_num, _max)
		self.joinLord = _num
		_ENV = nil
		;(nil).num = _num
		self.txtAllianceCount:setString(i18n("common_text_3327", nil))
		if _max <= _num then
			self.txtAllianceCount:setColor(display.COLOR_RED)
		else
			self.txtAllianceCount:setColor(cc.c3b(200, 80, 20))
		end
	end
	function self.singleClass:getAllianceCount(...)
		return self.joinLord
	end
	function self.singleClass:itemClick(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if self.singleCb then
				self.singleCb(self, not self.isMeSelect)
			end
			self:setValue(not self.isMeSelect)
		end
	end
	function self.singleClass:setScroll(scroll)
		self.pScroll = scroll
	end
	function self.singleClass:returnSelect()
		return self.isMeSelect
	end
	function self.singleClass:returnIndexNum()
		return self.initData.number
	end
	function self.singleClass:setValue(bool)
		if bool then
			self.isMeSelect = true
			self.imgSelect:setVisible(true)
		else
			self.isMeSelect = false
			self.imgSelect:setVisible(false)
		end
	end
	function self.singleClass:setCallBack(handl)
		self.singleCb = handl
	end
end
function PyramidPlayoffsSignUp.checkRight(...)
	local ret = true
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if allianceMgr:hasJoinAlliance() then
		local ownmember = memberMgr:getOwnMember()
		local ownRank = ownmember:getProperty("rank")
		if ownRank <= RANK_TOP_SPECIAL then
			ret = false
			SoraDShowMsgTip(i18n("common_text_4003"))
		end
	else
		ret = false
		SoraDShowMsgTip(i18n("common_text_3329"))
	end
	if ret then
		local battleState = pyramidWarCtrl.pyramidWarOpenState
		if battleState == gPyramidWarOpenState.NOT_OPEN then
			ret = false
		end
	end
	if ret and gPinnacleSeasonAllianceState.APPLY_ING ~= pyramidWarCtrl.pinnacleSeasonState then
		ret = false
	end
	if ret and gPinnacleSeasonState.APPLY_ED == pyramidWarCtrl.postSeasonAllianceState then
		ret = false
		SoraDShowMsgTip(i18n("common_text_3255"))
	end
	return ret
end
function PyramidPlayoffsSignUp:signUpBack(target, redata)
	SoraDShowMsgTip(i18n("common_text_3328"))
	self:removeFromParent()
end
function PyramidPlayoffsSignUp:signUpErrBack(target, redata)
	print("报名失败")
	self:req4Info()
	self:checkInTime()
end
function PyramidPlayoffsSignUp:btnSignUpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.btnSignUp:isBright() then
			_ENV = nil
			;(nil).count = 3
			SoraDShowMsgTip(i18n("common_text_4004", nil))
			return
		end
		local _ENV, selectNumList = SoraDShowMsgTip, SoraDShowMsgTip
		for i, v in ipairs(self.selectSingle) do
			if v:returnSelect() then
				table.insert(selectNumList, v:returnIndexNum())
			end
		end
		if #selectNumList == 3 then
			SoraDShowMsgBox(i18n("common_text_3694"), i18n("common_text_204"), nil, function(eventType, target)
				if eventType == MSGBOX_CALLBACK_YES and self.checkRight() then
					local gametop = gModuleMgr.getObject("gametop")
					local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
					pyramidWarCtrl:postSeasonApplyReq(selectNumList)
					dump(selectNumList, "selectNumList")
				end
			end)
		else
			_ENV = nil
			;(nil).count = 3
			SoraDShowMsgTip(i18n("common_text_4004", nil))
		end
	end
end
return PyramidPlayoffsSignUp

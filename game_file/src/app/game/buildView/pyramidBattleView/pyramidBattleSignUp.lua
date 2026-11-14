local PyramidBattleSignUp = class("pyramidBattleSignUp", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleSignUp")
	end
	return target
end)
function PyramidBattleSignUp:ctor()
	self.jointNumBack = false
	self.maxAlliance = 0
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_signUp")
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	self.btnSignUp = SoraDGetChildByName(self, "Button_signUp")
	self.txtContent = SoraDGetChildByName(self, "Text_content")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTip:setString(i18n("common_text_3325"))
	self.txtContent:setString(i18n("common_text_3324"))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	local titleOCX = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramidSignUp")
	titleOCX:setTitle(i18n("common_text_3323"))
	titleOCX:setTitleSize()
	self.btnSignUp:setPressedActionEnabled(true)
	self.btnSignUp:setTitleText(i18n("common_text_3315"))
	self.btnSignUp:setBright(false)
	self.btnSignUp:addTouchEventListener(handler(self, self.btnSignUpClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_APPLYTIMEBACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SIGNUPSUCCESS", handler(self, self.signUpBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_SIGNUPFAIL", handler(self, self.signUpErrBack))
	self:createSingleClass()
	self:initTimeRange()
	self:req4Info()
end
function PyramidBattleSignUp:endShow()
	self:checkInTime()
end
function PyramidBattleSignUp:initTimeRange(...)
	local pyramidWarltCtrl = include("pyramidWarltCtrl")
	local timeList = pyramidWarltCtrl.getMatchtimeList()
	dump(timeList, "timeList")
	self.singleTbl, _ENV = dump, dump
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, #timeList * 115)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local unSelect = function()
		for k, v in pairs(self.singleTbl) do
			v:setValue(false)
		end
		self.btnSignUp:setBright(true)
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
function PyramidBattleSignUp:req4Info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	self.maxAlliance = pyramidWarCtrl:getRegularSeasonApplyMaxAllianceNum()
	pyramidWarCtrl:regularSeasonGetApplyInfoReq()
end
function PyramidBattleSignUp:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "initData")
	self.allianceCountInfo = redata.info.retdata
	self:initView()
end
function PyramidBattleSignUp:initView(...)
	local curIndex = 0
	if next(self.allianceCountInfo) then
		for i, v in pairs(self.singleTbl) do
			local curNum = v:returnIndexNum()
			print("curNum = ", curNum)
			if self.allianceCountInfo[tostring(curNum)] then
				v:setAllianceCount(self.allianceCountInfo[tostring(curNum)], self.maxAlliance)
				if self.allianceCountInfo[tostring(curNum)] < self.maxAlliance and curIndex <= 0 then
					curIndex = i
				end
			end
		end
	else
		return
	end
	self.jointNumBack = true
end
function PyramidBattleSignUp:checkInTime(...)
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local mainState = pyramidWarCtrl.regularSeasonState
	local allianceState = pyramidWarCtrl.regularSeasonAllianceState
	local nowTimeLeft = pyramidWarCtrl:getLeftTime(mainState)
	if gRegularSeasonState.APPLY_ING == mainState and gRegularSeasonAllianceState.NOT_APPLY == allianceState then
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
function PyramidBattleSignUp:createSingleClass()
	self.singleClass = class("PyramidBattleSignUpSingle", function()
		local target = self.copyItem:clone()
		return target
	end)
	function self.singleClass:ctor()
		self.joinLord = 0
		self.txtNum = self:getChildByName("Text_num")
		self.txtTime = self:getChildByName("Text_rangeTime")
		self.txtAllianceCount = self:getChildByName("Text_allianceCount")
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
				self.singleCb()
			end
			self:setValue(true)
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
function PyramidBattleSignUp.checkRight(...)
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
			SoraDShowMsgTip(i18n("common_text_3252"))
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
	if ret and gRegularSeasonState.APPLY_ING ~= pyramidWarCtrl.regularSeasonState then
		ret = false
	end
	if ret and gRegularSeasonAllianceState.APPLY_ED == pyramidWarCtrl.regularSeasonAllianceState then
		ret = false
		SoraDShowMsgTip(i18n("common_text_3255"))
	end
	if ret then
		local myAid = allianceMgr:getOwnAid()
		if not pyramidWarCtrl:isCanApplyByAid(myAid) then
			ret = false
			SoraDShowMsgTip(i18n("common_text_3254"))
		end
	end
	if ret then
		local objAlliance = allianceMgr:getAlliance()
		local createTime = objAlliance:getProperty("creatTime")
		if serviceFunctions.systemTime() - createTime < ALLIANCE_CREATETIME_MIN then
			ret = false
			SoraDShowMsgTip(i18n("common_text_3253"))
		end
	end
	return ret
end
function PyramidBattleSignUp:signUpBack(target, redata)
	SoraDCloseLoading(self)
	SoraDShowMsgTip(i18n("common_text_3328"))
	self:removeFromParent()
end
function PyramidBattleSignUp:signUpErrBack(target, redata)
	print("报名失败")
	self:req4Info()
end
function PyramidBattleSignUp:btnSignUpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.jointNumBack then
			return
		end
		local selectNum = 0
		for k, v in pairs(self.singleTbl) do
			if v:returnSelect() then
				selectNum = v:returnIndexNum()
				if v:getAllianceCount() >= self.maxAlliance then
					selectNum = -1
				end
			end
		end
		if 0 < selectNum then
			SoraDShowMsgBox(i18n("common_text_3694"), i18n("common_text_204"), nil, function(eventType, target)
				if eventType == MSGBOX_CALLBACK_YES and self.checkRight() then
					SoraDShowLoading(self)
					local gametop = gModuleMgr.getObject("gametop")
					local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
					pyramidWarCtrl:regularSeasonApplyReq(selectNum)
					print("selectNum = ", selectNum)
				end
			end)
		elseif selectNum == 0 then
			SoraDShowMsgTip(i18n("common_text_3330"))
		elseif selectNum == -1 then
			SoraDShowMsgTip(i18n("common_text_3256"))
		end
	end
end
return PyramidBattleSignUp

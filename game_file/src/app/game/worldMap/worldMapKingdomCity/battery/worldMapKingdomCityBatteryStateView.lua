local GridScrollView = include("GridScrollView")
local kingdomMapUtil = include("kingdomMapUtil")
local nationalFlagRead = include("nationalFlagRead")
local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local WorldMapKingdomCityBatteryStateView = class("worldMapKingdomCityBatteryStateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapKingdomCityBatteryStateView")
	end
	return target
end)
function WorldMapKingdomCityBatteryStateView:ctor()
	self.flagTabs = 0
	self.timerCount = 0
	self.recordTable, _ENV, self.timer = nil, nil, nil
	self.famousTable, _ENV, self.nextRecord = nil, nil, 1
	self.integralTable, _ENV, self.myKingInfo, _ENV, self.myPlaceInfo, _ENV, self.nextFamous = nil, nil, nil, nil, nil, nil, 1
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.btnRecord = SoraDGetChildByName(self, "Button_record")
	self.btnFamous = SoraDGetChildByName(self, "Button_famousRoom")
	self.btnIntegral = SoraDGetChildByName(self, "Button_integral")
	self.btnGift = SoraDGetChildByName(self, "Button_gift")
	self.rScroll = SoraDGetChildByName(self, "ScrollView_listRecord")
	self.fScroll = SoraDGetChildByName(self, "ScrollView_listFamous")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtExplain = SoraDGetChildByName(self, "Text_explain")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.nodeOccupy = SoraDGetChildByName(self, "Center_Node_occupyInfo")
	self.nodeOccupyDes = SoraDGetChildByName(self, "Node_des")
	self.nodeOccupyTime = SoraDGetChildByName(self, "Node_occupyTime")
	self.Node_troop = SoraDGetChildByName(self.nodeOccupyDes, "Node_troop")
	self.Node_allianceFlag = SoraDGetChildByName(self.nodeOccupyDes, "Node_allianceFlag")
	self.Node_lord = SoraDGetChildByName(self.nodeOccupyDes, "Node_lord")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.txtWarn:setVisible(false)
	self.imgType = SoraDGetChildByName(self, "Image_type")
	self.txtType = SoraDGetChildByName(self, "Text_type")
	self.txtAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Button_FlagTouch = SoraDGetChildByName(self, "Button_FlagTouch")
	self.imgPlayerHead = SoraDGetChildByName(self, "Image_playerHead")
	self.imgPlayerHead:setTouchEnabled(true)
	self.spInBattle = SoraDGetChildByName(self, "Sprite_inBattle")
	self.troopCount = SoraDGetChildByName(self, "Text_power")
	self.txtPlayer = SoraDGetChildByName(self, "Text_player")
	self.imgListIntegral = SoraDGetChildByName(self, "Image_listIntegralTitle")
	self.iScroll = SoraDGetChildByName(self, "ScrollView_listIntegral")
	self.imgPlayerHead:addTouchEventListener(handler(self, self.btnPlayerHeadClick))
	self.Button_FlagTouch:setTouchEnabled(false)
	self.Button_FlagTouch:addTouchEventListener(handler(self, self.btnFlagClick))
	self.txtContinueOccuypTime = self.nodeOccupyTime:getChildByName("Text_continueTime")
	self.txtTotalOccuypTime = self.nodeOccupyTime:getChildByName("Text_totalOccupyTime")
	self.txtContinueOccuypTime = SoraDCreateTimerLabel(self, self.txtContinueOccuypTime)
	self.txtTotalOccuypTime = SoraDCreateTimerLabel(self, self.txtTotalOccuypTime)
	self.txtContinueOccuypTime:setColor(cc.c3b(0, 200, 0))
	self.txtTotalOccuypTime:setColor(cc.c3b(0, 200, 0))
	self.btnRecord:setTitleText(i18n("common_text_836"))
	self.btnFamous:setTitleText(i18n("common_text_837"))
	self.btnIntegral:setTitleText(i18n("common_text_2719"))
	self.btnGift:setTitleText(i18n("kindofwar_btn_01"))
	SoraDAutoSizeButtonText(self.btnRecord)
	SoraDAutoSizeButtonText(self.btnFamous)
	SoraDAutoSizeButtonText(self.btnIntegral)
	SoraDAutoSizeButtonText(self.btnGift)
	self.txtExplain:setString(i18n("common_text_1215"))
	self.txtTime:setString(i18n("common_text_699"))
	SoraDGetChildByName(self, "Text_intIntegral"):setString(i18n("common_text_1764"))
	SoraDGetChildByName(self, "Text_integralAlliance"):setString(i18n("common_text_171"))
	SoraDGetChildByName(self, "Text_integralRank"):setString(i18n("common_text_2193"))
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.rScroll = GridScrollView.new(self.rScroll)
	_ENV = self.txtTime
	self.txtTime.col = 1
	self.txtTime.h = 30
	self.txtTime.top = 30
	self.rScroll:init(self.txtTime, 0, handler(self, self.reTimeText), handler(self, self.refreshRecord))
	self.fScroll = GridScrollView.new(self.fScroll)
	_ENV = self.txtTime
	self.txtTime.col = 1
	self.fScroll:init(self.txtTime, 0, handler(self, self.reKingText), handler(self, self.refreshFamous))
	self.iScroll = GridScrollView.new(self.iScroll)
	_ENV = self.txtTime
	self.txtTime.col = 1
	self.iScroll:init(self.txtTime, 0, handler(self, self.reIntegralSingle), handler(self, self.refreshIntegral))
	self.rScroll:addEventListener(handler(self, self.rScrollEventCallBack))
	self.fScroll:addEventListener(handler(self, self.fScrollEventCallBack))
	self.iScroll:addEventListener(handler(self, self.iScrollEventCallBack))
	self:switchToMain(true)
	self.btnIntegral:addTouchEventListener(handler(self, self.btnIntegralClick))
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	self.btnFamous:addTouchEventListener(handler(self, self.btnFamousClick))
	self.btnGift:addTouchEventListener(handler(self, self.btnGiftClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
end
function WorldMapKingdomCityBatteryStateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE", handler(self, self.updatePalace))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_KING", handler(self, self.updateKing))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_ALLIANCEINTEGRAL", handler(self, self.updateIngegral))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_OCCUPYTIME", handler(self, self.updateOccupy))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.reqForStateInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACECHANGE", handler(self, self.occupyChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED", handler(self, self.reflashCurKingdomFlag))
end
function WorldMapKingdomCityBatteryStateView:refreshOccupyNode(...)
	local showOcuppyInfo = function(hideNum)
		self.nodeOccupyDes:setVisible(true)
		self.imgType:setVisible(false)
		self:delWarnText()
		local occupyUsrData = self.myPlaceInfo
		if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
			self.txtType:setString(i18n("common_text_1426"))
			self.txtType:setPositionY(-70)
			if occupyUsrData.abbr then
				self.txtAlliance:setString(occupyUsrData.abbr)
			else
				self.txtAlliance:setString(i18n("common_text_480"))
			end
			self.txtPlayer:setString(occupyUsrData.name)
			if occupyUsrData.flag then
				self.Node_flag:removeAllChildren()
				SoraDGetAllianceFlagByFid(occupyUsrData.flag):addTo(self.Node_flag)
				self.Button_FlagTouch:setTouchEnabled(true)
			else
				self.Node_flag:removeAllChildren()
				SoraDGetAllianceFlagByFid():addTo(self.Node_flag)
				self.Button_FlagTouch:setTouchEnabled(false)
			end
			SoraDGetHeadFromManager(self.imgPlayerHead, occupyUsrData.iconID, occupyUsrData.avatar)
			local curNum = kingdomMapUtil.getArmyCount(self.argList.armyData)
			if not hideNum and self.argList.armyData and curNum and occupyUsrData.maxNum then
				self.troopCount:setString(curNum .. "/" .. occupyUsrData.maxNum)
				self.Node_troop:setVisible(true)
			else
				self.Node_troop:setVisible(false)
			end
		else
			self.nodeOccupyDes:setVisible(false)
			self:addWarnText(i18n("common_text_1450"))
		end
	end
	local showKingInfo = function()
		self.nodeOccupyDes:setVisible(true)
		self.imgType:setVisible(true)
		self.txtType:setString(i18n("official_name_1"))
		self.txtType:setPositionY(-90)
		self.Node_troop:setVisible(false)
		self:delWarnText()
		local kingData = KWKingdomCtrl:getKingInfo()
		self.myKingInfo = kingData
		if kingData.kingUid and kingData.kingUid > 0 then
			if kingData.kingAbbr then
				self.txtAlliance:setString(kingData.kingAbbr)
			else
				self.txtAlliance:setString(i18n("common_text_480"))
			end
			self.txtPlayer:setString(kingData.kingName)
			if kingData.kingFlag and type(kingData.kingFlag) == "number" then
				self.Node_flag:removeAllChildren()
				SoraDGetAllianceFlagByFid(kingData.kingFlag):addTo(self.Node_flag)
				self.Button_FlagTouch:setTouchEnabled(true)
			else
				self.Node_flag:removeAllChildren()
				SoraDGetAllianceFlagByFid():addTo(self.Node_flag)
				self.Button_FlagTouch:setTouchEnabled(false)
			end
			SoraDGetHeadFromManager(self.imgPlayerHead, kingData.kingIcon, kingData.kingAvatar)
		else
			showOcuppyInfo(true)
		end
	end
	local judgeInPeace = function(bool)
		if bool then
			self.spInBattle:setSpriteFrame("3007.png")
			self.spInBattle:setScale(0.4)
		else
			self.spInBattle:setSpriteFrame("icon_alliancewar_attacker.png")
			self.spInBattle:setScale(0.8)
		end
	end
	self.kingWarState = self.myPlaceInfo.warStatus
	if gKingdomWarStatusType.inWar == self.kingWarState then
		showOcuppyInfo()
		self.txtExplain:setString(i18n("common_text_1214"))
		self.txtTime:setColor(cc.c3b(200, 0, 0))
		self.txtExplain:setColor(cc.c3b(200, 0, 0))
		judgeInPeace(false)
	elseif gKingdomWarStatusType.rule == self.kingWarState then
		showKingInfo()
		self.txtExplain:setString(i18n("common_text_1213"))
		judgeInPeace(true)
		self.txtTime:setColor(cc.c3b(0, 200, 0))
		self.txtExplain:setColor(cc.c3b(0, 200, 0))
	elseif gKingdomWarStatusType.close == self.kingWarState then
		self.nodeOccupyDes:setVisible(false)
		self:addWarnText(i18n("common_text_841"))
		self.txtExplain:setString(i18n("common_text_1215"))
		judgeInPeace(true)
		self.txtTime:setColor(cc.c3b(0, 200, 0))
		self.txtExplain:setColor(cc.c3b(0, 200, 0))
	end
	local isShowState = self.myPlaceInfo.showWarStatusTime
	print("isShowState=", isShowState)
	if isShowState then
		self.txtExplain:setVisible(true)
		self.spInBattle:setVisible(true)
		print("self.myPlaceInfo.hostKid = ", self.myPlaceInfo.hostKid)
		print("worldMapDefine.currentMapKindomID = ", worldMapDefine.currentMapKindomID)
		if gKingdomWarStatusType.inWar == self.kingWarState and self.myPlaceInfo.hostKid and 0 < self.myPlaceInfo.hostKid and self.myPlaceInfo.hostKid ~= worldMapDefine.currentMapKindomID then
			self.nodeOccupyTime:setVisible(true)
			self.txtTime:setVisible(false)
			self:showOccupyTime()
		else
			self.nodeOccupyTime:setVisible(false)
			self.txtTime:setVisible(true)
			local coolTime = self:getWarStatusTime()
			print(coolTime, "coolTime")
			if 0 < coolTime then
				self.txtTime:beginTime(coolTime)
			end
		end
	else
		self.txtExplain:setVisible(false)
		self.spInBattle:setVisible(false)
		self.nodeOccupyTime:setVisible(false)
		self.txtTime:setVisible(false)
	end
	self:updateBtnStatus()
end
function WorldMapKingdomCityBatteryStateView:updateBtnStatus()
	local kid = worldMapDefine.currentMapKindomID
	local kingdomId = gametop.playertop_:getMapID()
	if kid and kid ~= kingdomId then
		self.btnRecord:setVisible(false)
		self.btnIntegral:setVisible(false)
		self.btnGift:setVisible(true)
		self.btnFamous:setVisible(true)
		self.btnGift:setContentSize(cc.size(286, 70))
		self.btnGift:setPositionX(SoraDFPosX(-143, 0))
		self.btnFamous:setContentSize(cc.size(286, 70))
		self.btnFamous:setPositionX(SoraDFPosX(143, 0))
	else
		self:judgeIsConquest()
	end
end
function WorldMapKingdomCityBatteryStateView:getWarStatusTime()
	local warStatusTime = self.myPlaceInfo.warStatusTime or 0
	return warStatusTime
end
function WorldMapKingdomCityBatteryStateView:showOccupyTime()
	if self.myPlaceInfo.occupyTime and self.myPlaceInfo.occupyTotalTime then
		self.continueOccuypTime = self.myPlaceInfo.occupyTime - 1
		self.totalOccuypTime = self.myPlaceInfo.occupyTotalTime - 1
		self.txtContinueOccuypTime:endTime()
		self.txtTotalOccuypTime:endTime()
		self.txtContinueOccuypTime:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("worldwar_text_08", nil)
		end)
		self.txtTotalOccuypTime:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("common_text_4248", nil)
		end)
		self.txtContinueOccuypTime:beginTimeNode(function(...)
			self.continueOccuypTime = self.continueOccuypTime + 1
			return self.continueOccuypTime
		end)
		self.txtTotalOccuypTime:beginTimeNode(function(...)
			self.totalOccuypTime = self.totalOccuypTime + 1
			return self.totalOccuypTime
		end)
	end
end
function WorldMapKingdomCityBatteryStateView:occupyChange(...)
	if gMapObjTypeDef.mapObjTypeCastale == self.argList.instanceType then
		self:initView()
	end
end
function WorldMapKingdomCityBatteryStateView:initData(argList)
	if argList then
		self.argList = argList
		if gMapObjTypeDef.mapObjTypeCastale == argList.instanceType then
			self.argList.place = i18n("common_text_839")
			self.txtTitle:setString(i18n("common_text_839"))
		elseif gMapObjTypeDef.mapObjTypeBattery == argList.instanceType then
			self.argList.place = i18n("common_text_840")
			self.txtTitle:setString(i18n("common_text_840"))
		elseif gMapObjTypeDef.mapObjTypeFortress == argList.instanceType then
			self.argList.place = i18n("common_text_2859")
			self.txtTitle:setString(i18n("common_text_2859"))
		end
	end
	self:initView()
end
function WorldMapKingdomCityBatteryStateView:reqForStateInfo(target, data)
	if data and data.retdata then
		self.reqMsg = false
		if not data.retdata then
			_ENV = data.retdata
		end
		self.myPlaceInfo = data.retdata
		dump(self.myPlaceInfo, "self.myPlaceInfo===========")
		self:refreshOccupyNode()
		SoraDCloseLoading(self)
	end
end
function WorldMapKingdomCityBatteryStateView:initView(target, data)
	if not self.reqMsg then
		self.reqMsg = true
		self.nodeOccupyDes:setVisible(false)
		SoraDShowLoading(self)
		kingdomMapCtrl:getPlaceOwnerInfo(self.argList.uPos.x, self.argList.uPos.y)
	end
end
function WorldMapKingdomCityBatteryStateView:changeIntegral2occupy(bool)
	if bool then
		self.btnIntegral:addTouchEventListener(handler(self, self.btnOccupyTimeClick))
		self.btnIntegral:setTitleText(i18n("worldwar_text_07"))
		SoraDGetChildByName(self, "Text_intIntegral"):setString(i18n("common_text_289"))
	else
		self.btnIntegral:addTouchEventListener(handler(self, self.btnIntegralClick))
		self.btnIntegral:setTitleText(i18n("common_text_2719"))
		SoraDGetChildByName(self, "Text_intIntegral"):setString(i18n("common_text_1764"))
	end
end
function WorldMapKingdomCityBatteryStateView:judgeIsConquest(...)
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isInConquestWar = gConquestWarState.OPENING == conquestWarCtrl:getConquestWarState()
	if isInConquestWar then
		self.btnIntegral:setVisible(true)
		self.btnGift:setVisible(true)
		self.btnRecord:setVisible(true)
		self.btnFamous:setVisible(true)
		self.btnIntegral:setContentSize(cc.size(143, 70))
		self.btnIntegral:setPositionX(SoraDFPosX(208, 0))
		self.btnGift:setContentSize(cc.size(143, 70))
		self.btnGift:setPositionX(SoraDFPosX(69, 0))
		self.btnRecord:setContentSize(cc.size(143, 70))
		self.btnRecord:setPositionX(SoraDFPosX(-69, 0))
		self.btnFamous:setContentSize(cc.size(143, 70))
		self.btnFamous:setPositionX(SoraDFPosX(-208, 0))
		if gMapObjTypeDef.mapObjTypeCastale == self.argList.instanceType then
			self:changeIntegral2occupy(true)
		else
			self:changeIntegral2occupy(false)
		end
	elseif gKingdomWarStatusType.close == self.kingWarState then
		self.btnIntegral:setVisible(false)
		self.btnRecord:setVisible(false)
		self.btnFamous:setVisible(false)
		self.btnGift:setVisible(true)
		self.btnGift:setContentSize(cc.size(560, 70))
		self.btnGift:setPositionX(0)
	else
		self.btnIntegral:setVisible(true)
		self.btnGift:setVisible(true)
		self.btnRecord:setVisible(true)
		self.btnFamous:setVisible(true)
		self.btnIntegral:setContentSize(cc.size(143, 70))
		self.btnIntegral:setPositionX(SoraDFPosX(208, 0))
		self.btnGift:setContentSize(cc.size(143, 70))
		self.btnGift:setPositionX(SoraDFPosX(69, 0))
		self.btnRecord:setContentSize(cc.size(143, 70))
		self.btnRecord:setPositionX(SoraDFPosX(-69, 0))
		self.btnFamous:setContentSize(cc.size(143, 70))
		self.btnFamous:setPositionX(SoraDFPosX(-208, 0))
		self:changeIntegral2occupy(false)
	end
end
function WorldMapKingdomCityBatteryStateView:updatePalace(target, retdate)
	local nums = table.nums(retdate.retdate)
	if 0 < nums then
		self.nextRecord = self.nextRecord + table.nums(retdate.retdate)
		for _, v in ipairs(retdate.retdate) do
			table.insert(self.recordTable, v)
		end
		self.rScroll:updateNum(table.nums(self.recordTable))
	end
	if self.nextRecord == 1 and nums <= 0 then
		self:addNoRecordText(i18n("common_text_1464"), self.rScroll)
	else
		self:delNoRecordText(self.rScroll)
	end
	SoraDCloseLoading(self)
end
function WorldMapKingdomCityBatteryStateView:updateKing(target, retdate)
	local nums = table.nums(retdate.retdate)
	if 0 < nums then
		self.nextFamous = self.nextFamous + table.nums(retdate.retdate)
		for _, v in ipairs(retdate.retdate) do
			v.kid = retdate.data.kid
			table.insert(self.famousTable, v)
		end
		self.fScroll:updateNum(table.nums(self.famousTable))
	end
	if self.nextFamous == 1 and table.nums(retdate.retdate) <= 0 then
		self:addNoRecordText(i18n("common_text_1464"), self.fScroll)
	else
		self:delNoRecordText(self.fScroll)
	end
	SoraDCloseLoading(self)
end
function WorldMapKingdomCityBatteryStateView:updateIngegral(target, retdate)
	self.integralTable, _ENV = nil, nil
	if retdate.retdate then
		for _, v in ipairs(retdate.retdate) do
			table.insert(self.integralTable, v)
		end
		if table.nums(retdate.retdate) <= 0 then
			self:addNoRecordText(i18n("common_text_1464"), self.iScroll)
		else
			self:delNoRecordText(self.iScroll)
			self.iScroll:updateNum(table.nums(self.integralTable))
		end
	else
		self:delNoRecordText(self.iScroll)
		if self.kingWarState and gKingdomWarStatusType.close == self.kingWarState then
			self:addNoRecordText(i18n("common_text_699"), self.iScroll)
		else
			self:addNoRecordText(i18n("common_text_2764"), self.iScroll)
		end
		self.iScroll:updateNum(0)
	end
	SoraDCloseLoading(self)
end
function WorldMapKingdomCityBatteryStateView:updateOccupy(target, retdate)
	self.integralTable, _ENV = nil, nil
	dump(retdate, "retdate", 10)
	if retdate.retdate then
		for _, v in ipairs(retdate.retdate) do
			table.insert(self.integralTable, v)
		end
		if table.nums(retdate.retdate) <= 0 then
			self:addNoRecordText(i18n("common_text_1464"), self.iScroll)
		else
			self:delNoRecordText(self.iScroll)
			self.iScroll:updateNum(table.nums(self.integralTable))
		end
	else
		self:delNoRecordText(self.iScroll)
		if self.kingWarState and gKingdomWarStatusType.close == self.kingWarState then
			self:addNoRecordText(i18n("common_text_699"), self.iScroll)
		else
			self:addNoRecordText(i18n("common_text_2764"), self.iScroll)
		end
		self.iScroll:updateNum(0)
	end
	SoraDCloseLoading(self)
end
function WorldMapKingdomCityBatteryStateView:reflashCurKingdomFlag()
	if self.curKindom then
		local flagImg = nationalFlagRead.getImgByID(KWKingdomCtrl:getKingdomFlag())
		self.curKindom:getChildByName("Image_flag"):loadTexture(flagImg, ccui.TextureResType.plistType)
	end
end
function WorldMapKingdomCityBatteryStateView:refreshRecord(single, index)
	local text_content = single:getChildByName("Text_content")
	self:reRecordText(self.recordTable[index], text_content)
	single:getChildByName("Text_time"):setString(SoraDConvertTimeToDate(self.recordTable[index].time, false, true))
end
function WorldMapKingdomCityBatteryStateView:refreshFamous(single, index)
	local defaultColor = cc.c3b(200, 170, 150)
	if 1 == index then
		defaultColor = cc.c3b(255, 165, 0)
		self.curKindom = single
	end
	single:getChildByName("Text_name"):setColor(defaultColor)
	single:getChildByName("Text_turn"):setColor(defaultColor)
	single:getChildByName("Text_time"):setColor(defaultColor)
	local allianceName = self.famousTable[index].abbr and "(" .. self.famousTable[index].abbr .. ")" or ""
	single:getChildByName("Text_name"):setString(allianceName .. self.famousTable[index].name)
	_ENV = nil
	;(nil).num = self.famousTable[index].term
	single:getChildByName("Text_turn"):setString(i18n("common_text_1216", nil))
	_ENV = i18n("common_text_1216", nil)
	i18n("common_text_1216", nil).time = SoraDConvertTimeToDate(self.famousTable[index].time, false, true)
	single:getChildByName("Text_time"):setString(i18n("common_text_1217", i18n("common_text_1216", nil)))
	SoraDGetHeadFromManager(SoraDGetChildByName(single, "Image_head"), self.famousTable[index].icon, self.famousTable[index].avatar)
	single:getChildByName("Button_showInfo"):addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			_ENV = index
			index.targetName = "WorldMapKingdomCityBatteryStateView"
			lordInfoCtrl:getLordInfoByUid(self.famousTable[index].uid, self.famousTable[index].kid, index)
		end
	end)
	local imgFlag = single:getChildByName("Image_flag")
	if not self.famousTable[index].kingdomFlag then
		imgFlag:setVisible(false)
	else
		local flagImg = nationalFlagRead.getImgByID(self.famousTable[index].kingdomFlag)
		imgFlag:loadTexture(flagImg, ccui.TextureResType.plistType)
		imgFlag:setVisible(true)
	end
end
function WorldMapKingdomCityBatteryStateView:refreshIntegral(single, index)
	if self.integralTable[index].score then
		single:getChildByName("Text_int"):setString(self.integralTable[index].score)
	else
		single:getChildByName("Text_int"):setString(SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime))
	end
	_ENV = SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime)
	SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime).abbr = self.integralTable[index].abbr
	SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime).name = self.integralTable[index].aName
	single:getChildByName("Text_alliance"):setString(i18n("common_text_186", SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime)))
	_ENV = i18n("common_text_186", SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime))
	i18n("common_text_186", SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime)).name = self.integralTable[index].leaderName
	single:getChildByName("Text_lord"):setString(i18n("common_text_926", i18n("common_text_186", SoraDConvertSecondToString(self.integralTable[index].occupyTotalTime))))
	local Node_singleflag = single:getChildByName("Node_singleflag")
	Node_singleflag:removeAllChildren()
	SoraDGetAllianceFlagByFid(self.integralTable[index].flag):addTo(Node_singleflag)
	if index <= 3 then
		single:getChildByName("Text_num"):setVisible(false)
		single:getChildByName("Image_num"):setVisible(true)
		single:getChildByName("Image_num"):loadTexture("icon_ranking_" .. index .. ".png", ccui.TextureResType.plistType)
		single:getChildByName("Image_levelBg"):loadTexture("frame_alliance_pank_0" .. index .. ".png", ccui.TextureResType.plistType)
		single:getChildByName("Text_num"):setColor(cc.c3b(255, 200, 100))
		single:getChildByName("Text_int"):setColor(cc.c3b(255, 200, 100))
		single:getChildByName("Text_alliance"):setColor(cc.c3b(255, 200, 100))
		single:getChildByName("Text_lord"):setColor(cc.c3b(255, 200, 100))
	else
		single:getChildByName("Text_num"):setVisible(true)
		single:getChildByName("Text_num"):setString(index)
		single:getChildByName("Image_num"):setVisible(false)
		single:getChildByName("Image_levelBg"):loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		single:getChildByName("Text_num"):setColor(cc.c3b(175, 175, 175))
		single:getChildByName("Text_int"):setColor(cc.c3b(175, 175, 175))
		single:getChildByName("Text_alliance"):setColor(cc.c3b(175, 175, 175))
		single:getChildByName("Text_lord"):setColor(cc.c3b(175, 175, 175))
	end
end
function WorldMapKingdomCityBatteryStateView:addNoRecordText(text, parent)
	print("加文字啦！")
	if not parent:getChildByName("Text_warningTxt") then
		local tmpTxt = ccui.Text:create(text, "", 24)
		tmpTxt:setColor(display.COLOR_RED)
		tmpTxt:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		tmpTxt:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		tmpTxt:setAnchorPoint(cc.p(0.5, 0.5))
		tmpTxt:setPosition(parent:getContentSize().width / 2, parent:getContentSize().height / 2)
		tmpTxt:ignoreContentAdaptWithSize(false)
		tmpTxt:setTextAreaSize(cc.size(400, 350))
		tmpTxt:setName("Text_warningTxt")
		tmpTxt:addTo(parent, 99)
	else
		parent:getChildByName("Text_warningTxt"):setVisible(true)
		parent:getChildByName("Text_warningTxt"):setString(text)
	end
end
function WorldMapKingdomCityBatteryStateView:delNoRecordText(parent)
	if parent:getChildByName("Text_warningTxt") then
		parent:getChildByName("Text_warningTxt"):setVisible(false)
	end
end
function WorldMapKingdomCityBatteryStateView:addWarnText(text)
	self.txtWarn:setVisible(true)
	self.txtWarn:setString(text)
end
function WorldMapKingdomCityBatteryStateView:delWarnText(...)
	if self.txtWarn then
		self.txtWarn:setVisible(false)
	end
end
function WorldMapKingdomCityBatteryStateView:reTimeText()
	local sSize = cc.size(376, 365)
	local imgBg = ccui.ImageView:create("frame_alliance_note.png", ccui.TextureResType.plistType)
	imgBg:setScale9Enabled(true)
	imgBg:setContentSize(cc.size(sSize.width, 75))
	imgBg:setAnchorPoint(cc.p(0, 0))
	local frmText = ccui.Text:create("", "", 16)
	frmText:ignoreContentAdaptWithSize(false)
	frmText:setTextAreaSize(cc.size(sSize.width - 30, 65))
	frmText:setColor(cc.c3b(55, 125, 80))
	frmText:setAnchorPoint(cc.p(0, 0))
	frmText:setPosition(15, 12)
	frmText:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	frmText:setTextHorizontalAlignment(SoraDFLabelR())
	frmText:setName("Text_content")
	frmText:addTo(imgBg)
	local timeText = ccui.Text:create("", "", 18)
	timeText:setColor(cc.c3b(113, 113, 113))
	timeText:setPosition((sSize.width - 20) / 2, 90)
	timeText:setName("Text_time")
	timeText:addTo(imgBg)
	SoraDFTarget(timeText)
	SoraDFTarget(frmText)
	return imgBg
end
function WorldMapKingdomCityBatteryStateView:reRecordText(data, text_content)
	local type = data.logType
	local reText = ""
	if data.aAbbr then
		_ENV = nil
		;(nil).name = data.aName
		;(nil).abbr = data.aAbbr
		if i18n("common_text_186", nil) then
			goto lbl_17
		end
	end
	local aName = data.aName
	::lbl_17::
	if aName and data.aSourceKid and 0 ~= data.aSourceKid then
		aName = aName .. "#" .. tostring(data.aSourceKid)
	end
	if data.dAbbr then
		_ENV = tostring(data.aSourceKid)
		tostring(data.aSourceKid).name = data.dName
		tostring(data.aSourceKid).abbr = data.dAbbr
		if i18n("common_text_186", (tostring(data.aSourceKid))) then
			goto lbl_45
		end
	end
	local dName = data.dName
	::lbl_45::
	if dName and data.dSourceKid and 0 ~= data.dSourceKid then
		dName = dName .. "#" .. tostring(data.dSourceKid)
	end
	local sourceKid = data.aSourceKid
	if gPlaceLogType.occupy == type then
		_ENV = data.dSourceKid
		data.dSourceKid.name = aName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1200", data.dSourceKid)
	elseif gPlaceLogType.attackOccupy == type then
		_ENV = data.dSourceKid
		data.dSourceKid.attack = aName
		data.dSourceKid.defend = dName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1201", data.dSourceKid)
	elseif gPlaceLogType.defendOccupy == type then
		_ENV = data.dSourceKid
		data.dSourceKid.attack = aName
		data.dSourceKid.defend = dName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1198", data.dSourceKid)
		sourceKid = data.dSourceKid
	elseif gPlaceLogType.massOccupy == type then
		_ENV = data.dSourceKid
		data.dSourceKid.name = aName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1200", data.dSourceKid)
	elseif gPlaceLogType.massAttackOccupy == type then
		_ENV = data.dSourceKid
		data.dSourceKid.attack = aName
		data.dSourceKid.defend = dName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1202", data.dSourceKid)
	elseif gPlaceLogType.massDefendOccupy == type then
		_ENV = data.dSourceKid
		data.dSourceKid.attack = aName
		data.dSourceKid.defend = dName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1421", data.dSourceKid)
		sourceKid = data.dSourceKid
	elseif gPlaceLogType.help == type then
		_ENV = data.dSourceKid
		data.dSourceKid.name = aName
		data.dSourceKid.place = self.argList.place
		reText = i18n("common_text_1199", data.dSourceKid)
	end
	local color = display.COLOR_WHITE
	if sourceKid and 0 ~= sourceKid then
		local kid = worldMapDefine.currentMapKindomID
		if kid ~= sourceKid then
			color = cc.c3b(190, 40, 40)
		end
	end
	text_content:setColor(color)
	text_content:setString(reText)
end
function WorldMapKingdomCityBatteryStateView:showText(bool)
	if bool then
		self:addWarnText(i18n("common_text_841"))
	else
		self:delWarnText()
	end
end
function WorldMapKingdomCityBatteryStateView:showNode(bool)
	self.nodeOccupy:setVisible(bool)
end
function WorldMapKingdomCityBatteryStateView:switchToMain(bool)
	self:showNode(bool)
	if bool then
		self.rScroll:setVisible(false)
		self.fScroll:setVisible(false)
		self.imgListIntegral:setVisible(false)
		self.flagTabs = 0
	end
end
function WorldMapKingdomCityBatteryStateView:showScroll(scroll)
	if scroll == self.rScroll then
		self.rScroll:setVisible(true)
		self.fScroll:setVisible(false)
		self.imgListIntegral:setVisible(false)
		self.flagTabs = 1
	elseif scroll == self.fScroll then
		self.rScroll:setVisible(false)
		self.fScroll:setVisible(true)
		self.imgListIntegral:setVisible(false)
		self.flagTabs = 2
	elseif scroll == self.imgListIntegral then
		self.rScroll:setVisible(false)
		self.fScroll:setVisible(false)
		self.imgListIntegral:setVisible(true)
		self.flagTabs = 3
	end
	self:switchToMain(false)
end
function WorldMapKingdomCityBatteryStateView:reIntegralSingle()
	local single = SoraDGetChildByName(self, "Image_intSIngleCopy")
	if single then
		return single:clone()
	else
		return display.newNode()
	end
end
function WorldMapKingdomCityBatteryStateView:reKingText()
	local single = SoraDGetChildByName(self, "Image_kingSIngleCopy")
	if single then
		return single:clone()
	else
		return display.newNode()
	end
end
function WorldMapKingdomCityBatteryStateView:btnRecordClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.flagTabs ~= 1 then
			SoraDShowLoading(self)
			KWKingdomCtrl:getPlaceLog(self.argList.uPos.x, self.argList.uPos.y, self.nextRecord)
			self:showScroll(self.rScroll)
		else
			self:switchToMain(true)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:btnOccupyTimeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.flagTabs ~= 3 then
			SoraDShowLoading(self)
			KWKingdomCtrl:getServiceWarOccupyRank()
			self:showScroll(self.imgListIntegral)
		else
			self:switchToMain(true)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:btnIntegralClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.flagTabs ~= 3 then
			SoraDShowLoading(self)
			KWKingdomCtrl:getKingWarScoreRank()
			self:showScroll(self.imgListIntegral)
		else
			self:switchToMain(true)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:btnFamousClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.flagTabs ~= 2 then
			SoraDShowLoading(self)
			KWKingdomCtrl:getKingLog(self.nextFamous)
			self:showScroll(self.fScroll)
		else
			self:switchToMain(true)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:btnGiftClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("worldMapKingdomCityKingGiftBag")
		_ENV = nil
		;(nil).viewType = 1
		panel:init(nil)
		panel:show()
	end
end
function WorldMapKingdomCityBatteryStateView:btnHelpClick(button, type)
	if type == ccui.TouchEventType.ended then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.KINGDOM_WAR)
	end
end
function WorldMapKingdomCityBatteryStateView:showMainMenu(recvState)
	print(recvState, "状态")
	if gKingdomWarStatusType.close == recvState then
		self.nodeOccupy:setVisible(false)
		self.txtExplain:setString(i18n("common_text_1215"))
		self:addWarnText(i18n("common_text_841"))
	elseif gKingdomWarStatusType.inWar == recvState then
		self.nodeOccupy:setVisible(true)
		self.txtExplain:setString(i18n("common_text_1214"))
		self:delWarnText()
	elseif gKingdomWarStatusType.rule == recvState then
		self.nodeOccupy:setVisible(true)
		self.txtExplain:setString(i18n("common_text_1213"))
		self:delWarnText()
	end
end
function WorldMapKingdomCityBatteryStateView:rScrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom then
		print("脱到底了", self.nextRecord)
		KWKingdomCtrl:getPlaceLog(self.argList.uPos.x, self.argList.uPos.y, self.nextRecord)
		SoraDShowLoading(self)
	end
end
function WorldMapKingdomCityBatteryStateView:fScrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom then
		print("脱到底了", self.nextFamous)
		KWKingdomCtrl:getKingLog(self.nextFamous)
		SoraDShowLoading(self)
	end
end
function WorldMapKingdomCityBatteryStateView:iScrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom then
		print("脱到底了")
	end
end
function WorldMapKingdomCityBatteryStateView:btnPlayerHeadClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local occupyUsrData = self.myPlaceInfo
		dump(occupyUsrData, "occupyUsrData=")
		if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
			local kingdomID = worldMapDefine.currentMapKindomID
			local playerID = occupyUsrData.uid
			_ENV = nil
			;(nil).targetName = "WorldMapKingdomCityBatteryStateView"
			lordInfoCtrl:getLordInfoByUid(playerID, kingdomID, nil)
		end
		local kingUsrData = self.myKingInfo
		dump(kingUsrData, "kingUsrData=")
		if next(kingUsrData) then
			local kingdomID = worldMapDefine.currentMapKindomID
			local playerID = kingUsrData.kingUid
			_ENV = nil
			;(nil).targetName = "WorldMapKingdomCityBatteryStateView"
			lordInfoCtrl:getLordInfoByUid(playerID, kingdomID, nil)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == "WorldMapKingdomCityBatteryStateView" then
			SoraDOpenLordView(data.lord)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:btnFlagClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local occupyUsrData = self.myPlaceInfo
		if occupyUsrData and occupyUsrData.aid and occupyUsrData.aid > 0 then
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = nil
			_ENV, (nil).aid = occupyUsrData.aid, occupyUsrData.aid
			occupyUsrData.aid.from = "WorldMapKingdomCityBatteryStateView"
			allianceQuery:reqAllianceByID(nil, occupyUsrData.aid)
		end
		local kingUsrData = self.myKingInfo
		if next(kingUsrData) then
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = occupyUsrData.aid
			_ENV, occupyUsrData.aid.aid = kingUsrData.kingAid, kingUsrData.kingAid
			kingUsrData.kingAid.from = "WorldMapKingdomCityBatteryStateView"
			allianceQuery:reqAllianceByID(occupyUsrData.aid, kingUsrData.kingAid)
		end
	end
end
function WorldMapKingdomCityBatteryStateView:sMsgReqInfoBack(target, data)
	if data.clientData then
		local from = data.clientData.from
		if from == "WorldMapKingdomCityBatteryStateView" then
			local alliance = data.alliance
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
return WorldMapKingdomCityBatteryStateView

local GridScrollView = include("GridScrollView")
local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local kingdomMapUtil = include("kingdomMapUtil")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local pyramidBuildingRead = include("pyramidBuildingRead")
local constantRead = include("constantRead")
local worldMapPyramidBatteryStateView = class("worldMapPyramidBatteryStateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapPyramidBatteryStateView")
	end
	return target
end)
function worldMapPyramidBatteryStateView:ctor()
	self.flagTabs = 0
	self.timerCount = 0
	self.recordTable, _ENV, self.timer = nil, nil, nil
	self.famousTable, _ENV, self.nextRecord = nil, nil, 1
	self.integralTable, _ENV, self.myPlaceInfo, _ENV, self.nextFamous = nil, nil, nil, nil, 1
	self.warStatus = gKingdomWarStatusType.close
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.btnRecord = SoraDGetChildByName(self, "Button_record")
	self.rScroll = SoraDGetChildByName(self, "ScrollView_listRecord")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtExplain = SoraDGetChildByName(self, "Text_explain")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.txtWarn:setVisible(false)
	self.nodeOccupy = SoraDGetChildByName(self, "Center_Node_occupyInfo")
	self.nodeOccupyDes = SoraDGetChildByName(self, "Node_des")
	self.Node_troop = SoraDGetChildByName(self.nodeOccupyDes, "Node_troop")
	self.txtType = SoraDGetChildByName(self, "Text_type")
	self.txtAlliance = SoraDGetChildByName(self, "Text_alliance")
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Button_FlagTouch = SoraDGetChildByName(self, "Button_FlagTouch")
	self.imgPlayerHead = SoraDGetChildByName(self, "Image_playerHead")
	self.troopCount = SoraDGetChildByName(self, "Text_power")
	self.txtPlayer = SoraDGetChildByName(self, "Text_player")
	self.imgPlayerHead:setTouchEnabled(false)
	self.imgPlayerHead:addTouchEventListener(handler(self, self.btnPlayerHeadClick))
	self.Button_FlagTouch:setTouchEnabled(false)
	self.Button_FlagTouch:addTouchEventListener(handler(self, self.btnFlagClick))
	self.btnRecord:setTitleText(i18n("common_text_836"))
	SoraDAutoSizeButtonText(self.btnRecord)
	self.txtExplain:setString(i18n("common_text_1213"))
	self.txtTime:setString(i18n("common_text_699"))
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.rScroll = GridScrollView.new(self.rScroll)
	_ENV = self.txtTime
	self.txtTime.col = 1
	self.txtTime.h = 30
	self.txtTime.top = 35
	self.rScroll:init(self.txtTime, 0, handler(self, self.reTimeText), handler(self, self.refreshRecord))
	self.rScroll:addEventListener(handler(self, self.rScrollEventCallBack))
	self:switchToMain(true)
	self.btnRecord:addTouchEventListener(handler(self, self.btnRecordClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.carObj = fguiHelper.createObject("pyramidBattleView", "Com_battle")
	self.carObj:addTo(self.Center_Node, 9)
	self.carObj:setPosition(0, 190)
	self.carObj:setScale(0.7)
	self.carObj:setVisible(false)
end
function worldMapPyramidBatteryStateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_GETLOG_PALACE", handler(self, self.updatePalace))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initView))
end
function worldMapPyramidBatteryStateView:refreshOccupyNode(...)
	local showOcuppyInfo = function()
		self.nodeOccupyDes:setVisible(true)
		self:delWarnText()
		local occupyUsrData = self.myPlaceInfo
		dump(occupyUsrData, "占领者")
		if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
			self.txtType:setString(i18n("common_text_1426"))
			if occupyUsrData.abbr then
				self.txtAlliance:setString(occupyUsrData.abbr)
			else
				self.txtAlliance:setString(i18n("common_text_480"))
			end
			self.txtPlayer:setString(occupyUsrData.name)
			SoraDGetAutoHeightLabel(self.txtAlliance, 200)
			SoraDGetAutoHeightLabel(self.txtPlayer, 200)
			if occupyUsrData.flag then
				self.Node_flag:removeAllChildren()
				SoraDGetAllianceFlagByFid(occupyUsrData.flag):addTo(self.Node_flag)
				self.Button_FlagTouch:setTouchEnabled(true)
			else
				self.Node_flag:removeAllChildren()
				SoraDGetAllianceFlagByFid():addTo(self.Node_flag)
				self.Button_FlagTouch:setTouchEnabled(false)
			end
			self.imgPlayerHead:setTouchEnabled(true)
			SoraDGetHeadFromManager(self.imgPlayerHead, occupyUsrData.iconID, occupyUsrData.avatar)
			if occupyUsrData.maxNum then
				local curNum = kingdomMapUtil.getArmyCount(self.argList.armyData)
				self.troopCount:setString(curNum .. "/" .. occupyUsrData.maxNum)
				self.Node_troop:setVisible(true)
			else
				self.Node_troop:setVisible(false)
			end
		else
			self.nodeOccupyDes:setVisible(false)
			local help = worldMapDefine.getPyramidbuildingDes(self.argList.siteClassID)
			self:addWarnText(help, display.COLOR_GREEN)
		end
	end
	local warStatus = self.warStatus
	print("金字塔战争状态：", warStatus)
	if self.argList.siteClassID == gMapBattlefieldSiteTypeDef.subMapTypeAWArmory then
		self.btnRecord:setVisible(false)
		self.nodeOccupyDes:setVisible(false)
		local help = worldMapDefine.getPyramidbuildingDes(self.argList.siteClassID)
		self:addWarnText(help, display.COLOR_GREEN)
		if gKingdomWarStatusType.inWar == warStatus then
			self.txtExplain:setString(i18n("common_text_1214"))
		else
			self.txtExplain:setString(i18n("common_text_1213"))
		end
	elseif gKingdomWarStatusType.inWar == warStatus then
		showOcuppyInfo()
		self.txtExplain:setString(i18n("common_text_3136"))
	else
		self.nodeOccupyDes:setVisible(false)
		local help = worldMapDefine.getPyramidbuildingDes(self.argList.siteClassID)
		self:addWarnText(help, display.COLOR_GREEN)
		self.txtExplain:setString(i18n("common_text_1213"))
	end
	local warTime = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatusTime or 0
	if 0 < warTime then
		self.txtExplain:setVisible(true)
		self.txtTime:setVisible(true)
	else
		self.txtExplain:setVisible(false)
		self.txtTime:setVisible(false)
	end
	local queueData = self.argList.queueData
	if queueData then
		self.carObj:setVisible(true)
		self.carObj:initData(queueData)
	else
		self.carObj:setVisible(false)
	end
end
function worldMapPyramidBatteryStateView:initData(mapInstance, argList)
	dump(argList, "金字塔战场建筑")
	if argList then
		self.argList = argList
		self.mapInstance = mapInstance
		local name = worldMapDefine.getPyramidbuildingName(argList.siteClassID, argList.objId)
		self.argList.place = name
		self.txtTitle:setString(name)
	end
	self:initView()
end
function worldMapPyramidBatteryStateView:reqForStateInfo(target, data)
	if data then
		self.myPlaceInfo = data.retdata
		self:refreshOccupyNode()
		SoraDCloseLoading(self)
	end
end
function worldMapPyramidBatteryStateView:initView(target, data)
	self.nodeOccupyDes:setVisible(false)
	self.myPlaceInfo, _ENV = self.nodeOccupyDes.setVisible, self.nodeOccupyDes.setVisible
	local mapInstance = self.mapInstance
	if mapInstance and not tolua.isnull(mapInstance) then
		if mapInstance.leagueID and mapInstance.leagueID > 0 then
			local _ENV, placeInfo = mapInstance.leagueID, mapInstance.leagueID
			placeInfo.uid = mapInstance.playerID
			placeInfo.abbr = mapInstance.leagueName
			placeInfo.name = mapInstance.playerName
			placeInfo.flag = mapInstance.leagueFlag
			placeInfo.iconID = mapInstance.headid
			placeInfo.avatar = mapInstance.avatar
			if placeInfo.uid and 0 < placeInfo.uid then
				local kingdomID = worldMapDefine.currentMapKindomID
				local info = kingdomMapCtrl:getPlaceOwnerInfoEx(kingdomID, self.argList.buildClassID)
				placeInfo.maxNum = info.maxNum
				placeInfo.curNum = info.curNum
			end
			self.myPlaceInfo = placeInfo
		end
		self.warStatus = mapInstance.warStatus
	else
		self:removeFromParent()
		return
	end
	self:refreshOccupyNode()
	local coolTime = self:getCoolTime()
	if 0 < coolTime then
		self.txtTime:beginTime(coolTime)
	else
		self.txtTime:endTime()
	end
end
function worldMapPyramidBatteryStateView:getCoolTime(...)
	local curTime = serviceFunctions.systemTime()
	local warData = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID)
	local warStartTime = warData.warStartTime or 0
	local realStartTime = warData.realStartTime
	local warMaxTime = warData.warMaxTime or 0
	local runTime = curTime - realStartTime
	if self.argList.siteClassID == gMapBattlefieldSiteTypeDef.subMapTypeAWArmory then
		_UPVALUE4_ = self.argList.siteClassID
		self.argList.siteClassID[1] = 20
		self.argList.siteClassID[2] = 35
		self.argList.siteClassID[3] = 40
		local self.argList.siteClassID[4], timeTab = 55, self.argList.siteClassID
		for i, v in ipairs(timeTab) do
			if runTime <= v * 60 then
				return realStartTime + v * 60 - curTime
			end
		end
		return warStartTime + warMaxTime - curTime
	else
		local openTime
		local cfg = pyramidBuildingRead.getBuildConfigS(self.argList.objId)
		if cfg.unlockTime and 0 < cfg.unlockTime then
			if self.argList.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWTemple then
				if 900 < runTime then
					openTime = constantRead.getConstValue("ALLIANCEWAR_TEMPLE_REFRESH", 600)
				else
					openTime = cfg.unlockTime
				end
			else
				openTime = cfg.unlockTime
			end
		else
			openTime = 180
		end
		if runTime <= openTime then
			return realStartTime + openTime - curTime
		elseif self.argList.siteClassID == gMapBattlefieldSiteTypeDef.subTypeAWTemple then
			if self.mapInstance.warStatus == gKingdomWarStatusType.inWar then
				return warStartTime + warMaxTime - curTime
			elseif self.mapInstance.warStartTime then
				return self.mapInstance.warStartTime - curTime
			else
				return warStartTime + warMaxTime - curTime
			end
		else
			return warStartTime + warMaxTime - curTime
		end
	end
end
function worldMapPyramidBatteryStateView:updatePalace(target, retdate)
	dump(retdate, "偷窥记录")
	self.nextRecord = self.nextRecord + table.nums(retdate.retdate)
	for i, v in ipairs(retdate.retdate) do
		table.insert(self.recordTable, v)
	end
	if self.nextRecord == 1 and table.nums(retdate.retdate) <= 0 then
		self:addNoRecordText(i18n("common_text_1464"), self.rScroll)
	else
		self:delNoRecordText(self.rScroll)
	end
	self.rScroll:updateNum(table.nums(self.recordTable))
	SoraDCloseLoading(self)
end
function worldMapPyramidBatteryStateView:updateKing(target, retdate)
	dump(retdate, "偷窥记录")
	self.nextFamous = self.nextFamous + table.nums(retdate.retdate)
	for i, v in ipairs(retdate.retdate) do
		table.insert(self.famousTable, v)
	end
	if self.nextFamous == 1 and table.nums(retdate.retdate) <= 0 then
		self:addNoRecordText(i18n("common_text_1464"), self.rScroll)
	else
		self:delNoRecordText(self.rScroll)
	end
	self.rScroll:updateNum(table.nums(self.famousTable))
	SoraDCloseLoading(self)
end
function worldMapPyramidBatteryStateView:updateIngegral(target, retdate)
	self.integralTable, _ENV = nil, nil
	if retdate.retdate then
		for i, v in ipairs(retdate.retdate) do
			table.insert(self.integralTable, v)
		end
		if table.nums(retdate.retdate) <= 0 then
			self:addNoRecordText(i18n("common_text_1464"), self.rScroll)
		else
			self:delNoRecordText(self.rScroll)
		end
		self.iScroll:updateNum(table.nums(self.integralTable))
	else
		self:delNoRecordText(self.rScroll)
		self:addNoRecordText(i18n("common_text_2192"), self.rScroll)
		self.rScroll:updateNum(0)
	end
	SoraDCloseLoading(self)
end
function worldMapPyramidBatteryStateView:refreshRecord(single, index)
	local text_content = single:getChildByName("Text_content")
	self:reRecordText(self.recordTable[index], text_content)
	single:getChildByName("Text_time"):setString(SoraDConvertTimeToDate(self.recordTable[index].time, false, true, true))
end
function worldMapPyramidBatteryStateView:addNoRecordText(text, parent)
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
function worldMapPyramidBatteryStateView:delNoRecordText(parent)
	if parent:getChildByName("Text_warningTxt") then
		parent:getChildByName("Text_warningTxt"):setVisible(false)
	end
end
function worldMapPyramidBatteryStateView:addWarnText(text)
	self.txtWarn:setVisible(true)
	self.txtWarn:setString(text)
end
function worldMapPyramidBatteryStateView:delWarnText(...)
	if self.txtWarn then
		self.txtWarn:setVisible(false)
	end
end
function worldMapPyramidBatteryStateView:reTimeText()
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
function worldMapPyramidBatteryStateView:reRecordText(data, text_content)
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
	if data.dAbbr then
		_ENV = data.aAbbr
		data.aAbbr.name = data.dName
		data.aAbbr.abbr = data.dAbbr
		if i18n("common_text_186", data.aAbbr) then
			goto lbl_31
		end
	end
	local dName = data.dName
	::lbl_31::
	if gPlaceLogType.occupy == type then
		_ENV = data.dAbbr
		data.dAbbr.name = aName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1200", data.dAbbr)
	elseif gPlaceLogType.attackOccupy == type then
		_ENV = data.dAbbr
		data.dAbbr.attack = aName
		data.dAbbr.defend = dName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1201", data.dAbbr)
	elseif gPlaceLogType.defendOccupy == type then
		_ENV = data.dAbbr
		data.dAbbr.attack = aName
		data.dAbbr.defend = dName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1198", data.dAbbr)
	elseif gPlaceLogType.massOccupy == type then
		_ENV = data.dAbbr
		data.dAbbr.name = aName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1200", data.dAbbr)
	elseif gPlaceLogType.massAttackOccupy == type then
		_ENV = data.dAbbr
		data.dAbbr.attack = aName
		data.dAbbr.defend = dName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1202", data.dAbbr)
	elseif gPlaceLogType.massDefendOccupy == type then
		_ENV = data.dAbbr
		data.dAbbr.attack = aName
		data.dAbbr.defend = dName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1421", data.dAbbr)
	elseif gPlaceLogType.help == type then
		_ENV = data.dAbbr
		data.dAbbr.name = aName
		data.dAbbr.place = self.argList.place
		reText = i18n("common_text_1199", data.dAbbr)
	end
	text_content:setString(reText)
end
function worldMapPyramidBatteryStateView:showNode(bool)
	self.nodeOccupy:setVisible(bool)
end
function worldMapPyramidBatteryStateView:switchToMain(bool)
	self:showNode(bool)
	if bool then
		self.rScroll:setVisible(false)
		self.flagTabs = 0
	end
end
function worldMapPyramidBatteryStateView:showScroll(scroll)
	if scroll == self.rScroll then
		self.rScroll:setVisible(true)
		self.flagTabs = 1
	end
	self:switchToMain(false)
end
function worldMapPyramidBatteryStateView:btnRecordClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.flagTabs ~= 1 then
			SoraDShowLoading(self)
			allianceWarCtrl:getPlaceLog(worldMapDefine.currentMapKindomID, self.argList.uPos.x, self.argList.uPos.y, self.nextRecord)
			self:showScroll(self.rScroll)
		else
			self:switchToMain(true)
		end
	end
end
function worldMapPyramidBatteryStateView:btnHelpClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local help = worldMapDefine.getPyramidbuildingDes(self.argList.siteClassID)
		SoraDShowMsgBox(help, i18n("common_text_204"))
	end
end
function worldMapPyramidBatteryStateView:rScrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.bounceBottom then
		print("脱到底了", self.nextRecord)
		allianceWarCtrl:getPlaceLog(worldMapDefine.currentMapKindomID, self.argList.uPos.x, self.argList.uPos.y, self.nextRecord)
		SoraDShowLoading(self)
	end
end
function worldMapPyramidBatteryStateView:btnPlayerHeadClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local occupyUsrData = self.myPlaceInfo
		if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
			SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
			local kingdomID = worldMapDefine.currentMapKindomID
			local playerID = occupyUsrData.uid
			local gametop = gModuleMgr.getObject("gametop")
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			_ENV = handler(self, self.serverMessageGetLordInfo)
			handler(self, self.serverMessageGetLordInfo).targetName = self.__cname
			local playerData = lordInfoCtrl:getLordInfoByUid(playerID, kingdomID, handler(self, self.serverMessageGetLordInfo))
		end
	end
end
function worldMapPyramidBatteryStateView:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			SoraDOpenLordView(data.lord)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
function worldMapPyramidBatteryStateView:btnFlagClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local occupyUsrData = self.myPlaceInfo
		if occupyUsrData and occupyUsrData.aid and occupyUsrData.aid > 0 then
			print("flagClick", occupyUsrData.aid)
			SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = handler(self, self.sMsgReqInfoBack)
			handler(self, self.sMsgReqInfoBack).aid = occupyUsrData.aid
			allianceQuery:reqAllianceByID(handler(self, self.sMsgReqInfoBack))
		end
	end
end
function worldMapPyramidBatteryStateView:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	SoraDOpenAllianceInfoView(alliance)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK")
end
return worldMapPyramidBatteryStateView

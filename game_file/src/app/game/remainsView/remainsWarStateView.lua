local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local kingdomMapUtil = include("kingdomMapUtil")
local remainsWarRead = include("remainsWarRead")
local remainsWarStateView = class("remainsWarStateView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("remainsWarStateView")
	end
	return target
end)
function remainsWarStateView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtExplain = SoraDGetChildByName(self, "Text_explain")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.nodeOccupy = SoraDGetChildByName(self, "Center_Node_occupyInfo")
	self.nodeOccupyDes = SoraDGetChildByName(self, "Node_des")
	self.Node_troop = SoraDGetChildByName(self.nodeOccupyDes, "Node_troop")
	self.txtType = SoraDGetChildByName(self, "Text_type")
	self.image_LeagueFlag = SoraDGetChildByName(self, "image_LeagueFlag")
	self.imgPlayerHead = SoraDGetChildByName(self, "Image_playerHead")
	self.troopCount = SoraDGetChildByName(self, "Text_power")
	self.txtPlayer = SoraDGetChildByName(self, "Text_player")
	self.imgPlayerHead:setTouchEnabled(false)
	self.imgPlayerHead:addTouchEventListener(handler(self, self.btnPlayerHeadClick))
	self.txtWarn = SoraDGetChildByName(self, "Text_warn")
	self.txtWarn:setVisible(false)
	self.txtExplain:setString(i18n("common_text_1213"))
	self.txtTime:setString(i18n("common_text_699"))
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtType = SoraDGetChildByName(self, "Text_type")
	self.txtType:setString(i18n("common_text_1426"))
end
function remainsWarStateView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEINFOBACK", handler(self, self.reqForStateInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_PLACEONWERCHANGED", handler(self, self.initView))
end
function remainsWarStateView:initData(mapInstance, argList)
	dump(argList, "遗迹建筑")
	if argList then
		self.argList = argList
		self.mapInstance = mapInstance
		local name = remainsWarRead.getBuildName(argList.siteClassID)
		self.argList.place = name
		self.txtTitle:setString(name)
	end
	self:initView()
end
function remainsWarStateView:showOcuppyInfo()
	self.nodeOccupyDes:setVisible(true)
	self:delWarnText()
	local occupyUsrData = self.myPlaceInfo
	dump(occupyUsrData, "占领者")
	if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
		self.txtPlayer:setString(occupyUsrData.name)
		if occupyUsrData.camp then
			self.image_LeagueFlag:setVisible(true)
			self.image_LeagueFlag:setSpriteFrame(remainsWarRead.getCampIcon(occupyUsrData.camp))
			if 1 == occupyUsrData.camp then
				self.image_LeagueFlag:setScale(0.5)
			else
				self.image_LeagueFlag:setScale(1.0)
			end
		else
			self.image_LeagueFlag:setVisible(false)
		end
		self.imgPlayerHead:setTouchEnabled(true)
		SoraDGetHeadFromManager(self.imgPlayerHead, occupyUsrData.iconID, occupyUsrData.avatar)
		local curNum = kingdomMapUtil.getArmyCount(self.argList.armyData)
		if self.argList.armyData and curNum and occupyUsrData.maxNum then
			self.troopCount:setString(curNum .. "/" .. occupyUsrData.maxNum)
			self.Node_troop:setVisible(true)
		else
			self.Node_troop:setVisible(false)
		end
	else
		self.nodeOccupyDes:setVisible(false)
		local help = i18n("common_text_480")
		self:addWarnText(help)
	end
end
function remainsWarStateView:refreshOccupyNode()
	local warStatus = remainsWarCtrl:getWarStatus()
	print("遗迹之战状态：", warStatus)
	if gKingdomWarStatusType.inWar == warStatus then
		self:showOcuppyInfo()
		self.txtExplain:setString(i18n("remains_text_300"))
	elseif gKingdomWarStatusType.close == warStatus then
		self.nodeOccupyDes:setVisible(false)
		self.txtExplain:setString(i18n("common_text_1213"))
	end
	local time = remainsWarCtrl:getStatusTime()
	if 0 < time then
		self.txtExplain:setVisible(true)
		self.txtTime:setVisible(true)
	else
		self.txtExplain:setVisible(false)
		self.txtTime:setVisible(false)
	end
end
function remainsWarStateView:reqForStateInfo(target, data)
	if data then
		self.myPlaceInfo = data.retdata
		dump(self.myPlaceInfo, "self.myPlaceInfo===========")
		self:refreshOccupyNode()
		SoraDCloseLoading(self)
	end
end
function remainsWarStateView:initView(target, data)
	self.nodeOccupyDes:setVisible(false)
	SoraDShowLoading(self)
	kingdomMapCtrl:getPlaceOwnerInfo(self.argList.uPos.x, self.argList.uPos.y)
	local coolTime = remainsWarCtrl:getStatusTime()
	if 0 < coolTime then
		self.txtTime:beginTime(coolTime)
	else
		self.txtTime:endTime()
	end
end
function remainsWarStateView:btnHelpClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function remainsWarStateView:btnPlayerHeadClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local occupyUsrData = self.myPlaceInfo
		if occupyUsrData and occupyUsrData.uid and occupyUsrData.uid > 0 then
			SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
			local kingdomID = worldMapDefine.currentMapKindomID
			local playerID = occupyUsrData.uid
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			_ENV = handler(self, self.serverMessageGetLordInfo)
			handler(self, self.serverMessageGetLordInfo).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(playerID, kingdomID, handler(self, self.serverMessageGetLordInfo))
		end
	end
end
function remainsWarStateView:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == self.__cname then
			SoraDOpenLordView(data.lord)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
function remainsWarStateView:addWarnText(text)
	self.txtWarn:setVisible(true)
	self.txtWarn:setString(text)
end
function remainsWarStateView:delWarnText()
	if self.txtWarn then
		self.txtWarn:setVisible(false)
	end
end
function remainsWarStateView:sMsgReqInfoBack(target, data)
	local alliance = data.alliance
	SoraDOpenAllianceInfoView(alliance)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK")
end
return remainsWarStateView

local allianceMgr = SoraDGetCtrl("allianceMgr")
local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local worldMapFantasyLandGift = class("worldMapFantasyLandGift", function()
	local target = include("worldMapInstance").new("worldMapFantasyLandGift")
	return target
end)
function worldMapFantasyLandGift:ctor()
	self.ignoreRequest = true
	self:_initUI()
	self:_initData()
end
function worldMapFantasyLandGift:_initData()
end
function worldMapFantasyLandGift:_initUI()
	self.modelImage = display.newSprite("#icon_9001670_gift1.png")
	self:addChild(self.modelImage, -1)
	self.modelImage:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	self.modelImage:setScale(0.7)
	self.image_name_bg = display.newSprite("#frame_map_07.png")
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 30))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = ""
	self.image_name_bg.size = 18
	self.text_Name = SoraDCreateLabel(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setColor(cc.c3b(254, 241, 196))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 30))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.progressBar = SoraDCreatePanel("worldMapBossProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 60))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.progressBar:setGroupAuto(true)
	self.progressBar:setVisible(false)
end
function worldMapFantasyLandGift:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001717_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST", handler(self, self.onMsgUpdateColor))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_JOIN_SUCCESS", handler(self, self.onMsgUpdateColor))
end
function worldMapFantasyLandGift:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "getedPartyGift" then
	end
end
function worldMapFantasyLandGift:onMsgUpdateColor(target, event)
	local nameColor = cc.c3b(254, 241, 196)
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if self.data.aid == selfLeagueID then
		nameColor = worldMapDefine.getLeagueManorLineColor(true)
	end
	self.text_Name:setColor(nameColor)
end
function worldMapFantasyLandGift:getGiftType(...)
	return self.giftType
end
function worldMapFantasyLandGift:initInstanceData(giftId, data)
	self.giftId = giftId
	self.giftType = data.giftType
	self.modelImage:setSpriteFrame(activity_9001717_Read.getGiftIcon(self.giftType))
	self.totalTime = activity_9001717_Read.getGiftDuration(self.giftType)
	self.giftName = activity_9001717_Read.getGiftName(self.giftType)
	self:updateData(data)
end
function worldMapFantasyLandGift:updateData(data)
	dump(data, "worldMapFantasyLandGift:updateData")
	self.data = data
	if activity_9001717_Ctrl:checkPartyGift(self.giftId) then
		self.image_name_bg:setVisible(false)
		self.text_Name:setVisible(false)
		self.progressBar:setVisible(false)
		self.modelImage:setColor(cc.c3b(154, 154, 154))
	else
		self.image_name_bg:setVisible(true)
		self.text_Name:setVisible(true)
		self.progressBar:setVisible(true)
		self.modelImage:setColor(cc.c3b(255, 255, 255))
		local nameStr = textParser.formatAllianceName(self.data.allianceAbbr, self.giftName)
		self.text_Name:setString(nameStr)
		local nameColor = cc.c3b(254, 241, 196)
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		if self.data.aid == selfLeagueID then
			nameColor = worldMapDefine.getLeagueManorLineColor(true)
		end
		self.text_Name:setColor(nameColor)
		local leftTime = self.data.createTime + self.totalTime - serviceFunctions.systemTime()
		self.progressBar:setVisible(0 < leftTime)
		if 0 < leftTime then
			self.progressBar:setTimeValue(leftTime, self.totalTime)
		end
	end
end
function worldMapFantasyLandGift:onClickInstance(onShowView)
	if activity_9001717_Ctrl:checkPartyGift(self.giftId) then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	end
	return include("worldMapInstance").onClickInstance(self, onShowView)
end
function worldMapFantasyLandGift:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	print("worldMapFantasyLandGift:getInstanceOp===", isSelfKindom)
	if isSelfKindom and tonumber(self.data.aid) == tonumber(allianceMgr:getOwnAid()) then
		_ENV = allianceMgr:getOwnAid()
		allianceMgr:getOwnAid().buttonType = worldMapDefine.worldMapTipButtonType_activity_9001717_lingqu
		table.insert(buttonTypeArray, allianceMgr:getOwnAid())
	end
	return buttonTypeArray
end
function worldMapFantasyLandGift:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	dump(tipButtonType, "tipButtonType")
	if tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001717_lingqu then
		if activity_9001717_Ctrl:checkPartyGift(self.giftId) then
			SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
			return true
		end
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local hasMyQueue = kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.fantasyLandGift, nil, nil, self.giftId)
		if hasMyQueue then
			SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_50"))
			return
		end
		_ENV = SoraDShowMsgTip
		SoraDShowMsgTip.dispatchType = worldMapDefine.worldMapTipButtonType_activity_9001717_lingqu
		SoraDShowMsgTip.toPoint = include("mapSyncUtilClient").serverTOClientPos(cc.p(self.data.x, self.data.y))
		local SoraDShowMsgTip.instanceID, armyData = self.data.id, SoraDShowMsgTip
		worldMapFunction.gotoDispatch(armyData, true)
		return true
	end
	return false
end
return worldMapFantasyLandGift

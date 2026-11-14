local allianceMgr = SoraDGetCtrl("allianceMgr")
local activity_9001670_Read = include("activity_9001670_Read")
local worldMapBubbleLandGift = class("worldMapBubbleLandGift", function()
	local target = include("worldMapInstance").new("worldMapBubbleLandGift")
	return target
end)
function worldMapBubbleLandGift:ctor()
	self.ignoreRequest = true
	self:_initUI()
	self:_initData()
end
function worldMapBubbleLandGift:_initData()
end
function worldMapBubbleLandGift:_initUI()
	self.modelImage = display.newSprite("#icon_9001670_gift1.png")
	self:addChild(self.modelImage, -1)
	self.modelImage:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	self.modelImage:setScale(1.5)
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
function worldMapBubbleLandGift:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001670_UPDATE", handler(self, self.onMsgUpdateData))
end
function worldMapBubbleLandGift:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "getedPartyGift" then
	end
end
function worldMapBubbleLandGift:getGiftType(...)
	return self.giftType
end
function worldMapBubbleLandGift:initInstanceData(giftId, data)
	self.giftId = giftId
	self.giftType = data.giftType
	self.modelImage:setSpriteFrame(activity_9001670_Read.getGiftIcon(self.giftType))
	self.totalTime = activity_9001670_Read.getGiftDuration(self.giftType)
	self.giftName = activity_9001670_Read.getGiftName(self.giftType)
	self:updateData(data)
end
function worldMapBubbleLandGift:updateData(data)
	dump(data, "worldMapBubbleLandGift:updateData")
	self.data = data
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
function worldMapBubbleLandGift:onClickInstance(onShowView)
	return include("worldMapInstance").onClickInstance(self, onShowView)
end
function worldMapBubbleLandGift:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	print("worldMapBubbleLandGift:getInstanceOp===", isSelfKindom)
	if isSelfKindom and tonumber(self.data.aid) == tonumber(allianceMgr:getOwnAid()) then
		_ENV = allianceMgr:getOwnAid()
		allianceMgr:getOwnAid().buttonType = worldMapDefine.worldMapTipButtonType_activity_9001670_lingqu
		table.insert(buttonTypeArray, allianceMgr:getOwnAid())
	end
	return buttonTypeArray
end
function worldMapBubbleLandGift:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	dump(tipButtonType, "tipButtonType")
	if tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001670_lingqu then
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		local hasMyQueue = kingdomMapCtrl:hasMyQueue(_G.gMapMoveLineServerType.bubbleLandGift, nil, nil, self.giftId)
		if hasMyQueue then
			SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_50"))
			return
		end
		_ENV = SoraDShowMsgTip
		SoraDShowMsgTip.dispatchType = worldMapDefine.worldMapTipButtonType_activity_9001670_lingqu
		SoraDShowMsgTip.toPoint = include("mapSyncUtilClient").serverTOClientPos(cc.p(self.data.x, self.data.y))
		local SoraDShowMsgTip.instanceID, armyData = self.data.id, SoraDShowMsgTip
		worldMapFunction.gotoDispatch(armyData, true)
		return true
	end
	return false
end
return worldMapBubbleLandGift

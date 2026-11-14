local allianceMgr = SoraDGetCtrl("allianceMgr")
local worldMapFantasyLandParty = class("worldMapFantasyLandParty", function()
	local target = include("worldMapInstance").new("worldMapFantasyLandParty")
	return target
end)
function worldMapFantasyLandParty:ctor()
	self.ignoreRequest = true
	self:_initUI()
	self:_initData()
	self.totalTime = include("constantRead").getConstValue("FANTASYLAND_BANQUET_TIME")
end
function worldMapFantasyLandParty:_initData()
end
function worldMapFantasyLandParty:_initUI()
	self.modelImage = display.newSprite(IsArClient and "#Map_castle_WaterPark.png" or "#Map_castle_WaterPark_ros.png")
	self:addChild(self.modelImage, -1)
	self.modelImage:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	self.modelImage:setPosition(cc.p(self.centerPoint.x - 80, self.centerPoint.y + 30))
	self.modelImage:setScale(1)
	self.image_name_bg = display.newSprite("#frame_map_07.png")
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 80))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = ""
	self.image_name_bg.size = 18
	self.text_Name = SoraDCreateLabel(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setColor(cc.c3b(254, 241, 196))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 80))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.progressBar = SoraDCreatePanel("worldMapBossProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 110))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.progressBar:setGroupAuto(true)
	self.progressBar:setVisible(false)
end
function worldMapFantasyLandParty:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST", handler(self, self.onMsgUpdateColor))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_JOIN_SUCCESS", handler(self, self.onMsgUpdateColor))
end
function worldMapFantasyLandParty:onMsgUpdateColor(target, event)
	local nameColor = cc.c3b(254, 241, 196)
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	if self.data.aid == selfLeagueID then
		nameColor = worldMapDefine.getLeagueManorLineColor(true)
	end
	self.text_Name:setColor(nameColor)
end
function worldMapFantasyLandParty:initInstanceData(resourceClassID, data)
	self:updateData(data)
end
function worldMapFantasyLandParty:updateData(data)
	dump(data, "worldMapFantasyLandParty:updateData")
	self.data = data
	local nameStr = textParser.formatAllianceName(self.data.allianceAbbr, i18n("activity_name_9001500"))
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
function worldMapFantasyLandParty:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	if isSelfKindom and tonumber(self.data.aid) == tonumber(allianceMgr:getOwnAid()) then
		_ENV = allianceMgr:getOwnAid()
		allianceMgr:getOwnAid().buttonType = worldMapDefine.worldMapTipButtonType_activity_9001717_record
		table.insert(buttonTypeArray, allianceMgr:getOwnAid())
	end
	return buttonTypeArray
end
return worldMapFantasyLandParty

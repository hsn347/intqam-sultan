local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local worldMapDrumAndVuln = class("worldMapDrumAndVuln", function(target)
	local target = include("worldMapInstance").new("worldMapDrumAndVuln")
	return target
end)
function worldMapDrumAndVuln:ctor()
	self.isBeOccupyed = false
	self.treasureType = gWorldTypeServerDef.subMapTypeWarTreasureDrum
	self.playerName = ""
	self.playerID = 0
	self.leagueID = 0
	self.leagueName = nil
	self.digTime = 0
	self.sourceID = 0
	self.treasureState = gMapObjStateTypeDef.gMapObjStateTypeFree
	self.emojiID = nil
	self.treasureImg = display.newSprite("#Map_build_vulnerary.png")
	self:addChild(self.treasureImg, -1)
	self.occupyIcon = display.newSprite("#icon_map_res_me.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setVisible(false)
	self:addChild(self.occupyIcon, 2)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_protect)
	self:removeFireEffect(true, true)
end
function worldMapDrumAndVuln:setBatchNodeGroupID(groupID)
	self.treasureImg:setGroupID(groupID)
end
function worldMapDrumAndVuln:initInstanceData(resourceClassID, treasureData)
	self.resourceClassID = resourceClassID
	if resourceClassID == 4302 then
		self.treasureImg:setSpriteFrame("Map_build_vulnerary.png")
		self.treasureImg:setPosition(0, 10)
	else
		self.treasureImg:setSpriteFrame("Map_build_warDrum.png")
		self.treasureImg:setPosition(-30, 30)
	end
	if not treasureData then
		return
	end
	self:updateData(treasureData)
end
function worldMapDrumAndVuln:updateData(treasureData)
	if not treasureData then
		return
	end
	self.playerID = treasureData.playerID or 0
	if self.playerID == 0 then
		self.playerName = nil
	end
	self.leagueID = treasureData.leagueID or 0
	if self.leagueID == 0 then
		self.leagueName = nil
	end
	if treasureData.playerName then
		self.playerName = treasureData.playerName
	end
	if treasureData.leagueName then
		self.leagueName = treasureData.leagueName
	end
	if treasureData.sourceKid then
		self.sourceID = treasureData.sourceKid
	end
	self:updateFireEffect(self.treasureState)
	self:updateEmojiByData(treasureData)
	if self.playerID > 0 then
		self:setBeOccupyed()
	else
		self:cancelBeOccupyed()
	end
end
function worldMapDrumAndVuln:onClickInstance(onShowView)
	local buildLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	local resourceLevelLimit = worldMapDefine.getWarTreasureCastleLv(self.resourceClassID)
	print("worldMapDrumAndVuln:onClickIn", resourceLevelLimit)
	if buildLv < resourceLevelLimit then
		cityCtrl = resourceLevelLimit
		resourceLevelLimit.Level = resourceLevelLimit
		local limitString = i18n("common_text_497", resourceLevelLimit)
		SoraDShowMsgTip(limitString)
		return
	end
	self:playClickSound()
	return self:onShowWorldMapTip(onShowView)
end
function worldMapDrumAndVuln:setBeOccupyed()
	self.isBeOccupyed = true
	self.occupyIcon:setVisible(true)
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local occupyIconName = "icon_map_res_normal.png"
	if selfPlayerID == self.playerID then
		occupyIconName = "icon_map_res_me.png"
	elseif selfLeagueID == self.leagueID then
		occupyIconName = "icon_map_res_alliance.png"
	else
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
		if allianceRelationType == gMapAllianceRelationType.ALLY then
			occupyIconName = "icon_map_res_bund.png"
		elseif allianceRelationType == gMapAllianceRelationType.FRIENDLY then
			occupyIconName = "icon_map_res_friend.png"
		elseif allianceRelationType == gMapAllianceRelationType.ENEMY then
			occupyIconName = "icon_map_res_enemy.png"
		end
		if self.sourceID and self.sourceID > 0 then
			local selfSourceID = lordInfoCtrl:getMapSourceKid()
			if self.sourceID ~= selfSourceID then
				occupyIconName = "icon_map_res_others.png"
			end
		end
	end
	self.occupyIcon:setSpriteFrame(occupyIconName)
end
function worldMapDrumAndVuln:cancelBeOccupyed()
	self.isBeOccupyed = false
	self.occupyIcon:setVisible(false)
end
function worldMapDrumAndVuln:getFavoriteName()
	local favoriteName = worldMapDefine.getWarTreasureBuildingName(self.resourceClassID)
	return favoriteName
end
function worldMapDrumAndVuln:playClickSound()
	SoraDPlaySound("worldmap", 5)
end
function worldMapDrumAndVuln:getInstanceOp(isSelfKindom)
	local allianceMgr, buttonTypeArray
	local selfLeagueID = allianceMgr:getOwnTeamID() or 0
	local selfPlayerID = gametop.playertop_:getPlayerID()
	local playerID = self.playerID or 0
	local leagueID = self.leagueID or 0
	print("worldMapDrumAndVuln:getInstanceOp --", self.playerID, self.leagueID, selfLeagueID)
	if playerID <= 0 then
		if isSelfKindom then
			allianceMgr = self.playerID
			self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_zhanLing
			table.insert(buttonTypeArray, self.playerID)
			allianceMgr = self.playerID
			self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, self.playerID)
		end
	elseif isSelfKindom then
		if playerID == selfPlayerID then
			allianceMgr = self.playerID
			self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_fanHui
			table.insert(buttonTypeArray, self.playerID)
			allianceMgr = self.playerID
			self.playerID.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, self.playerID)
			if self:canHasEmojiOperator(selfPlayerID) then
				allianceMgr = selfPlayerID
				selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_biaoqingyinzhang
				table.insert(buttonTypeArray, selfPlayerID)
			end
		elseif 0 < selfLeagueID and selfLeagueID == leagueID then
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, selfPlayerID)
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, selfPlayerID)
		else
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_gongJi
			table.insert(buttonTypeArray, selfPlayerID)
			allianceMgr = selfPlayerID
			selfPlayerID.buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
			table.insert(buttonTypeArray, selfPlayerID)
			local towerLv = cityCtrl:getBuildMaxLv(BUILDID.WATCH_TOWER)
			if 1 < towerLv then
				allianceMgr = worldMapDefine.worldMapTipButtonType_xiangqing
				worldMapDefine.worldMapTipButtonType_xiangqing.buttonType = worldMapDefine.worldMapTipButtonType_zhenCha
				table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xiangqing)
			end
			allianceMgr = worldMapDefine.worldMapTipButtonType_xiangqing
			worldMapDefine.worldMapTipButtonType_xiangqing.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
			table.insert(buttonTypeArray, worldMapDefine.worldMapTipButtonType_xiangqing)
		end
	else
		allianceMgr = buttonTypeArray
		buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_yongHuXinxi
		table.insert(buttonTypeArray, buttonTypeArray)
	end
	allianceMgr = buttonTypeArray
	buttonTypeArray.buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, buttonTypeArray)
	return buttonTypeArray
end
return worldMapDrumAndVuln

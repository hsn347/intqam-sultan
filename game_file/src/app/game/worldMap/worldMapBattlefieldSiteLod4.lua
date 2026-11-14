local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local pyramidBuildingRead = include("pyramidBuildingRead")
local worldMapBattlefieldSiteLod4 = class("worldMapBattlefieldSiteLod4", include("worldMapInstanceLod"))
function worldMapBattlefieldSiteLod4:ctor()
	worldMapBattlefieldSiteLod4.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapBattlefieldSiteLod4:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.protectScale = 1
end
function worldMapBattlefieldSiteLod4:_initUI()
	local node = SoraDCreateCSBNode("worldMapAtlantisWarLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Node_kingdom:setVisible(false)
	self.Node_player:setVisible(false)
	self.Node_buildTime:setVisible(false)
	self.Sprite_build:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
end
function worldMapBattlefieldSiteLod4:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapBattlefieldSiteLod4:initInstanceData(objData, worldInstanceData, instanceData)
	self.siteClassID = objData.objId
	self.subType = pyramidBuildingRead.getType(self.siteClassID)
	local imgName = pyramidBuildingRead.getIconLod(self.subType)
	self.Sprite_build:setSpriteFrame(imgName)
	local size = pyramidBuildingRead.getBuildSize(self.siteClassID)
	local iconSize = size * 2
	self.protectScale = size * 0.7
	if self.subType == gMapBattlefieldSiteTypeDef.subTypeAWRes then
		iconSize = iconSize * 4
		self.protectScale = size * 0.7 * 2
	end
	self.Sprite_build:setScale(iconSize)
	self.Node_protect:setScale(self.protectScale)
	self:updateData(objData)
end
function worldMapBattlefieldSiteLod4:updateData(data, delayTime)
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
end
function worldMapBattlefieldSiteLod4:updatePlayerInfo(data)
	if self:checkInWarStatus() and self.leagueID and self.leagueID > 0 then
		local selfLeagueID = allianceMgr:getOwnTeamID() or 0
		local relationType = gMapAllianceRelationType.NORMAL
		if self.leagueID == selfLeagueID then
			if data.ownerUid == SoraDGetPlayerID() then
				relationType = gMapAllianceRelationType.SELF
			else
				relationType = gMapAllianceRelationType.ALLY
			end
		elseif self.leagueID ~= 0 then
			relationType = gMapAllianceRelationType.ENEMY
		end
		local nameColor = worldMapDefine.getLeagueManorLineColor(false, relationType)
		self.Sprite_build:setColor(nameColor)
	else
		local nameColor = worldMapDefine.getNormalManorLineColor()
		self.Sprite_build:setColor(nameColor)
	end
end
function worldMapBattlefieldSiteLod4:updateSafeState()
	if self:checkInWarStatus() then
		self.Node_protect:setVisible(false)
	else
		self.Node_protect:setVisible(true)
	end
end
function worldMapBattlefieldSiteLod4:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.25
	local buildScale = math.min(2.5, realScale)
	self.Node_build:setScale(buildScale)
	self.Node_protect:setScale(buildScale * self.protectScale)
end
function worldMapBattlefieldSiteLod4:updateLodChange(...)
end
function worldMapBattlefieldSiteLod4:getSpriteBuild(...)
	return self.Sprite_build
end
function worldMapBattlefieldSiteLod4:getBuildId(...)
	return self.siteClassID
end
return worldMapBattlefieldSiteLod4

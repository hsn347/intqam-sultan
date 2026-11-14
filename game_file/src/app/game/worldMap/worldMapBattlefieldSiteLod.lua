local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local worldLodDef = worldMapDefine.worldLodDef
local pyramidBuildingRead = include("pyramidBuildingRead")
local worldMapBattlefieldSiteLod = class("worldMapBattlefieldSiteLod", include("worldMapInstanceLod"))
function worldMapBattlefieldSiteLod:ctor()
	worldMapBattlefieldSiteLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapBattlefieldSiteLod:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.protectScale = 1
	self.hasInitBuildTime = false
end
function worldMapBattlefieldSiteLod:_initUI()
	local node = SoraDCreateCSBNode("worldMapAtlantisWarLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Text_buildTime = SoraDCreateTimerLabel(self, self.Text_buildTime)
end
function worldMapBattlefieldSiteLod:onMessageListener()
end
function worldMapBattlefieldSiteLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapBattlefieldSiteLod:onMsgRefreshWarData(...)
	if not self.hasInitBuildTime then
		self:initBuildTime()
	end
end
function worldMapBattlefieldSiteLod:initInstanceData(objData, worldInstanceData, instanceData)
	dump(objData, "==worldMapBattlefieldSiteLod:initInstanceData objData==")
	dump(worldInstanceData, "==worldMapBattlefieldSiteLod:initInstanceData worldInstanceData==")
	self.siteClassID = objData.objId
	self.subType = pyramidBuildingRead.getType(self.siteClassID)
	local imgName = pyramidBuildingRead.getImage(self.subType)
	self.Sprite_build:setSpriteFrame(imgName)
	local size = pyramidBuildingRead.getBuildSize(self.siteClassID)
	self.protectScale = size * 0.7
	self.Node_protect:setScale(self.protectScale)
	self:initBuildTime()
	self:updateData(objData)
end
function worldMapBattlefieldSiteLod:updateData(data)
	dump(data, "==worldMapBattlefieldSiteLod:updateData==")
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
end
function worldMapBattlefieldSiteLod:updatePlayerInfo(data)
	if self:checkInWarStatus() then
		self.Node_player:setVisible(true)
		if data.playerName then
			self.playerName = data.playerName
		end
		if data.leagueID then
			self.leagueID = data.leagueID
		end
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
		local siteName = pyramidBuildingRead.getName(self.subType)
		if self.leagueID == 0 then
			self.Node_kingdom:setVisible(false)
			self.Text_player:setColor(nameColor)
			self.Text_player:setString(i18n(siteName))
		else
			self.Node_kingdom:setVisible(true)
			self.Text_player:setColor(nameColor)
			self.Text_player:setString(self.playerName)
			self.Text_kingdom:setString(i18n(siteName))
			self.Text_kingdom:setColor(nameColor)
		end
	else
		self.Node_player:setVisible(false)
		self.Node_kingdom:setVisible(false)
	end
end
function worldMapBattlefieldSiteLod:updateSafeState()
	if self:checkInWarStatus() then
		self.Node_protect:setVisible(false)
	else
		self.Node_protect:setVisible(true)
	end
end
function worldMapBattlefieldSiteLod:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.65
	self.Node_player:setScale(realScale)
	self.Node_kingdom:setScale(realScale)
	self.Node_buildTime:setScale(realScale * 2)
end
function worldMapBattlefieldSiteLod:updateLodChange(...)
	if self.lod == worldLodDef.LOD3 then
		self.Node_kingdom:setVisible(false)
	elseif self:checkInWarStatus() and self.leagueID ~= 0 then
		self.Node_kingdom:setVisible(true)
	end
end
function worldMapBattlefieldSiteLod:initBuildTime(...)
	self.Node_buildTime:setVisible(false)
end
function worldMapBattlefieldSiteLod:refreshTextBuildTime(widget, build)
end
return worldMapBattlefieldSiteLod

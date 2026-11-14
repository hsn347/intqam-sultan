local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local worldMapIconLodAlliance = class("worldMapIconLodAlliance", include("worldMapIconLod"))
function worldMapIconLodAlliance:ctor()
	worldMapIconLodAlliance.super.ctor(self)
	self:_initData()
end
function worldMapIconLodAlliance:_initData()
	self.leagueID = 0
	self.isSelfIn = false
	self.battleState = gMapObjStateTypeDef.gMapObjStateTypeFree
end
function worldMapIconLodAlliance:initUIOccupyIcon()
	if self.occupyIcon then
		return
	end
	self.occupyIcon = display.newSpriteNoChild("#lod_Pickaxe-B.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setPosition(cc.p(0, 15))
	self.occupyIcon:setVisible(false)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self:addChild(self.occupyIcon, 2)
end
function worldMapIconLodAlliance:initUIBuildingIcon()
	if self.buildingIcon then
		return
	end
	self.buildingIcon = display.newSpriteNoChild("#lod_alliance_putup.png")
	self.buildingIcon:setAnchorPoint(0.5, 0.0)
	self.buildingIcon:setPosition(cc.p(0, 15))
	self.buildingIcon:setVisible(false)
	self.buildingIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self:addChild(self.buildingIcon, 2)
end
function worldMapIconLodAlliance:addCacheBefore()
	if self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
	if self.buildingIcon then
		self.buildingIcon:setVisible(false)
	end
end
function worldMapIconLodAlliance:initInstanceData(objData, worldInstanceData, instanceData)
	local classID = worldInstanceData.class
	local imgName = worldMapDefine.getAllianceResourceIoonLod(classID)
	if imgName then
		self:setIcon(imgName)
	end
	self:updateData(objData)
end
function worldMapIconLodAlliance:updateData(data)
	if not data then
		return
	end
	if data.isSelfIn ~= nil then
		self.isSelfIn = data.isSelfIn
	else
		local isSelfIn = self:checkIsSelfIn()
		self.isSelfIn = isSelfIn
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.status then
		self.battleState = data.status
	end
	if self.isSelfIn and self.battleState ~= gMapObjStateTypeDef.gMapObjStateTypeWorking then
		if not self.occupyIcon then
			self:initUIOccupyIcon()
		end
		self.occupyIcon:setVisible(true)
	elseif self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
	local leagueID = self.leagueID or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local nameColor
	if selfLeagueID == leagueID then
		nameColor = worldMapDefine.getLeagueManorLineColor(true)
	else
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
		nameColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
	end
	self:setColor(nameColor)
	local showIcon = false
	if self.battleState == gMapObjStateTypeDef.gMapObjStateTypeWorking and leagueID == selfLeagueID then
		showIcon = true
	end
	if showIcon then
		if not self.buildingIcon then
			self:initUIBuildingIcon()
		end
		self.buildingIcon:setVisible(true)
	elseif self.buildingIcon then
		self.buildingIcon:setVisible(false)
	end
end
function worldMapIconLodAlliance:checkIsSelfIn()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	if kingdomMapCtrl.kingdomMapCell:hasMyQueueToMapObj(self.instanceID, gMapMoveLineServerType.moveLineTypeSuperResource, gMapMoveLineStatusType.moveLineStatusTypeWorking) then
		return true
	end
end
return worldMapIconLodAlliance

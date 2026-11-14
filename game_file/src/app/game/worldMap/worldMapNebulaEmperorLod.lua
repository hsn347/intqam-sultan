local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local worldLodDef = worldMapDefine.worldLodDef
local worldMapNebulaEmperorLod = class("worldMapNebulaEmperorLod", include("worldMapInstanceLod"))
function worldMapNebulaEmperorLod:ctor()
	worldMapNebulaEmperorLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapNebulaEmperorLod:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.fromCamp = 0
	self.protectEndTime = 0
	self.playerVisible = false
	self.protectScale = 1
	self.buildScale = 3.5
	self.selfCamp = nebulaEmperorCtrl:getSelfCamp()
	self.selfTeamId = nebulaEmperorCtrl:getSelfTeamId()
end
function worldMapNebulaEmperorLod:_initUI()
	local node = SoraDCreateCSBNode("worldMapNebulaEmperorLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Sprite_build:setScale(self.buildScale)
	self.Sprite_camp:setVisible(false)
end
function worldMapNebulaEmperorLod:setLod(lod)
	self.lod = lod
end
function worldMapNebulaEmperorLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.objData = objData
	self.siteClassID = objData.objId
	self.subType = nebulaEmperorRead.getBuildType(self.siteClassID)
	local buildSize = nebulaEmperorRead.getBuildSize(self.siteClassID)
	self.protectScale = buildSize * 0.7
	self.Node_protect:setScale(self.protectScale)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarTower then
		self.Node_protect:setPositionY(150)
	end
	self:updateLodChange()
	self:initCampBuildPlayerInfo()
end
function worldMapNebulaEmperorLod:updateLodChange(...)
	self:updateData(self.objData)
	self.Sprite_build:setPosition(0, 0)
	local imgName
	if self.lod <= worldLodDef.LOD3 then
		imgName = nebulaEmperorRead.getBuildImage(self.siteClassID)
		local pos = nebulaEmperorUtil.getMapBuildPosition(self.subType)
		self.Sprite_build:setPosition(pos)
	else
		imgName = nebulaEmperorRead.getBuildIconLod(self.siteClassID)
	end
	if imgName then
		self.Sprite_build:setSpriteFrame(imgName)
	end
end
function worldMapNebulaEmperorLod:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.65
	self.Node_player:setScale(realScale)
	if self.lod == worldLodDef.LOD4 then
		local buildScale = math.min(2.5, revertScale * 0.25)
		self.Sprite_build:setScale(buildScale * self.buildScale * 1.5)
		self.Node_protect:setScale(buildScale * self.protectScale)
	elseif self.lod == worldLodDef.LOD2 then
		if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
			self.Sprite_build:setScale(0.77)
		else
			self.Sprite_build:setScale(1)
		end
	else
		if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
			self.Sprite_build:setScale(0.77)
		else
			self.Sprite_build:setScale(1)
		end
		self.Node_protect:setScale(self.protectScale)
	end
end
function worldMapNebulaEmperorLod:updateData(data, delayTime)
	self.objData = data
	if data.camp then
		self.fromCamp = data.camp
	end
	if data.teamId then
		self.fromTeamId = data.teamId
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	if data.protectEndTime then
		self.protectEndTime = data.protectEndTime
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
end
function worldMapNebulaEmperorLod:updatePlayerInfo(data)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		self.Node_player:setVisible(false)
		return
	end
	if self.fromCamp and self.fromCamp > 0 then
		self.playerVisible = true
		if data.teamAbbr then
			self.teamAbbr = data.teamAbbr
		end
		if data.playerName then
			self.playerName = data.playerName
		end
		local relationType = nebulaEmperorUtil.getRelationType(self.fromCamp, self.selfCamp)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
		self.Text_player:setColor(nameColor)
		_ENV = nameColor
		nameColor.abbr = self.teamAbbr
		nameColor.name = self.playerName
		local teamStr = i18n("common_text_186", nameColor)
		self.Text_player:setString(teamStr)
		if self.lod >= worldLodDef.LOD4 then
			self.Sprite_build:setColor(nameColor)
		end
	else
		self.playerVisible = false
		if self.lod >= worldLodDef.LOD4 then
			self.Sprite_build:setColor(cc.c3b(165, 165, 165))
		end
	end
	self:updatePlayerVisible()
end
function worldMapNebulaEmperorLod:updatePlayerVisible()
	if self.lod ~= worldLodDef.LOD4 then
		self.Node_player:setVisible(self.playerVisible)
	else
		self.Node_player:setVisible(false)
	end
end
function worldMapNebulaEmperorLod:checkInProtectTime(...)
	if self.subType == gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		return false
	end
	if not self:checkInWarStatus() then
		return true
	end
	if self.protectEndTime ~= 0 and self.protectEndTime > serviceFunctions.systemTime() then
		return true
	end
	return false
end
function worldMapNebulaEmperorLod:updateSafeState()
	if self:checkInProtectTime() then
		self.Node_protect:setVisible(true)
	else
		self.Node_protect:setVisible(false)
	end
end
function worldMapNebulaEmperorLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapNebulaEmperorLod:initCampBuildPlayerInfo(...)
	if self.subType ~= gWorldTypeServerDef.subTypeNebulaEmperorWarCamp then
		return
	end
	if self.lod < worldLodDef.LOD4 then
		return
	end
	local buildCamp = nebulaEmperorRead.getBuildCamp(self.siteClassID)
	local relationType = nebulaEmperorUtil.getRelationType(buildCamp, self.selfCamp)
	local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
	self.Sprite_build:setColor(nameColor)
end
return worldMapNebulaEmperorLod

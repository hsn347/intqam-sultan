local nebulaWarRead = include("nebulaWarRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local worldLodDef = worldMapDefine.worldLodDef
local teamDef = include("teamDef")
local worldMapNebulaWarLod = class("worldMapNebulaWarLod", include("worldMapInstanceLod"))
function worldMapNebulaWarLod:ctor()
	worldMapNebulaWarLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapNebulaWarLod:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.fromCamp = 0
	self.protectEndTime = 0
	self.playerVisible = false
	self.protectScale = 1
	self.buildScale = 3.5
	self.selfCamp = nebulaActivityCtrl:getSelfCamp()
	self.selfTeamId = nebulaActivityCtrl:getSelfTeamId()
end
function worldMapNebulaWarLod:_initUI()
	include("worldMapBuildProtectTips").new(self)
	local node = SoraDCreateCSBNode("worldMapNebulaWarLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Sprite_build:setScale(self.buildScale)
	if self.Sprite_camp then
		self.Sprite_camp:setVisible(false)
	end
end
function worldMapNebulaWarLod:setLod(lod)
	self.lod = lod
end
function worldMapNebulaWarLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.objData = objData
	self.buildId = objData.objId
	self.buildType = nebulaWarRead.getBuildTypeByBuildId(self.buildId)
	local buildSize = nebulaWarRead.getBuildSize(self.buildId)
	self.protectScale = buildSize * 0.7
	self.Node_protect:setScale(self.protectScale)
	self:updateLodChange()
end
function worldMapNebulaWarLod:updateLodChange(...)
	self:updateData(self.objData)
	self.Sprite_build:setPosition(0, 0)
	local imgName
	if self.lod <= worldLodDef.LOD3 then
		imgName = nebulaWarRead.getBuildImageByBuildId(self.buildId)
		local pos = nebulaWarUtil.getMapBuildPosition(self.buildType)
		self.Sprite_build:setPosition(pos)
	else
		imgName = nebulaWarRead.getBuildIconLodByBuildId(self.buildId)
	end
	if imgName then
		self.Sprite_build:setSpriteFrame(imgName)
	end
end
function worldMapNebulaWarLod:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.65
	self.Node_player:setScale(realScale)
	self:setProtectTipsScale(realScale)
	if self.lod == worldLodDef.LOD4 then
		local buildScale = math.min(2.5, revertScale * 0.25)
		self.Sprite_build:setScale(buildScale * self.buildScale * 1.5)
		self.Node_protect:setScale(buildScale * self.protectScale)
	elseif self.lod == worldLodDef.LOD2 then
		self.Sprite_build:setScale(1)
	else
		self.Sprite_build:setScale(1)
		self.Node_protect:setScale(self.protectScale)
	end
end
function worldMapNebulaWarLod:updateData(data, delayTime)
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
	self:updateDataProtectime(data)
	self:updatePlayerInfo(data)
	self:updateSafeState()
end
function worldMapNebulaWarLod:updatePlayerInfo(data)
	if self.fromCamp and self.fromCamp > 0 then
		self.playerVisible = true
		if data.teamAbbr then
			self.teamAbbr = data.teamAbbr
		end
		if data.playerName then
			self.playerName = data.playerName
		end
		local relationType = nebulaWarUtil.getRelationType(self.fromCamp, self.selfCamp, self.fromTeamId, self.selfTeamId)
		local nameColor = worldMapDefine.getLeagueManorLineColor(nil, relationType)
		self.Text_player:setColor(nameColor)
		nebulaWarUtil = nameColor
		nameColor.abbr = self.teamAbbr
		nameColor.name = self.playerName
		local teamStr = i18n("common_text_186", nameColor)
		self.Text_player:setString(teamStr)
		if self.lod >= worldLodDef.LOD4 then
			self.Sprite_build:setColor(nameColor)
		end
	else
		self.playerVisible = false
		if self.lod >= worldLodDef.LOD4 and self.buildType ~= gWorldTypeServerDef.subTypeNebulaWarBigMine and self.buildType ~= gWorldTypeServerDef.subTypeNebulaWarSmallMine then
			self.Sprite_build:setColor(cc.c3b(165, 165, 165))
		end
	end
	self:updatePlayerVisible()
end
function worldMapNebulaWarLod:updatePlayerVisible()
	if self.lod ~= worldLodDef.LOD4 then
		self.Node_player:setVisible(self.playerVisible)
	else
		self.Node_player:setVisible(false)
	end
end
function worldMapNebulaWarLod:checkInProtectTime(...)
	if not self:checkInWarStatus() then
		return true
	end
	if self.protectEndTime ~= 0 and self.protectEndTime > serviceFunctions.systemTime() then
		return true
	end
	return false
end
function worldMapNebulaWarLod:updateSafeState()
	if self:checkInProtectTime() then
		self.Node_protect:setVisible(true)
		if self.lod <= worldLodDef.LOD3 then
			self:setProtectimeShow(true)
		else
			self:setProtectimeShow(false)
		end
	else
		self.Node_protect:setVisible(false)
		self:setProtectimeShow(false)
	end
end
function worldMapNebulaWarLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapNebulaWarLod:getSpriteBuild(...)
	return self.Sprite_build
end
function worldMapNebulaWarLod:getBuildId(...)
	return self.buildId
end
return worldMapNebulaWarLod

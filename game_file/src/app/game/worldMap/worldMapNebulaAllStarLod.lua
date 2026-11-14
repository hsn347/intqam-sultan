local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local worldLodDef = worldMapDefine.worldLodDef
local nebulaWarRead = include("nebulaWarRead")
local worldMapNebulaAllStarLod = class("worldMapNebulaAllStarLod", include("worldMapInstanceLod"))
function worldMapNebulaAllStarLod:ctor()
	worldMapNebulaAllStarLod.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapNebulaAllStarLod:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.fromCamp = 0
	self.protectEndTime = 0
	self.playerVisible = false
	self.protectScale = 1
	self.buildScale = 3.5
	self.selfCamp = nebulaAllStarCtrl:getSelfCamp()
	self.selfTeamId = nebulaAllStarCtrl:getSelfTeamId()
end
function worldMapNebulaAllStarLod:_initUI()
	local node = SoraDCreateCSBNode("worldMapNebulaEmperorLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Sprite_build:setScale(self.buildScale)
	self.Sprite_camp:setVisible(false)
end
function worldMapNebulaAllStarLod:setLod(lod)
	self.lod = lod
end
function worldMapNebulaAllStarLod:initInstanceData(objData, worldInstanceData, instanceData)
	self.objData = objData
	self.siteClassID = objData.objId
	self.subType = nebulaAllStarRead.getBuildType(self.siteClassID)
	local buildSize = nebulaAllStarRead.getBuildSize(self.siteClassID)
	self.protectScale = buildSize * 0.7
	self.Node_protect:setScale(self.protectScale)
	self:updateLodChange()
end
function worldMapNebulaAllStarLod:updateLodChange(...)
	self:updateData(self.objData)
	self.Sprite_build:setPosition(0, 0)
	local imgName
	if self.lod <= worldLodDef.LOD3 then
		imgName = nebulaAllStarRead.getBuildImage(self.siteClassID)
		local pos = nebulaAllStarRead.getMapBuildPosition(self.subType)
		self.Sprite_build:setPosition(pos)
	else
		imgName = nebulaAllStarRead.getBuildIconLod(self.siteClassID)
	end
	if imgName then
		self.Sprite_build:setSpriteFrame(imgName)
	end
end
function worldMapNebulaAllStarLod:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.65
	self.Node_player:setScale(realScale)
	if self.lod == worldLodDef.LOD4 then
		local buildScale = math.min(2.5, revertScale * 0.25)
		self.Sprite_build:setScale(buildScale * self.buildScale * 1.5)
		self.Node_protect:setScale(buildScale * self.protectScale)
	elseif self.lod == worldLodDef.LOD2 then
		local scale = nebulaAllStarRead.getMapBuildScale(self.subType)
		self.Sprite_build:setScale(scale)
	else
		local scale = nebulaAllStarRead.getMapBuildScale(self.subType)
		self.Sprite_build:setScale(scale)
		self.Node_protect:setScale(self.protectScale)
	end
end
function worldMapNebulaAllStarLod:updateData(data, delayTime)
	dump(data, "==worldMapNebulaAllStarLod:updateData==")
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
function worldMapNebulaAllStarLod:updatePlayerInfo(data)
	if self.fromCamp and self.fromCamp > 0 then
		self.playerVisible = true
		if data.playerName then
			self.playerName = data.playerName
		end
		local nameColor = nebulaAllStarRead.getCampColorRGB(self.fromCamp)
		self.Text_player:setColor(nameColor)
		local teamAbbr = nebulaWarRead.getAreaAbbr(self.fromCamp)
		nebulaAllStarRead = nil
		;(nil).abbr = teamAbbr
		;(nil).name = self.playerName
		local teamStr = i18n("common_text_186", nil)
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
function worldMapNebulaAllStarLod:updatePlayerVisible()
	if self.lod ~= worldLodDef.LOD4 then
		self.Node_player:setVisible(self.playerVisible)
	else
		self.Node_player:setVisible(false)
	end
end
function worldMapNebulaAllStarLod:checkInProtectTime(...)
	if self.subType == gWorldTypeServerDef.subTypeNebulaAllStarWarCamp then
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
function worldMapNebulaAllStarLod:updateSafeState()
	if self:checkInProtectTime() then
		self.Node_protect:setVisible(true)
	else
		self.Node_protect:setVisible(false)
	end
end
function worldMapNebulaAllStarLod:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
return worldMapNebulaAllStarLod

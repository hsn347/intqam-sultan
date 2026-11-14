local gametop = gModuleMgr.getObject("gametop")
local AMB = require_data("atlantiswar_map_build", true).data
local AMBC = require_data("atlantiswar_map_build_config").data
local worldMapAtlantisWarLod4 = class("worldMapAtlantisWarLod4", include("worldMapInstanceLod"))
function worldMapAtlantisWarLod4:ctor()
	worldMapAtlantisWarLod4.super.ctor(self)
	self:_initData()
	self:_initUI()
end
function worldMapAtlantisWarLod4:_initData(...)
	self.warStatus = gKingdomWarStatusType.close
	self.fromKid = 0
	self.protectScale = 1
end
function worldMapAtlantisWarLod4:_initUI()
	local node = SoraDCreateCSBNode("worldMapAtlantisWarLod")
	node:addTo(self, 1)
	SoraDGetAllChildFromWidget(node, self)
	self.Node_kingdom:setVisible(false)
	self.Node_player:setVisible(false)
	self.Node_buildTime:setVisible(false)
	self.Sprite_build:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
end
function worldMapAtlantisWarLod4:checkInWarStatus(...)
	return self.warStatus == gKingdomWarStatusType.inWar
end
function worldMapAtlantisWarLod4:initInstanceData(objData, worldInstanceData, instanceData)
	self.siteClassID = objData.objId
	local imgName = AMBC[self.siteClassID].iconLod or "lod_shmc_small_901.png"
	self.Sprite_build:setSpriteFrame(imgName)
	local size = AMB[self.siteClassID].size
	self.Sprite_build:setScale(size * 2)
	self.protectScale = size * 0.7
	self.Node_protect:setScale(self.protectScale)
	self:updateData(objData)
end
function worldMapAtlantisWarLod4:updateData(data, delayTime)
	if data.fromKid then
		self.fromKid = data.fromKid
	end
	if data.warStatus then
		self.warStatus = data.warStatus
	end
	self:updatePlayerInfo(data)
	self:updateSafeState()
end
function worldMapAtlantisWarLod4:updatePlayerInfo(data)
	if self:checkInWarStatus() and self.fromKid and self.fromKid > 0 then
		local selfKid = gametop.playertop_:getKingdomID()
		local relationType = gMapAllianceRelationType.ENEMY
		if self.fromKid == selfKid then
			relationType = gMapAllianceRelationType.SELF
		end
		local nameColor = worldMapDefine.getLeagueManorLineColor(false, relationType)
		self.Sprite_build:setColor(nameColor)
	else
		local nameColor = worldMapDefine.getNormalManorLineColor()
		self.Sprite_build:setColor(nameColor)
	end
end
function worldMapAtlantisWarLod4:updateSafeState()
	if self:checkInWarStatus() then
		self.Node_protect:setVisible(false)
	else
		self.Node_protect:setVisible(true)
	end
end
function worldMapAtlantisWarLod4:updateScaleChange(revertScale, scale)
	local realScale = revertScale * 0.25
	local buildScale = math.min(2.5, realScale)
	self.Node_build:setScale(buildScale)
	self.Node_protect:setScale(buildScale * self.protectScale)
end
function worldMapAtlantisWarLod4:updateLodChange(...)
end
function worldMapAtlantisWarLod4:getSpriteBuild(...)
	return self.Sprite_build
end
function worldMapAtlantisWarLod4:getBuildId(...)
	return self.siteClassID
end
return worldMapAtlantisWarLod4

local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local worldMapResourceLod = class("worldMapResourceLod", include("worldMapInstanceLod"))
function worldMapResourceLod:ctor()
	worldMapResourceLod.super.ctor(self)
	self:_initData()
end
function worldMapResourceLod:_initData()
	self.playerID = 0
	self.leagueID = 0
end
function worldMapResourceLod:initUIOccupyIcon()
	if self.occupyIcon then
		return
	end
	self.occupyIcon = display.newSpriteNoChild("#lod_Pickaxe-C.png")
	self.occupyIcon:setAnchorPoint(0.5, 0.0)
	self.occupyIcon:setPosition(cc.p(0, 15))
	self.occupyIcon:setVisible(false)
	self.occupyIcon:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
	self:addChild(self.occupyIcon, 2)
end
function worldMapResourceLod:initUIResourceIcon()
	if self.resourceImage then
		return
	end
	self.resourceImage = display.newSpriteNoChild("#lod_farm.png")
	self.resourceImage:addTo(self, -1)
	self.resourceImage:setGroupID(worldMapDefine.GROU_ID.group_lod_icon)
end
function worldMapResourceLod:addCacheBefore()
	if self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
	if self.resourceImage then
		self.resourceImage:setVisible(false)
	end
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapResourceLod:initResourceIcon(objData)
	if not self.resourceImage then
		self:initUIResourceIcon()
	end
	local imgName = worldMapDefine.getResourceIconLod(self.resourceClassID) or "lod_goldMine.png"
	self.resourceImage:setSpriteFrame(imgName)
	self.resourceImage:setVisible(true)
end
function worldMapResourceLod:initInstanceData(objData, worldInstanceData, instanceData)
	if self.lod <= worldLodDef.LOD3 then
		self.resourceClassID = worldInstanceData.class
		self:initResourceIcon(objData)
	end
	self:updateData(objData)
end
function worldMapResourceLod:updateLodChange()
	if self.resourceImage then
		self.resourceImage:setVisible(self.lod <= worldLodDef.LOD3)
	end
end
function worldMapResourceLod:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if self.playerID and self.playerID > 0 then
		local leagueID = self.leagueID or 0
		local selfPlayerID = gametop.playertop_:getPlayerID()
		if selfPlayerID == self.playerID or self.lod <= worldLodDef.LOD2 then
			self:setBeOccupyed(selfPlayerID, self.playerID, leagueID)
		elseif self.occupyIcon then
			self.occupyIcon:setVisible(false)
		end
	elseif self.occupyIcon then
		self.occupyIcon:setVisible(false)
	end
end
function worldMapResourceLod:setBeOccupyed(selfPlayerID, playerID, leagueID)
	if not self.occupyIcon then
		self:initUIOccupyIcon()
	end
	self.occupyIcon:setVisible(true)
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local occupyIconName = "lod_Pickaxe-Grey.png"
	if selfPlayerID == playerID then
		occupyIconName = "lod_Pickaxe-G.png"
	elseif selfLeagueID == leagueID then
		occupyIconName = "lod_Pickaxe-B.png"
	else
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
		if allianceRelationType == gMapAllianceRelationType.ALLY then
			occupyIconName = "lod_Pickaxe-C.png"
		elseif allianceRelationType == gMapAllianceRelationType.FRIENDLY then
			occupyIconName = "lod_Pickaxe-Y.png"
		elseif allianceRelationType == gMapAllianceRelationType.ENEMY then
			occupyIconName = "lod_Pickaxe-R.png"
		end
	end
	self.occupyIcon:setSpriteFrame(occupyIconName)
end
return worldMapResourceLod

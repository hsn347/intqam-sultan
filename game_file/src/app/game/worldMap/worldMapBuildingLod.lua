local worldMapBuildingLod = class("worldMapBuildingLod", include("worldMapIconLod"))
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
function worldMapBuildingLod:ctor()
	worldMapBuildingLod.super.ctor(self)
	self:_initData()
end
function worldMapBuildingLod:_initData()
	self.playerID = 0
	self.leagueRank = nil
	self.leagueID = 0
	self.kingdomId = 0
end
function worldMapBuildingLod:_initUI()
	worldMapBuildingLod.super._initUI(self)
	self.imgIcon:setPosition(-6, 9)
	if worldMapDefine.isNebulaAllStarKingdomID() then
		self.imgIcon:setScale(0.3)
	end
end
function worldMapBuildingLod:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.leagueRank then
		self.leagueRank = data.leagueRank
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	if data.kingdomId then
		self.kingdomId = data.kingdomId
	end
	self:setPlayerIcon()
end
local worldLodDef = worldMapDefine.worldLodDef
function worldMapBuildingLod:updateLodChange()
	if self.lod <= worldLodDef.LOD3 then
		if not self.showLod3 then
			self:setPlayerIcon()
		end
	elseif self.showLod3 then
		self:setPlayerIcon()
	end
	if worldMapDefine.isNebulaAllStarKingdomID() then
		if self.lod <= worldLodDef.LOD3 then
			self.imgIcon:setScale(0.3)
		else
			self.imgIcon:setScale(1)
		end
	end
end
function worldMapBuildingLod:setPlayerIcon()
	local imgName
	local imgNameLod3, imgNameLod4 = self:getImgIconName()
	if self.lod == worldLodDef.LOD3 then
		self.showLod3 = true
		imgName = imgNameLod3
	else
		self.showLod3 = false
		imgName = imgNameLod4
	end
	if imgName then
		self:setIcon(imgName)
	end
end
function worldMapBuildingLod:getImgIconName(...)
	local worldMapWarDef = include("worldMapWarDef")
	_ENV = nil
	;(nil).playerID = self.playerID
	;(nil).leagueID = self.leagueID
	;(nil).kingdomId = self.kingdomId
	;(nil).leagueRank = self.leagueRank
	local imgNameLod3, imgNameLod4 = worldMapWarDef.getCastleImage(nil)
	if worldMapDefine.isNebulaAllStarKingdomID() then
		imgNameLod3 = "allstar_player_city.png"
	elseif worldMapDefine.isGardenKingdomID() then
		imgNameLod3 = imgNameLod4
	end
	return imgNameLod3, imgNameLod4
end
return worldMapBuildingLod

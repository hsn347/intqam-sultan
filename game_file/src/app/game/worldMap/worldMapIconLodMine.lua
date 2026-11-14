local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local worldMapIconLodMine = class("worldMapIconLodMine", include("worldMapIconLod"))
function worldMapIconLodMine:ctor()
	worldMapIconLodMine.super.ctor(self)
	self:_initData()
end
function worldMapIconLodMine:_initData()
	self.leagueID = 0
end
function worldMapIconLodMine:initInstanceData(objData, worldInstanceData, instanceData)
	local classID = worldInstanceData.class
	local imgName = "lod_allianceFarm.png"
	local iconLod = allianceStrongholdMineRead.getMineIconLod(classID)
	if iconLod then
		imgName = iconLod
	end
	if imgName then
		self:setIcon(imgName)
	end
	self:updateData(objData)
end
function worldMapIconLodMine:updateData(data)
	if not data then
		return
	end
	if data.leagueID then
		self.leagueID = data.leagueID
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
end
return worldMapIconLodMine

local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local worldMapIconLodCampsite = class("worldMapIconLodCampsite", include("worldMapIconLod"))
function worldMapIconLodCampsite:ctor()
	worldMapIconLodCampsite.super.ctor(self)
	self:_initData()
	self:setIcon("lod_marchingQueue.png")
end
function worldMapIconLodCampsite:_initData()
	self.playerID = 0
	self.leagueID = 0
end
function worldMapIconLodCampsite:updateData(data)
	if not data then
		return
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.leagueID then
		self.leagueID = data.leagueID
	end
	local worldMapWarDef = include("worldMapWarDef")
	_ENV = nil
	;(nil).playerID = self.playerID
	;(nil).leagueID = self.leagueID
	local nameColor = worldMapWarDef.getNameColor(nil)
	self:setColor(nameColor)
end
return worldMapIconLodCampsite

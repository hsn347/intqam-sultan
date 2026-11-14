local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local worldMapBuildConnect = class("worldMapBuildConnect", function(target)
	return target
end)
local gMapObjTypeDef = _G.gMapObjTypeDef
function worldMapBuildConnect:_initBuildConnect()
	self.connect = nil
	self.buildRect = nil
end
function worldMapBuildConnect:updateBuildConnect(data)
	if data.connect ~= nil then
		self.connect = data.connect
	end
end
function worldMapBuildConnect:isConnected()
	if self.connect then
		local kid = gametop.playertop_:getKingdomID()
		if self.leagueID and self.leagueID > 0 and kid == self.sourceID then
			local selfLeagueID = allianceMgr:getOwnTeamID() or 0
			for _, v in pairs(self.connect) do
				if v and v.teamId and v.teamId == selfLeagueID then
					return true
				end
			end
		else
			local radianceWarDef = include("radianceWarDef")
			local objId = self:getSiteClassID()
			if objId == radianceWarDef.RADIANCE_WAR_PALACE_ID or radianceWarDef.RADIANCE_WAR_PALACE_BEACON_ID[objId] then
				local selfLeagueID = allianceMgr:getOwnTeamID() or 0
				for _, v in pairs(self.connect) do
					if v and v.teamId and v.teamId == selfLeagueID then
						return true
					end
				end
			else
				for _, v in pairs(self.connect) do
					if v and v.kid and v.kid == kid then
						return true
					end
				end
			end
		end
	end
	if self.instanceType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
		local initTilePoint = cityCtrl:getCurCityPos()
		for i = 0, 1 do
			for j = 0, 1 do
				local pos = cc.p(initTilePoint.x + i, initTilePoint.y + j)
				if self:isInSelfManor(pos) then
					return true
				end
			end
		end
	end
	return false
end
function worldMapBuildConnect:isInSelfManor(pos)
	if not self.buildRect then
		local range = self.radioation
		local size = self.size + range * 2
		local tilePoint = self:getTilePoint()
		self.buildRect = cc.rect(tilePoint.x - range, tilePoint.y - range, size - 1, size - 1)
	end
	if cc.rectContainsPoint(self.buildRect, pos) then
		return true
	end
	return false
end
return worldMapBuildConnect

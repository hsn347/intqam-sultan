local worldMapComManorline = class("worldMapComManorline", include("worldMapCom"))
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
function worldMapComManorline:ctor()
	worldMapComManorline.super.ctor(self, "worldMapComManorline")
end
function worldMapComManorline:onExit()
	worldMapComManorline.super.onExit(self)
	for _, v in pairs(self.updateLeagueManorLineTimeArrary) do
		if v.handle then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(v.handle)
		end
	end
	self.updateLeagueManorLineTimeArrary, worldMapComManorline = pairs(self.updateLeagueManorLineTimeArrary)
end
function worldMapComManorline:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE", handler(self, self.updateLeagueManorInstance))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
end
function worldMapComManorline:updateLeagueManorInstance(target, data)
	local instanceID = data.instanceID
	local leagueID = data.leagueID
	local kingdomID = data.kingdomID
	local tilePoint = data.tilePoint
	local updateType = data.updateType
	local activiyStatus = data.activityStatus
	activiyStatus = false
	local size = data.size or 1
	local radioation = data.radioation or 2
	if leagueID and 0 < leagueID then
		local manorDataArrary = self.currentShowLeagueManorDataArrary[leagueID]
		if updateType == worldMapLeagueManorUpdateType.leagueManorInstanceAdd then
			_UPVALUE4_ = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
			worldMapLeagueManorUpdateType.leagueManorInstanceAdd[1] = tonumber(tilePoint.x) - radioation
			worldMapLeagueManorUpdateType.leagueManorInstanceAdd[2] = tonumber(tilePoint.y) - radioation
			worldMapLeagueManorUpdateType.leagueManorInstanceAdd[3] = 2 * radioation + size
			local worldMapLeagueManorUpdateType.leagueManorInstanceAdd[4], lineData = 2 * radioation + size, worldMapLeagueManorUpdateType.leagueManorInstanceAdd
			if not manorDataArrary then
				manorDataArrary[2], _ENV, manorDataArrary[1], _ENV, manorDataArrary, _ENV = tonumber(tilePoint.x) - radioation, tonumber(tilePoint.x) - radioation, tonumber(tilePoint.x) - radioation, tonumber(tilePoint.x) - radioation, tonumber(tilePoint.x) - radioation, tonumber(tilePoint.x) - radioation
			end
			if activiyStatus then
				manorDataArrary[1][instanceID] = lineData
			else
				manorDataArrary[2][instanceID] = lineData
			end
		elseif updateType == worldMapLeagueManorUpdateType.leagueManorInstanceRemove then
			if not manorDataArrary then
				return
			end
			if manorDataArrary then
				if activiyStatus then
					manorDataArrary[1][instanceID] = nil
				else
					manorDataArrary[2][instanceID] = nil
				end
			end
		elseif updateType == worldMapLeagueManorUpdateType.leagueManorInstanceActiviy then
			if not manorDataArrary then
				return
			end
			if activiyStatus then
				local manorData = manorDataArrary[2][instanceID]
				if manorData then
					manorDataArrary[1][instanceID] = manorData
					manorDataArrary[2][instanceID] = nil
				end
			else
				local manorData = manorDataArrary[1][instanceID]
				if manorData then
					manorDataArrary[2][instanceID] = manorData
					manorDataArrary[1][instanceID] = nil
				end
			end
		elseif updateType == worldMapLeagueManorUpdateType.leagueManorRelationChange then
		end
		self.currentShowLeagueManorDataArrary[leagueID] = manorDataArrary
		self.updateLeagueManorLineArrary[leagueID] = kingdomID
	end
end
function worldMapComManorline:cleanData()
	for _, manorLineArrary in pairs(self.currentShowLeagueManorLineArrary) do
		if manorLineArrary then
			for _, v in pairs(manorLineArrary[1]) do
				v.worldMapCell:addToCache(v, 1)
			end
			for _, v in pairs(manorLineArrary[2]) do
				v.worldMapCell:addToCache(v, 2)
			end
		end
	end
end
function worldMapComManorline:resetData()
	self.updateLeagueManorLineTimeArrary, allianceMgr, self.updateLeagueManorLineArrary, allianceMgr, self.currentShowLeagueManorDataArrary, allianceMgr, self.currentShowLeagueManorLineArrary, allianceMgr = nil, nil, nil, nil, nil, nil, nil, nil
	self.myLeagueID = allianceMgr:getOwnTeamID()
end
function worldMapComManorline:updateInfo()
	self:updateLeagueManorLine()
end
function worldMapComManorline:updateLeagueManorLine(dt)
	if self.updateLeagueManorLineArrary then
		for k, v in pairs(self.updateLeagueManorLineArrary) do
			local updateData = self.updateLeagueManorLineTimeArrary[k]
			local nowTime = os.time()
			if updateData == nil then
				updateData, _ENV = nil, nil
			end
			if updateData.time and nowTime - updateData.time <= 1 then
				local handle = SoraDDelayCallOnce("league_" .. k, function()
					if self.updateLeagueManorLineTimeArrary[k] then
						self.updateLeagueManorLineTimeArrary[k].handle = nil
						self:drawLeagueManor(k, v)
					end
				end, 0.2, true)
				if handle then
					updateData.handle = handle
				end
			else
				self:drawLeagueManor(k, v)
			end
			updateData.time = nowTime
			self.updateLeagueManorLineArrary[k] = nil
			self.updateLeagueManorLineTimeArrary[k] = updateData
		end
	end
end
function worldMapComManorline:drawLeagueManor(leagueID, kingdomID)
	local manorLineArrary = self.currentShowLeagueManorLineArrary[leagueID]
	if manorLineArrary then
		for _, v in pairs(manorLineArrary[1]) do
			v.worldMapCell:addToCache(v, 1)
		end
		for _, v in pairs(manorLineArrary[2]) do
			v.worldMapCell:addToCache(v, 2)
		end
		manorLineArrary = nil
		self.currentShowLeagueManorLineArrary[leagueID] = manorLineArrary
	end
	local manorDataArrary = self.currentShowLeagueManorDataArrary[leagueID]
	if manorDataArrary then
		manorLineArrary[2], _ENV, manorLineArrary[1], _ENV, manorLineArrary, _ENV = pairs(manorLineArrary[2])
		local mapViewCell = self.target_:getWorldMapCell(kingdomID)
		if mapViewCell then
			local lineColor
			local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
			self.myLeagueID = allianceMgr:getOwnTeamID()
			if self.myLeagueID == leagueID then
				lineColor = worldMapDefine.getLeagueManorLineColor(true)
			else
				lineColor = worldMapDefine.getLeagueManorLineColor(false, allianceRelationType)
				local selfSourceID = lordInfoCtrl:getMapSourceKid()
				local isMatchKingdom = conquestWarCtrl:isMatchKingdom(selfSourceID, kingdomID)
				if isMatchKingdom then
					lineColor = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ENEMY)
				end
			end
			if manorDataArrary[1] and next(manorDataArrary[1]) then
				local _ENV, rectangleData1 = next(manorDataArrary[1]), next(manorDataArrary[1])
				for _, v in pairs(manorDataArrary[1]) do
					table.insertto(rectangleData1, v)
				end
				local manorLineArrary1 = mapViewCell:mergePolygonAndDraw(rectangleData1, true, lineColor, self.target_.containerView)
				manorLineArrary[1] = manorLineArrary1
			end
			if manorDataArrary[2] and next(manorDataArrary[2]) then
				local _ENV, rectangleData2 = next(manorDataArrary[2]), next(manorDataArrary[2])
				for _, v in pairs(manorDataArrary[2]) do
					table.insertto(rectangleData2, v)
				end
				local manorLineArrary2 = mapViewCell:mergePolygonAndDraw(rectangleData2, false, lineColor, self.target_.containerView)
				manorLineArrary[2] = manorLineArrary2
			end
			self.currentShowLeagueManorLineArrary[leagueID] = manorLineArrary
		end
	end
end
function worldMapComManorline:isInselfOrAllyLeagueManor(tilePoint, isCheckScore)
	isCheckScore = isCheckScore or false
	local isIn = false
	local isScoreEnough = false
	for leagueID, dataArrary in pairs(self.currentShowLeagueManorDataArrary) do
		if isIn then
			break
		end
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
		if self.myLeagueID == leagueID or allianceRelationType == gMapAllianceRelationType.ALLY then
			local data = dataArrary[1]
			for _, v in pairs(data) do
				if isIn then
					break
				end
				local mamorRect = cc.rect(v[1], v[2], v[3] - 1, v[4] - 1)
				if cc.rectContainsPoint(mamorRect, tilePoint) then
					isIn = true
					if isCheckScore then
						if self.myLeagueID == leagueID then
							if allianceRelationCtrl:getTerrScore(self.myLeagueID) > 15000 then
								isScoreEnough = true
							end
							break
						end
						if allianceRelationCtrl:getTerrScore(self.myLeagueID) > 15000 and allianceRelationCtrl:getTerrScore(leagueID) > 15000 then
							isScoreEnough = true
						end
					end
					break
				end
			end
		end
	end
	if isCheckScore then
		return isIn and isScoreEnough
	end
	return isIn
end
function worldMapComManorline:isInSelfLeagueManor(leagueID, selfManorRect)
	local isInSelfLeagueManor = false
	local selfLeagueManorDataArrary = self.currentShowLeagueManorDataArrary[leagueID]
	if selfLeagueManorDataArrary then
		for k, v in pairs(selfLeagueManorDataArrary[1]) do
			if k ~= "leagueManorInstanceID" then
				local mamorRect = cc.rect(v[1], v[2], v[3], v[4])
				local isIn = SoraDRectIntersectsRect(selfManorRect, mamorRect, true)
				if isIn then
					isInSelfLeagueManor = true
					break
				end
			end
		end
	end
	return isInSelfLeagueManor
end
function worldMapComManorline:isInOtherLeagueManor(leagueID, selfManorRect)
	local isInOtherLeagueManor = false
	for k, v in pairs(self.currentShowLeagueManorDataArrary) do
		if isInOtherLeagueManor then
			break
		end
		if k ~= leagueID then
			for _, m in ipairs(v) do
				if isInOtherLeagueManor then
					break
				end
				for _, n in pairs(m) do
					local mamorRect = cc.rect(n[1], n[2], n[3], n[4])
					local isIn = SoraDRectIntersectsRect(selfManorRect, mamorRect, false)
					if isIn then
						isInOtherLeagueManor = true
						break
					end
				end
			end
		end
	end
	return isInOtherLeagueManor
end
function worldMapComManorline:exportMethods()
	_UPVALUE4_ = nil
	;(nil)[1] = "isInselfOrAllyLeagueManor"
	;(nil)[2] = "updateLeagueManorInstance"
	;(nil)[3] = "isInSelfLeagueManor"
	;(nil)[4] = "isInOtherLeagueManor"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComManorline

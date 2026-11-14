local worldMapComManorlineWar = class("worldMapComManorlineWar", include("worldMapCom"))
function worldMapComManorlineWar:ctor()
	worldMapComManorlineWar.super.ctor(self, "worldMapComManorlineWar")
end
function worldMapComManorlineWar:onExit()
	worldMapComManorlineWar.super.onExit(self)
	for _, v in pairs(self.updateLeagueManorLineTimeArrary) do
		if v.handle then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(v.handle)
		end
	end
	self.updateLeagueManorLineTimeArrary, worldMapComManorlineWar = pairs(self.updateLeagueManorLineTimeArrary)
end
function worldMapComManorlineWar:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE", handler(self, self.updateLeagueManorInstance))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
end
function worldMapComManorlineWar:updateLeagueManorInstance(target, data)
	local instanceID = data.instanceID
	local leagueID = data.leagueID
	local lineColor = data.lineColor
	local tilePoint = data.tilePoint
	local updateType = data.updateType
	local size = data.size or 1
	local radioation = data.radioation or 0
	local radioationX = data.radioationX or radioation
	local radioationY = data.radioationY or radioation
	if leagueID and 0 < leagueID then
		local manorDataArrary = self.currentShowLeagueManorDataArrary[leagueID]
		if updateType == worldMapLeagueManorUpdateType.leagueManorInstanceAdd then
			_UPVALUE4_ = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
			worldMapLeagueManorUpdateType.leagueManorInstanceAdd[1] = tonumber(tilePoint.x) - radioationX
			worldMapLeagueManorUpdateType.leagueManorInstanceAdd[2] = tonumber(tilePoint.y) - radioationY
			worldMapLeagueManorUpdateType.leagueManorInstanceAdd[3] = 2 * radioationX + size
			local worldMapLeagueManorUpdateType.leagueManorInstanceAdd[4], lineData = 2 * radioationY + size, worldMapLeagueManorUpdateType.leagueManorInstanceAdd
			if not manorDataArrary then
				manorDataArrary, _ENV = tonumber(tilePoint.x) - radioationX, tonumber(tilePoint.x) - radioationX
				self.currentShowLeagueManorDataArrary[leagueID] = manorDataArrary
			end
			_ENV = self.currentShowLeagueManorDataArrary
			self.currentShowLeagueManorDataArrary.lineData = lineData
			manorDataArrary[instanceID], self.currentShowLeagueManorDataArrary.lineColor = self.currentShowLeagueManorDataArrary, lineColor
		elseif updateType == worldMapLeagueManorUpdateType.leagueManorInstanceRemove then
			if not manorDataArrary then
				return
			end
			manorDataArrary[instanceID] = nil
		end
		self.updateLeagueManorLineArrary[instanceID] = leagueID
	end
end
function worldMapComManorlineWar:cleanData()
	for _, manorLineArrary in pairs(self.currentShowLeagueManorLineArrary) do
		if manorLineArrary then
			for _, lineArrary in pairs(manorLineArrary) do
				for _, v in pairs(lineArrary) do
					v.worldMapCell:addToCache(v, 1)
				end
			end
		end
	end
end
function worldMapComManorlineWar:resetData()
	self.updateLeagueManorLineTimeArrary, _UPVALUE0_, self.updateLeagueManorLineArrary, _UPVALUE0_, self.currentShowLeagueManorDataArrary, _UPVALUE0_, self.currentShowLeagueManorLineArrary, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function worldMapComManorlineWar:updateInfo()
	self:updateLeagueManorLine()
end
function worldMapComManorlineWar:updateLeagueManorLine(dt)
	if self.updateLeagueManorLineArrary then
		for k, v in pairs(self.updateLeagueManorLineArrary) do
			local updateData = self.updateLeagueManorLineTimeArrary[k]
			local nowTime = os.time()
			if updateData == nil then
				updateData, _ENV = nil, nil
			end
			if updateData.time and nowTime - updateData.time <= 1 then
				local handle = SoraDDelayCallOnce("instance_" .. k, function()
					if self.updateLeagueManorLineTimeArrary[k] then
						self.updateLeagueManorLineTimeArrary[k].handle = nil
						self:drawLeagueManor(v, k)
					end
				end, 0.2, true)
				if handle then
					updateData.handle = handle
				end
			else
				self:drawLeagueManor(v, k)
			end
			updateData.time = nowTime
			self.updateLeagueManorLineArrary[k] = nil
			self.updateLeagueManorLineTimeArrary[k] = updateData
		end
	end
end
function worldMapComManorlineWar:drawLeagueManor(leagueID, instanceID)
	local manorLineArrary = self.currentShowLeagueManorLineArrary[leagueID]
	if manorLineArrary and manorLineArrary[instanceID] then
		local lineArrary = manorLineArrary[instanceID]
		manorLineArrary[instanceID] = nil
		for _, v in pairs(lineArrary) do
			v.worldMapCell:addToCache(v, 1)
		end
	end
	local manorDataArrary = self.currentShowLeagueManorDataArrary[leagueID]
	if manorDataArrary then
		local mapViewCell = self.target_:getWorldMapCell()
		if mapViewCell and manorDataArrary and manorDataArrary[instanceID] then
			local v = manorDataArrary[instanceID]
			local manorLineData = mapViewCell:mergePolygonAndDraw(v.lineData, true, v.lineColor, self.target_.containerView, 0.49, true, true, "SinglePicture/leagueLine3.png", 0)
			if not manorLineArrary then
				manorLineArrary, _ENV = mapViewCell, mapViewCell
				self.currentShowLeagueManorLineArrary[leagueID] = manorLineArrary
			end
			manorLineArrary[instanceID] = manorLineData
		end
	end
end
function worldMapComManorlineWar:isInSelfLeagueManor(leagueID, selfManorRect, haveBorder)
	local isInSelfLeagueManor = false
	local selfLeagueManorDataArrary = self.currentShowLeagueManorDataArrary[leagueID]
	if selfLeagueManorDataArrary then
		for _, line in pairs(selfLeagueManorDataArrary) do
			local v = line.lineData
			local mamorRect = cc.rect(v[1], v[2], v[3], v[4])
			local isIn = SoraDRectIntersectsRect(selfManorRect, mamorRect, haveBorder)
			if isIn then
				isInSelfLeagueManor = true
				break
			end
		end
	end
	return isInSelfLeagueManor
end
function worldMapComManorlineWar:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "isInSelfLeagueManor"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComManorlineWar

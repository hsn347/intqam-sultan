local worldMapComManorlineBuild = class("worldMapComManorlineBuild", include("worldMapCom"))
function worldMapComManorlineBuild:ctor()
	worldMapComManorlineBuild.super.ctor(self, "worldMapComManorlineBuild")
end
function worldMapComManorlineBuild:onExit()
	worldMapComManorlineBuild.super.onExit(self)
	for _, v in pairs(self.updateLeagueManorLineTimeArrary) do
		if v.handle then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(v.handle)
		end
	end
	self.updateLeagueManorLineTimeArrary, worldMapComManorlineBuild = pairs(self.updateLeagueManorLineTimeArrary)
end
function worldMapComManorlineBuild:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_BUILD_INSTANCE", handler(self, self.updateLeagueManorInstance))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
end
function worldMapComManorlineBuild:updateLeagueManorInstance(target, data)
	local instanceID = data.instanceID
	local lineColor = data.lineColor
	local tilePoint = data.tilePoint
	local updateType = data.updateType
	local size = data.size or 1
	local radioation = data.radioation or 0
	local radioationX = data.radioationX or radioation
	local radioationY = data.radioationY or radioation
	local manorDataArrary = self.currentShowLeagueManorDataArrary[instanceID]
	if updateType == worldMapLeagueManorUpdateType.leagueManorInstanceAdd then
		_UPVALUE4_ = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
		worldMapLeagueManorUpdateType.leagueManorInstanceAdd[1] = tonumber(tilePoint.x) - radioationX
		worldMapLeagueManorUpdateType.leagueManorInstanceAdd[2] = tonumber(tilePoint.y) - radioationY
		worldMapLeagueManorUpdateType.leagueManorInstanceAdd[3] = 2 * radioationX + size
		local worldMapLeagueManorUpdateType.leagueManorInstanceAdd[4], lineData = 2 * radioationY + size, worldMapLeagueManorUpdateType.leagueManorInstanceAdd
		if not manorDataArrary then
			manorDataArrary, _ENV = tonumber(tilePoint.x) - radioationX, tonumber(tilePoint.x) - radioationX
			self.currentShowLeagueManorDataArrary[instanceID] = manorDataArrary
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
	self.updateLeagueManorLineArrary[instanceID] = instanceID
end
function worldMapComManorlineBuild:cleanData()
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
function worldMapComManorlineBuild:resetData()
	self.updateLeagueManorLineTimeArrary, _UPVALUE0_, self.updateLeagueManorLineArrary, _UPVALUE0_, self.currentShowLeagueManorDataArrary, _UPVALUE0_, self.currentShowLeagueManorLineArrary, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function worldMapComManorlineBuild:updateInfo()
	self:updateLeagueManorLine()
end
function worldMapComManorlineBuild:updateLeagueManorLine(dt)
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
						self:drawLeagueManor(k)
					end
				end, 0.2, true)
				if handle then
					updateData.handle = handle
				end
			else
				self:drawLeagueManor(k)
			end
			updateData.time = nowTime
			self.updateLeagueManorLineArrary[k] = nil
			self.updateLeagueManorLineTimeArrary[k] = updateData
		end
	end
end
function worldMapComManorlineBuild:drawLeagueManor(instanceID)
	local manorLineArrary = self.currentShowLeagueManorLineArrary[instanceID]
	if manorLineArrary and manorLineArrary[instanceID] then
		local lineArrary = manorLineArrary[instanceID]
		manorLineArrary[instanceID] = nil
		for _, v in pairs(lineArrary) do
			v.worldMapCell:addToCache(v, 1)
		end
	end
	local manorDataArrary = self.currentShowLeagueManorDataArrary[instanceID]
	if manorDataArrary then
		local mapViewCell = self.target_:getWorldMapCell()
		if mapViewCell and manorDataArrary and manorDataArrary[instanceID] then
			local v = manorDataArrary[instanceID]
			local manorLineData = mapViewCell:mergePolygonAndDraw(v.lineData, true, v.lineColor, self.target_.containerView, 0.49, true, true, "SinglePicture/leagueLine3.png", 0)
			if not manorLineArrary then
				manorLineArrary, _ENV = mapViewCell, mapViewCell
				self.currentShowLeagueManorLineArrary[instanceID] = manorLineArrary
			end
			manorLineArrary[instanceID] = manorLineData
		end
	end
end
function worldMapComManorlineBuild:exportMethods()
	_UPVALUE0_ = nil
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComManorlineBuild

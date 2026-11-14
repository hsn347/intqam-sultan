local createAllianceBuildingFactory = include("createAllianceBuildingFactory")
local createAllianceBuildingCD = include("createAllianceBuildingCD")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceFlagInfo = include("allianceFlagInfo")
local allianceBuildingMgr = class("allianceBuildingMgr")
function allianceBuildingMgr:ctor(aid)
	createAllianceBuildingCD = nil
	;(nil).buildingCountList, createAllianceBuildingCD, (nil).destroyBuildingList, createAllianceBuildingCD, (nil).buildingList, createAllianceBuildingCD, (nil).aid = nil, nil, nil, nil, nil, nil, aid
	;(nil).createCD = createAllianceBuildingCD:create(aid)
	self.property, (nil).flagInfo = nil, allianceFlagInfo.new()
end
function allianceBuildingMgr:destroy()
	for bid, list in pairs(self.property.buildingList) do
		for id, building in pairs(list) do
			building:destroy()
		end
	end
	self.property.buildingList, _ENV = pairs(self.property.buildingList)
	self.property.destroyBuildingList, _ENV = pairs(self.property.buildingList)
	self.property.buildingCountList, _ENV = pairs(self.property.buildingList)
	self:getCreateCDModule():destroy()
	self:getFlagInfoModule():destroy()
	self:notifyWorldMapDestroyAllBuilding()
end
function allianceBuildingMgr:initialize(data)
	local aid = self:getAID()
	dump(data, "allianceBuildingMgr:initialize====", 10)
	if data then
		local buildingData = data.buildingData
		if buildingData then
			for id, data in pairs(buildingData) do
				local bid = data.bid
				local building = createAllianceBuildingFactory:initializeBuilding(bid, data)
				self:addBuilding(building)
			end
		end
		local createCDData = data.createCDData
		if createCDData then
			self:getCreateCDModule():initialize(createCDData)
		end
		local flagInfo = data.flagInfo
		if flagInfo then
			self:getFlagInfoModule():initialize(flagInfo)
		end
		local destroyBuildingList = data.destroyBuildingList
		self:setBuildingDestroyList(destroyBuildingList)
	end
end
function allianceBuildingMgr:getAID()
	return self.property.aid
end
function allianceBuildingMgr:createBuildingUseGold(...)
	return self:createBuilding(gAllianceCreateBuildingCostType.GOLD, ...)
end
function allianceBuildingMgr:createBuildingUseBonus(...)
	return self:createBuilding(gAllianceCreateBuildingCostType.BONUS, ...)
end
function allianceBuildingMgr:destroyBuilding(id, bid)
	local building = self:getBuilding(id, bid)
	if not building then
		return gErrDef.Err_ALLIANCE_BUILDING_NOT_EXIST
	end
	local ret = self:checkDestroyCondition(building)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	ret = self:destroyOneBuilding(building)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	if gAllianceBuilding.PALACE == bid then
		local fortressList = self:getBuildingListByType(gAllianceBuilding.FORTRESS)
		if "table" == type(fortressList) and next(fortressList) then
			local _ENV, destroyBuildingList = next(fortressList), next(fortressList)
			for id, building in pairs(fortressList) do
				table.insert(destroyBuildingList, building)
			end
			for i, building in ipairs(destroyBuildingList) do
				ret = self:destroyOneBuilding(building)
				if gErrDef.Err_None ~= ret then
					print("ALLIANCE EXCEPTION: destroyBuilding: destroyFortress failed! aid, id, fortressID, ret = ", self:getAID(), id, fortressID, ret)
				end
			end
		end
	end
	return gErrDef.Err_None
end
function allianceBuildingMgr:beBattled(id, bid, addBrunTime, addBurnValue)
	local building = self:getBuilding(id, bid)
	if not building then
		return gErrDef.Err_ALLIANCE_BUILDING_NOT_EXIST
	end
	return building:burn(addBrunTime, addBurnValue)
end
function allianceBuildingMgr:getBuildingInfo(id, bid)
	local building = self:getBuilding(id, bid)
	if not building then
		if allianceBuildingltCtrl:isMainBuilding(bid) then
			local allianceBuildingltCtrl, data = allianceBuildingltCtrl:isMainBuilding(bid), allianceBuildingltCtrl:isMainBuilding(bid)
			data.bid = bid
			data.status = gAllianceBuildingStatus.NONE
			data.remainCDTime = self:getCreateCDModule():getCDRemainTime(bid)
			data.HPMax = allianceBuildingltCtrl:getHPMax(bid)
			data.currentHP = 0
			local destroyBuildingData = self:getDestroyBuildingData(bid)
			if destroyBuildingData then
				data.status = destroyBuildingData.status
				data.currentHP = destroyBuildingData.HP
			end
			local update = function()
				data.remainCDTime = self:getCreateCDModule():getCDRemainTime(bid)
			end
			data.update = update
			return data
		end
		return
	end
	local detail = building:getDetail()
	detail.remainCDTime = self:getCreateCDModule():getCDRemainTime(bid)
	local update = function()
		detail.status = building:getStatus()
		detail.currentHP = building:getCurrentHP()
		detail.remainBurningTime = building:getRemainBurningTime()
		detail.burningSpeed = building:getBurningSpeed()
		detail.remainCDTime = self:getCreateCDModule():getCDRemainTime(bid)
	end
	detail.update = update
	detail.buildingData = building.property.buildingData
	return detail
end
function allianceBuildingMgr:getMainBuildingInfo()
	local mainBuildingList = allianceBuildingltCtrl:getMainBuildingList()
	local allianceBuildingltCtrl, ret = allianceBuildingltCtrl, allianceBuildingltCtrl
	for _, bid in pairs(mainBuildingList) do
		local buildingList = self:getBuildingListByType(bid)
		if buildingList then
			for id, building in pairs(buildingList) do
				local data = self:getBuildingInfo(id, bid)
				table.insert(ret, data)
			end
		else
			local data = self:getBuildingInfo(0, bid)
			table.insert(ret, data)
		end
	end
	return ret
end
function allianceBuildingMgr:getBurningBuildingList()
	local _ENV, burningBuilding
	for bid, list in pairs(self.property.buildingList) do
		for id, building in pairs(list) do
			if building:needWarn() then
				local HP = building:calcCurrentHP()
				local HPMax = allianceBuildingltCtrl:getHPMax(bid)
				local HPPer = tonumber(string.match(HP / HPMax * 100, "(%d+)"))
				_ENV = string.match(HP / HPMax * 100, "(%d+)")
				string.match(HP / HPMax * 100, "(%d+)").bid = bid
				string.match(HP / HPMax * 100, "(%d+)").pos = building:getPos()
				string.match(HP / HPMax * 100, "(%d+)").HPPer = HPPer
				table.insert(burningBuilding, string.match(HP / HPMax * 100, "(%d+)"))
			end
		end
	end
	return burningBuilding
end
function allianceBuildingMgr:getIsHaveBuidingInConstruction()
	for bid, list in pairs(self.property.buildingList) do
		for id, building in pairs(list) do
			if building:getStatus() == gAllianceBuildingStatus.BUILDING then
				return true
			end
		end
	end
	return false
end
function allianceBuildingMgr:getAllBuildingPos()
	local mainBuildingList = allianceBuildingltCtrl:getMainBuildingList()
	local allianceBuildingltCtrl, ret = allianceBuildingltCtrl, allianceBuildingltCtrl
	for _, bid in pairs(mainBuildingList) do
		local buildingList = self:getBuildingListByType(bid)
		if buildingList then
			for id, building in pairs(buildingList) do
				local pos = building:getPos()
				allianceBuildingltCtrl = nil
				;(nil).bid = bid
				;(nil).pos = pos
				table.insert(ret, nil)
			end
		end
	end
	local flagPosList = self:getFlagInfoModule():getAllFlagPos()
	for i, v in ipairs(flagPosList) do
		table.insert(ret, v)
	end
	return ret
end
function allianceBuildingMgr:dump()
	print("==================BEGIN==================")
	for bid, list in pairs(self.property.buildingList) do
		for id, building in pairs(list) do
			building:dump()
		end
	end
	self:getCreateCDModule():dump()
	print("==================END==================")
end
function allianceBuildingMgr:createBuilding(costType, bid, pos, creator)
	print("allianceBuildingMgr.createBuilding:", costType, bid, pos, creator)
	local ret = self:checkCreateCondition(bid, pos, creator, costType)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	ret = self:deductCost(costType, bid, creator)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	local aid = self:getAID()
	local building = createAllianceBuildingFactory:createNewBuilding(bid, aid, pos, creator)
	ret = self:notifyWorldMapCreateBuilding(building)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	self:createDone(building)
	return gErrDef.Err_None
end
function allianceBuildingMgr:addBuilding(building)
	if not building then
		return false
	end
	local bid = building:getBID()
	if not self.property.buildingList[bid] then
		_ENV = self.property.buildingList[bid]
	end
	self.property.buildingList[bid] = self.property.buildingList[bid]
	local id = building:getID()
	if not self.property.buildingList[bid][id] then
		self.property.buildingList[bid][id] = building
		self:removeBuildingFromDestroyList(bid)
		self.property.buildingCountList[bid] = self.property.buildingCountList[bid] or 0
		self.property.buildingCountList[bid] = self.property.buildingCountList[bid] + 1
		return true
	else
		print("ALLIANCE EXCEPTION: allianceBuildingMgr.addBuilding: building already exist! id, bid = ", id, bid)
	end
end
function allianceBuildingMgr:removeBuilding(building)
	local id, bid = building:getID(), building:getBID()
	if self.property.buildingList[bid] and self.property.buildingList[bid][id] then
		local building = self.property.buildingList[bid][id]
		self.property.buildingList[bid][id] = nil
		if not next(self.property.buildingList[bid]) then
			self.property.buildingList[bid] = nil
		end
		local buildingData = building:getDBData()
		if allianceBuildingltCtrl:isMainBuilding(bid) then
			self:addBuildingToDestroyList(buildingData)
		end
		if self.property.buildingCountList[bid] then
			self.property.buildingCountList[bid] = self.property.buildingCountList[bid] - 1
			if self.property.buildingCountList[bid] <= 0 then
				self.property.buildingCountList[bid] = nil
			end
		else
			print("ALLIANCE EXCEPTION: allianceBuildingMgr.removeBuilding: not found building count! id, bid = ", id, bid)
		end
		return building
	end
end
function allianceBuildingMgr:addBuildingToDestroyList(buildingData)
	if not buildingData then
		return false
	end
	local bid = buildingData.bid
	local bidStr = tostring(bid)
	self.property.destroyBuildingList[bidStr] = buildingData
end
function allianceBuildingMgr:removeBuildingFromDestroyList(bid)
	local bidStr = tostring(bid)
	local buildingData = self.property.destroyBuildingList[bidStr]
	if buildingData then
		self.property.destroyBuildingList[bidStr] = nil
		return buildingData
	end
end
function allianceBuildingMgr:setBuildingDestroyList(list)

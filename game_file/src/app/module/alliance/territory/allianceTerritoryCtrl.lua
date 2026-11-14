local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceTerritory = include("allianceTerritory")
local allianceTerritoryCtrl = class("allianceTerritoryCtrl", gameModule)
local _ENV, REQ = "allianceTerritoryCtrl", "allianceTerritoryCtrl"
local _ENV, RSP = gameModule, gameModule
function allianceTerritoryCtrl:ctor(properties)
	allianceTerritoryCtrl.super.ctor(self, properties)
	self.property, allianceTerritoryCtrl = allianceTerritoryCtrl.super.ctor, allianceTerritoryCtrl.super.ctor
end
function allianceTerritoryCtrl:EnterGame()
	allianceTerritoryCtrl.super.EnterGame(self)
	self:registerMsg()
end
function allianceTerritoryCtrl:resetData()
	self:destroyTerritory()
	self.buildingFlags, _UPVALUE0_ = self.destroyTerritory, self.destroyTerritory
end
function allianceTerritoryCtrl:Logout()
	allianceTerritoryCtrl.super.Logout(self)
	self:resetData()
end
function allianceTerritoryCtrl:initializeLoginData(data)
	dump(data, "allianceTerritoryCtrl:initializeLoginData==========", 10)
	if not data then
		return
	end
	local aid = data.aid
	self:createTerritory(aid)
	self:getTerritory():initialize(data)
	REQ.reqInitializeData()
end
function allianceTerritoryCtrl:createTerritory(aid)
	self:initializeTerritory(aid)
end
function allianceTerritoryCtrl:destroyTerritory()
	self:destroyRecycleBuildings()
	local territory = self:getTerritory()
	if territory then
		territory:destroy()
		self:removeTerritory()
		return true
	end
	print("ALLIANCE EXCEPTION: destroyTerritory error! territory does not exist!")
	return false
end
function allianceTerritoryCtrl:buildAllianceBuildingUseGold(bid, pos)
	local territory = self:getTerritory()
	if not territory then
		print("ALLIANCE EXCEPTION: allianceTerritoryCtrl.buildAllianceBuildingUseGold: not found territory! bid, pos=", bid, pos)
		return gErrDef.Err_ALLIANCE_NOT_FOUND_TERRITORY
	end
	local aid = territory:getAID()
	REQ.reqBuildBuildingUseGold(aid, bid, pos)
	return gErrDef.Err_None
end
function allianceTerritoryCtrl:buildAllianceBuildingUseBonus(bid, pos, isRecycle)
	local territory = self:getTerritory()
	if not territory then
		print("ALLIANCE EXCEPTION: allianceTerritoryCtrl.buildAllianceBuildingUseBonus: not found territory! bid, pos=", bid, pos)
		return gErrDef.Err_ALLIANCE_NOT_FOUND_TERRITORY
	end
	local aid = territory:getAID()
	REQ.reqBuildBuildingUseBonus(aid, bid, pos, isRecycle)
	return gErrDef.Err_None
end
function allianceTerritoryCtrl:demolishAllianceBuilding(id, bid)
	local territory = self:getTerritory()
	if not territory then
		print("ALLIANCE EXCEPTION: allianceTerritoryCtrl.demolishAllianceBuilding: not found territory! id, bid=", id, bid)
		return gErrDef.Err_ALLIANCE_NOT_FOUND_TERRITORY
	end
	local aid = territory:getAID()
	REQ.reqDemolishAllianceBuilding(aid, id, bid)
	return gErrDef.Err_None
end
function allianceTerritoryCtrl:getAllianceMainBuildingInfo()
	local territory = self:getTerritory()
	if not territory then
		print("ALLIANCE EXCEPTION: allianceTerritoryCtrl.demolishAllianceBuilding: not found territory! id, bid, cid=", id, bid, cid)
		return
	end
	return territory:getBuildingModule():getMainBuildingInfo()
end
function allianceTerritoryCtrl:getBuildingRemainCDTime(bid)
	local territory = self:getTerritory()
	if not territory then
		print("ALLIANCE EXCEPTION: allianceTerritoryCtrl.demolishAllianceBuilding: not found territory! id, bid, cid=", id, bid, cid)
		return 0
	end
	return territory:getBuildingModule():getCreateCDModule():getCDRemainTime(bid)
end
function allianceTerritoryCtrl:getCurrentBuildingHP(id, bid)
	local ret = 0
	local territory = self:getTerritory()
	if not territory then
		print("ALLIANCE EXCEPTION: allianceTerritoryCtrl.demolishAllianceBuilding: not found territory! id, bid, cid=", id, bid, cid)
		return ret
	end
	local building = territory:getBuildingModule():getBuilding(id, bid)
	if not building then
		return ret
	end
	return building:getCurrentHP()
end
function allianceTerritoryCtrl:getAllianceFlagCount()
	return self:getTerritory():getBuildingModule():getFlagInfoModule():getFlagCount()
end
function allianceTerritoryCtrl:getAllianceFlagInfo()
	return self:getTerritory():getBuildingModule():getFlagInfoModule():getFlagInfoList()
end
function allianceTerritoryCtrl:getAllianceBuildingInfo(id, bid)
	local info = self:getTerritory():getBuildingModule():getBuildingInfo(id, bid)
	if info then
		_ENV = id
		id.msg = "MESSAGE_ALLIANCE_GET_BUILDINGINFO_SUCCESS"
		id.buildingInfo = info
		SoraDSendMessage(id)
		return info
	end
	REQ.reqAllianceBuildingData(id, bid)
end
function allianceTerritoryCtrl:restoreAllianceBuilding(id, bid, costType)
	REQ.reqRestoreAllianceBuilding(id, bid, costType)
end
function allianceTerritoryCtrl:getAllianceTaxWarehouseData()
	return self:getTerritory():getTaxModule():getTaxWarehouseData()
end
function allianceTerritoryCtrl:getTaxRecordList(recordIDFlag, count)
	print("allianceTerritoryCtrl:getTaxRecordList", recordIDFlag, count)
	local moreLocalData = self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordLocalData(recordIDFlag)
	local moreServerData = self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData()
	if not moreLocalData and not moreServerData then
		print("本地和服务器都没有更多数据了====================")
		_ENV = "本地和服务器都没有更多数据了===================="
		;("本地和服务器都没有更多数据了====================").data, _ENV, ("本地和服务器都没有更多数据了====================").msg = nil, nil, "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS"
		;("本地和服务器都没有更多数据了====================").more = false
		SoraDSendMessage("本地和服务器都没有更多数据了====================")
		return
	end
	if moreLocalData then
		local ret, list, lastRecordID, more = self:getTerritory():getTaxModule():getRecordList(recordIDFlag, count)
		print("ret = ", ret)
		print("lastRecordID = ", lastRecordID)
		if gErrDef.Err_None == ret then
			local localRecordCount = #list
			print("localRecordCountt", #list)
			if localRecordCount == count or not moreServerData then
				more = more or moreServerData
				if not more then
					lastRecordID = nil
				end
				_ENV = "localRecordCountt"
				;("localRecordCountt").msg = "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS"
				;("localRecordCountt").data = list
				;("localRecordCountt").more = more
				;("localRecordCountt").nextReqFlag = lastRecordID
				SoraDSendMessage("localRecordCountt")
				return
			end
		end
	end
	if moreServerData then
		REQ.reqAllianceTaxRecord(recordIDFlag, count)
	end
end
function allianceTerritoryCtrl:allocateTaxes(resID)
	REQ.reqAllocateTaxes(resID)
end
function allianceTerritoryCtrl:getBurningBuildingList()
	local _UPVALUE0_, ret
	local territory = self:getTerritory()
	if territory then
		ret = territory:getBuildingModule():getBurningBuildingList()
	end
	return ret
end
function allianceTerritoryCtrl:getTaxPer()
	return self:getTerritory():getTaxModule():getTaxPer()
end
function allianceTerritoryCtrl:getAreas()
	return self:getTerritory():getAreasModule():getAreas()
end
function allianceTerritoryCtrl:getIsHaveBuidingInConstruction()
	return self:getTerritory():getBuildingModule():getIsHaveBuidingInConstruction()
end
function allianceTerritoryCtrl:getAllBuildingPos()
	return self:getTerritory():getBuildingModule():getAllBuildingPos()
end
function allianceTerritoryCtrl:getTerritory()
	return self.property.territory
end
function allianceTerritoryCtrl:initializeTerritory(aid)
	if not self:getTerritory() then
		self.property.territory = allianceTerritory.new(aid)
	end
	return self:getTerritory()
end
function allianceTerritoryCtrl:removeTerritory()
	self.property.territory = nil
end
function allianceTerritoryCtrl:updateData(notifyMsg)
	dump(notifyMsg, "allianceTerritoryCtrl.updateData rspMsg", 5)
	local notifyType = notifyMsg.notifyType
	local notifyData = notifyMsg.notifyData
	local flagInfo = notifyMsg.flagInfo
	if "create" == notifyType then
		local bid = notifyData.bid
		local building = include("createAllianceBuildingFactory"):initializeBuilding(bid, notifyData)
		local territory = self:getTerritory()
		if territory then
			territory:getBuildingModule():addBuilding(building)
		end
		if gAllianceBuilding.FLAG == bid then
			local creator = flagInfo.creator
			local nickname = flagInfo.nickname or ""
			local iconID = flagInfo.iconID
			local avatar = flagInfo.avatar
			local pos = flagInfo.pos
			local status = notifyData.status
			territory:getBuildingModule():getFlagInfoModule():addFlag(creator, nickname, pos, iconID, avatar, status)
			if status == gAllianceBuildingStatus.BUILDING then
				table.insert(self.buildingFlags, notifyData)
			end
		end
		local id = notifyData.id
		_ENV = flagInfo.iconID
		flagInfo.iconID.msg = "MESSAGE_ALLIANCE_BUILDING_CHANGE"
		flagInfo.iconID.id = id
		flagInfo.iconID.bid = bid
		SoraDSendMessage(flagInfo.iconID)
	elseif "destroy" == notifyType then
		local aid = notifyData.aid
		local bid = notifyData.bid
		local id = notifyData.id
		local pos = notifyData.pos
		local territory = self:getTerritory()
		if territory then
			territory:demolishBuilding(id, bid)
		end
		if gAllianceBuilding.FLAG == bid then
			local creator = flagInfo.creator
			territory:getBuildingModule():getFlagInfoModule():removeFlag(creator, pos)
			local _ENV, flags = territory:getBuildingModule():getFlagInfoModule().removeFlag, territory:getBuildingModule():getFlagInfoModule().removeFlag
			for k, v in ipairs(self.buildingFlags) do
				if v.id ~= id then
					table.insert(flags, v)
				end
			end
			self.buildingFlags = flags
		end
		local CDFinishTime = notifyData.CDFinishTime
		if CDFinishTime then
			self:getTerritory():getBuildingModule():getCreateCDModule():startTimingCD(bid, CDFinishTime)
		end
		_ENV = self:getTerritory():getBuildingModule():getCreateCDModule()
		self:getTerritory():getBuildingModule():getCreateCDModule().msg = "MESSAGE_ALLIANCE_BUILDING_CHANGE"
		self:getTerritory():getBuildingModule():getCreateCDModule().id = id
		self:getTerritory():getBuildingModule():getCreateCDModule().bid = bid
		SoraDSendMessage((self:getTerritory():getBuildingModule():getCreateCDModule()))
		_ENV = self:getTerritory():getBuildingModule():getCreateCDModule()
		self:getTerritory():getBuildingModule():getCreateCDModule().msg = "MESSAGE_ALLIANCE_BUILDING_DESTROY"
		self:getTerritory():getBuildingModule():getCreateCDModule().id = id
		self:getTerritory():getBuildingModule():getCreateCDModule().bid = bid
		SoraDSendMessage((self:getTerritory():getBuildingModule():getCreateCDModule()))
	elseif "statusChange" == notifyType then
		local bid = notifyData.bid
		local id = notifyData.id
		local territory = self:getTerritory()
		if territory then
			local building = territory:getBuildingModule():getBuilding(id, bid)
			if building then
				building.property = notifyData
			else
				local building = include("createAllianceBuildingFactory"):initializeBuilding(bid, notifyData)
				territory:getBuildingModule():addBuilding(building)
			end
		end
		if gAllianceBuilding.FLAG == bid then
			if notifyData.status == gAllianceBuildingStatus.BUILDING then
				for k, v in ipairs(self.buildingFlags) do
					if v.id == id then
						self.buildingFlags[k] = notifyData
					end
				end
			else
				local _ENV, flags = ipairs(self.buildingFlags)
				for k, v in ipairs(self.buildingFlags) do
					if v.id ~= id then
						table.insert(flags, v)
					end
				end
				self.buildingFlags = flags
			end
		end
		_ENV = ipairs(self.buildingFlags)
		ipairs(self.buildingFlags).msg = "MESSAGE_ALLIANCE_BUILDING_CHANGE"
		ipairs(self.buildingFlags).id = id
		ipairs(self.buildingFlags).bid = bid
		ipairs(self.buildingFlags).notifyData = notifyData
		SoraDSendMessage(ipairs(self.buildingFlags))
		_ENV = ipairs(self.buildingFlags)
		ipairs(self.buildingFlags).msg = "MESSAGE_GREEN_POINT_UPDATE"
		ipairs(self.buildingFlags).type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_BUILD
		SoraDSendMessage(ipairs(self.buildingFlags))
	elseif "levyTaxes" == notifyType then
		local territory = self:getTerritory()
		if territory then
			self:getTerritory():getTaxModule():levyTaxes(notifyData)
		end
	elseif "allocateRes" == notifyType then
		local resID = notifyData.resID
		local territory = self:getTerritory()
		if territory then
			self:getTerritory():getTaxModule():allocateTaxes(resID)
		end
	elseif "terrAreaChange" == notifyType then
		local areas = notifyData.areas
		local territory = self:getTerritory()
		if territory then
			self:getTerritory():getAreasModule():setAreas(areas)
			_ENV = self:getTerritory():getAreasModule()
			self:getTerritory():getAreasModule().msg = "MESSAGE_ALLIANCE_BUILDING_CHANGE"
			SoraDSendMessage((self:getTerritory():getAreasModule()))
		end
	elseif "allianceRes" == notifyType then
		local territory = self:getTerritory()
		if territory then
			self:getTerritory():getTaxModule():setTaxWarehouseData(notifyData.resData)
			_ENV = self:getTerritory():getTaxModule()
			self:getTerritory():getTaxModule().msg = "MESSAGE_ALLIANCE_COST_RECORD_BACK"
			SoraDSendMessage((self:getTerritory():getTaxModule()))
		end
	elseif "resMineList" == notifyType then
		local allianceBuild = gametop.playertop_:getModule("allianceBuild")
		allianceBuild:setResMineList(notifyData.resMineList)
		_ENV = allianceBuild
		allianceBuild.msg = "MESSAGE_ALLIANCE_COST_RECORD_BACK"
		SoraDSendMessage(allianceBuild)
	elseif "recycleBuildings" == notifyType then
		self:initRecycleBuildings(notifyData.recycleBuildings)
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_BUILDING_CHANGE"
		SoraDSendMessage(self)
	end
end
function allianceTerritoryCtrl:onUpdateTargetActivity(data)
	self:getTerritory():setGoalActivityData(data)
end
function allianceTerritoryCtrl:getGoalActivity()
	return self:getTerritory():getGoalActivityData()
end
function allianceTerritoryCtrl:getBuildingFlags()
	return self.buildingFlags
end
function allianceTerritoryCtrl:getBuildingFlagByID(id)
	for k, v in ipairs(self.buildingFlags) do
		if v.id == id then
			return v.buildingData
		end
	end
	return nil
end
function allianceTerritoryCtrl:destroyRecycleBuildings(...)
	self.property.recycleBuildings, _UPVALUE0_ = nil, nil
end
function allianceTerritoryCtrl:initRecycleBuildings(recycleBuildings)
	local _ENV, ret
	for k, v in pairs(recycleBuildings) do
		if v and 0 < v then
			_ENV = nil
			;(nil).bid = tonumber(k)
			;(nil).count = v
			table.insert(ret, nil)
		end
	end
	table.sort(ret, function(a, b)
		return a.bid < b.bid
	end)
	self.property.recycleBuildings = ret
end
function allianceTerritoryCtrl:getRecycleBuildings(...)
	return self.property.recycleBuildings
end
function allianceTerritoryCtrl:checkHasRecycleBuilding(...)
	if self.property.recycleBuildings and next(self.property.recycleBuildings) then
		return true
	end
end
function allianceTerritoryCtrl:checkIsRecycleBuilding(bid)
	if not self.property.recycleBuildings then
		return false
	end
	for i, v in ipairs(self.property.recycleBuildings) do
		if v.bid == bid then
			return v.count > 0
		end
	end
end
function RSP:getInitializeDataRsp(rspData)
	dump(rspData, "RSP.getInitializeTerritoryDataRsp ===============================", 5)
	if not rspData.data then
		local _ENV, data = rspData.data, rspData.data
	end
	if not data.flagData then
		local _ENV, flagData = data.flagData, data.flagData
	end
	local flagInfo = flagData.flagInfo
	if flagInfo and next(flagInfo) then
		local territory = self:getTerritory()
		if territory then
			territory:getBuildingModule():getFlagInfoModule():initialize(flagInfo)
		end
	end
	local burningFlags = flagData.burningFlags
	if burningFlags and next(burningFlags) then
		local territory = self:getTerritory()
		if territory then
			for i, v in ipairs(burningFlags) do
				local bid = v.bid
				local building = include("createAllianceBuildingFactory"):initializeBuilding(bid, v)
				territory:getBuildingModule():addBuilding(building)
			end
		end
	end
	if not flagData.buildingFlags then
		_ENV = flagData.buildingFlags
	end
	self.buildingFlags = flagData.buildingFlags
end
function RSP:buildBuildingUseGoldRsp(rspData)
	if rspData.err ~= gErrDef.Err_None then
	end
end
function RSP:buildBuildingUseBonusRsp(rspData)
	dump(rspData, "RSP.buildBuildingUseBonusRsp", 5)
	if rspData.err ~= gErrDef.Err_None then
		if gErrDef.Err_ALLIANCE_BUILDING_COUNT_LIMIT == rspData.err and gAllianceBuilding.ALTAR == rspData.data.bid then
			SoraDShowMsgTip(i18n("alliance_beast_notice_10"))
		end
		if gErrDef.Err_ALLIANCE_BUILD_TOUCH_OTHER_ALLIANCE == rspData.err then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_014"))
		end
		if gErrDef.Err_ALLIANCE_IN_BUILDING_COUNT_LIMIT == rspData.err then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_095"))
		end
		if gErrDef.Err_ALLIANCE_RES_NOT_ENOUGH == rspData.err then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_015"))
		end
	end
end
function RSP:demolishAllianceBuildingRsp(rspData)
	if rspData.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_BUILDING_DEMOLISH_SUCCESS"
		gErrDef.Err_None.bid = rspData.data.bid
		gErrDef.Err_None.id = rspData.data.id
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:getAllianceBuildingDataRsp(rspData)
	if rspData.err == gErrDef.Err_None then
		local buildingData = rspData.data.buildingData
		local id = buildingData.id
		local bid = buildingData.bid
		local territory = self:getTerritory()
		if territory then
			local building = territory:getBuildingModule():getBuilding(id, bid)
			if building then
				building.property = buildingData
			else
				local building = include("createAllianceBuildingFactory"):initializeBuilding(bid, buildingData)
				territory:getBuildingModule():addBuilding(building)
			end
		end
		local info = self:getTerritory():getBuildingModule():getBuildingInfo(id, bid)
		if info then
			_ENV = id
			id.msg = "MESSAGE_ALLIANCE_GET_BUILDINGINFO_SUCCESS"
			id.buildingInfo = info
			SoraDSendMessage(id)
			return
		end
	end
end
function RSP:restoreBuildingRsp(rspData)
	if rspData.err == gErrDef.Err_None then
	end
end
function RSP:allocateTaxesRsp(rspData)
	if rspData.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_GIVETAX_SUCCESS"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function RSP:getAllianceTaxRecordRsp(rspData)
	if rspData.err == gErrDef.Err_None then
		local recordList = rspData.data.recordList
		for k, v in pairs(recordList) do
			self:getTerritory():getTaxModule():getTaxRecordModule():newRecord(v)
		end
		local more = rspData.data.more
		if not more then
			self:getTerritory():getTaxModule():completeServerDataReq()
		end
		local flag = rspData.data.flag
		local count = rspData.data.count
		local ret, data, lastRecordID = self:getTerritory():getTaxModule():getRecordList(flag, count)
		if gErrDef.Err_None == ret then
			local moreServerData = self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData()
			_ENV = nil
			;(nil).msg = "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS"
			;(nil).data = data
			;(nil).more = moreServerData
			;(nil).nextReqFlag = lastRecordID
			SoraDSendMessage(nil)
		end
	elseif rspData.err == gErrDef.Err_ALLIANCE_TAX_NO_MORE_RECORD then
		self:getTerritory():getTaxModule():completeServerDataReq()
		local flag = rspData.data.flag
		local count = rspData.data.count
		local ret, data, lastRecordID = self:getTerritory():getTaxModule():getRecordList(flag, count)
		if gErrDef.Err_None == ret then
			local moreServerData = self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData()
			_ENV = self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData()
			self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData().msg = "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS"
			self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData().data = data
			self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData().more = moreServerData
			self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData().nextReqFlag = lastRecordID
			SoraDSendMessage((self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData()))
		else
			_ENV = SoraDSendMessage
			SoraDSendMessage.data, _ENV, SoraDSendMessage.msg = self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData(), self:getTerritory():getTaxModule():getTaxRecordModule():moreRecordServerData(), "MESSAGE_ALLIANCE_GET_TAXRECORD_SUCCESS"
			SoraDSendMessage.more = false
			SoraDSendMessage(SoraDSendMessage)
		end
	end
end
function REQ.reqInitializeData()
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_TERRITORY_INIT_DATA)
end
function REQ.reqBuildBuildingUseGold(aid, bid, pos)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).bid = bid
	local (nil).pos, data = pos, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BUILD_BUILDING_USE_GOLD, data)
end
function REQ.reqBuildBuildingUseBonus(aid, bid, pos, isRecycle)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).bid = bid
	;(nil).pos = pos
	local (nil).isRecycle, data = isRecycle, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BUILD_BUILDING_USE_BONUS, data)
end
function REQ.reqDemolishAllianceBuilding(aid, id, bid)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).id = id
	local (nil).bid, data = bid, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMOLISH_TERR_BUILDING, data)
end
function REQ.reqAllianceBuildingData(id, bid)
	serverproxy = nil
	;(nil).id = id
	local (nil).bid, data = bid, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_BUILDING_INFO, data)
end
function REQ.reqRestoreAllianceBuilding(id, bid, costType)
	serverproxy = nil
	;(nil).id = id
	;(nil).bid = bid
	local (nil).costType, data = costType, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RESTORE_BUILDING, data)
end
function REQ.reqAllocateTaxes(resID)
	serverproxy = nil
	local (nil).resID, data = resID, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ALLOCATE_TAXES, data)
end
function REQ.reqAllianceTaxRecord(flag, count)
	serverproxy = nil
	;(nil).flag = flag
	local (nil).count, data = count, nil
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_ALLIANCE_TAX_RECORD, data)
end
function REQ.modifyTerritoryColor(colorId)
	serverproxy = nil
	;(nil).colorId = colorId
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_TERRITORY_COLOR, nil)
end
function allianceTerritoryCtrl:modifyTerritoryColor(...)
	REQ.modifyTerritoryColor(...)
end
function RSP:modifyTerritoryColorRsp(rspData)
	dump(rspData, "RSP.modifyTerritoryColorRsp", 5)
	if rspData.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("atlantiswar_text_0027"))
	end
end
function allianceTerritoryCtrl:registerMsg()
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_TERRITORY_INIT_DATA, handler(self, RSP.getInitializeDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BUILD_BUILDING_USE_GOLD, handler(self, RSP.buildBuildingUseGoldRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_BUILD_BUILDING_USE_BONUS, handler(self, RSP.buildBuildingUseBonusRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMOLISH_TERR_BUILDING, handler(self, RSP.demolishAllianceBuildingRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_BUILDING_INFO, handler(self, RSP.getAllianceBuildingDataRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RESTORE_BUILDING, handler(self, RSP.restoreBuildingRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ALLOCATE_TAXES, handler(self, RSP.allocateTaxesRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_MODIFY_TERRITORY_COLOR, handler(self, RSP.modifyTerritoryColorRsp))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_ALLIANCE_TAX_RECORD, handler(self, RSP.getAllianceTaxRecordRsp))
end
return allianceTerritoryCtrl

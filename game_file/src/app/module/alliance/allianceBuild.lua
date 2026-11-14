local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local kingdomMapltCtrl = include("kingdomMapltCtrl")
local allianceResPoint = include("allianceResPoint")
local allianceBuild = class("allianceBuild", gameModule)
local _ENV, REQ = "allianceBuild", "allianceBuild"
local _ENV, RSP = gameModule, gameModule
function allianceBuild:ctor(properties)
	allianceBuild.super.ctor(self, properties)
	local aid
	allianceBuild = self
	self.building_list, allianceBuild, self.property, self.aid = self, self, self, aid
end
function allianceBuild:EnterGame()
	allianceBuild.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SET_BUILDING, handler(self, RSP.setAllianceBuildingRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMOLISH_BUILDING, handler(self, RSP.demolishAllianceBuildingRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RES_COST_RECORD, handler(self, RSP.costRecordRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RES_MINE_PROFIT, handler(self, RSP.mineProfitRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RES_MINE_PROFIT_GET, handler(self, RSP.mineProfitGetRsp))
end
function allianceBuild:resetData()
	self:demolishAllBuild()
	self.res, _UPVALUE0_, self.resMineList, _UPVALUE0_, self.costRecord, _UPVALUE0_ = self.demolishAllBuild, self.demolishAllBuild, self.demolishAllBuild, self.demolishAllBuild, self.demolishAllBuild, self.demolishAllBuild
end
function allianceBuild:Logout()
	allianceBuild.super.Logout(self)
	self:resetData()
end
function allianceBuild:initClientData(initData)
	if initData then
		self.property.aid = initData.aid
		if initData.buildings then
			for buildingType, bidlist in pairs(initData.buildings) do
				for bid, iidlist in pairs(bidlist) do
					for iid, property in pairs(iidlist) do
						if gAllianceBuildType.CASTLE == tonumber(buildingType) then
						elseif gAllianceBuildType.RESOURCE == tonumber(buildingType) then
							local _ENV, command = gAllianceBuildType.RESOURCE, gAllianceBuildType.RESOURCE
							command.getNumOfSetBuilding = handler(self, self.getNumOfSetBuilding)
							local building = allianceResPoint.new(property, command)
							self:addBuilding(tonumber(bid), iid, building)
						end
					end
				end
			end
		end
	end
end
function allianceBuild:getBuildingList()
	local _ENV, ret
	for buildingType, bidlist in pairs(self.building_list) do
		for bid, iidlist in pairs(bidlist) do
			for iid, v in pairs(iidlist) do
				table.insert(ret, v)
			end
		end
		table.sort(ret, function(l, r)
			local liid = l:getIID()
			local lbid, lindex = string.match(liid, "%d+_(%d+)_(%d+)")
			local riid = r:getIID()
			local rbid, rindex = string.match(riid, "%d+_(%d+)_(%d+)")
			if tonumber(lbid) == tonumber(rbid) then
				return tonumber(lindex) < tonumber(rindex)
			else
				return tonumber(lbid) < tonumber(rbid)
			end
		end)
	end
	return ret
end
function allianceBuild:getTimeOfResPoint(bid, iid)
	local ret, resPoint = self:getBuilding(bid, iid)
	if gErrDef.Err_None ~= ret then
		return
	end
	local startTime = resPoint:getBuildStartTime()
	local remainTime = resPoint:getBuildRemainTime()
	return startTime, remainTime
end
function allianceBuild:getResPointInfo()
	local _ENV, ret
	local list = self.building_list[gAllianceBuildType.RESOURCE]
	if list then
		for bid, iidlist in pairs(list) do
			for iid, v in pairs(iidlist) do
				if not v:isFree() then
					local bid = v:getBID()
					local iid = v:getIID()
					local startTime = v:getBuildStartTime()
					local finishTime = v:getBuildFinishTime()
					local remainTime = v:getBuildRemainTime()
					_ENV = v
					v.bid = bid
					v.iid = iid
					v.startTime = startTime
					v.finishTime = finishTime
					v.remainTime = remainTime
					v.status = v:getMapStatus()
					ret[iid], v.pos = v, v:getPos()
				end
			end
		end
	end
	return ret
end
function allianceBuild:getAID()
	return self.property.aid
end
function allianceBuild:addBuilding(bid, iid, building)
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	local buildingType = allianceResPointltCtrl.getBuildingType(bid)
	if buildingType then
		if not self.building_list[buildingType] then
			_ENV = self.building_list[buildingType]
		end
		self.building_list[buildingType] = self.building_list[buildingType]
		if not self.building_list[buildingType][bid] then
			_ENV = self.building_list[buildingType][bid]
		end
		self.building_list[buildingType][bid] = self.building_list[buildingType][bid]
		self.building_list[buildingType][bid][iid] = building
	end
	return gErrDef.Err_None
end
function allianceBuild:removeBuilding(bid, iid)
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	local buildingType = allianceResPointltCtrl.getBuildingType(bid)
	self.building_list[buildingType][bid][iid] = nil
	if not next(self.building_list[buildingType][bid]) then
		self.building_list[buildingType][bid] = nil
	end
	if not next(self.building_list[buildingType]) then
		self.building_list[buildingType] = nil
	end
	return gErrDef.Err_None
end
function allianceBuild:getBuilding(bid, iid)
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	local buildingType = allianceResPointltCtrl.getBuildingType(bid)
	local ret = self.building_list[buildingType]
	ret = ret and ret[bid]
	ret = ret and ret[iid]
	if not ret then
		return gErrDef.Err_ALLIANCE_BUILDING_NOT_EXIST
	end
	return gErrDef.Err_None, ret
end
function allianceBuild:getMainBuilding(bid, iid)
	local buildingType = bid
	local ret = self.building_list[buildingType]
	ret = ret and ret[bid]
	ret = ret and ret[iid]
	if not ret then
		return gErrDef.Err_ALLIANCE_BUILDING_NOT_EXIST
	end
	return gErrDef.Err_None, ret
end
function allianceBuild:getNumOfSetBuilding(buildingType)
	local num = 0
	local bidlist = self.building_list[buildingType]
	if not bidlist then
		return num
	end
	for bid, iidlist in pairs(bidlist) do
		for iid, v in pairs(iidlist) do
			if not v:isFree() then
				num = num + 1
			end
		end
	end
	return num
end
function allianceBuild:canBuildingMarch(bid, iid)
	local ret, building = self:getBuilding(bid, iid)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	return building:canMarch()
end
function allianceBuild:createNewBuilding(bid, iid, ...)
	if gErrDef.Err_None == self:getBuilding(bid, iid) then
		return gErrDef.Err_ALLIANCE_BUILDING_EXIST
	end
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	local buildingType = allianceResPointltCtrl.getBuildingType(bid)
	local building
	if gAllianceBuildType.CASTLE == buildingType then
	elseif gAllianceBuildType.RESOURCE == buildingType then
		building = allianceResPoint:create(bid, iid, ...)
	end
	if not building then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	self:addBuilding(bid, iid, building)
	return gErrDef.Err_None, building
end
function allianceBuild:setBuilding(bid, iid, x, y)
	serverproxy = nil
	;(nil).bid = bid
	serverproxy, (nil).iid = nil, iid
	;(nil).x = x
	;(nil).pos, (nil).y = nil, y
	local data
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_SET_BUILDING, data)
end
function allianceBuild:demolishBuilding(bid, iid)
	serverproxy = nil
	;(nil).bid = bid
	local (nil).iid, data = iid, nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEMOLISH_BUILDING, data)
end
function allianceBuild:demolishAllBuild()
	self.building_list, _ENV, self.property, _ENV = nil, nil, nil, nil
	return gErrDef.Err_None
end
function allianceBuild:reqAllianceResCostRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RES_COST_RECORD, nil)
end
function allianceBuild:reqAllianceResMineProfit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RES_MINE_PROFIT, nil)
end
function allianceBuild:reqGetAllianceResMineProfit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RES_MINE_PROFIT_GET, nil)
end
function RSP:setAllianceBuildingRsp(content)
	if gErrDef.Err_None ~= content.err then
		return
	end
	local rspData = content.data
	local bid = rspData.bid
	local pos = rspData.pos
	local allianceResPointltCtrl = include("allianceResPointltCtrl")
	local buildingType = allianceResPointltCtrl.getBuildingType(bid)
	if gAllianceBuildType.CASTLE == buildingType then
	elseif gAllianceBuildType.RESOURCE == buildingType then
	end
end
function RSP:demolishAllianceBuildingRsp(content)
	if gErrDef.Err_None ~= content.err then
		return
	end
end
function RSP:costRecordRsp(content)
	dump(content, "RSP.costRecordRsp", 10)
	if gErrDef.Err_None == content.err then
		self.costRecord = content.rspdata.costRecord
		self.resMineList = content.rspdata.resMineList
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_ALLIANCE_COST_RECORD_BACK"
	SoraDSendMessage(content.err)
end
function RSP:mineProfitRsp(content)
	dump(content, "RSP.mineProfitRsp", 10)
	if gErrDef.Err_None == content.err then
		self.res = content.rspdata.res
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_ALLIANCE_RES_MINE_PROFIT_BACK"
	SoraDSendMessage(content.err)
end
function RSP:mineProfitGetRsp(content)
	dump(content, "RSP.mineProfitGetRsp", 10)
	if gErrDef.Err_None == content.err then
		SoraDMailGainItems(content.rspdata.reward, true)
		self.res, _ENV = SoraDMailGainItems, SoraDMailGainItems
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_ALLIANCE_GET_RES_MINE_PROFIT_BACK"
	SoraDSendMessage(content.rspdata.reward)
end
function allianceBuild:getCostRecord()
	return self.costRecord
end
function allianceBuild:setResMineList(list)
	self.resMineList = list
end
function allianceBuild:getResMineList()
	return self.resMineList
end
function allianceBuild:getRes()
	return self.res
end
function allianceBuild:getResTotal()
	_UPVALUE4_ = nil
	;(nil)[1] = gIDDef.FOOD
	;(nil)[2] = gIDDef.WOOD
	;(nil)[3] = gIDDef.IRON
	local (nil)[4], resID = gIDDef.MITHRIL, nil
	local total = 0
	for k, v in ipairs(resID) do
		local count = self.res[tostring(v)] or 0
		total = total + count
	end
	return total
end
function allianceBuild:dump()
end
return allianceBuild

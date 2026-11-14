local gamemodulec = include("GameModule")
local msgCtrl = include("msgCtrl")
local armyCtrl = class("armyCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local armyltCtrl = include("armyltCtrl")
local worldMapWarDef = include("worldMapWarDef")
function armyCtrl:ctor(properties)
	armyCtrl.super.ctor(self, properties)
	self.warTypeConfig = worldMapWarDef.getWarArmyConfig()
	self:resetData()
end
function armyCtrl:resetData()
	;(nil).defCompileInfo, _ENV, (nil).compileDivineBeast, _ENV, (nil).compileArms, _ENV, (nil).compileHero, _ENV, (nil).compileArmy, _ENV, (nil).trainArmy, _ENV, _ENV, self.handle_notify = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	_ENV, (nil).activeDefCompile = nil, 0
	;(nil).mapId = 9999
	self.armyInfo, (nil).legendWarWoundedArmy, (nil).army, _ENV, (nil).type = nil, nil, nil, nil, 1
	for __, cfg in pairs(self.warTypeConfig) do
		self.armyInfo[cfg.totalArmyKey], _ENV = nil, nil
		self.armyInfo[cfg.woundedArmyKey], _ENV = nil, nil
	end
	self.filterQueueIds, _ENV = pairs(self.warTypeConfig)
	self.gildedframeInfo, _ENV, self.warframeInfo, _ENV, self.maxTrainInfo, _ENV, self.singleTrainAddInfo, _ENV, self.dttime = pairs(self.warTypeConfig)
	self.warType = gKingdomClassType.normal
end
function armyCtrl:saveHospitalOrder(order)
	self.hospitalOrder = order
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:armyCtrl:hospitalOrder~integer", order, nil)
end
function armyCtrl:readHospitalOrder()
	_ENV = nil
	;(nil).byUID = true
	self.hospitalOrder = SoraDConfigGet("Game:armyCtrl:hospitalOrder~integer", nil) or 0
	return self.hospitalOrder
end
function armyCtrl:setWarType(warType)
	self.warType = warType
end
function armyCtrl:getDefCompile(index)
	for k, v in pairs(self.armyInfo.defCompileInfo) do
		local _ENV, list
		local isOld = false
		if not v.heroList then
			_ENV = v.heroList
		end
		for ki, vi in pairs(v.heroList) do
			if type(ki) == "string" then
				isOld = true
				table.insert(list, vi)
			end
		end
		v.heroList = isOld and list or v.heroList
	end
	if not self.armyInfo.defCompileInfo[tostring(index)] then
		_ENV = self.armyInfo.defCompileInfo[tostring(index)]
	end
	return self.armyInfo.defCompileInfo[tostring(index)]
end
function armyCtrl:getActiveDefCompile()
	return self.armyInfo.activeDefCompile
end
function armyCtrl:getTotalArmyList(warType)
	if nil == warType then
		warType = self.warType
	end
	if warType == gKingdomClassType.nebulaAllStar then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		return nebulaAllStarCtrl:getTotalArmyList()
	else
		local cfg = worldMapWarDef.getArmyConfigByWarType(warType)
		if not self.armyInfo[cfg.totalArmyKey] then
			_ENV = self.armyInfo[cfg.totalArmyKey]
		end
		return self.armyInfo[cfg.totalArmyKey]
	end
end
function armyCtrl:getWoundedArmyList(warType)
	if nil == warType then
		warType = self.warType
	end
	local cfg = worldMapWarDef.getArmyConfigByWarType(warType)
	if not self.armyInfo[cfg.woundedArmyKey] then
		local worldMapWarDef, armyList = self.armyInfo[cfg.woundedArmyKey], self.armyInfo[cfg.woundedArmyKey]
	end
	if warType == gKingdomClassType.legendLord then
		if not armyList.army then
			worldMapWarDef = armyList.army
		end
		return armyList.army
	else
		return armyList
	end
end
function armyCtrl:EnterGame()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.hostpital_pyramidwar_cd_queue), handler(self, self.pyramidWarArmyQueueCallBack))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.chariot_plant_queue), handler(self, self.armyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.stables_queue), handler(self, self.armyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.range_queue), handler(self, self.armyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.barracks_queue), handler(self, self.armyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.frotress_queue), handler(self, self.armyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.elite_queue), handler(self, self.armyQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.prompt_army), handler(self, self.armyQueueCallback))
	local hospitalQueues = worldMapWarDef.getHospitalQueues()
	for queueType, __ in pairs(hospitalQueues) do
		queueCtrl:addEventListener(tostring(queueType), handler(self, self.armyQueueCallback))
	end
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_INIT_ARMYDATA, handler(self, self.initArmyDataRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_TRAIN_ARMY, handler(self, self.trainArmyRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_FIRE_ARMY, handler(self, self.fireArmyRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_GET_ARMY, handler(self, self.getTrainArmyRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_COMPILE, handler(self, self.setArmyCompileRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_GET_COMPILE, handler(self, self.getArmyCompileRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_COMPILENAME, handler(self, self.setArmyCompileNameRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_PROMPT_ARMY, handler(self, self.promptArmyRsp))
	for __, cfg in pairs(self.warTypeConfig) do
		msgCtrl.register(gCmd.CMD_ARMY_MODULE, cfg.subcmd, handler(self, self.cureWoundedArmyRsp))
	end
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_DFEND_COMPILE_INFO, handler(self, self.setDefendCompileRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_ACTIVE_DEFEND_COMPILE, handler(self, self.activeDefendCompileRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_DFEND_COMPILE_NAME, handler(self, self.setDefendCompileNameRsp))
	msgCtrl.register(gCmd.CMD_ARMY_MODULE, gCmd.REQ_QUICK_TRAIN_ARMY, handler(self, self.setQuickTrainArmyRsp))
end
function armyCtrl:Logout()
	armyCtrl.super.Logout(self)
	self:resetData()
end
function armyCtrl:update(dttime)
end
function armyCtrl:pyramidWarArmyQueueCallBack(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_PYRAMIDBATTLE_HOSPITALCDCHANGE"
	SoraDSendMessage(nil)
end
function armyCtrl:armyQueueCallback(event)
	local eventname = event.name
	local data = event.data
	local optype = tonumber(data.optype)
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	if optype == QUEUE_OPERATE_TYPE.CANCLE then
		if eventname == tostring(gQueueTypeDef.prompt_army) then
			self:updateArmyCount(data.fromArmyID, data.count)
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
			SoraDSendMessage(self)
			SoraDShowMsgTip(i18n("common_text_4369"))
		else
			if queueCtrl:isWarHospitalQueue(tonumber(eventname)) or tonumber(eventname) == gQueueTypeDef.hostpital_queue and worldMapDefine.isInWar() then
				_ENV = gQueueTypeDef.hostpital_queue
				gQueueTypeDef.hostpital_queue.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
				SoraDSendMessage(gQueueTypeDef.hostpital_queue)
				local msgNotice = include("msgNotice")
				msgNotice.notice("brightWar_text_166", nil, gNoticeIconTypeDef.ICON_BUILD, tonumber(data.bid))
			else
				local msgNotice = include("msgNotice")
				msgNotice.notice("notice_0055", nil, gNoticeIconTypeDef.ICON_BUILD, tonumber(data.bid))
			end
			_ENV = msgNotice.notice
			msgNotice.notice.msg = "MESSAGE_SERVER_MAINCITYVIEW_ARMY_QUEUE_CALLBACK"
			msgNotice.notice.bid = tonumber(data.bid)
			msgNotice.notice.iid = tonumber(data.iid)
			msgNotice.notice.optype = QUEUE_OPERATE_TYPE.CANCLE
			msgNotice.notice.costres = data.costres
			SoraDSendMessage(msgNotice.notice)
			_ENV = msgNotice.notice
			msgNotice.notice.msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
			msgNotice.notice.optype = optype
			msgNotice.notice.bid = tonumber(data.bid)
			msgNotice.notice.iid = tonumber(data.iid)
			SoraDSendMessage(msgNotice.notice)
		end
		return
	end
	if queueCtrl:isHospitalQueue(tonumber(eventname)) then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCellList = cityCtrl:getBuildCellList(tonumber(data.bid))
		for i = 1, #buildCellList do
			local buildCell = buildCellList[i]
			if nil ~= buildCell then
				local buildIndex = tonumber(buildCell.info.index)
				if tonumber(buildCell.info.state) == BUILD_STATE.NORMAL then
					if optype == QUEUE_OPERATE_TYPE.MERGE_ADD then
						_ENV = BUILD_STATE.NORMAL
						BUILD_STATE.NORMAL.msg = "MESSAGE_BUILD_WORKING"
						BUILD_STATE.NORMAL.buildID = buildIndex
						BUILD_STATE.NORMAL.buildCfgID = tonumber(data.bid)
						SoraDSendMessage(BUILD_STATE.NORMAL)
					else
						_ENV = BUILD_STATE.NORMAL
						BUILD_STATE.NORMAL.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
						BUILD_STATE.NORMAL.buildIndex = buildIndex
						SoraDSendMessage(BUILD_STATE.NORMAL)
					end
				end
			end
		end
		_ENV = #buildCellList
		;(#buildCellList).msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
		SoraDSendMessage(#buildCellList)
		_ENV = #buildCellList
		;(#buildCellList).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
		SoraDSendMessage(#buildCellList)
		if optype ~= QUEUE_OPERATE_TYPE.MERGE_ADD and optype ~= QUEUE_OPERATE_TYPE.MERGE_REMOVE then
			local msgNotice = include("msgNotice")
			msgNotice.notice("notice_0051")
		end
	elseif eventname == tostring(gQueueTypeDef.prompt_army) then
		_ENV = gQueueTypeDef.prompt_army
		gQueueTypeDef.prompt_army.msg = "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL"
		SoraDSendMessage(gQueueTypeDef.prompt_army)
		_ENV = gQueueTypeDef.prompt_army
		gQueueTypeDef.prompt_army.msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
		SoraDSendMessage(gQueueTypeDef.prompt_army)
		SoraDShowMsgTip(i18n("common_text_4372"))
	else
		local bid = tonumber(data.bid)
		local armyid = tonumber(data.armyid)
		local armycount = tonumber(data.armycount)
		local speedUpComplete = tostring(data.speedUpComplete)
		if speedUpComplete == tostring(SPEEDUP_TYPE.GOLD) or speedUpComplete == tostring(SPEEDUP_TYPE.TOOLS) then
			self:notifyViewShowArmyResult(bid, armyid, armycount)
		else
			self:addTrainArmy(bid, armyid, armycount)
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCell(tonumber(data.bid), 0)
		local buildIndex = tonumber(buildCell.info.index)
		_ENV = 0
		;(0).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		;(0).buildIndex = buildIndex
		SoraDSendMessage(0)
		if armyid == 501 then
			_ENV = 0
			;(0).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;(0).step = 2022
			SoraDSendMessage(0)
		end
		self:updatePromoteCache(bid)
	end
	_ENV = tonumber(data.armyid)
	tonumber(data.armyid).msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
	SoraDSendMessage((tonumber(data.armyid)))
	_ENV = tonumber(data.armyid)
	tonumber(data.armyid).msg = "MESSAGE_SERVER_MAINCITYVIEW_BUILDINFO_QUEUE_END"
	tonumber(data.armyid).bid = tonumber(event.data.bid)
	SoraDSendMessage((tonumber(data.armyid)))
end
function armyCtrl:notifyViewShowArmyResult(bid, armyID, armyCount)
	local bid = tonumber(bid)
	local armyid = tonumber(armyID)
	local armycount = tonumber(armyCount)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCell(bid, 0)
	if buildCell then
		local buildIndex = tonumber(buildCell.info.index)
		local content
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_SHOW_HARVEST_ARMY_RESULT"
		;(nil).index = buildIndex
		;(nil).bid = bid
		;(nil).armyid = armyid
		;(nil).armycount = armycount
		SoraDSendMessage(nil, content)
	end
end
function armyCtrl:getWoundedArmy(warType)
	local woundedArmy = self:getWoundedArmyList(warType)
	for k, v in pairs(woundedArmy) do
		if tonumber(v) < 1 then
			woundedArmy[k] = nil
		end
	end
	return woundedArmy
end
function armyCtrl:getTotalWoundedArmyCount(warType)
	local ret = 0
	local woundedarmylist = self:getWoundedArmy(warType)
	for k, v in pairs(woundedarmylist) do
		ret = ret + tonumber(v)
	end
	return ret
end
function armyCtrl:getTotalPromoteArmyCount()
	local ret = 0
	local promoteArmylist = self:getPromoteArmy()
	for k, v in pairs(promoteArmylist) do
		ret = ret + tonumber(v)
	end
	return ret
end
function armyCtrl:getTrapList()
	local _ENV, traplist
	for k, v in pairs(self.armyInfo.totalArmy) do
		if serviceFunctions.isTrapID(k) and tonumber(v) > 0 then
			traplist[k] = tonumber(v)
		end
	end
	return traplist
end
function armyCtrl:getArmyList(warType)
	local _ENV, armylist
	local totalArmy = self:getTotalArmyList(warType)
	for k, v in pairs(totalArmy) do
		if armyltCtrl.isArmyID(k) and tonumber(v) > 0 then
			armylist[k] = tonumber(v)
		end
	end
	return armylist
end
function armyCtrl:getTrapTotalCount()
	local ret = 0
	local traplist = self:getTrapList()
	for k, v in pairs(traplist) do
		ret = ret + tonumber(v)
	end
	return ret
end
function armyCtrl:getArmyIDList(warType)
	local _ENV, armyIDList
	local totalArmy = self:getTotalArmyList(warType)
	for k, v in pairs(totalArmy) do
		local armyid = tonumber(k)
		if armyltCtrl.isArmyID(armyid) then
			table.insert(armyIDList, armyid)
		end
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local marcharmylist = kingdomMapCtrl.kingdomMapCell:getAllQueueLiveArmy(self.filterQueueIds)
	for k, v in pairs(marcharmylist) do
		local armyid = tonumber(k)
		if armyltCtrl.isArmyID(armyid) then
			local isadd = false
			for _k, _v in pairs(armyIDList) do
				if armyid == tonumber(_v) then
					isadd = true
				end
			end
			if not isadd then
				table.insert(armyIDList, armyid)
			end
		end
	end
	return armyIDList
end
function armyCtrl:getArmyCostFood(armyid, count, addPercent)
	local armyLogic = include("armyLogic")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local addPercent = addPercent or armyLogic.getArmyCostFoodAddPercent()
	local base = armyltCtrl.armyAttr(armyid, ARMY_ATTR.COSTFOOD)
	local ret = math.floor(base * count * addPercent)
	return ret
end
function armyCtrl:getTotalArmyCostFood_imp(warType, addPercent)
	local ret = 0
	local armyidlist = self:getArmyIDList(warType)
	local armyLogic = include("armyLogic")
	local addPercent = addPercent or armyLogic.getArmyCostFoodAddPercent()
	for _, v in pairs(armyidlist) do
		local armycount = self:getArmyCount(v, ARMY_OPTYPE.ALL_ARMY, warType)
		ret = ret + self:getArmyCostFood(v, armycount, addPercent)
	end
	return ret
end
function armyCtrl:getTotalArmyCostFood()
	local ret = 0
	local armyLogic = include("armyLogic")
	local addPercent = armyLogic.getArmyCostFoodAddPercent()
	ret = ret + self:getTotalArmyCostFood_imp(gKingdomClassType.normal, addPercent)
	ret = ret + self:getTotalArmyCostFood_imp(gKingdomClassType.radiance, addPercent)
	return ret
end
function armyCtrl:getTotalArmyCount(warType)
	local ret = 0
	local armyidlist = self:getArmyIDList(warType)
	for k, v in pairs(armyidlist) do
		local count = self:getArmyCount(v, ARMY_OPTYPE.ALL_ARMY, warType)
		ret = ret + count
	end
	return ret
end
function armyCtrl:getArmyCount(armyid, counttype, warType)
	local ret = 0
	local armytable
	if counttype == ARMY_OPTYPE.WOUNDED_ARMY then
		armytable = self:getWoundedArmyList(warType)
	else
		armytable = self:getTotalArmyList(warType)
	end
	for _armyid, _armycount in pairs(armytable) do
		if tonumber(armyid) == tonumber(_armyid) then
			ret = tonumber(_armycount)
		end
	end
	if counttype == ARMY_OPTYPE.ALL_ARMY then
		local marcharmy = 0
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local marcharmylist = kingdomMapCtrl.kingdomMapCell:getAllQueueLiveArmy(self.filterQueueIds)
		for k, v in pairs(marcharmylist) do
			if tonumber(armyid) == tonumber(k) then
				marcharmy = v
			end
		end
		ret = ret + marcharmy
	end
	return ret
end
function armyCtrl:getArmyQueueCount(armyid)
	local marcharmy = 0
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local marcharmylist = kingdomMapCtrl.kingdomMapCell:getAllQueueLiveArmy(self.filterQueueIds)
	for k, v in pairs(marcharmylist) do
		if tonumber(armyid) == tonumber(k) then
			marcharmy = v
		end
	end
	return marcharmy
end
function armyCtrl:getNormalArmyCount(armyid)
	local allArmyNum = self:getArmyCount(armyid, ARMY_OPTYPE.ALL_ARMY)
	local outArmyNum = self:getArmyQueueCount(armyid)
	return allArmyNum - outArmyNum
end
function armyCtrl:getArmyCountByLv(armyType, armyLv)
	local armyLogic = include("armyLogic")
	local ret = 0
	local armytable = self:getArmyList()
	for _armyid, _armycount in pairs(armytable) do
		local _armyType, _armyLv = armyltCtrl.getArmyTypeAndLv(_armyid)
		if _armyType == armyType and _armyLv == armyLv then
			ret = ret + _armycount
		end
	end
	return ret
end
function armyCtrl:getInnerCityNormalArmy(warType)
	local ret = 0
	local armyList = self:getArmyList(warType)
	for k, v in pairs(armyList) do
		ret = ret + v
	end
	return ret
end
function armyCtrl:updateArmyCount(armyid, armycount, warType)
	warType = warType or gKingdomClassType.normal
	local armytable = self:getTotalArmyList(warType)
	local maxcount = gConstValue.MAX_ARMY
	local isfind = false
	for _armyid, _armycount in pairs(armytable) do
		if tonumber(_armyid) == tonumber(armyid) then
			isfind = true
			local curcount = tonumber(armycount) + tonumber(_armycount)
			if curcount <= 0 then
				armytable[tostring(armyid)] = 0
			else
				if armycount > maxcount then
					armycount = maxcount
				end
				armytable[tostring(armyid)] = tostring(curcount)
			end
		end
	end
	if not isfind and 0 < armycount then
		if maxcount < armycount then
			armycount = maxcount
		end
		armytable[tostring(armyid)] = tostring(armycount)
	end
end
function armyCtrl:updateWoundedArmy(armyid, armycount, warType)
	local woundArmyTable = self:getWoundedArmyList(warType)
	local isfind = false
	for _armyid, _armycount in pairs(woundArmyTable) do
		if tonumber(_armyid) == tonumber(armyid) then
			isfind = true
			local curcount = tonumber(armycount) + tonumber(_armycount)
			if curcount <= 0 then
				woundArmyTable[tostring(armyid)] = 0
			else
				woundArmyTable[tostring(armyid)] = tostring(curcount)
			end
		end
	end
	if not isfind and 0 < armycount then
		woundArmyTable[tostring(armyid)] = tostring(armycount)
	end
end
function armyCtrl:addTrainArmy(bid, armyid, armycount)
	local isfindbid = false
	for _bid, army in pairs(self.armyInfo.trainArmy) do
		if tonumber(_bid) == tonumber(bid) then
			local isfindarmyid = false
			for k, v in pairs(army) do
				if tonumber(k) == tonumber(armyid) then
					army[k] = tostring(tonumber(army[k]) + armycount)
					isfindarmyid = true
				end
			end
			if not isfindarmyid then
				army[tostring(armyid)] = tostring(armycount)
			end
			isfindbid = true
		end
	end
	if not isfindbid and 0 < armycount then
		local _ENV, army = pairs(self.armyInfo.trainArmy)
		army[tostring(armyid)] = tostring(armycount)
		self.armyInfo.trainArmy[tostring(bid)] = army
	end
end
function armyCtrl:getTrainArmy(bid)
	for _bid, army in pairs(self.armyInfo.trainArmy) do
		if tonumber(_bid) == tonumber(bid) then
			return army
		end
	end
	return nil
end
function armyCtrl:getArmyCompileName(compiletype)
	local name = self.armyInfo.compileArmy["n" .. tostring(compiletype)]
	return name
end
function armyCtrl:checkArmyCompileName(str)
	for __, name in pairs(self.armyInfo.compileArmy) do
		if name == str then
			return true
		end
	end
	return false
end
function armyCtrl:getArmyCompileCount(...)
	local totalNum = 4
	local addCount = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.ARMY_COMPILE_LIMIT)
	if addCount then
		totalNum = totalNum + addCount
	end
	return totalNum
end
function armyCtrl:getDefendCompileName(compiletype, default)
	local info = self:getDefCompile(compiletype)
	return info and info.name or default or tostring(compiletype)
end
function armyCtrl:checkDefendCompileName(str)
	for __, info in pairs(self.armyInfo.defCompileInfo) do
		if info.name == str then
			return true
		end
	end
	return false
end
function armyCtrl:initArmyDataReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_INIT_ARMYDATA, nil, ...)
end
function armyCtrl:trainArmyReq(bid, armyid, armycount, mode, ...)
	local isget = false
	if mode == OPERATE_MODE.IMMEDIATELY then
		isget = true
	end
	_ENV = OPERATE_MODE.IMMEDIATELY
	OPERATE_MODE.IMMEDIATELY.bid = tostring(bid)
	OPERATE_MODE.IMMEDIATELY.armyid = tostring(armyid)
	OPERATE_MODE.IMMEDIATELY.armycount = tostring(armycount)
	OPERATE_MODE.IMMEDIATELY.mode = tostring(mode)
	local OPERATE_MODE.IMMEDIATELY.isget, data = isget, OPERATE_MODE.IMMEDIATELY
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	if not guideCtrl:isStep(gGuideStep.FORCED_STEP_5) and guideCtrl:getCurMainCityGuideStep() == nil then
		serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_TRAIN_ARMY, data, ...)
	end
end
function armyCtrl:fireArmyReq(armyid, armycount, otype, ...)
	_ENV = nil
	;(nil).armyid = tostring(armyid)
	;(nil).armycount = tostring(armycount)
	local (nil).otype, data = tostring(otype), nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_FIRE_ARMY, data, ...)
end
function armyCtrl:cureWoundedArmyReq(armyinfo, mode, warType, ...)
	local _ENV, tempinfo
	local isMax = false
	for k, v in pairs(armyinfo) do
		tempinfo[k] = tostring(v)
		if self:getArmyCount(k, ARMY_OPTYPE.ALL_ARMY, warType) >= gConstValue.MAX_ARMY then
			isMax = true
		end
	end
	_ENV = (for generator)
	pairs(armyinfo).mode = tostring(mode)
	local pairs(armyinfo).armyinfo, data = tempinfo, pairs(armyinfo)
	if isMax then
		SoraDShowMsgTip(i18n("complement_tips_06"))
		return
	end
	if nil == warType then
		warType = self.warType
	end
	local cfg = worldMapWarDef.getArmyConfigByWarType(warType)
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, cfg.subcmd, data, ...)
end
function armyCtrl:promoteArmyReq(armyid, armycount, mode, ...)
	serverproxy = nil
	;(nil).armyid = armyid
	;(nil).armycount = armycount
	local (nil).mode, data = mode, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_PROMPT_ARMY, data, ...)
end
function armyCtrl:getTrainArmyReq(bid, ...)
	_ENV = nil
	local (nil).bid, data = tostring(bid), nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_GET_ARMY, data, ...)
end
function armyCtrl:setArmyCompile(armytb, compiletype, heroInfo, armsInfo, divineBeastInfo, ...)
	serverproxy = nil
	;(nil).armytb = armytb
	;(nil).compiletype = compiletype
	;(nil).heroInfo = heroInfo
	;(nil).armsInfo = armsInfo
	local (nil).divineBeastInfo, data = divineBeastInfo, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_COMPILE, data, ...)
end
function armyCtrl:getArmyCompile(compiletype, ...)
	serverproxy = nil
	local (nil).compiletype, data = compiletype, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_GET_COMPILE, data, ...)
end
function armyCtrl:setArmyCompileName(compiletype, name, ...)
	serverproxy = nil
	;(nil).compiletype = compiletype
	local (nil).name, data = name, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_COMPILENAME, data, ...)
end
function armyCtrl:setDefendCompileInfo(compileIndex, armsID, heroList, divineBeastList, compileName, ...)
	_ENV = nil
	;(nil).compileIndex = compileIndex
	;(nil).armsID = armsID
	;(nil).heroList = heroList
	;(nil).divineBeastList = divineBeastList
	local (nil).compileName, data = compileName, nil
	dump(data, "armyCtrl:setDefendCompileInfo")
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_DFEND_COMPILE_INFO, data, ...)
end
function armyCtrl:activeDefendCompile(compileIndex, isInit, ...)
	serverproxy = nil
	;(nil).compileIndex = compileIndex
	local (nil).isInit, data = isInit, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_ACTIVE_DEFEND_COMPILE, data, ...)
end
function armyCtrl:initArmyDataRsp(content)
	self.armyInfo = content.data
	dump(self.armyInfo, "==armyCtrl:initArmyDataRsp==", 10)
	self:registerNotify()
end
function armyCtrl:trainArmyRsp(content)
	local data = content.data
	local err = content.err
	print("armyCtrl:trainArmyRsp err=" .. err)
	dump(content, "content======", 10)
	if err == gErrDef.Err_None then
		local retdata = data.retdata
		local armyInfo = data.armyInfo
		if armyInfo then
			self.armyInfo = armyInfo
			self.singleTrainAddInfo = self.armyInfo.singleTrainAddInfo
		end
		local costres = retdata.costres
		local queuetype = tonumber(retdata.queuetype)
		local totaltime = tonumber(retdata.totaltime)
		local lefttime = tonumber(retdata.lefttime)
		local starttime = serviceFunctions.systemTime()
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		if lefttime == 0 then
			_ENV = "queueCtrl"
			;("queueCtrl").msg = "MESSAGE_MAINCITYVIEW_TRAIN_ARMY_IMMDIATELY_BACK"
			;("queueCtrl").bid = data.bid
			SoraDSendMessage("queueCtrl")
			_ENV = "queueCtrl"
			;("queueCtrl").msg = "MESSAGE_ARMY_TRAIN_IMM_BACK"
			;("queueCtrl").bid = data.bid
			SoraDSendMessage("queueCtrl")
			local armyid = tonumber(data.armyid)
			local armycount = tonumber(data.armycount)
			local bid = tonumber(data.bid)
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCell = cityCtrl:getBuildCell(tonumber(data.bid), 0)
			if buildCell then
				local buildIndex = tonumber(buildCell.info.index)
				_ENV = 0
				;(0).msg = "MESSAGE_MAINCITYVIEW_SHOW_HARVEST_ARMY_RESULT"
				;(0).index = buildIndex
				;(0).bid = bid
				;(0).armyid = armyid
				;(0).armycount = armycount
				SoraDSendMessage(0, content)
			end
		else
			_ENV = SoraDSendMessage
			SoraDSendMessage.bid = tostring(data.bid)
			SoraDSendMessage.armyid = tostring(data.armyid)
			SoraDSendMessage.armycount = tostring(data.armycount)
			SoraDSendMessage.costres = costres
			SoraDSendMessage._uniqueid = retdata._uniqueid
			queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, SoraDSendMessage)
			local queue = queueCtrl:queryQueue(queuetype)
			if queue then
				queue.ottime = totaltime
			end
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCell = cityCtrl:getBuildCell(tonumber(data.bid), 0)
			if nil ~= buildCell then
				_ENV = tonumber(data.bid)
				tonumber(data.bid).msg = "MESSAGE_BUILD_WORKING"
				tonumber(data.bid).buildID = tonumber(buildCell.info.index)
				tonumber(data.bid).buildCfgID = tonumber(data.bid)
				SoraDSendMessage(tonumber(data.bid), content)
			end
		end
		SoraDPlaySound("innercontrol", 8)
		_ENV = "innercontrol"
		;("innercontrol").msg = "MESSAGE_ARMY_TOOL_UPDATE"
		;("innercontrol").bid = tonumber(data.bid)
		SoraDSendMessage("innercontrol")
		_ENV = "innercontrol"
		;("innercontrol").msg = "MESSAGE_UI_PANDECT_ARMY"
		;("innercontrol").queueType = queuetype
		;("innercontrol").bid = tonumber(data.bid)
		;("innercontrol").iid = 0
		SoraDSendMessage("innercontrol")
	elseif gErrDef.Err_RESOUCH_NOT_REACH == err or gErrDef.Err_GOLD_NOT_REACH == err or gErrDef.Err_ARMY_QUEUE_BUSY == err then
		_ENV = data.armyInfo
		data.armyInfo.msg = "MESSAGE_MAINCITYVIEW_BUILD_TRAIN_FAILED"
		data.armyInfo.bid = tonumber(data.bid)
		SoraDSendMessage(data.armyInfo)
	end
end
function armyCtrl:fireArmyRsp(content)
	local data = content.data
	local err = content.err
	print("armyCtrl:fireArmyRsp err=" .. err)
	if err == gErrDef.Err_None then
		local armyid = tonumber(data.armyid)
		local armycount = tonumber(data.armycount)
		local otype = tonumber(data.otype)
		if otype == ARMY_OPTYPE.NORMAL_ARMY then
			self:updateArmyCount(armyid, -armycount)
		elseif otype == ARMY_OPTYPE.WOUNDED_ARMY then
			self:updateWoundedArmy(armyid, -armycount)
		end
		local armyInfo = data.armyInfo
		if armyInfo then
			self.armyInfo = armyInfo
		end
		SoraDShowMsgTip(i18n("common_text_4370"))
	else
	end
	_ENV = tonumber(data.armycount)
	tonumber(data.armycount).msg = "MESSAGE_ARMY_DISMISSAL"
	SoraDSendMessage(tonumber(data.armycount), content)
	_ENV = tonumber(data.armycount)
	tonumber(data.armycount).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
	SoraDSendMessage((tonumber(data.armycount)))
	_ENV = tonumber(data.armycount)
	tonumber(data.armycount).msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
	SoraDSendMessage((tonumber(data.armycount)))
	_ENV = tonumber(data.armycount)
	tonumber(data.armycount).msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
	SoraDSendMessage((tonumber(data.armycount)))
end
function armyCtrl:setDefendCompileRsp(content)
	dump(content, "setDefendCompileRsp=====", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		self.armyInfo.defCompileInfo = content.rspdata.defCompileInfo
		self.armyInfo.activeDefCompile = content.data.compileIndex
		local compileIndex = content.data.compileIndex
		self.armyInfo.activeDefCompile = compileIndex
		local compileName = self:getDefendCompileName(compileIndex)
		_ENV = nil
		;(nil).var1 = compileName
		SoraDShowMsgTip(i18n("cityDefense_formation_set_success_tips", nil))
	end
	_ENV = self:getDefendCompileName(compileIndex)
	self:getDefendCompileName(compileIndex).msg = "MESSAGE_WALLS_DEFEND_COMPILE_UPDATE"
	SoraDSendMessage((self:getDefendCompileName(compileIndex)))
end
function armyCtrl:activeDefendCompileRsp(content)
	dump(content, "activeDefendCompileRsp=====", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		self.armyInfo.activeDefCompile = content.rspdata.activeDefCompile
		if not content.data.isInit then
			SoraDShowMsgTip(i18n("cityDefense_formation_change_success_tips"))
		end
	end
	_ENV = i18n("cityDefense_formation_change_success_tips")
	i18n("cityDefense_formation_change_success_tips").msg = "MESSAGE_WALLS_DEFEND_COMPILE_UPDATE"
	SoraDSendMessage(i18n("cityDefense_formation_change_success_tips"))
end
function armyCtrl:setDefendCompileName(compileIndex, compileName)
	serverproxy = nil
	;(nil).compileIndex = compileIndex
	local (nil).compileName, data = compileName, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_SET_DFEND_COMPILE_NAME, data)
end
function armyCtrl:setDefendCompileNameRsp(content)
	dump(content, "setDefendCompileNameRsp=====", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		self.armyInfo.defCompileInfo = content.rspdata.defCompileInfo
		local compileIndex = content.data.compileIndex
		local compileName = self:getDefendCompileName(compileIndex)
		_ENV = nil
		;(nil).num = compileName
		SoraDShowMsgTip(i18n("common_text_1427", nil))
	end
	_ENV = self:getDefendCompileName(compileIndex)
	self:getDefendCompileName(compileIndex).msg = "MESSAGE_WALLS_DEFEND_COMPILE_UPDATE"
	self:getDefendCompileName(compileIndex).subMsg = "compileName"
	SoraDSendMessage((self:getDefendCompileName(compileIndex)))
end
function armyCtrl:setQuickTrainArmy(bid, armyid, armycount)
	_ENV = nil
	;(nil).bid = tonumber(bid)
	;(nil).armyid = tonumber(armyid)
	local (nil).armycount, data = armycount, nil
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_QUICK_TRAIN_ARMY, data)
end
function armyCtrl:setQuickTrainArmyRsp(content)
	dump(content, "setQuickTrainArmyRsp=====", 10)
	self:trainArmyRsp(content)
end
function armyCtrl:promptArmyRsp(content)
	dump(content, "content=====", 10)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local data = content.rspdata
	local err = content.err
	local cityBuildConstDef = include("cityBuildConstDef")
	if err == gErrDef.Err_None then
		local queuetype = gQueueTypeDef.prompt_army
		local totaltime = data.prompttime
		local lefttime = data.prompttime
		local mode = data.mode
		if mode ~= OPERATE_MODE.IMMEDIATELY then
			local starttime = serviceFunctions.systemTime()
			_ENV = nil
			;(nil).bid = tostring(cityBuildConstDef.buildIndexDef.index_TroopFlag)
			;(nil).fromArmyID = data.armyidori
			;(nil).toArmyID = data.armyid
			;(nil).count = data.armycount
			queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
			local queue = queueCtrl:queryQueue(queuetype)
			if queue then
				queue.ottime = totaltime
			end
		else
			self:updateArmyCount(data.armyid, data.armycount)
			SoraDShowMsgTip(i18n("common_text_4372"))
		end
		self:updateArmyCount(data.armyidori, -data.armycount)
		if data.addCountTakeEffect and next(self.singleTrainAddInfo) then
			self.singleTrainAddInfo.itemCount = self.singleTrainAddInfo.itemCount - 1
			_ENV = self.singleTrainAddInfo.itemCount - 1
			;(self.singleTrainAddInfo.itemCount - 1).msg = "MESSAGE_ARMY_TOOL_UPDATE"
			SoraDSendMessage(self.singleTrainAddInfo.itemCount - 1)
		end
		_ENV = self.singleTrainAddInfo.itemCount - 1
		;(self.singleTrainAddInfo.itemCount - 1).msg = "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL"
		;(self.singleTrainAddInfo.itemCount - 1).buildIndex = cityBuildConstDef.OtherBuildDef.TroopFlag
		SoraDSendMessage(self.singleTrainAddInfo.itemCount - 1)
		_ENV = self.singleTrainAddInfo.itemCount - 1
		;(self.singleTrainAddInfo.itemCount - 1).msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
		SoraDSendMessage(self.singleTrainAddInfo.itemCount - 1)
	elseif err == gErrDef.Err_ARMY_PROMPT_RES_IS_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("hero_text_90"))
	elseif err == gErrDef.Err_ARMY_PROMPT_QUEUE_BUSY then
		SoraDShowMsgTip(i18n("arms_promotion_text_02"))
	elseif err == gErrDef.Err_ARMY_PROMPT_COUNT_IS_NOT_ENOUGH then
		SoraDShowMsgTip(i18n("arms_promotion_text_03"))
	else
		SoraDShowMsgTip(i18n("notice_0026"))
	end
end
function armyCtrl:cureWoundedArmyRsp(content)
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = data.retdata
		local isPyramidWar = retdata.isPyramidWar
		if isPyramidWar and retdata.pyramidWarQueue then
			local pyramidWarQueue = retdata.pyramidWarQueue
			local totaltime = tonumber(pyramidWarQueue.totaltime)
			local lefttime = tonumber(pyramidWarQueue.lefttime)
			local starttime = serviceFunctions.systemTime()
			gametop = nil
			queueCtrl:addQueue(gQueueTypeDef.hostpital_pyramidwar_cd_queue, starttime, totaltime, lefttime, nil)
			local queue = queueCtrl:queryQueue(gQueueTypeDef.hostpital_pyramidwar_cd_queue)
			if queue then
				queue.ottime = totaltime
			end
		end
		local queuetype = tonumber(retdata.queuetype)
		local totaltime = tonumber(retdata.totaltime)
		local lefttime = tonumber(retdata.lefttime)
		local starttime = serviceFunctions.systemTime()
		local costres
		gametop = nil
		;(nil).bid = tostring(BUILDID.HOSTPITAL)
		;(nil).armyinfo = data.armyinfo
		;(nil).costres = costres
		;(nil).ishelp = 0
		queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, nil)
		local queue = queueCtrl:queryQueue(queuetype)
		if queue then
			queue.ottime = totaltime
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCellList = cityCtrl:getBuildCellList(tonumber(BUILDID.HOSTPITAL))
		if lefttime == 0 then
		elseif queueCtrl:isHospitalQueue(queuetype) and queuetype == include("worldMapWarDef").getHostpitalQueueType(self.warType) then
			for i = 1, #buildCellList do
				local buildCell = buildCellList[i]
				if nil ~= buildCell and tonumber(buildCell.info.state) == BUILD_STATE.NORMAL then
					gametop = BUILD_STATE.NORMAL
					BUILD_STATE.NORMAL.msg = "MESSAGE_BUILD_WORKING"
					BUILD_STATE.NORMAL.buildID = tonumber(buildCell.info.index)
					BUILD_STATE.NORMAL.buildCfgID = tonumber(data.bid)
					SoraDSendMessage(BUILD_STATE.NORMAL, content)
				end
			end
		end
		SoraDPlaySound("innercontrol", 4)
	else
		print("armyCtrl:cureWoundedArmyRsp err=" .. err)
	end
	gametop = "armyCtrl:cureWoundedArmyRsp err=" .. err
	;("armyCtrl:cureWoundedArmyRsp err=" .. err).msg = "MESSAGE_WOUNDEDARMY_HEAL"
	SoraDSendMessage("armyCtrl:cureWoundedArmyRsp err=" .. err, content)
	gametop = "armyCtrl:cureWoundedArmyRsp err=" .. err
	;("armyCtrl:cureWoundedArmyRsp err=" .. err).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
	SoraDSendMessage("armyCtrl:cureWoundedArmyRsp err=" .. err)
end
function armyCtrl:getTrainArmyRsp(content)
	local data = content.data
	local err = content.err
	print("armyCtrl:getTrainArmyRsp err=" .. err)
	if err == gErrDef.Err_None then
		for _bid, army in pairs(self.armyInfo.trainArmy) do
			if tonumber(_bid) == tonumber(data.bid) then
				local bid = tonumber(_bid)
				local cityCtrl = gametop.playertop_:getModule("cityCtrl")
				local buildCell = cityCtrl:getBuildCell(tonumber(data.bid), 0)
				local buildIndex = tonumber(buildCell.info.index)
				for k, v in pairs(army) do
					local armyid = tonumber(k)
					local armycount = tonumber(v)
					self:updateArmyCount(armyid, armycount)
					local msgNotice = include("msgNotice")
					if armyltCtrl.isArmyID(armyid) then
						_ENV = armycount
						armycount.soliderID = armyid
						msgNotice.notice("notice_0057", armycount)
					else
						_ENV = armycount
						armycount.soliderID = armyid
						msgNotice.notice("notice_0059", armycount)
					end
					_ENV = "notice_0059"
					;("notice_0059").msg = "MESSAGE_MAINCITYVIEW_SHOW_HARVEST_ARMY_RESULT"
					;("notice_0059").index = buildIndex
					;("notice_0059").bid = bid
					;("notice_0059").armyid = armyid
					;("notice_0059").armycount = armycount
					SoraDSendMessage("notice_0059", content)
				end
				self.armyInfo.trainArmy[_bid] = nil
			end
		end
		local armyInfo = data.armyInfo
		if armyInfo then
			self.armyInfo = armyInfo
		end
		_ENV = pairs(self.armyInfo.trainArmy)
		pairs(self.armyInfo.trainArmy).msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
		SoraDSendMessage(pairs(self.armyInfo.trainArmy))
	end
end
function armyCtrl:setArmyCompileRsp(content)
	dump(content, "armyCtrl:setArmyCompileRsp", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local compiletype = data.compiletype
		local armytb = data.armytb
		self.armyInfo.compileArmy[tostring(compiletype)] = armytb
	else
		print("armyCtrl:setArmyCompileRsp err=" .. err)
	end
	_ENV = "armyCtrl:setArmyCompileRsp err=" .. err
	;("armyCtrl:setArmyCompileRsp err=" .. err).msg = "MESSAGE_ARMY_TEAMSET_BACK"
	;("armyCtrl:setArmyCompileRsp err=" .. err).err = err
	;("armyCtrl:setArmyCompileRsp err=" .. err).compiletype = data.compiletype
	SoraDSendMessage("armyCtrl:setArmyCompileRsp err=" .. err)
end
function armyCtrl:getArmyCompileRsp(content)
	dump(content, "armyCtrl:getArmyCompileRsp", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local compiletype = data.compiletype
		local compileArmy = data.compileArmy
		local compileHero = data.compileHero
		local compileArms = data.compileArms
		local compileDivineBeast = data.compileDivineBeast
		self.armyInfo.compileArmy[tostring(compiletype)] = compileArmy
		self.armyInfo.compileHero[tostring(compiletype)] = compileHero
		self.armyInfo.compileArms[tostring(compiletype)] = compileArms
		self.armyInfo.compileDivineBeast[tostring(compiletype)] = compileDivineBeast
		_ENV = tostring(compiletype)
		tostring(compiletype).msg = "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA"
		tostring(compiletype).type = compiletype
		tostring(compiletype).redata = compileArmy
		tostring(compiletype).heroList = compileHero
		tostring(compiletype).armsList = compileArms
		tostring(compiletype).divineBeastList = compileDivineBeast
		SoraDSendMessage((tostring(compiletype)))
	else
		print("armyCtrl:getArmyCompileRsp err=" .. err)
	end
end
function armyCtrl:setArmyCompileNameRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local compiletype = data.compiletype
		local name = data.name
		self.armyInfo.compileArmy["n" .. tostring(compiletype)] = name
		_ENV = "n" .. tostring(compiletype)
		_ENV, ("n" .. tostring(compiletype)).msg = tostring(compiletype), "MESSAGE_WALLS_TROOPNAME_CHANGENAME"
		tostring(compiletype).tid = compiletype
		;("n" .. tostring(compiletype)).redata, tostring(compiletype).tName = tostring(compiletype), name
		SoraDSendMessage("n" .. tostring(compiletype))
	else
		print("armyCtrl:setArmyCompileNameRsp err=" .. err)
	end
end
function armyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ARMY, handler(self, self.updatearmyinfo))
end
function armyCtrl:updatearmyinfo(event)
	if not event.data then
		_ENV = event.data
	end
	for k, v in pairs(event.data) do
		local armyInfo = v.armyInfo
		if armyInfo then
			self.armyInfo = armyInfo
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_WONDERFUL_CHALLENGE_GET_REWARD_SUCCESS"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_ARMY"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_PANDECT_MARCH"
			SoraDSendMessage(nil)
			_ENV = nil
			;(nil).msg = "MESSAGE_ARMY_INFO_UPDATE"
			SoraDSendMessage(nil)
		end
		if v.filterQueueId then
			self.filterQueueIds[v.filterQueueId] = true
		end
		if self.armyInfo and self.armyInfo.singleTrainAddInfo then
			self.singleTrainAddInfo = self.armyInfo.singleTrainAddInfo
			_ENV = v.filterQueueId
			v.filterQueueId.msg = "MESSAGE_ARMY_TOOL_UPDATE"
			SoraDSendMessage(v.filterQueueId)
		end
		if "guide" == v.notifyType then
			if self.armyInfo and self.armyInfo.trainArmy and next(self.armyInfo.trainArmy) then
				for bidStr, armylist in pairs(self.armyInfo.trainArmy) do
					for armyIDStr, armyCountStr in pairs(armylist) do
						local armyID = tonumber(armyIDStr)
						local bid = tonumber(bidStr)
						local armyCount = tonumber(armyCountStr)
						local cityCtrl = gametop.playertop_:getModule("cityCtrl")
						local buildCell = cityCtrl:getBuildCell(bid, 0)
						if buildCell then
							local buildIndex = tonumber(buildCell.info.index)
							_ENV = 0
							;(0).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
							;(0).buildIndex = buildIndex
							SoraDSendMessage(0)
						end
					end
				end
				local guideCtrl = SoraDGetCtrl("guideCtrl")
				guideCtrl:updateGuideModule(gGuideModule.TRAIN_ARMY)
				guideCtrl:CompleteGuideStep(nil, gGuideStep.TRAIN_ARMY_STEP_2)
			end
		elseif "cancelRadianceCure" == v.notifyType then
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCellList = cityCtrl:getBuildCellList(tonumber(BUILDID.HOSTPITAL))
			for i = 1, #buildCellList do
				local buildCell = buildCellList[i]
				if nil ~= buildCell then
					local buildIndex = tonumber(buildCell.info.index)
					if tonumber(buildCell.info.state) == BUILD_STATE.NORMAL then
						_ENV = BUILD_STATE.NORMAL
						BUILD_STATE.NORMAL.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
						BUILD_STATE.NORMAL.buildIndex = buildIndex
						SoraDSendMessage(BUILD_STATE.NORMAL)
					end
				end
			end
			local msgNotice = include("msgNotice")
			msgNotice.notice("notice_0051")
		end
	end
end
function armyCtrl:getCuringArmy(queueType)
	queueType = queueType or gQueueTypeDef.hostpital_queue
	local _ENV, ret = gQueueTypeDef, gQueueTypeDef
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(queueType)
	if queue and queue.data then
		local data = queue.data
		ret, _ENV = data.armyinfo, data.armyinfo
		ret = data.armyinfo or gQueueTypeDef
	end
	return ret
end
function armyCtrl:getCuringArmyCount(queueType)
	queueType = queueType or gQueueTypeDef.hostpital_queue
	local ret = 0
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(queueType)
	if queue then
		local data = queue.data
		local armyinfo = data.armyinfo
		for _, v in pairs(armyinfo) do
			ret = ret + tonumber(v)
		end
	end
	return ret
end
function armyCtrl:getCountByArmyType(armyType, warType)
	local getCount = function(armylist)
		local count = 0
		if "table" == type(armylist) then
			for _armyid, _armycount in pairs(armylist) do
				local armyid = tonumber(_armyid)
				if armyid and armyltCtrl.getSoldierType(armyid) == armyType then
					count = count + tonumber(_armycount)
				end
			end
		end
		return count
	end
	local totalArmy = self:getTotalArmyList(warType)
	local armyCount = getCount(totalArmy)
	local woundedArmy = self:getWoundedArmyList(warType)
	armyCount = armyCount + getCount(woundedArmy)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local marcharmylist = kingdomMapCtrl.kingdomMapCell:getAllQueueLiveArmy(self.filterQueueIds)
	local woundedArmyList = kingdomMapCtrl.kingdomMapCell:getAllQueueWoundedArmy(self.filterQueueIds)
	armyCount = armyCount + getCount(marcharmylist)
	armyCount = armyCount + getCount(woundedArmyList)
	return armyCount
end
function armyCtrl:getHostpitalPyramidWarCDQueueTime()
	local ret = 0
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.hostpital_pyramidwar_cd_queue)
	if queue and queue.timerNode then
		ret = queue.timerNode.timer:getRemainTime()
	end
	return ret
end
function armyCtrl:getSingleAddInfo()
	_UPVALUE0_ = nil
	;(nil).itemID = 0
	;(nil).itemCount = 0
	local (nil).addCount, ret = 0, nil
	if self.singleTrainAddInfo and self.singleTrainAddInfo.itemID then
		ret = self.singleTrainAddInfo
	end
	return ret
end
function armyCtrl:updatePromoteCache(bid)
	local _ENV, ret
	local _ENV, warframeRet
	local _ENV, gildedframeRet
	local armyLogic = include("armyLogic")
	local armorSystemRead = include("armorSystemRead")
	local canTrainList = armyLogic.getCanTrainList(bid)
	for k, v in ipairs(canTrainList) do
		if v.iscantrain then
			local armyType = armyltCtrl.armyAttr(v.armyid, ARMY_ATTR.ARMY_TYPE)
			local armorId = armorSystemRead:getArmorIdByArmyId(v.armyid)
			if armorId then
				local cfg = armorSystemRead:getArmorRefSoldierInfo(armorId)
				if cfg.newLv == 14 then
					gildedframeRet[tostring(armyType)], _ENV = armyType, armyType
					gildedframeRet[tostring(armyType)].lv = armyLogic.getArmyLV(v.armyid)
					gildedframeRet[tostring(armyType)].armyid = v.armyid
				elseif cfg.newLv == 13 then
					warframeRet[tostring(armyType)], _ENV = armyType, armyType
					warframeRet[tostring(armyType)].lv = armyLogic.getArmyLV(v.armyid)
					warframeRet[tostring(armyType)].armyid = v.armyid
				end
			elseif ret[tostring(armyType)] then
				ret[tostring(armyType)].lv = math.max(ret[tostring(armyType)].lv, armyLogic.getArmyLV(v.armyid))
				ret[tostring(armyType)].armyid = v.armyid
			else
				ret[tostring(armyType)], _ENV = armyType, armyType
				ret[tostring(armyType)].lv = armyLogic.getArmyLV(v.armyid)
				ret[tostring(armyType)].armyid = v.armyid
			end
		end
	end
	self.maxTrainInfo[bid] = ret
	self.warframeInfo[bid] = warframeRet
	self.gildedframeInfo[bid] = gildedframeRet
end
function armyCtrl:getWarframeInfo(bid)
	if not self.warframeInfo[bid] or not next(self.warframeInfo[bid]) then
		self:updatePromoteCache(bid)
	end
	if not self.warframeInfo[bid] then
		_ENV = self.warframeInfo[bid]
	end
	return self.warframeInfo[bid]
end
function armyCtrl:getGildedframeInfo(bid)
	if not self.gildedframeInfo[bid] or not next(self.gildedframeInfo[bid]) then
		self:updatePromoteCache(bid)
	end
	if not self.gildedframeInfo[bid] then
		_ENV = self.gildedframeInfo[bid]
	end
	return self.gildedframeInfo[bid]
end
function armyCtrl:getTrainMaxLvByBid(bid)
	if not self.maxTrainInfo[bid] then
		self:updatePromoteCache(bid)
	end
	if not self.maxTrainInfo[bid] then
		_UPVALUE0_ = self.maxTrainInfo[bid]
	end
	return self.maxTrainInfo[bid]
end
function armyCtrl:isArmyCanPromote(warType)
	_UPVALUE5_ = nil
	;(nil)[1] = BUILDID.CHARIOT_PLANT
	;(nil)[2] = BUILDID.STABLES
	;(nil)[3] = BUILDID.RANGE
	;(nil)[4] = BUILDID.BARRACKS
	local (nil)[5], bidArray = BUILDID.ELITE_PALACE, nil
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local armyLogic = include("armyLogic")
	for k, v in ipairs(bidArray) do
		local build = cityCtrl:getBuildCell(v, 0)
		if build then
			local canTrainList = armyLogic.getCanTrainList(v)
			for i, data in ipairs(canTrainList) do
				local num = self:getArmyCount(data.armyid, warType)
				if 0 < num then
					local maxLimit = self:getTrainMaxLvByBid(v)
					local lv = armyLogic.getArmyLV(data.armyid)
					local armyType = armyltCtrl.armyAttr(data.armyid, ARMY_ATTR.ARMY_TYPE)
					if maxLimit[tostring(armyType)] and lv < maxLimit[tostring(armyType)].lv then
						return true
					end
				end
			end
		end
	end
	return false
end
function armyCtrl:isCanPromote(armyID, warType)
	local armyLogic = include("armyLogic")
	local num = self:getArmyCount(armyID, warType)
	local lv = armyLogic.getArmyLV(armyID)
	local armyType = armyltCtrl.armyAttr(armyID, ARMY_ATTR.ARMY_TYPE)
	local barrackID = armyltCtrl.armyAttr(armyID, ARMY_ATTR.BARRACK_ID)
	local maxLimit = self:getTrainMaxLvByBid(barrackID)
	local ret = false
	if 0 < num and maxLimit[tostring(armyType)] and lv < maxLimit[tostring(armyType)].lv and barrackID ~= BUILDID.FORTRESS then
		ret = true
	end
	return ret
end
function armyCtrl:isCanWearWarframe(armyID)
	local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armorId = armorSystemRead:getArmorIdByArmyId(armyID, true)
	local barrackID = armyltCtrl.armyAttr(armyID, ARMY_ATTR.BARRACK_ID)
	if armorId and barrackID ~= BUILDID.FORTRESS then
		_ENV = ARMY_ATTR.BARRACK_ID
		ARMY_ATTR.BARRACK_ID.isArmorID = true
		ARMY_ATTR.BARRACK_ID.armorID = armorId
		if SoraDIsBrave8Level(ARMY_ATTR.BARRACK_ID) and commonCheck.WARFRAME_WEAR then
			return true
		end
	end
	return false
end
function armyCtrl:isCanWearGilded(armyID)
	local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armorId = armorSystemRead:getArmorIdByArmyId(armyID, true)
	local barrackID = armyltCtrl.armyAttr(armyID, ARMY_ATTR.BARRACK_ID)
	if armorId and barrackID ~= BUILDID.FORTRESS then
		_ENV = ARMY_ATTR.BARRACK_ID
		ARMY_ATTR.BARRACK_ID.isArmorID = true
		ARMY_ATTR.BARRACK_ID.armorID = armorId
		if SoraDIsGildedArmorOpen(ARMY_ATTR.BARRACK_ID) and commonCheck.GILT_ARMOR_WEAR then
			return true
		end
	end
	return false
end
function armyCtrl:initClientData(data)
	dump(data, "armyCtrl:initClientData", 10)
	self.armyInfo = data
	self.filterQueueIds, _ENV, self.singleTrainAddInfo = self.armyInfo.singleTrainAddInfo, self.armyInfo.singleTrainAddInfo, self.armyInfo.singleTrainAddInfo
	self:registerNotify()
end
function armyCtrl:reqDispatchArmy(army)
	dump("armyCtrl:reqDispatchArmy", army, 10)
	_ENV = nil
	;(nil).army = army
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_DISPATCH_RADIANCE_WAR_ARMY, nil)
end
function armyCtrl:reqRecallArmy()
	print("armyCtrl:reqRecallArmy")
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_RECALL_RADIANCE_WAR_ARMY)
end
function armyCtrl:reqCureWoundedArmy(army)
	dump("armyCtrl:reqCureWoundedArmy", army, 10)
	_ENV = nil
	;(nil).army = army
	serverproxy:Request(gCmd.CMD_ARMY_MODULE, gCmd.REQ_CURE_RADIANCE_WAR_WOUNDED_ARMY, nil)
end
function armyCtrl:checkWoundedArmyState()
	local woundedCount = self:getTotalWoundedArmyCount() or 0
	local curingNum = self:getCuringArmyCount() or 0
	if 0 < woundedCount and 0 < woundedCount - curingNum then
		return true
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	if kingdomMapCtrl:getKingdomMapCell():hasWoundedQueueArmy() then
		return true
	end
	return false
end
return armyCtrl

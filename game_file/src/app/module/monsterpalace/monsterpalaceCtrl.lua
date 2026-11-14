local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local monsterpalaceCtrl = class("monsterpalaceCtrl", gamemodulec)
local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
local timerList = gModuleMgr.getObject("timerList")
local MAX_RECORD_NUM = 100
function monsterpalaceCtrl:ctor(properties)
	monsterpalaceCtrl.super.ctor(self, properties)
	self.feathershopdata = monsterpalaceltCtrl:get_feahtershop()
	self:resetData()
	self.personalNormalCount = 0
	self.personalEliteCount = 0
	self.systemNormalCount = 0
	self.systemEliteCount = 0
end
function monsterpalaceCtrl:modifyPersonalRecordNum(battletype, addnum)
	addnum = addnum or 0
	if battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
		self.personalNormalCount = self.personalNormalCount + addnum
		return self.personalNormalCount
	elseif battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
		self.personalEliteCount = self.personalEliteCount + addnum
		return self.personalEliteCount
	end
end
function monsterpalaceCtrl:modifySystemRecordNum(battletype, addnum)
	addnum = addnum or 0
	if battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
		self.systemNormalCount = self.systemNormalCount + addnum
		return self.systemNormalCount
	elseif battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
		self.systemEliteCount = self.systemEliteCount + addnum
		return self.systemEliteCount
	end
end
function monsterpalaceCtrl:getActivityStatus()
	if self.initdata then
		return self.initdata.activitystatus
	else
		return 0
	end
end
function monsterpalaceCtrl:getInitInfo()
	return self.initdata
end
function monsterpalaceCtrl:getBattleInfo(battleType)
	return self.battleinfo[battleType]
end
function monsterpalaceCtrl:getItemCount()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	return backpackCtrl:getItemCount(self:getItemID())
end
function monsterpalaceCtrl:getItemID()
	return MONSTERPALACE_HORNID
end
function monsterpalaceCtrl:Logout()
	monsterpalaceCtrl.super.Logout(self)
	self:resetData()
end
function monsterpalaceCtrl:resetData()
	self.personalawardinfo, _UPVALUE0_, self.serverawardinfo, _UPVALUE0_, self.curbattleaward, _UPVALUE0_, self.awardlist, _UPVALUE0_, self.battleinfo, _UPVALUE0_, self.initdata, _UPVALUE0_, self.queue, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.firstQueryFlag = true
end
function monsterpalaceCtrl:getEliteChallengeStatus()
	if self.initdata then
		return self.initdata.elitestatus, self.initdata.elitetime
	else
		return MONSTERPALACE_ELITE_STATUS_CLOSE, 86400
	end
end
function monsterpalaceCtrl:getEliteQueuetimer()
	return self.queue[MONSTERPALCE_ELITE_QUEUE_KEY]
end
function monsterpalaceCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self:dispatchEvent(event)
		self.queue[queuetype] = nil
	end
	local _ENV, queue = self, self
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function monsterpalaceCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function monsterpalaceCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function monsterpalaceCtrl:splitPersonalAward(battleType)
	local _ENV, reTbl
	for _, v in ipairs(self.personalawardinfo) do
		if v.battletype and v.battletype == battleType then
			table.insert(reTbl, v)
		end
	end
	return reTbl
end
function monsterpalaceCtrl:timesCallBack()
end
function monsterpalaceCtrl:EnterGame()
	self:addEventListener(MONSTERPALCE_ELITE_QUEUE_KEY, handler(self, self.timesCallBack))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_ENTRANCE, handler(self, self.entranceinfoRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_ENTERBATTLE, handler(self, self.enterpalacebattleRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_ATTACK, handler(self, self.palaceattackRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_FEATHER_SHOP, handler(self, self.feathershopRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_FEATHER_SHOP_BUY, handler(self, self.feathershopbuyRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_QUERY_AWARDLOG, handler(self, self.queryAwardLogRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_SYSTEM_LOG, handler(self, self.querySystemLogRsp))
	msgCtrl.register(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_PERSONAL_LOG, handler(self, self.queryPersonalLogRsp))
end
function monsterpalaceCtrl:entranceinfoRsp(content)
	dump(content, "monsterpalaceCtrl:entranceinfoRsp", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		self.initdata = data
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_MONSTERPALACE_ENTRANCE"
		SoraDSendMessage(10)
	end
end
function monsterpalaceCtrl:enterpalacebattleRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local battletype = tonumber(data.battletype)
		if not self.battleinfo[battletype] then
			self.battleinfo[battletype], _ENV = nil, nil
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		else
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		end
		if battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
			self.battleinfo[battletype].maxhp = self.initdata.normalmaxhp
		elseif battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
			self.battleinfo[battletype].maxhp = self.initdata.elitemaxhp
		end
		_ENV = self.initdata.elitemaxhp
		self.initdata.elitemaxhp.msg = "MESSAGE_SERVER_MONSTERPALACE_ENTERBATTLE"
		SoraDSendMessage(self.initdata.elitemaxhp)
	else
	end
end
function monsterpalaceCtrl:palaceattackRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local battletype = tonumber(data.battletype)
		local bDie = data.dieflag
		local bfinished = data.bfinished
		if not self.battleinfo[battletype] then
			self.battleinfo[battletype], _ENV = nil, nil
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		else
			self.battleinfo[battletype].dechp = data.dechp
			self.battleinfo[battletype].remainkilltimes = data.remainkilltimes
			self.battleinfo[battletype].Allanhbless = data.Allanhbless
		end
		self.curbattleaward = data.awardlist
		if battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
			self.initdata.normaldechp = data.dechp
			self.initdata.normalkilltimes = data.remainkilltimes
		elseif battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
			self.initdata.elitedechp = data.dechp
			self.initdata.elitekilltimes = data.remainkilltimes
		end
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_SERVER_MONSTERPALACE_ATTACK"
		data.remainkilltimes.awardlist = data.awardlist
		data.remainkilltimes.monsterDie = bDie
		data.remainkilltimes.noMonster = bfinished
		SoraDSendMessage(data.remainkilltimes)
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_SERVER_MONSTERPALACE_REFRESHINFO"
		SoraDSendMessage(data.remainkilltimes)
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
		data.remainkilltimes.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
		SoraDSendMessage(data.remainkilltimes)
	else
		_ENV = data.dieflag
		data.dieflag.msg = "MESSAGE_SERVER_MONSTERPALACE_ERRCALLBACK"
		data.dieflag.errType = err
		SoraDSendMessage(data.dieflag)
	end
end
function monsterpalaceCtrl:feathershopRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		self.feathershopdata = data
	else
	end
end
function monsterpalaceCtrl:feathershopbuyRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
		local priceConfig = clone(monsterpalaceltCtrl:get_feahtershop(self:getZeroLv()))
		_UPVALUE2_ = monsterpalaceltCtrl:get_feahtershop(self:getZeroLv())
		monsterpalaceltCtrl:get_feahtershop(self:getZeroLv())[1] = "id"
		monsterpalaceltCtrl:get_feahtershop(self:getZeroLv())[2] = "count"
		local gainList = serviceFunctions.tableFormat(priceConfig[data.index].rewards, monsterpalaceltCtrl:get_feahtershop(self:getZeroLv()))
		SoraDMailGainItems(gainList, true)
		_ENV = gainList
		gainList.msg = "MESSAGE_SERVER_MONSTERPALACE_FEATHERSHOPBUY"
		gainList.idx = data.index
		SoraDSendMessage(gainList)
	else
	end
end
function monsterpalaceCtrl:entranceinfoReq()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_ENTRANCE, data)
	if self.firstQueryFlag then
		local serverproxy, dataaward = self.firstQueryFlag, self.firstQueryFlag
		serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_SYSTEM_LOG, dataaward)
		serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_PERSONAL_LOG, dataaward)
		self.firstQueryFlag = false
	end
end
function monsterpalaceCtrl:enterpalacebattleReq(type)
	local serverproxy, data
	data.battletype = type
	serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_ENTERBATTLE, data)
end
function monsterpalaceCtrl:palaceattackReq(type)
	local serverproxy, data
	data.attacktype = type
	serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_ATTACK, data)
end
function monsterpalaceCtrl:feathershopReq()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_FEATHER_SHOP, data)
end
function monsterpalaceCtrl:feathershopbuyReq(idindex)
	local serverproxy, data
	data.index = idindex
	serverproxy:Request(gCmd.CMD_MONSTERPALACE_MODULE, gCmd.REQ_MONSTERPALACE_FEATHER_SHOP_BUY, data)
end
function monsterpalaceCtrl:queryAwardLogReq()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_MONSTERPALACE_QUERYSYSLOG"
	SoraDSendMessage(nil)
end
function monsterpalaceCtrl:getServerAwardInfo()
	local ret = clone(self.serverawardinfo)
	return ret
end
function monsterpalaceCtrl:getPersonalAwardInfo()
	local ret = clone(self.personalawardinfo)
	return ret
end
function monsterpalaceCtrl:queryPersonalLogRsp(content)
	local data = content.data
	local err = content.err
	self.personalawardinfo = data.personalaward
	for k, v in pairs(self.personalawardinfo) do
		if v.battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
			self.personalNormalCount = self.personalNormalCount + 1
		elseif v.battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
			self.personalEliteCount = self.personalEliteCount + 1
		end
	end
end
function monsterpalaceCtrl:querySystemLogRsp(content)
	local data = content.data
	local err = content.err
	self.serverawardinfo = data.systemawardlog
	for k, v in pairs(self.serverawardinfo) do
		if v.battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
			self.systemNormalCount = self.systemNormalCount + 1
		elseif v.battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
			self.systemEliteCount = self.systemEliteCount + 1
		end
	end
end
function monsterpalaceCtrl:queryAwardLogRsp(content)
	local data = content.data
	local err = content.err
	self.serverawardinfo = data.systemawardlog
	for k, v in pairs(self.serverawardinfo) do
		if v.battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
			self.systemNormalCount = self.systemNormalCount + 1
		elseif v.battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
			self.systemEliteCount = self.systemEliteCount + 1
		end
	end
	self.personalawardinfo = data.personalaward
	for k, v in pairs(self.personalawardinfo) do
		if v.battletype == gMonsterpalaceBattletype.NORMAL_BATTLE then
			self.personalNormalCount = self.personalNormalCount + 1
		elseif v.battletype == gMonsterpalaceBattletype.ELITE_BATTLE then
			self.personalEliteCount = self.personalEliteCount + 1
		end
	end
end
function monsterpalaceCtrl:initClientData(data)
	dump(data, "monsterpalaceCtrl:initClient data", 10)
	self.initdata = data
	if self.initdata and self.initdata.activitystatus then
		local starttime = serviceFunctions.systemTime()
		local totaltime = self.initdata.elitetime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		self:addQueue(MONSTERPALCE_ELITE_QUEUE_KEY, starttime, totaltime, lefttime)
	end
	self:registerNotify()
end
function monsterpalaceCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MONSTERPALACE_ACTIVITY, handler(self, self.notifyUpdate))
end
function monsterpalaceCtrl:notifyUpdate(event)
	local notifydata = event.data
	dump(event, "monsterpalaceCtrl:notifyUpdate==========", 20)
	for k, data in pairs(notifydata) do
		if data.type == "activestatus" then
			self.initdata = data.data
			if self.initdata and self.initdata.activitystatus then
				local starttime = serviceFunctions.systemTime()
				local totaltime = self.initdata.elitetime
				local nowtime = serviceFunctions.systemTime()
				local lasttime = nowtime - starttime
				local lefttime = totaltime - lasttime
				if lefttime <= 0 then
					lefttime = 0
				end
				self:addQueue(MONSTERPALCE_ELITE_QUEUE_KEY, starttime, totaltime, lefttime)
			end
			if self.battleinfo then
				if self.battleinfo[gMonsterpalaceBattletype.NORMAL_BATTLE] and self.initdata then
					self.battleinfo[gMonsterpalaceBattletype.NORMAL_BATTLE].dechp = self.initdata.normaldechp
					self.battleinfo[gMonsterpalaceBattletype.NORMAL_BATTLE].remainkilltimes = self.initdata.normalkilltimes
				end
				if self.battleinfo[gMonsterpalaceBattletype.ELITE_BATTLE] and self.initdata then
					self.battleinfo[gMonsterpalaceBattletype.ELITE_BATTLE].dechp = self.initdata.elitedechp
					self.battleinfo[gMonsterpalaceBattletype.ELITE_BATTLE].remainkilltimes = self.initdata.elitekilltimes
				end
			end
			_ENV = self.initdata.elitekilltimes
			self.initdata.elitekilltimes.msg = "MESSAGE_SERVER_MONSTERPALACE_UPDATEACTIVESTATUS"
			SoraDSendMessage(self.initdata.elitekilltimes)
		elseif data.type == "personalaward" then
			if next(data.data) then
				local battletype = data.data[1].battletype
				for k, v in pairs(data.data) do
					local curCount = self:modifyPersonalRecordNum(battletype)
					if curCount >= MAX_RECORD_NUM then
						for k1, v1 in ipairs(self.personalawardinfo) do
							if v1.battletype == battletype then
								table.remove(self.personalawardinfo, k1)
								curCount = self:modifyPersonalRecordNum(battletype, -1)
								break
							end
						end
						table.insert(self.personalawardinfo, v)
						curCount = self:modifyPersonalRecordNum(battletype, 1)
					else
						table.insert(self.personalawardinfo, v)
						curCount = self:modifyPersonalRecordNum(battletype, 1)
					end
				end
			end
			local reward = self.personalawardinfo[#self.personalawardinfo]
			_ENV = pairs(data.data)
			pairs(data.data).msg = "MESSAGE_SERVER_MONSTERPALACE_UPDATE_PERSONALAWARD"
			pairs(data.data).reward = reward
			SoraDSendMessage(pairs(data.data))
		elseif data.type == "systemaward" then
			if next(data.data) then
				local battletype = data.data[1].battletype
				for k, v in pairs(data.data) do
					local curCount = self:modifySystemRecordNum(battletype)
					if curCount >= MAX_RECORD_NUM then
						for k1, v1 in ipairs(self.serverawardinfo) do
							if v1.battletype == battletype then
								table.remove(self.serverawardinfo, k1)
								curCount = self:modifySystemRecordNum(battletype, -1)
								break
							end
						end
						table.insert(self.serverawardinfo, v)
						curCount = self:modifySystemRecordNum(battletype, 1)
					else
						table.insert(self.serverawardinfo, v)
						curCount = self:modifySystemRecordNum(battletype, 1)
					end
				end
			end
			local reward = self.serverawardinfo[#self.serverawardinfo]
			_ENV = pairs(data.data)
			pairs(data.data).msg = "MESSAGE_SERVER_MONSTERPALACE_UPDATE_SYSTEMAWARD"
			pairs(data.data).reward = reward
			SoraDSendMessage(pairs(data.data))
		end
	end
end
function monsterpalaceCtrl:getZeroLv()
	if next(self.initdata) ~= nil then
		return self.initdata.serverLevel or 1
	end
	return 1
end
function monsterpalaceCtrl:judgeIsEnough()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
	local priceConfig = clone(monsterpalaceltCtrl:get_feahtershop(self:getZeroLv()))
	local ret = false
	for _, v in pairs(priceConfig) do
		local itemList = SoraDIntArr2FormatTable(v.needItem)
		local isEnough = true
		for _, val in pairs(itemList) do
			if backpackCtrl:getItemCount(val.id) < val.num then
				isEnough = false
			end
		end
		if isEnough then
			ret = true
			break
		end
	end
	return ret
end
return monsterpalaceCtrl

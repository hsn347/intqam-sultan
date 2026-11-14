local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local activity_9001660_Ctrl = class("activity_9001660_Ctrl", gamemodulec)
local activity_9001660_Read = include("activity_9001660_Read")
local MAX_RECORD_NUM = 100
function activity_9001660_Ctrl:ctor(properties)
	activity_9001660_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MUTANT_TENTACLES_ACTIVITY
	self:resetData()
	self.personalNormalCount = 0
	self.personalEliteCount = 0
	self.systemNormalCount = 0
	self.systemEliteCount = 0
end
function activity_9001660_Ctrl:modifyPersonalRecordNum(battletype, addnum)
	addnum = addnum or 0
	if battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
		self.personalNormalCount = self.personalNormalCount + addnum
		return self.personalNormalCount
	elseif battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
		self.personalEliteCount = self.personalEliteCount + addnum
		return self.personalEliteCount
	end
end
function activity_9001660_Ctrl:modifySystemRecordNum(battletype, addnum)
	addnum = addnum or 0
	if battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
		self.systemNormalCount = self.systemNormalCount + addnum
		return self.systemNormalCount
	elseif battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
		self.systemEliteCount = self.systemEliteCount + addnum
		return self.systemEliteCount
	end
end
function activity_9001660_Ctrl:getActivityStatus()
	if self.initdata then
		return self.initdata.activitystatus
	else
		return 0
	end
end
function activity_9001660_Ctrl:Logout()
	activity_9001660_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001660_Ctrl:resetData()
	self.personalawardinfo, _UPVALUE0_, self.serverawardinfo, _UPVALUE0_, self.curbattleaward, _UPVALUE0_, self.awardlist, _UPVALUE0_, self.battleinfo, _UPVALUE0_, self.initdata, _UPVALUE0_, self.queue, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.firstQueryFlag = true
end
function activity_9001660_Ctrl:getEliteChallengeStatus()
	if self.initdata then
		return self.initdata.elitestatus, self.initdata.elitetime
	else
		return activity_9001660_Read.MONSTERPALACE_ELITE_STATUS_CLOSE, 86400
	end
end
function activity_9001660_Ctrl:splitPersonalAward(battleType)
	local _ENV, reTbl
	for _, v in ipairs(self.personalawardinfo) do
		if v.battletype and v.battletype == battleType then
			table.insert(reTbl, v)
		end
	end
	return reTbl
end
function activity_9001660_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_ENTRANCE, handler(self, self.entranceinfoRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_ENTERBATTLE, handler(self, self.enterpalacebattleRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_ATTACK, handler(self, self.palaceattackRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_FEATHER_SHOP, handler(self, self.feathershopRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_FEATHER_SHOP_BUY, handler(self, self.feathershopbuyRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_QUERY_AWARDLOG, handler(self, self.queryAwardLogRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_SYSTEM_LOG, handler(self, self.querySystemLogRsp))
	msgCtrl.register(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_PERSONAL_LOG, handler(self, self.queryPersonalLogRsp))
	self:registerNotify()
end
function activity_9001660_Ctrl:entranceinfoRsp(content)
	dump(content, "activity_9001660_Ctrl:entranceinfoRsp", 10)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
		self.initdata = data
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_MUTANT_TENTACLES_ENTRANCE"
		SoraDSendMessage(10)
	end
end
function activity_9001660_Ctrl:enterpalacebattleRsp(content)
	local data = content.rspdata
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
		if battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
			self.battleinfo[battletype].maxhp = self.initdata.normalmaxhp
		elseif battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
			self.battleinfo[battletype].maxhp = self.initdata.elitemaxhp
		end
	end
	_ENV = self.battleinfo[battletype]
	self.battleinfo[battletype].msg = "MESSAGE_SERVER_MUTANT_TENTACLES_ENTERBATTLE"
	SoraDSendMessage(self.battleinfo[battletype])
end
function activity_9001660_Ctrl:palaceattackRsp(content)
	dump(content, "activity_9001660_Ctrl:palaceattackRsp", 10)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
		local battletype = tonumber(data.battletype)
		local bDie = data.dieflag
		if content.data.attacktype == activity_9001660_Read.gMutantTentaclesAtkType.ATKTYPE_CRITICAL then
			bDie = true
		end
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
		if battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
			self.initdata.normaldechp = data.dechp
			self.initdata.normalkilltimes = data.remainkilltimes
		elseif battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
			self.initdata.elitedechp = data.dechp
			self.initdata.elitekilltimes = data.remainkilltimes
		end
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_SERVER_MUTANT_TENTACLES_ATTACK"
		data.remainkilltimes.awardlist = data.awardlist
		data.remainkilltimes.monsterDie = bDie
		data.remainkilltimes.noMonster = bfinished
		SoraDSendMessage(data.remainkilltimes)
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_SERVER_MUTANT_TENTACLES_REFRESHINFO"
		SoraDSendMessage(data.remainkilltimes)
		_ENV = data.remainkilltimes
		data.remainkilltimes.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
		data.remainkilltimes.activityID = gActivityTimeActivityID.MUTANT_TENTACLES_ACTIVITY
		SoraDSendMessage(data.remainkilltimes)
	else
		_ENV = true
		;(true).msg = "MESSAGE_SERVER_MUTANT_TENTACLES_ERRCALLBACK"
		;(true).errType = err
		SoraDSendMessage(true)
	end
end
function activity_9001660_Ctrl:feathershopRsp(content)
	local data = content.rspdata
	local err = content.err
	if err == gErrDef.Err_None then
	else
	end
end
function activity_9001660_Ctrl:feathershopbuyRsp(content)
	dump(content, "activity_9001660_Ctrl:feathershopbuyRsp", 10)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		local priceConfig = clone(activity_9001660_Read.get_feahtershop(self:getZeroLv(), self:getClassType()))
		_UPVALUE2_ = activity_9001660_Read.get_feahtershop(self:getZeroLv(), self:getClassType())
		activity_9001660_Read.get_feahtershop(self:getZeroLv(), self:getClassType())[1] = "id"
		activity_9001660_Read.get_feahtershop(self:getZeroLv(), self:getClassType())[2] = "count"
		local gainList = serviceFunctions.tableFormat(priceConfig[data.index].rewards, activity_9001660_Read.get_feahtershop(self:getZeroLv(), self:getClassType()))
		SoraDMailGainItems(gainList, true)
		_ENV = gainList
		gainList.msg = "MESSAGE_SERVER_MUTANT_TENTACLES_FEATHERSHOPBUY"
		gainList.idx = data.index
		SoraDSendMessage(gainList)
	else
	end
end
function activity_9001660_Ctrl:entranceinfoReq(isForce)
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_ENTRANCE, data)
	if isForce or self.firstQueryFlag then
		local serverproxy, dataaward = self.firstQueryFlag, self.firstQueryFlag
		serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_SYSTEM_LOG, dataaward)
		serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_PERSONAL_LOG, dataaward)
		self.firstQueryFlag = false
	end
end
function activity_9001660_Ctrl:enterpalacebattleReq(type)
	local serverproxy, data
	data.battletype = type
	serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_ENTERBATTLE, data)
end
function activity_9001660_Ctrl:palaceattackReq(type)
	local serverproxy, data
	data.attacktype = type
	serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_ATTACK, data)
end
function activity_9001660_Ctrl:feathershopReq()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_FEATHER_SHOP, data)
end
function activity_9001660_Ctrl:feathershopbuyReq(idindex)
	local serverproxy, data
	data.index = idindex
	serverproxy:Request(gCmd.CMD_MUTANT_TENTACLES_MODULE, gCmd.REQ_MUTANT_TENTACLES_FEATHER_SHOP_BUY, data)
end
function activity_9001660_Ctrl:queryAwardLogReq()
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_MUTANT_TENTACLES_QUERYSYSLOG"
	SoraDSendMessage(nil)
end
function activity_9001660_Ctrl:getServerAwardInfo()
	local ret = clone(self.serverawardinfo)
	return ret
end
function activity_9001660_Ctrl:getPersonalAwardInfo()
	local ret = clone(self.personalawardinfo)
	return ret
end
function activity_9001660_Ctrl:queryPersonalLogRsp(content)
	local data = content.rspdata
	local err = content.err
	self.personalawardinfo = data.personalaward
	for k, v in pairs(self.personalawardinfo) do
		if v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
			self.personalNormalCount = self.personalNormalCount + 1
		elseif v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
			self.personalEliteCount = self.personalEliteCount + 1
		end
	end
end
function activity_9001660_Ctrl:querySystemLogRsp(content)
	local data = content.rspdata
	local err = content.err
	if data then
		self.serverawardinfo = data.systemawardlog
		for k, v in pairs(self.serverawardinfo) do
			if v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
				self.systemNormalCount = self.systemNormalCount + 1
			elseif v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
				self.systemEliteCount = self.systemEliteCount + 1
			end
		end
	end
end
function activity_9001660_Ctrl:queryAwardLogRsp(content)
	local data = content.rspdata
	local err = content.err
	self.serverawardinfo = data.systemawardlog
	for k, v in pairs(self.serverawardinfo) do
		if v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
			self.systemNormalCount = self.systemNormalCount + 1
		elseif v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
			self.systemEliteCount = self.systemEliteCount + 1
		end
	end
	self.personalawardinfo = data.personalaward
	for k, v in pairs(self.personalawardinfo) do
		if v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE then
			self.personalNormalCount = self.personalNormalCount + 1
		elseif v.battletype == activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE then
			self.personalEliteCount = self.personalEliteCount + 1
		end
	end
end
function activity_9001660_Ctrl:initClientData(data)
	dump(data, "activity_9001660_Ctrl:initClient data", 10)
	self.initdata = data
end
function activity_9001660_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MUTANT_TENTACLES, handler(self, self.notifyUpdate))
end
function activity_9001660_Ctrl:notifyUpdate(event)
	local notifydata = event.data
	dump(event, "activity_9001660_Ctrl:notifyUpdate==========", 20)
	for k, data in pairs(notifydata) do
		if data.type == "activestatus" then
			self.initdata = data.data
			if self.battleinfo then
				if self.battleinfo[activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE] and self.initdata then
					self.battleinfo[activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE].dechp = self.initdata.normaldechp
					self.battleinfo[activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE].remainkilltimes = self.initdata.normalkilltimes
				end
				if self.battleinfo[activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE] and self.initdata then
					self.battleinfo[activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE].dechp = self.initdata.elitedechp
					self.battleinfo[activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE].remainkilltimes = self.initdata.elitekilltimes
				end
			end
			_ENV = self.initdata.elitekilltimes
			self.initdata.elitekilltimes.msg = "MESSAGE_SERVER_MUTANT_TENTACLES_UPDATEACTIVESTATUS"
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
			pairs(data.data).msg = "MESSAGE_SERVER_MUTANT_TENTACLES_UPDATE_PERSONALAWARD"
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
			pairs(data.data).msg = "MESSAGE_SERVER_MUTANT_TENTACLES_UPDATE_SYSTEMAWARD"
			pairs(data.data).reward = reward
			SoraDSendMessage(pairs(data.data))
		end
	end
end
function activity_9001660_Ctrl:getReceiveStatusAndNum()
	local num = 0
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local normalCost = include("constantRead").getConstValue("MUTATED_TENTACLES_ITEM_NUM", 10)
	if normalCost <= self:getItemCount() then
		num = 1
	end
	return 0 < num, -1
end
function activity_9001660_Ctrl:getZeroLv()
	if next(self.initdata) ~= nil then
		return self.initdata.serverLevel or 1
	end
	return 1
end
function activity_9001660_Ctrl:getInitInfo()
	return self.initdata
end
function activity_9001660_Ctrl:getBattleInfo(battleType)
	return self.battleinfo[battleType]
end
function activity_9001660_Ctrl:judgeTimesOut(battleType)
	local isOut = false
	if activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE == battleType then
		isOut = self.initdata.normalkilltimes == nil or self.initdata.normalkilltimes <= 0
	elseif activity_9001660_Read.gMutantTentaclesBattletype.ELITE_BATTLE == battleType then
		isOut = self.initdata.elitekilltimes == nil or 0 >= self.initdata.elitekilltimes
	end
	return isOut
end
function activity_9001660_Ctrl:judgeIsEnough()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local priceConfig = clone(activity_9001660_Read.get_feahtershop(self:getZeroLv(), self:getClassType()))
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
function activity_9001660_Ctrl:getItemCount()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	return backpackCtrl:getItemCount(self:getItemID())
end
function activity_9001660_Ctrl:getItemID()
	return include("constantRead").getConstValue("MUTATED_TENTACLES_ITEM")
end
function activity_9001660_Ctrl:getClassType()
	return SoraDGetActivityClassType(self.activityID)
end
return activity_9001660_Ctrl

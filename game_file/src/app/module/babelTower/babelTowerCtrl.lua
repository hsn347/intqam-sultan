local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local babelTowerCtrl = class("babelTowerCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function babelTowerCtrl:ctor(properties)
	babelTowerCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.TONGTIAN_TOWER_ACTIVITY
	self.ticketsID = 726001
	self:resetData()
end
function babelTowerCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_INFO, handler(self, self.reqTongtianTowerInfoRsp))
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_CLIMB, handler(self, self.reqTongtianTowerClimbRsp))
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_BUFF_CHOOSE, handler(self, self.reqTongtianTowerBuffChooseRsp))
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_FLOOR_RESET, handler(self, self.reqResetTowerFloorRsp))
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_RANK, handler(self, self.reqTowerRankRsp))
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_NEXT_FLOOR, handler(self, self.reqNextFloorRsp))
	msgCtrl.register(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_CLIMB_TEN, handler(self, self.reqTenRsp))
end
function babelTowerCtrl:Logout()
	babelTowerCtrl.super.Logout(self)
	self:resetData()
end
function babelTowerCtrl:resetData()
	self.floor = 1
	self.lastingBuff, _UPVALUE0_, self.state = nil, nil, 0
	self.blood = 0
	self.bloodMax = 0
	self.firstClimb = false
	self.isSkipInfo = false
end
function babelTowerCtrl:reqTongtianTowerInfo()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_INFO, nil)
end
function babelTowerCtrl:reqTongtianTowerClimb(data)
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_CLIMB, data)
end
function babelTowerCtrl:reqTongtianTowerBuffChoose(data)
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_BUFF_CHOOSE, data)
end
function babelTowerCtrl:reqResetTowerFloor(data)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_FLOOR_RESET, nil)
end
function babelTowerCtrl:reqTowerRank()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_RANK, nil)
end
function babelTowerCtrl:reqNextFloor()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_NEXT_FLOOR, nil)
end
function babelTowerCtrl:reqTen(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_TONGTIAN_TOWER_MODULE, gCmd.REQ_TONGTIAN_TOWER_CLIMB_TEN, nil)
end
function babelTowerCtrl:reqTongtianTowerInfoRsp(content)
	dump(content, "babelTowerCtrl:reqTongtianTowerInfoRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.floor = content.rspdata.floor
		self.state = content.rspdata.state
		self.blood = content.rspdata.blood
		self.bloodMax = content.rspdata.bloodMax
		self.chooseDoor = content.rspdata.door
		self.firstClimb = not content.rspdata.exp
		self:addBuffList(content.rspdata.allBuff)
		_ENV = self
		self.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.subMsg = "init"
		self.state = self.state
		self.door = self.chooseDoor
		SoraDSendMessage(self)
	end
end
function babelTowerCtrl:reqTongtianTowerClimbRsp(content)
	dump(content, "babelTowerCtrl:reqTongtianTowerClimbRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local eventIndex = content.rspdata.eventIndex
		local isPass = content.rspdata.pass
		local hasBuff = content.rspdata.hasBuff
		local changeBlood = content.rspdata.blood - self.blood
		self.blood = content.rspdata.blood
		self.bloodMax = content.rspdata.bloodMax
		self.floor = content.rspdata.floor
		self.state = content.rspdata.state
		self.firstClimb = not content.rspdata.exp
		self:addBuffList(content.rspdata.allBuff)
		_ENV = self
		self.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.subMsg = "climb"
		self.eventIndex = eventIndex
		self.isPass = isPass
		self.hasBuff = hasBuff
		self.state = self.state
		self.changeBlood = changeBlood
		SoraDSendMessage(self)
	end
end
function babelTowerCtrl:reqTongtianTowerBuffChooseRsp(content)
	dump(content, "babelTowerCtrl:reqTongtianTowerBuffChooseRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local changeBlood = content.rspdata.blood - self.blood
		self.blood = content.rspdata.blood or self.blood
		self.bloodMax = content.rspdata.bloodMax
		self.state = content.rspdata.state
		self:addBuffList(content.rspdata.allBuff)
		_ENV = self
		self.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.subMsg = "chooseBuff"
		self.changeBlood = changeBlood
		SoraDSendMessage(self)
	end
end
function babelTowerCtrl:reqResetTowerFloorRsp(content)
	dump(content, "babelTowerCtrl:reqResetTowerFloorRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.blood = content.rspdata.blood
		self.bloodMax = content.rspdata.bloodMax
		self.floor = 1
		self.state = 0
		_ENV = "babelTowerCtrl:reqResetTowerFloorRsp(content)"
		self:addBuffList("babelTowerCtrl:reqResetTowerFloorRsp(content)")
		_ENV = self
		self.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.subMsg = "reset"
		SoraDSendMessage(self)
	end
end
function babelTowerCtrl:reqTowerRankRsp(content)
	dump(content, "babelTowerCtrl:reqTowerRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		gErrDef.Err_None.subMsg = "rank"
		gErrDef.Err_None.infoData = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function babelTowerCtrl:reqNextFloorRsp(content)
	dump(content, "babelTowerCtrl:reqNextFloorRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		self.state = 0
		self.floor = content.rspdata.floor
		self:addBuffList(content.rspdata.allBuff)
		_ENV = self
		self.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.reward = reward
		self.subMsg = "nextFloor"
		SoraDSendMessage(self)
	else
		SoraDShowMsgTip(i18n("Promise_Summit_text_25"))
	end
end
function babelTowerCtrl:reqTenRsp(content)
	dump(content, "babelTowerCtrl:reqTenRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local tenData = content.rspdata.tenData
		local tmpBlood = self.blood
		local tenResult.events, _ENV, tenResult.rewards, _ENV, _ENV, tenResult = 10, 10, 10, 10, "babelTowerCtrl:reqTenRsp(content)", "babelTowerCtrl:reqTenRsp(content)"
		tenResult.floorCount = 0
		tenResult.oldBlood = tmpBlood
		tenResult.floor = content.rspdata.floor
		tenResult.blood = content.rspdata.blood
		tenResult.finalFloor = tenResult.floor
		tenResult.isTen = true
		tenResult.changeBlood = 0
		tenResult.isWin = true
		tenResult.buffFloor = 0
		tenResult.buffIndex = content.data.index
		for k, v in pairs(content.rspdata.tenData) do
			if v.pass then
				tenResult.floorCount = tenResult.floorCount + 1
				for k2, v2 in pairs(v.reward) do
					table.insert(tenResult.rewards, v2)
				end
				for k2, v2 in pairs(v.boxReward) do
					table.insert(tenResult.rewards, v2)
				end
			else
				tenResult.isWin = false
			end
			if v.floor and tenResult.finalFloor < v.floor then
				tenResult.finalFloor = v.floor
			end
			if v.hasBuff then
				tenResult.buffFloor = v.floor
			end
			if not tenResult.events[v.eventIndex] then
				tenResult.events[v.eventIndex] = 0
			end
			tenResult.events[v.eventIndex] = tenResult.events[v.eventIndex] + 1
			if v.changeBlood and 0 > v.changeBlood then
				tenResult.changeBlood = tenResult.changeBlood - v.changeBlood
			end
		end
		self.floor = content.rspdata.floor
		self.state = content.rspdata.state
		self.blood = content.rspdata.blood
		self.bloodMax = content.rspdata.bloodMax
		self.chooseDoor = content.rspdata.door
		self.firstClimb = not content.rspdata.exp
		self:addBuffList(content.rspdata.allBuff)
		_ENV = self
		self.msg = "MESSAGE_BABEL_TOWER_REFRESH"
		self.tenResult = tenResult
		self.subMsg = "ten"
		SoraDSendMessage(self)
	end
end
function babelTowerCtrl:addBuffList(allBuff)
	self.lastingBuff, _ENV, self.allBuff, _ENV = nil, nil, nil, nil
	for key, info in pairs(allBuff) do
		local beginFloor = tonumber(string.split(key, "_")[1])
		local isValid = false
		if info.type == 5 or info.type == 3 then
			local finishFloor = beginFloor + info.type
			if finishFloor >= self.floor then
				isValid = true
				_ENV = nil
				;(nil).buffType = info.type
				;(nil).buffValue = info.value
				;(nil).buffTime = info.times
				;(nil).floor = beginFloor
				table.insert(self.lastingBuff, nil)
			end
		end
		_ENV = self.lastingBuff
		self.lastingBuff.buffType = info.type
		self.lastingBuff.buffValue = info.value
		self.lastingBuff.isValid = isValid
		self.lastingBuff.floor = beginFloor
		table.insert(self.allBuff, self.lastingBuff)
	end
	dump(self.allBuff, "addBuffListvalue", 10)
	table.sort(self.allBuff, function(l, r)
		if l.isValid == r.isValid then
			return l.floor < r.floor
		else
			return l.isValid
		end
	end)
end
function babelTowerCtrl:getAllBuff()
	if not self.allBuff then
		_UPVALUE0_ = self.allBuff
	end
	return self.allBuff
end
function babelTowerCtrl:getFloor()
	return self.floor or 0
end
function babelTowerCtrl:getBlood()
	return self.blood or 0
end
function babelTowerCtrl:getBloodMax()
	return self.bloodMax or 0
end
function babelTowerCtrl:getRewardMultiple()
	local baseMultiple = 0
	for i, v in ipairs(self.lastingBuff) do
		if self.floor > v.floor and self.floor <= v.floor + v.buffType then
			baseMultiple = baseMultiple + v.buffValue
		end
	end
	print(self.floor, baseMultiple)
	return baseMultiple == 0 and 1 or baseMultiple
end
function babelTowerCtrl:isFirstClimb()
	return self.firstClimb
end
function babelTowerCtrl:setIsSkipInfo(isSkip)
	self.isSkipInfo = isSkip
end
function babelTowerCtrl:getIsSkipInfo()
	return self.isSkipInfo
end
return babelTowerCtrl

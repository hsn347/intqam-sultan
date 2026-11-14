local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local autokillCtrl = class("autokillCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
function autokillCtrl:isAutoKillStart()
	if self.setData then
		return self.setData.autoState
	end
	return false
end
function autokillCtrl:getAutoKillQueueList()
	if self.setData and self.setData.queueIdList then
		return self.setData.queueIdList
	else
		_UPVALUE0_ = self.setData.queueIdList
		return self.setData.queueIdList
	end
end
function autokillCtrl:isAutoKillQueue(queueId)
	if self.setData and self.setData.queueIdList then
		return self.setData.queueIdList[queueId]
	end
end
function autokillCtrl:getAutoKillQueueCount()
	if self.setData then
		return table.nums(self:getAutoKillQueueList())
	else
		return 0
	end
end
function autokillCtrl:getMonsterMaxLv()
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
	local towerLv = nebulaActivityCtrl:getTowerLv()
	if 1 <= towerLv and self.monsterMaxLv >= gMaxNpcLevel then
		self.monsterMaxLv = math.max(self.monsterMaxLv, nebulaTowerLvDesRead.getMonsterMaxLv(towerLv))
	end
	return self.monsterMaxLv
end
function autokillCtrl:isAutoKillQueueId(troopInstance)
	if self:isAutoKillQueue(troopInstance:getMoveLineID()) or self:isAutoKillQueue(troopInstance:getOrgId()) then
		return true
	end
	return false
end
function autokillCtrl:getSetData()
	if not self.setData or not next(self.setData) then
		_ENV = next(self.setData)
		next(self.setData).autoState = false
		next(self.setData).minLevel = 0
		next(self.setData).maxLevel = 0
		next(self.setData).autoUseItem = false
		next(self.setData).compileIndex = 0
		next(self.setData).userQueueNum = 0
		next(self.setData).queueId = nil
		next(self.setData).queueIdList, _ENV, next(self.setData).usedItemList, _ENV, next(self.setData).itemList, _ENV, next(self.setData).attackMaxLev = self.setData, self.setData, self.setData, self.setData, self.setData, self.setData, false
		self.setData, next(self.setData).mapType = next(self.setData), nil
	end
	return self.setData
end
function autokillCtrl:setSetDataByMsg(msg)
	if not msg.data then
		_ENV = msg.data
	end
	self.setData = msg.data
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_AUTO_KILL_QUEUEID"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_AUTO_KILL_INIT_DATA"
	SoraDSendMessage(nil)
end
function autokillCtrl:setSetData(rspdata)
	if rspdata and rspdata.initData then
		if not rspdata.initData then
			_ENV = rspdata.initData
		end
		self.setData = rspdata.initData
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_AUTO_KILL_INIT_DATA"
		SoraDSendMessage(nil)
	end
end
function autokillCtrl:reqAutokillStop()
	print("autokillCtrl:reqAutokillStop")
	serverproxy:Request(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_STOP)
end
function autokillCtrl:reqAutokillInit()
	print("autokillCtrl:reqAutokillInit")
	serverproxy:Request(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_INIT)
end
function autokillCtrl:reqAutokillStart(data)
	dump(data, "autokillCtrl:reqAutokillStart", 10)
	serverproxy:Request(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_START, data)
end
function autokillCtrl:reqAutokillMaxMonsterLv()
	print("autokillCtrl:reqAutokillMaxMonsterLv")
	local data
	serverproxy:Request(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_MAX_MONSTER_LEV, data)
end
function autokillCtrl:ctor(properties)
	autokillCtrl.super.ctor(self, properties)
end
function autokillCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_STOP, handler(self, self.autokillStopRSP))
	msgCtrl.register(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_INIT, handler(self, self.autokillInitRSP))
	msgCtrl.register(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_START, handler(self, self.autokillStartRSP))
	msgCtrl.register(gCmd.CMD_AUTO_KILL_MONSTER_MODULE, gCmd.REQ_AUTOKILL_MAX_MONSTER_LEV, handler(self, self.reqMaxNpcLevRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.AUTO_ATTACK_MONSTER, handler(self, self.onMsg))
	self:resetData()
	self:reqAutokillMaxMonsterLv()
end
function autokillCtrl:resetData()
	self.setData, _UPVALUE0_ = nil, nil
	self.monsterMaxLv = 1
end
function autokillCtrl:Logout()
	autokillCtrl.super.Logout(self)
	self:resetData()
end
function autokillCtrl:initClientData(data)

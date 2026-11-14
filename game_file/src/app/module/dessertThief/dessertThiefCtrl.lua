local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local dessertThiefCtrl = class("dessertThiefCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
function dessertThiefCtrl:ctor(properties)
	dessertThiefCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY
	self:resetData()
end
function dessertThiefCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SWEET_MEAT_ROBBER_MODULE, gCmd.REQ_SWEET_MEAT_ROBBER_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_SWEET_MEAT_ROBBER_MODULE, gCmd.REQ_SWEET_MEAT_ROBBER_SUMMON, handler(self, self.reqSweetMeatSummonRsp))
	self:sendInitMsg()
end
function dessertThiefCtrl:initClientData(data)
	self.msgData = data
end
function dessertThiefCtrl:Logout()
	dessertThiefCtrl.super.Logout(self)
	self:resetData()
end
function dessertThiefCtrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function dessertThiefCtrl:sendInitMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_SWEET_MEAT_ROBBER_MODULE, gCmd.REQ_SWEET_MEAT_ROBBER_INIT, nil)
	end
end
function dessertThiefCtrl:reqSweetMeatSumon()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SWEET_MEAT_ROBBER_MODULE, gCmd.REQ_SWEET_MEAT_ROBBER_SUMMON, nil)
end
function dessertThiefCtrl:reqInitRsp(content)
	dump(content, "dessertThiefCtrl:reqInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_DESSERT_THIEF_UPDATE"
		SoraDSendMessage(self)
	end
end
function dessertThiefCtrl:reqSweetMeatSummonRsp(content)
	dump(content, "dessertThiefCtrl:reqSweetMeatSummonRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		SoraDGotoWorldMapPoint(cc.p(self:getBossPosition()), true)
		_ENV = cc.p(self:getBossPosition())
		cc.p(self:getBossPosition()).msg = "MESSAGE_DESSERT_THIEF_UPDATE"
		SoraDSendMessage((cc.p(self:getBossPosition())))
		SoraDRemoveAllPanelFromManager()
	end
end
function dessertThiefCtrl:getReceiveStatusAndNum()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queueRoot = kingdomMapCtrl:getQueueRootByWar()
	local allianceWarListData = queueRoot:getAllWarHallQueue()
	if allianceWarListData and next(allianceWarListData) ~= nil then
		local isInQueue = false
		for key, v in pairs(allianceWarListData) do
			if v.newClassType == gAllianceQueueClassType.pve then
				for k2, v2 in pairs(v.queues) do
					_UPVALUE2_ = nil
					;(nil)[1] = v2.to.bossType
					;(nil)[2] = gBossType.sweetMeatRobber
					dump(nil, "to.bossType == gBossType.sweetMeatRobber")
					if v2.to.bossType == gBossType.sweetMeatRobber then
						return true, -1
					end
				end
			end
		end
	end
	return false, 0
end
function dessertThiefCtrl:getBossLv()
	return self.msgData.bossLv
end
function dessertThiefCtrl:getBossPosition()
	return self.msgData.bossX, self.msgData.bossY
end
function dessertThiefCtrl:getBossData()
	return self.msgData.mapObjData
end
return dessertThiefCtrl

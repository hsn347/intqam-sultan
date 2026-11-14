local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local kingOfGloryCtrl = class("kingOfGloryCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local kingOfGloryRead = include("kingOfGloryRead")
_ENV = "kingOfGloryRead"
;("kingOfGloryRead").UNLOCKED = 0
;("kingOfGloryRead").LOCKED = 1
local ("kingOfGloryRead").RECEVIED, RECEVIE_TYPE = 2, "kingOfGloryRead"
function kingOfGloryCtrl:ctor(properties)
	kingOfGloryCtrl.super.ctor(self, properties)
	self:resetData()
end
function kingOfGloryCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KING_OF_GLORY_MODULE, gCmd.REQ_KING_OF_GLORY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_KING_OF_GLORY_MODULE, gCmd.REQ_KING_OF_GLORY_AWARD, handler(self, self.reqGetRewardRsp))
end
function kingOfGloryCtrl:Logout()
	kingOfGloryCtrl.super.Logout(self)
	self:resetData()
end
function kingOfGloryCtrl:resetData()
	self.mainData = nil
end
function kingOfGloryCtrl:initClientData(data)
	dump(data, "==kingOfGloryCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.mainData = data
end
function kingOfGloryCtrl:reqInit(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KING_OF_GLORY_MODULE, gCmd.REQ_KING_OF_GLORY_INIT, nil, ...)
end
function kingOfGloryCtrl:reqGetReward(index, ...)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_KING_OF_GLORY_MODULE, gCmd.REQ_KING_OF_GLORY_AWARD, nil, ...)
end
function kingOfGloryCtrl:reqInitRsp(content)
	dump(content, "kingOfGloryCtrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.kingOfGloryData)
		_ENV = self
		self.msg = "MESSAGE_KING_OF_GLORY_INIT"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY
		SoraDSendMessage(self)
	end
end
function kingOfGloryCtrl:reqGetRewardRsp(content)
	dump(content, "kingOfGloryCtrl:reqGetRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.kingOfGloryData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_KING_OF_GLORY_GET_REWARD"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = gActivityTimeActivityID.KING_OF_GLORY_ACTIVITY
		SoraDSendMessage(content.rspdata.reward)
	end
end
function kingOfGloryCtrl:getReceiveStatusAndNum()
	local cfgs, canReciveCount = self:getCfgList()
	if 0 < canReciveCount then
		return true, canReciveCount
	end
	return false, 0
end
function kingOfGloryCtrl:isRecevied(index)
	if self.mainData and self.mainData.receiveRecord and self.mainData.receiveRecord[tostring(index)] then
		return true
	end
	return false
end
function kingOfGloryCtrl:getCfgList()
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local tablePlayerInfo = lordInfoCtrl:getLordInfo()
	local nowPower = tablePlayerInfo.fcInfo.totalFc
	local cfgs = kingOfGloryRead.getCfgs()
	local canReciveCount = 0
	for k, v in pairs(cfgs) do
		local isRecevied = self:isRecevied(v.index)
		if isRecevied then
			v.recevie_type = RECEVIE_TYPE.RECEVIED
		elseif nowPower >= v.power then
			v.recevie_type = RECEVIE_TYPE.UNLOCKED
			canReciveCount = canReciveCount + 1
		else
			v.recevie_type = RECEVIE_TYPE.LOCKED
		end
	end
	table.sort(cfgs, function(left, right)
		if left.recevie_type == right.recevie_type then
			return left.index < right.index
		end
		return left.recevie_type < right.recevie_type
	end)
	return cfgs, canReciveCount
end
return kingOfGloryCtrl

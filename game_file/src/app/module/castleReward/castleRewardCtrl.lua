local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local castleRewardCtrl = class("castleRewardCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local castleRewardRead = include("castleRewardRead")
function castleRewardCtrl:ctor(properties)
	castleRewardCtrl.super.ctor(self, properties)
	self.giftID = 14309
	self:resetData()
end
function castleRewardCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CASTLE_REWARD_MODULE, gCmd.REQ_CASTLE_REWARD_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_CASTLE_REWARD_MODULE, gCmd.REQ_CASTLE_REWARD_RECEIVE, handler(self, self.reqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_CASTLE_REWARD_MODULE, gCmd.REQ_CASTLE_REWARD_RECEIVE_ALL, handler(self, self.reqGetAllRewardRsp))
	self:registerNotify()
end
function castleRewardCtrl:Logout()
	castleRewardCtrl.super.Logout(self)
	self:resetData()
end
function castleRewardCtrl:resetData()
	self.castleData = nil
end
function castleRewardCtrl:initClientData(data)
	dump(data, "==castleRewardCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.castleData = data
end
function castleRewardCtrl:reqInit(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CASTLE_REWARD_MODULE, gCmd.REQ_CASTLE_REWARD_INIT, nil, ...)
end
function castleRewardCtrl:reqGetReward(type, castlelv, ...)
	serverproxy = nil
	;(nil).type = type
	;(nil).castlelv = castlelv
	serverproxy:Request(gCmd.CMD_CASTLE_REWARD_MODULE, gCmd.REQ_CASTLE_REWARD_RECEIVE, nil, ...)
end
function castleRewardCtrl:reqGetAllReward(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_CASTLE_REWARD_MODULE, gCmd.REQ_CASTLE_REWARD_RECEIVE_ALL, nil, ...)
end
function castleRewardCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CASTLE_REWARD_ACTIVITY, handler(self, self.notifyHandler))
end
function castleRewardCtrl:notifyHandler(event)
	for _, content in pairs(event.data) do
		if content.castleRewardData then
			self:initClientData(content.castleRewardData)
			_ENV = self
			self.msg = "MESSAGE_CASTLE_REWARD_INIT"
			SoraDSendMessage(self)
			_ENV = self
			self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self.eventID = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY
			SoraDSendMessage(self)
		end
	end
end
function castleRewardCtrl:reqInitRsp(content)
	dump(content, "castleRewardCtrl:reqInitRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.castleRewardData)
		_ENV = self
		self.msg = "MESSAGE_CASTLE_REWARD_INIT"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY
		SoraDSendMessage(self)
	end
end
function castleRewardCtrl:reqGetRewardRsp(content)
	dump(content, "castleRewardCtrl:reqGetRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.castleRewardData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_CASTLE_REWARD_GET_REWARD"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY
		SoraDSendMessage(content.rspdata.reward)
	end
end
function castleRewardCtrl:reqGetAllRewardRsp(content)
	dump(content, "castleRewardCtrl:reqGetRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.castleRewardData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_CASTLE_REWARD_GET_ALL_REWARD"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = gActivityTimeActivityID.CASTLE_REWARD_ACTIVITY
		SoraDSendMessage(content.rspdata.reward)
	end
end
function castleRewardCtrl:getReceiveStatusAndNum()
	local curlv = SoraDGetCastleLv()
	local cfgs = self:getCfgList()
	local count = 0
	local isBuy = self:getIsBuy()
	for i, v in ipairs(cfgs) do
		local isGot = self:isRecevied(1, v.castlelv)
		if curlv >= v.castlelv and not isGot then
			count = count + 1
		end
		isGot = self:isRecevied(2, v.castlelv)
		if curlv >= v.castlelv and not isGot and isBuy then
			count = count + 1
		end
	end
	return 0 < count, count
end
function castleRewardCtrl:isRecevied(rType, castleLv)
	if self.castleData and self.castleData.receiveRecord and self.castleData.receiveRecord[rType .. "_" .. castleLv] then
		return true
	end
	return false
end
function castleRewardCtrl:getIsBuy()
	return self.castleData and self.castleData.buytime ~= nil and self.castleData.buytime > 0
end
function castleRewardCtrl:getCfgList()
	return castleRewardRead.getCfgs()
end
function castleRewardCtrl:getCurIndex(curLv)
	local cfgs = self:getCfgList()
	local curCfg
	local index = 0
	local nextCfg = cfgs[1]
	for i, v in ipairs(cfgs) do
		if curLv > v.castlelv then
			curCfg = v
			nextCfg = cfgs[i + 1]
			index = i
		end
	end
	return index, curCfg, nextCfg
end
function castleRewardCtrl:getGiftData()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local giftData = rechargeActivityCtrl:getRechargeActivityData(self.giftID)
	return giftData
end
return castleRewardCtrl

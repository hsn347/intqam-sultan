local GameModule = include("GameModule")
local petCarnivalCtrl = class("petCarnivalCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local petCarnivalRead = include("petCarnivalRead")
_ENV = "petCarnivalRead"
;("petCarnivalRead").noClaim = 1
;("petCarnivalRead").noReach = 2
local ("petCarnivalRead").claimed, giftStatus = 3, "petCarnivalRead"
function petCarnivalCtrl:ctor(properties)
	petCarnivalCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGICAL_DOMINO
	self:resetData()
end
function petCarnivalCtrl:Logout()
	petCarnivalCtrl.super.Logout(self)
end
function petCarnivalCtrl:resetData()
	self.stageReward, _UPVALUE0_, self.recordData, _UPVALUE0_, self.allData, _UPVALUE0_, self.totalPoint = nil, nil, nil, nil, nil, nil, 0
	self.double = false
end
function petCarnivalCtrl:initClientData(data)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:reqInitData()
	end
end
function petCarnivalCtrl:getReceiveStatusAndNum(activityID)
	if activityID == gActivityTimeActivityID.MAGICAL_DOMINO then
		local bAward = false
		local num = 0
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MAGICAL_DOMINO) then
			for k, v in pairs(self.stageReward) do
				if v == 1 then
					num = num + 1
					bAward = true
				end
			end
		end
		return bAward, num
	end
	return false, 0
end
function petCarnivalCtrl:EnterGame()
	print("petCarnivalCtrl进入游戏")
	msgCtrl.register(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_INIT, handler(self, self.getInitData))
	msgCtrl.register(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_OPENCARD, handler(self, self.getOpenCard))
	msgCtrl.register(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_OPENCARD_BATCH, handler(self, self.getOpenTenCard))
	msgCtrl.register(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_STAGE_REWARD, handler(self, self.getClaimReward))
end
function petCarnivalCtrl:getTotalPoint()
	return self.totalPoint
end
function petCarnivalCtrl:getAllData()
	return self.allData
end
function petCarnivalCtrl:getIsDouble()
	return self.isDouble
end
function petCarnivalCtrl:setRecoedData(card, reward)
	self.recordData, _ENV = nil, nil
	for k, v in ipairs(card) do
		local _ENV, data
		data.cardRecord = v
		if reward[k] then
			data.rewardRecord = reward[k]
		end
		table.insert(self.recordData, data)
	end
end
function petCarnivalCtrl:getRecord()
	return self.recordData
end
function petCarnivalCtrl:getStageRewardStauts(index)
	local idx = tostring(index)
	if self.stageReward[idx] == 1 then
		return giftStatus.noClaim
	elseif self.stageReward[idx] == 2 then
		return giftStatus.claimed
	else
		return giftStatus.noReach
	end
end
function petCarnivalCtrl:reqInitData()
	print("petCarnivalCtrl请求")
	serverproxy:Request(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_INIT)
end
function petCarnivalCtrl:reqOpenCard()
	print("petCarnivalCtrl请求开牌")
	serverproxy:Request(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_OPENCARD)
end
function petCarnivalCtrl:reqOpenTenCard()
	serverproxy:Request(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_OPENCARD_BATCH)
end
function petCarnivalCtrl:reqClaimReward(id)
	print("请求领取奖励" .. id)
	_ENV = print
	local print.index, data = id, print
	serverproxy:Request(gCmd.CMD_MAGICAL_DOMINO_MODULE, gCmd.REQ_MAGICAL_DOMINO_STAGE_REWARD, data)
end
function petCarnivalCtrl:registerNotify()
	print("注册服务器主动通知registerNotify")
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_KING_RECHARGE, handler(self, self.notifyHandler))
end
function petCarnivalCtrl:notifyHandler(event)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(nil).eventID = self.activityID
	SoraDSendMessage(nil)
end
function petCarnivalCtrl:getInitData(content)
	print(content.err)
	if content.err == gErrDef.Err_None then
		self.allData = content.rspdata
		self.totalPoint = content.rspdata.score
		self:setRecoedData(content.rspdata.cardRecord, content.rspdata.rewardRecord)
		self.stageReward = content.rspdata.reward
		self.double = content.rspdata.double
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_PETCARNIVAL_INIT"
		SoraDSendMessage(self)
	elseif content.err == gErrDef.Err_NEW_RECHARGE_NOT_OPEN then
		_ENV = gErrDef.Err_NEW_RECHARGE_NOT_OPEN
		gErrDef.Err_NEW_RECHARGE_NOT_OPEN.msg = "MESSAGE_PETCARNIVAL_ERR"
		SoraDSendMessage(gErrDef.Err_NEW_RECHARGE_NOT_OPEN)
	end
end
function petCarnivalCtrl:getOpenCard(content)
	print(content.err)
	if content.err == gErrDef.Err_None then
		self.totalPoint = content.rspdata.score
		self.stageReward = content.rspdata.stageReward
		self.double = content.rspdata.nextDouble
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_PETCARNIVAL_OPENCARD"
		gErrDef.Err_None.reward = content.rspdata.reward
		gErrDef.Err_None.card = content.rspdata.card
		gErrDef.Err_None.type = content.rspdata.type
		gErrDef.Err_None.double = self.double
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_PETCARNIVAL_INIT"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_PETCARNIVAL_ERR"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function petCarnivalCtrl:getOpenTenCard(content)
	dump(content, "萌宠大狂欢开牌10")
	if content.err == gErrDef.Err_None then
		self.totalPoint = content.rspdata.score
		self.stageReward = content.rspdata.stageReward
		self.double = content.rspdata.nextDouble
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_PETCARNIVAL_OPENCARD_BATCH"
		gErrDef.Err_None.list = self:setTenData(content.rspdata.cards)
		gErrDef.Err_None.double = self.double
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_PETCARNIVAL_INIT"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_PETCARNIVAL_ERR"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function petCarnivalCtrl:setTenData(card)
	for k, v in ipairs(card) do
		v.index = k
	end
	return card
end
function petCarnivalCtrl:getClaimReward(data)
	print(data.err)
	if data.err == gErrDef.Err_None then
		self:reqInitData()
		local rewarddata = data.rspdata.reward
		_ENV = nil
		;(nil).msg = "MESSAGE_PETCARNIVAL_CLAIM_REWARD"
		;(nil).reward = rewarddata
		SoraDSendMessage(nil)
	end
end
return petCarnivalCtrl

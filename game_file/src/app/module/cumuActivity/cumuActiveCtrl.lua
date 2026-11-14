local GameModule = include("GameModule")
local cumuActiveCtrl = class("cumuActiveCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local rechargeltCtrl = include("rechargeltCtrl")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").noReach = 1
;("msgCtrl").noClaim = 2
local ("msgCtrl").claimed, giftStatus = 3, "msgCtrl"
function cumuActiveCtrl:ctor(properties)
	cumuActiveCtrl.super.ctor(self, properties)
end
function cumuActiveCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_CUMU_ACTIVE_MODULE, gCmd.REQ_RECEIVE_CRAZY_TRIO_REWARD, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_CUMU_ACTIVE_MODULE, gCmd.REQ_RECEIVE_CRAZY_SEPTET_REWARD, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_CUMU_ACTIVE_MODULE, gCmd.REQ_RECEIVE_NEW_CRAZY_SEPTET_REWARD, handler(self, self.reqReceiveRsp))
	self:resetData()
end
function cumuActiveCtrl:resetData()
	self.handle_notify = nil
	self.crazyTrioDataState, _UPVALUE0_, self.newrechargeGoldData, _UPVALUE0_, self.rechargeGoldData, _UPVALUE0_, self.crazyTrioData, _UPVALUE0_, self.cumuData, _UPVALUE0_, self.handle_notify_crazy_trio = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function cumuActiveCtrl:Logout()
	self:resetData()
	cumuActiveCtrl.super.Logout(self)
end
function cumuActiveCtrl:initClientData(data)
	dump(data, "cumuActiveCtrl:initClientData")
	if not data then
		return
	end
	self:registerNotify()
	self:initCumuData(data)
	_ENV = self
	self.msg = "MESSAGE_CUMUACTIVITY_REFRESH"
	SoraDSendMessage(self)
end
function cumuActiveCtrl:initCumuData(data)
	if type(data) == "table" then
		if data.cumuData then
			self.cumuData = data.cumuData
		end
		if data.rechargeGoldData then
			self.rechargeGoldData = data.rechargeGoldData
		end
		if data.crazyTrioData and data.crazyTrioData.beginTime then
			self.crazyTrioData = data.crazyTrioData
			self.activityID = gActivityTimeActivityID.CRAZY_TRIO_ACTIVITY
		end
		if data.crazySeptetData and data.crazySeptetData.beginTime then
			self.crazyTrioData = data.crazySeptetData
			self.activityID = gActivityTimeActivityID.CRAZY_SEPTET_ACTIVITY
		end
		if data.newCrazySeptetData and data.newCrazySeptetData.beginTime then
			self.crazyTrioData = data.newCrazySeptetData
			self.activityID = gActivityTimeActivityID.NEW_CRAZY_SEPTET_ACTIVITY
		end
		if self.activityID then
			rechargeltCtrl.initCrazyActivity(self.activityID)
			self.trioData = rechargeltCtrl.getRechargeTotalConfig()
		end
		if data.newRechargeGoldData then
			self.newrechargeGoldData = data.newRechargeGoldData
		end
	end
end
function cumuActiveCtrl:setCrazyTrioState()
	local totalDollor = self.crazyTrioData.totalDollor
	for k, v in ipairs(self.trioData) do
		if self.crazyTrioData.receive[tostring(k)] then
			self.crazyTrioDataState[k] = giftStatus.claimed
		elseif totalDollor < v.price then
			self.crazyTrioDataState[k] = giftStatus.noReach
		else
			self.crazyTrioDataState[k] = giftStatus.noClaim
		end
	end
end
function cumuActiveCtrl:getInitialReceiveState()
	self:setCrazyTrioState()
	local redNum = 0
	for k, v in ipairs(self.crazyTrioDataState) do
		if v == giftStatus.noClaim then
			redNum = redNum + 1
		end
	end
	return 0 < redNum, redNum
end
function cumuActiveCtrl:isAllCrazyTrioClaimed()
	local ret = true
	for k, v in ipairs(self.crazyTrioDataState) do
		if v ~= giftStatus.claimed then
			ret = false
			break
		end
	end
	return ret
end
function cumuActiveCtrl:getCrazyTrioDataStateByIndex(index)
	return self.crazyTrioDataState[index]
end
function cumuActiveCtrl:sendReqClaim(receiveIndex)
	serverproxy = nil
	;(nil).receiveIndex = receiveIndex
	serverproxy:Request(gCmd.CMD_CUMU_ACTIVE_MODULE, gCmd.REQ_RECEIVE_CRAZY_TRIO_REWARD, nil)
end
function cumuActiveCtrl:sendReqClaimNew(receiveIndex)
	serverproxy = nil
	;(nil).receiveIndex = receiveIndex
	serverproxy:Request(gCmd.CMD_CUMU_ACTIVE_MODULE, gCmd.REQ_RECEIVE_CRAZY_SEPTET_REWARD, nil)
end
function cumuActiveCtrl:sendReqClaimSevenNew(receiveIndex)
	serverproxy = nil
	;(nil).receiveIndex = receiveIndex
	serverproxy:Request(gCmd.CMD_CUMU_ACTIVE_MODULE, gCmd.REQ_RECEIVE_NEW_CRAZY_SEPTET_REWARD, nil)
end
function cumuActiveCtrl:reqReceiveRsp(ret)
	dump(ret, "cumuActiveCtrl:reqReceiveRsp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		if ret.rspdata.crazyTrioData then
			self.crazyTrioData = ret.rspdata.crazyTrioData
		elseif ret.rspdata.crazySeptetData then
			self.crazyTrioData = ret.rspdata.crazySeptetData
		elseif ret.rspdata.newCrazySeptetData then
			self.crazyTrioData = ret.rspdata.newCrazySeptetData
		end
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO"
		gErrDef.Err_None.reward = ret.rspdata.reward
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		gErrDef.Err_None.eventID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
		if table.nums(self.crazyTrioData.receive) == rechargeltCtrl.getRechargeTotalConfigNum() then
			_ENV = rechargeltCtrl.getRechargeTotalConfigNum()
			rechargeltCtrl.getRechargeTotalConfigNum().msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			rechargeltCtrl.getRechargeTotalConfigNum().activityID = self.activityID
			SoraDSendMessage((rechargeltCtrl.getRechargeTotalConfigNum()))
		end
	end
end
function cumuActiveCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CUMUACTIVE, handler(self, self.notifyCumuActive))
	self.handle_notify_crazy_trio = notifyCtrl:register(gNotifyID.CRAZY_TRIO, handler(self, self.notifyCrazyTrio))
end
function cumuActiveCtrl:notifyCumuActive(event)
	if event and event.data then
		dump(event.data, "cumuActiveCtrl:notifyCumuActive", 10)
		for _, content in pairs(event.data) do
			self:initCumuData(content)
			if true == content.isGetMail then
				local activityID = content.activityID
				local nType = gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE == activityID and gCumuActivityType.CUMURECHARGE or gCumuActivityType.CUMUCONSUM
				local total = self:getCumuAmount(activityID)
				_ENV = activityID
				activityID.msg = "MESSAGE_CUMUACTIVITY_REWARD"
				activityID.nType = nType
				activityID.total = total
				SoraDSendMessage(activityID)
			end
		end
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_CUMUACTIVITY_REFRESH"
		SoraDSendMessage(pairs(event.data))
	end
end
function cumuActiveCtrl:notifyCrazyTrio(event)
	dump(event, "cumuActiveCtrl:notifyCrazyTrio", 10)
	if event and event.data then
		for _, content in pairs(event.data) do
			self:initCumuData(content)
			_ENV = self
			self.msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO"
			SoraDSendMessage(self)
			_ENV = self
			_UPVALUE1_, self.msg = content, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			self.activityID, content[1] = content, gActivityTimeActivityID.CRAZY_TRIO_ACTIVITY
			SoraDSendMessage(self)
			if content.rechargeGoldData and next(content.rechargeGoldData) then
				_ENV = content.rechargeGoldData
				content.rechargeGoldData.msg = "MESSAGE_RECHARGE_GOLD_FOR_REWARD_REFRESH"
				SoraDSendMessage(content.rechargeGoldData)
			end
		end
	end
end
function cumuActiveCtrl:getCumuAmount(activityID)
	if activityID == gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE then
		return self.cumuData.recharegeAmount
	elseif activityID == gActivityTimeActivityID.CUMU_ACTIVITY_CONSUME then
		return self.cumuData.consumeAmount
	end
	return 0
end
function cumuActiveCtrl:getCumuScale(activityID)
	if activityID == gActivityTimeActivityID.CUMU_ACTIVITY_RECHARGE then
		return self.cumuData.recharegeScale
	elseif activityID == gActivityTimeActivityID.CUMU_ACTIVITY_CONSUME then
		return self.cumuData.consumeScale
	end
	return 0
end
function cumuActiveCtrl:getCrazyTrioData()
	return self.crazyTrioData
end
function cumuActiveCtrl:getActivityID()
	return self.activityID or gActivityTimeActivityID.NEW_CRAZY_SEPTET_ACTIVITY
end
function cumuActiveCtrl:getReceiveStatusAndNum()
	return self:getInitialReceiveState()
end
function cumuActiveCtrl:getRechargeGoldData(minlv, gold)
	local key = tostring(minlv) .. "_" .. tostring(gold)
	return self.rechargeGoldData[key] or 0
end
function cumuActiveCtrl:getnewRechargeGoldData(minlv, gold)
	local key = tostring(minlv) .. "_" .. tostring(gold)
	return self.newrechargeGoldData.receiveInfo[key] or 0
end
function cumuActiveCtrl:getnewRechargecastleLv()
	return self.newrechargeGoldData.castleLv or 0
end
function cumuActiveCtrl:getnewRechargecminCastleLv()
	return self.newrechargeGoldData.castleLv or 0
end
return cumuActiveCtrl

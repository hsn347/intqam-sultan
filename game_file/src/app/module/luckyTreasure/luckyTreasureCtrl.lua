local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local luckyTreasureCtrl = class("luckyTreasureCtrl", gamemodulec)
local luckyTreasureRead = include("luckyTreasureRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function luckyTreasureCtrl:ctor(properties)
	luckyTreasureCtrl.super.ctor(self, properties)
	self:resetData()
end
function luckyTreasureCtrl:Logout()
	luckyTreasureCtrl.super.Logout(self)
	self:resetData()
end
function luckyTreasureCtrl:resetData()
	self.turnIndex = 0
	self.curLuckValue = 0
	self.curRate = 0
	self.freeTurnFlag = false
	self.rechargDollor = 0
end
function luckyTreasureCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_TURNTABLE_ACTIVITY, gCmd.REQ_TURNTABLE_ACTIVITY_SINGLE, handler(self, self.reqSingleTurnRsp))
	msgCtrl.register(gCmd.CMD_TURNTABLE_ACTIVITY, gCmd.REQ_TURNTABLE_ACTIVITY_TEN, handler(self, self.reqTenTurnRsp))
end
function luckyTreasureCtrl:initClientData(retdata)
	if retdata then
		self.turnIndex = retdata.index
		self.curRate = retdata.curRate or 0
		self.curLuckValue = retdata.turnCount
		self.freeTurnFlag = retdata.freeTurnFlag
		self.rechargDollor = retdata.rechargDollor
		self:registerNotify()
	end
end
function luckyTreasureCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.TURNTABLE_ACTIVITY, handler(self, self.notifyUpdate))
end
function luckyTreasureCtrl:notifyUpdate(event)
	if event.data then
		for k, data in pairs(event.data) do
			self.turnIndex = data.index
			self.curRate = data.curRate or 0
			self.curLuckValue = data.turnCount
			self.freeTurnFlag = data.freeTurnFlag
			self.rechargDollor = data.rechargDollor
		end
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		pairs(event.data).eventID = gActivityTimeActivityID.TURNTABLE_ACTIVITY
		SoraDSendMessage(pairs(event.data))
		_ENV = pairs(event.data)
		pairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		pairs(event.data).eventID = gActivityTimeActivityID.TURNTABLE_ACTIVITY
		SoraDSendMessage(pairs(event.data))
	end
end
function luckyTreasureCtrl:getTurnId()
	return self.turnIndex
end
function luckyTreasureCtrl:getCurrentRewardItemList()
	return luckyTreasureRead.getRewardListByIndex(self.turnIndex)
end
function luckyTreasureCtrl:getCurTurnAwardList()
	return luckyTreasureRead.getRewardListByIndex(self.turnIndex)
end
function luckyTreasureCtrl:getCurrentCostItem()
	return luckyTreasureRead.getRewrarCostByIndex(self.turnIndex)
end
function luckyTreasureCtrl:getImportantRewardByIndex()
	return luckyTreasureRead.getImportantRewardByIndex(self.turnIndex)
end
function luckyTreasureCtrl:getImportanCurLuckValue()
	return self.curLuckValue
end
function luckyTreasureCtrl:getCurRate()
	return self.curRate
end
function luckyTreasureCtrl:getIsFreeFlag()
	return self.freeTurnFlag
end
function luckyTreasureCtrl:getCurrentTurnBanner()
	return luckyTreasureRead.getCurrentTurnBanner(self.turnIndex)
end
function luckyTreasureCtrl:getReceiveStatusAndNum()
	local num = 0
	if self.freeTurnFlag then
		num = 1
	end
	return self.freeTurnFlag, num
end
function luckyTreasureCtrl:checkShowActivity(...)
	local constantRead = include("constantRead")
	if self.rechargDollor and self.rechargDollor >= constantRead.getConstValue("TURNTABLE_MIN_DOLLOR_LIMIT") then
		return true
	end
end
function luckyTreasureCtrl:sendReqSingleTurn()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TURNTABLE_ACTIVITY, gCmd.REQ_TURNTABLE_ACTIVITY_SINGLE, nil)
end
function luckyTreasureCtrl:sendReqTenTurn()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_TURNTABLE_ACTIVITY, gCmd.REQ_TURNTABLE_ACTIVITY_TEN, nil)
end
function luckyTreasureCtrl:reqSingleTurnRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data
		self.curLuckValue = data.turnCount
		self.freeTurnFlag = data.freeTurnFlag
		local reward = data.result
		self.curRate = data.curRate or 0
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_TURNTABLE_GET_REWARD_INFO"
		;(nil).reward = reward
		;(nil).isSingle = true
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = gActivityTimeActivityID.TURNTABLE_ACTIVITY
		SoraDSendMessage(nil)
	elseif content.err == gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES then
		_ENV = gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES
		gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES.msg = "MESSAGE_SERVER_TURNTABLE_GET_REWARD_INFO"
		SoraDSendMessage(gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES)
		SoraDShowMsgTip(i18n("Lucky_treasure_text_10"))
	end
	SoraDCloseLoading()
end
function luckyTreasureCtrl:reqTenTurnRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data
		self.curLuckValue = data.turnCount
		local reward = data.result
		self.curRate = data.curRate or 0
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_TURNTABLE_GET_REWARD_INFO"
		;(nil).reward = reward
		;(nil).isSingle = false
		SoraDSendMessage(nil)
	elseif content.err == gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES then
		_ENV = gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES
		gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES.msg = "MESSAGE_SERVER_TURNTABLE_GET_REWARD_INFO"
		SoraDSendMessage(gErrDef.Err_TURNTABLE_MAX_LOTTERY_TIMES)
		SoraDShowMsgTip(i18n("Lucky_treasure_text_10"))
	end
end
return luckyTreasureCtrl

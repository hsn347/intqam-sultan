local newExchangeMallRead = include("newExchangeMallRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local newExchangeMallCtrl = class("newExchangeMallCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function newExchangeMallCtrl:ctor(properties)
	newExchangeMallCtrl.super.ctor(self, properties)
	self:resetData()
end
function newExchangeMallCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_NEW_EXCHANGE_GOOD, handler(self, self.reqNewExchangeGoodRsp))
	msgCtrl.register(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_NEW_EXCHANGE_REMIND, handler(self, self.reqNewExchangeRemindRsp))
	msgCtrl.register(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_NEW_EXCHANGE_INIT, handler(self, self.reqNewExchangeInitRsp))
	self:registerNotify()
end
function newExchangeMallCtrl:Logout()
	newExchangeMallCtrl.super.Logout(self)
	self:resetData()
end
function newExchangeMallCtrl:resetData()
	self.remindArray, _UPVALUE0_, self.countArray, _UPVALUE0_ = nil, nil, nil, nil
end
function newExchangeMallCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_EXCHANGE_MALL, handler(self, self.notifyHandler))
end
function newExchangeMallCtrl:notifyHandler(event)
	dump(event.data, "newExchangeMallCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.countArray = v.countArray
		self.remindArray = v.remindArray
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH"
		;(nil).notify = true
		SoraDSendMessage(nil)
	end
end
function newExchangeMallCtrl:reqNewExchangeGood(storeID, buyCount)
	serverproxy = nil
	;(nil).storeID = storeID
	;(nil).buyCount = buyCount
	serverproxy:Request(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_NEW_EXCHANGE_GOOD, nil)
end
function newExchangeMallCtrl:reqNewExchangeRemind(storeID, remindStatus)
	serverproxy = nil
	;(nil).storeID = storeID
	;(nil).remindStatus = remindStatus
	serverproxy:Request(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_NEW_EXCHANGE_REMIND, nil)
end
function newExchangeMallCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_EXCHANGEMALL_MODULE, gCmd.REQ_NEW_EXCHANGE_INIT, nil)
end
function newExchangeMallCtrl:reqNewExchangeGoodRsp(content)
	dump(content, "newExchangeMallCtrl:reqNewExchangeGoodRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.reward, true)
		self.countArray = content.rspdata.newExchangeMallData.countArray
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EXCHANGEMALL_EX_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENTCENTER_EXCHANGE_REFRESH"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING"
		SoraDSendMessage(content.rspdata.reward)
	end
end
function newExchangeMallCtrl:reqNewExchangeRemindRsp(content)
	dump(content, "newExchangeMallCtrl:reqNewExchangeRemindRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.remindArray = content.rspdata.newExchangeMallData.remindArray
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EXCHANGEMALL_SET_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function newExchangeMallCtrl:reqNewExchangeInitRsp(content)
	dump(content, "newExchangeMallCtrl:reqNewExchangeInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.countArray = content.rspdata.newExchangeMallData.countArray
		self.remindArray = content.rspdata.newExchangeMallData.remindArray
	end
end
function newExchangeMallCtrl:getCurExchangeNum(storeID)
	return self.countArray[tostring(storeID)] or 0
end
function newExchangeMallCtrl:getRemindStatus(storeID)
	return self.remindArray[tostring(storeID)] and 0 or 1
end
function newExchangeMallCtrl:getConfigByActivityID(activityID, classtype)
	local cfg = SoraDGetCtrl("exchangeMallCtrl"):getConfigByActivityID(activityID)
	if not cfg then
		cfg, _ENV = newExchangeMallRead.getConfigByActivityID(activityID, classtype), newExchangeMallRead.getConfigByActivityID(activityID, classtype)
		cfg = newExchangeMallRead.getConfigByActivityID(activityID, classtype) or SoraDGetCtrl("exchangeMallCtrl"):getConfigByActivityID(activityID)
		dump(cfg, "newExchangeMallCtrl:getConfigByActivityID", 10)
		for i, v in ipairs(cfg) do
			v.remindStatus = self:getRemindStatus(v.storeID)
			v.curExchangeNum = self:getCurExchangeNum(v.storeID)
		end
	end
	return cfg
end
function newExchangeMallCtrl:getCostIDByActivityID(activityID)
	local costIDArray = SoraDGetCtrl("exchangeMallCtrl"):getCostIDByActivityID(activityID)
	if not costIDArray then
		costIDArray, _ENV = SoraDGetCtrl("exchangeMallCtrl"), SoraDGetCtrl("exchangeMallCtrl")
		if not newExchangeMallRead.getCostIDByActivityID(activityID) then
			_ENV = newExchangeMallRead.getCostIDByActivityID(activityID)
		end
		for costId, _ in pairs((newExchangeMallRead.getCostIDByActivityID(activityID))) do
			table.insert(costIDArray, costId)
		end
	end
	if #costIDArray == 0 then
		costIDArray = include("activityExchangeMallRead"):getCostIDByActivityID(activityID)
	end
	return costIDArray
end
function newExchangeMallCtrl:getReceiveStatusAndNum(activityID)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	activityID = activityID or gActivityTimeActivityID.EXCHANGE_MALL
	local tmp = exchangeMallActivityID
	if activityID ~= gActivityTimeActivityID.EXCHANGE_MALL then
		_ENV = gActivityTimeActivityID.EXCHANGE_MALL
		tmp, gActivityTimeActivityID.EXCHANGE_MALL[1] = gActivityTimeActivityID.EXCHANGE_MALL, activityID
	end
	local getOwnCountFunc
	if activityID == gActivityTimeActivityID.WRATH_BEAST_ACTIVITY then
		local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
		function getOwnCountFunc()
			return wrathBeastCtrl:getActivityData("godBeastGem")
		end
	elseif activityID == gActivityTimeActivityID.EXCHANGE_MALL_ARENA then
		function getOwnCountFunc()
			local arenaCtrl = SoraDGetCtrl("arenaCtrl")
			return arenaCtrl:getArenaTicketNums()
		end
	else
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		function getOwnCountFunc(costItemID)
			return backpackCtrl:getItemCount(costItemID)
		end
	end
	local ret, num = false, 0
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	for i, eid in ipairs(tmp) do
		if activityShowCtrl:isActivityOpen(eid) and newExchangeMallRead.isReachOpenLvByID(eid) then
			local tmpData = self:getConfigByActivityID(eid)
			if tmpData and next(tmpData) then
				for _, value in ipairs(tmpData) do
					if self:getSingleRedDot(value, getOwnCountFunc) then
						ret = true
						num = num + 1
						if activityID == gActivityTimeActivityID.EXCHANGE_MALL then
							return true, -1
						end
					end
				end
			end
		end
	end
	return ret, num
end
function newExchangeMallCtrl:getReceiveStatusAndNumByList(activityID, exchangeList, needNum)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if not activityShowCtrl:isActivityOpen(activityID) or not newExchangeMallRead.isReachOpenLvByID(activityID) then
		return false, 0
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local getOwnCountFunc = function(costItemID)
		return backpackCtrl:getItemCount(costItemID)
	end
	local ret, num = false, 0
	for _, value in ipairs(exchangeList) do
		if self:getSingleRedDot(value, getOwnCountFunc) then
			ret = true
			num = num + 1
			if not needNum then
				return ret, -1
			end
		end
	end
	return ret, num
end
function newExchangeMallCtrl:getSingleRedDot(cfg, getOwnCountFunc)
	if cfg.remindStatus ~= 1 or not cfg.exchangeitem then
		return false
	end
	if cfg.limitType ~= 0 and not (cfg.curExchangeNum < cfg.limitnum) then
		return false
	end
	local isNoEnough = false
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local exchangeitem = serviceFunctions.tableFormat(cfg.exchangeitem, nil)
	for _, v in ipairs(exchangeitem) do
		local ownCont = getOwnCountFunc(v.id)
		if ownCont < v.count then
			isNoEnough = true
			break
		end
	end
	if not isNoEnough then
		return true
	else
		return false
	end
end
return newExchangeMallCtrl

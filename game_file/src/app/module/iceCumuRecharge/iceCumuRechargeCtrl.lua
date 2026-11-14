local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local iceCumuRechargeCtrl = class("iceCumuRechargeCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local cumulativeRecharge2021Read = include("cumulativeRecharge2021Read")
function iceCumuRechargeCtrl:ctor(properties)
	iceCumuRechargeCtrl.super.ctor(self, properties)
	self:resetData()
end
function iceCumuRechargeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CUMU_RECHARGE_2023_MODULE, gCmd.REQ_CUMU_RECHARGE_2023_INIT, handler(self, self.reqCumuRecharge2023InitRsp))
	msgCtrl.register(gCmd.CMD_CUMU_RECHARGE_2023_MODULE, gCmd.REQ_CUMU_RECHARGE_2023_CLAIM, handler(self, self.reqCumuRecharge2023ClaimRsp))
	self.activityID = gActivityTimeActivityID.CUMU_RECHARGE_2023
	self:registerNotify()
end
function iceCumuRechargeCtrl:Logout()
	iceCumuRechargeCtrl.super.Logout(self)
	self:resetData()
end
function iceCumuRechargeCtrl:resetData()
	self.usefullList, _UPVALUE0_, self.ClaimList, _UPVALUE0_ = nil, nil, nil, nil
	self.finishDay = 0
	self.lastRealDay = 0
end
function iceCumuRechargeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CUMU_RECHARGE_2023, handler(self, self.notifyHandler))
end
function iceCumuRechargeCtrl:notifyHandler(event)
	dump(event.data, "iceCumuRechargeCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.type == "updateData" then
			self.finishDay, self.usefullList, self.lastRealDay = self:getUsefullInfo(v.data.cumuDayData)
			_ENV = self:getUsefullInfo(v.data.cumuDayData)
			self:getUsefullInfo(v.data.cumuDayData).msg = "MESSAGE_ICE_CUMULATIVE_RECHARGE_REFRESH"
			self:getUsefullInfo(v.data.cumuDayData).subMsg = "init"
			SoraDSendMessage(self:getUsefullInfo(v.data.cumuDayData))
			_ENV = self:getUsefullInfo(v.data.cumuDayData)
			self:getUsefullInfo(v.data.cumuDayData).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			self:getUsefullInfo(v.data.cumuDayData).eventID = self.activityID
			SoraDSendMessage(self:getUsefullInfo(v.data.cumuDayData))
		end
	end
end
function iceCumuRechargeCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_CUMU_RECHARGE_2023_MODULE, gCmd.REQ_CUMU_RECHARGE_2023_INIT, nil)
	end
end
function iceCumuRechargeCtrl:reqCumuRecharge2023Claim(type, index)
	serverproxy = nil
	;(nil).type = type
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_CUMU_RECHARGE_2023_MODULE, gCmd.REQ_CUMU_RECHARGE_2023_CLAIM, nil)
end
function iceCumuRechargeCtrl:reqCumuRecharge2023InitRsp(content)
	dump(content, "iceCumuRechargeCtrl:reqCumuRecharge2023InitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.ClaimList = content.rspdata.ClaimList
		self.finishDay, self.usefullList, self.lastRealDay = self:getUsefullInfo(content.rspdata.cumuDayData)
		_ENV = self:getUsefullInfo(content.rspdata.cumuDayData)
		self:getUsefullInfo(content.rspdata.cumuDayData).msg = "MESSAGE_ICE_CUMULATIVE_RECHARGE_REFRESH"
		self:getUsefullInfo(content.rspdata.cumuDayData).subMsg = "init"
		SoraDSendMessage(self:getUsefullInfo(content.rspdata.cumuDayData))
		_ENV = self:getUsefullInfo(content.rspdata.cumuDayData)
		self:getUsefullInfo(content.rspdata.cumuDayData).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self:getUsefullInfo(content.rspdata.cumuDayData).eventID = self.activityID
		SoraDSendMessage(self:getUsefullInfo(content.rspdata.cumuDayData))
	end
end
function iceCumuRechargeCtrl:reqCumuRecharge2023ClaimRsp(content)
	dump(content, "iceCumuRechargeCtrl:reqCumuRecharge2023ClaimRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.ClaimList[tostring(content.data.index)] = true
		_ENV = tostring(content.data.index)
		tostring(content.data.index).msg = "MESSAGE_ICE_CUMULATIVE_RECHARGE_REFRESH"
		tostring(content.data.index).subMsg = "claim"
		tostring(content.data.index).index = content.data.index
		tostring(content.data.index).reward = content.rspdata.reward
		SoraDSendMessage((tostring(content.data.index)))
		_ENV = tostring(content.data.index)
		tostring(content.data.index).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		tostring(content.data.index).eventID = self.activityID
		SoraDSendMessage((tostring(content.data.index)))
	end
end
function iceCumuRechargeCtrl:getReceiveStatusAndNum()
	local ret = 0
	local list = cumulativeRecharge2021Read.getIceRechargeList()
	for i, v in ipairs(list) do
		if not self.ClaimList[tostring(v.Index)] and self:getCurPrice(v.days) >= v.amount then
			ret = ret + 1
		end
	end
	local cumu = cumulativeRecharge2021Read.getIceRechargeCumu()
	if not self.ClaimList[tostring(cumu.Index)] and self:getCurDay() >= cumu.days then
		ret = ret + 1
	end
	print("getReceiveStatusAndNumret", ret)
	return 0 < ret, -1
end
function iceCumuRechargeCtrl:isSameDay(day)
	local date = SoraDGetCtrl("activityShowCtrl"):getBeginTimeSecond(self.activityID)
	return serviceFunctions.isSameDay(date + (day - 1) * 86400)
end
function iceCumuRechargeCtrl:getCurPrice(day)
	return self.usefullList[tonumber(day)] or 0
end
function iceCumuRechargeCtrl:getCurDay()
	return self.finishDay
end
function iceCumuRechargeCtrl:getUsefullInfo(cumuDayData)
	local curDay = 0
	local cumulativeRecharge2021Read, usefulList
	local lastRealDay = 0
	local list = cumulativeRecharge2021Read.getIceRechargeList()
	if list then
		for realDay, value in ipairs(self:getFullCumuDayData(cumuDayData)) do
			local item = list[curDay + 1]
			if item then
				if value >= item.amount then
					curDay = curDay + 1
					lastRealDay = realDay
					usefulList[curDay] = value
				elseif 0 < value then
					usefulList[curDay + 1] = value
				end
			end
		end
	end
	if not usefulList[curDay + 1] then
		usefulList[curDay + 1] = 0
	end
	return curDay, usefulList, lastRealDay
end
function iceCumuRechargeCtrl:getFullCumuDayData(cumuDayData)
	local _ENV, tempList
	local info = SoraDGetCtrl("activityShowCtrl"):getShowDataByID(self.activityID)
	local days = serviceFunctions.differDays(info.begintime, info.endtime)
	for i = 1, days + 1 do
		tempList[i] = cumuDayData[i] or 0
	end
	return tempList
end
function iceCumuRechargeCtrl:isRewardClaim(Index)
	return self.ClaimList[tostring(Index)]
end
function iceCumuRechargeCtrl:getTaskList()
	local cumulativeRecharge2021Read, ret
	local list = cumulativeRecharge2021Read.getIceRechargeList()
	dump(self.usefullList, "usefulList")
	for i, v in ipairs(list) do
		local cumulativeRecharge2021Read, item
		item.amount = v.amount
		item.type = v.type
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		item.reward = serviceFunctions.tableFormat(v.reward, nil)
		item.index = v.Index
		item.days = v.days
		item.status = gBtnTargetStatusDef.GO
		print("getTaskList", self:isSameDay(self.lastRealDay), self:getCurPrice(v.days), v.days)
		if self.ClaimList[tostring(v.Index)] then
			item.status = gBtnTargetStatusDef.GOT
		elseif self:getCurPrice(v.days) >= v.amount then
			item.status = gBtnTargetStatusDef.GET
		elseif not self.usefullList[tonumber(v.days)] or self:isSameDay(self.lastRealDay) then
			item.status = gBtnTargetStatusDef.NONE
		end
		table.insert(ret, item)
	end
	return ret
end
return iceCumuRechargeCtrl

local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001486_Ctrl = class("activity_9001486_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001486_Ctrl:ctor(properties)
	activity_9001486_Ctrl.super.ctor(self, properties)
	self:resetData()
end
function activity_9001486_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DICTATORSHIPS_MODULE, gCmd.REQ_DICTATORSHIPS_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_DICTATORSHIPS_MODULE, gCmd.REQ_DICTATORSHIPS_CLAIM, handler(self, self.reqClaimRsp))
	msgCtrl.register(gCmd.CMD_DICTATORSHIPS_MODULE, gCmd.REQ_DICTATORSHIPS_BUY, handler(self, self.reqBuyRsp))
	msgCtrl.register(gCmd.CMD_DICTATORSHIPS_MODULE, gCmd.REQ_DICTATORSHIPS_DATA_EX, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_DICTATORSHIPS_MODULE, gCmd.REQ_DICTATORSHIPS_CLAIM_EX, handler(self, self.reqClaimRsp))
	msgCtrl.register(gCmd.CMD_DICTATORSHIPS_MODULE, gCmd.REQ_DICTATORSHIPS_BUY_EX, handler(self, self.reqBuyRsp))
end
function activity_9001486_Ctrl:Logout()
	activity_9001486_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001486_Ctrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function activity_9001486_Ctrl:initClientData(retdata)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY] = "dictatorshipsCtrl"
	local (nil)[gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY], config = "newDictatorshipsCtrl", nil
	for activityID, key in pairs(config) do
		local data = retdata[key]
		dump(data, "==activity_9001486_Ctrl:initClientData==" .. key, 10)
		self.initData[tostring(activityID)] = data
	end
	self:registerNotify()
end
function activity_9001486_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOTIFY_DICTATORSHIPS, handler(self, self.notifyHandler))
end
function activity_9001486_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001486_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		local activityID = v.activityID
		if notifyType == "updateData" then
			local data = self:getActivityData(activityID)
			data.cumuDayData = v.data.cumuDayData
			_ENV = activityID
			activityID.msg = "MESSAGE_ACTIVITY_9001486_CUMUDAYDATA"
			SoraDSendMessage(activityID)
		elseif notifyType == "buyGift" and notifyData.success then
			paymentManager.loopForFinishTransaction()
			local reward = notifyData.reward
			local rid = notifyData.rid
			_ENV = nil
			_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
			;(nil).result = true
			;(nil).rid = rid
			;(nil).data, (nil).itemList = nil, reward
			SoraDSendMessage(nil)
			local data = self:getActivityData(activityID)
			data.bBuyGift = true
			_ENV = activityID
			activityID.msg = "MESSAGE_ACTIVITY_9001486_BUYGIFT"
			SoraDSendMessage(activityID)
		end
	end
end
function activity_9001486_Ctrl:reqData(activityID)
	local subcmd = gCmd.REQ_DICTATORSHIPS_DATA
	if activityID == gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY then
		subcmd = gCmd.REQ_DICTATORSHIPS_DATA_EX
	end
	_ENV, _ENV = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(gCmd.CMD_DICTATORSHIPS_MODULE, subcmd, nil, nil)
end
function activity_9001486_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001486_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local activityID = content.clientData.activityID
		if not content.rspdata then
			_ENV = content.rspdata
		end
		self.initData[tostring(activityID)] = content.rspdata
	end
end
function activity_9001486_Ctrl:reqClaim(activityID, index)
	local subcmd = gCmd.REQ_DICTATORSHIPS_CLAIM
	if activityID == gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY then
		subcmd = gCmd.REQ_DICTATORSHIPS_CLAIM_EX
	end
	_ENV = nil
	_ENV, (nil).index = nil, index
	;(nil).activityID = activityID
	serverproxy:Request(gCmd.CMD_DICTATORSHIPS_MODULE, subcmd, nil, nil)
end
function activity_9001486_Ctrl:reqClaimRsp(content)
	dump(content, "activity_9001486_Ctrl:reqClaimRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local reward = content.rspdata.reward
		SoraDMailGainItems(reward, true)
		local activityID = content.clientData.activityID
		local data = self:getActivityData(activityID)
		if not data.claimList then
			_ENV = data.claimList
		end
		data.claimList = data.claimList
		local index = content.data.index
		data.claimList[tostring(index)] = serviceFunctions.systemTime()
		_ENV = tostring(index)
		tostring(index).msg = "MESSAGE_ACTIVITY_9001486_CLAIM"
		tostring(index).index = index
		SoraDSendMessage((tostring(index)))
	end
end
function activity_9001486_Ctrl:reqBuy(rid)
	local subcmd = gCmd.REQ_DICTATORSHIPS_BUY
	if self:getGiftRechargeID(gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY) == rid then
		subcmd = gCmd.REQ_DICTATORSHIPS_BUY_EX
	end
	_ENV = nil
	serverproxy:Request(gCmd.CMD_DICTATORSHIPS_MODULE, subcmd, nil)
end
function activity_9001486_Ctrl:reqBuyRsp(content)
	dump(content, "activity_9001486_Ctrl:reqBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		paymentManager.purchase(rspdata.rechargeID, rspdata.orderID)
	end
end
function activity_9001486_Ctrl:getActivityData(activityID)
	if not self.initData[tostring(activityID)] then
		_ENV = self.initData[tostring(activityID)]
	end
	return self.initData[tostring(activityID)]
end
function activity_9001486_Ctrl:getCumuDayData(activityID)
	local data = self:getActivityData(activityID)
	if not data.cumuDayData then
		_UPVALUE0_ = data.cumuDayData
	end
	return data.cumuDayData
end
function activity_9001486_Ctrl:getRechargeTotal(activityID)
	local total = 0
	for __, v in pairs(self:getCumuDayData(activityID)) do
		total = total + v
	end
	return total
end
function activity_9001486_Ctrl:getClaimList(activityID)
	local data = self:getActivityData(activityID)
	if not data.claimList then
		_UPVALUE0_ = data.claimList
	end
	return data.claimList
end
function activity_9001486_Ctrl:getGiftConfig(activityID)
	if not self.giftConfig then
		local dictatorship_recharge = require_data("dictatorship_recharge", true).data
		_ENV = "dictatorship_recharge"
		;("dictatorship_recharge")[gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY] = dictatorship_recharge[1]
		self.giftConfig, ("dictatorship_recharge")[gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY] = "dictatorship_recharge", dictatorship_recharge[2]
	end
	return self.giftConfig[activityID]
end
function activity_9001486_Ctrl:getGiftRewards(activityID)
	local cfg = self:getGiftConfig(activityID)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local ret = serviceFunctions.tableFormat(cfg.Rewards, nil)
	_ENV = "count"
	;("count").id = 1001
	;("count").count = cfg.Gold
	table.insert(ret, 1, "count")
	return ret
end
function activity_9001486_Ctrl:getGiftRechargeID(activityID)
	local cfg = self:getGiftConfig(activityID)
	return cfg.RechargeID
end
function activity_9001486_Ctrl:getRechargeConfig(activityID, ctype)
	if not self.rechargeConfig then
		local dictatorship = require_data("dictatorship", true).data
		local _ENV, ret = "dictatorship", "dictatorship"
		for i, v in ipairs(dictatorship) do
			if not ret[v.activtyID] then
				_ENV = ret[v.activtyID]
			end
			ret[v.activtyID] = ret[v.activtyID]
			if not ret[v.activtyID][v.classtype] then
				_ENV = ret[v.activtyID][v.classtype]
			end
			ret[v.activtyID][v.classtype] = ret[v.activtyID][v.classtype]
			if not ret[v.activtyID][v.classtype][v.type] then
				_ENV = ret[v.activtyID][v.classtype][v.type]
			end
			ret[v.activtyID][v.classtype][v.type] = ret[v.activtyID][v.classtype][v.type]
			table.insert(ret[v.activtyID][v.classtype][v.type], v)
		end
		self.rechargeConfig = ret
	end
	local data = self:getActivityData(activityID)
	local classtype = data.classType or 1
	local config = self.rechargeConfig[activityID]
	local rechargeConfig = config[classtype] or config[1]
	return rechargeConfig[ctype]
end
function activity_9001486_Ctrl:getRechargeList(activityID, ctype)
	local rechargeConfig = self:getRechargeConfig(activityID, ctype)
	local _ENV, ret = self, self
	for i, config in ipairs(rechargeConfig) do
		_ENV = nil
		;(nil).type = config.type
		;(nil).grade = i
		;(nil).cfg = config
		table.insert(ret, nil)
	end
	table.sort(ret, function(a, b)
		if a.type ~= b.type then
			return a.type < b.type
		end
		return a.grade < b.grade
	end)
	return ret
end
function activity_9001486_Ctrl:getAchieveDay(activityID)
	if not self.daysList then
		self.daysList, _ENV = self.daysList, self.daysList
		_UPVALUE2_ = nil
		;(nil)[1] = gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY
		;(nil)[2] = gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY
		for __, activityID in ipairs(nil) do
			local rechargeConfig = self:getRechargeConfig(activityID, 1)
			local _ENV, ret = self, self
			for i, v in ipairs(rechargeConfig) do
				ret[v.days] = v
			end
			self.daysList[activityID] = ret
		end
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local info = activityShowCtrl:getActivityData(activityID)
	local begintime = info.begintime
	if activityID == gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY then
		begintime = activityShowCtrl:getParamByID(activityID).begintime
	end
	local days = serviceFunctions.differDays(begintime, info.endtime)
	local cumuDayData = self:getCumuDayData(activityID)
	local achieveDay = 0
	for i = 1, days + 1 do
		local item = self.daysList[activityID][achieveDay + 1]
		local value = cumuDayData[tostring(i)] or 0
		if item and value >= item.amount then
			achieveDay = achieveDay + 1
		end
	end
	return achieveDay, #self.daysList[activityID]
end
function activity_9001486_Ctrl:checkBoxReceived(activityID, index)
	local claimList = self:getClaimList(activityID)
	return claimList[tostring(index)] or false
end
function activity_9001486_Ctrl:getHasBuyGift(activityID)
	local data = self:getActivityData(activityID)
	return data.bBuyGift
end
function activity_9001486_Ctrl:getReceiveStatusAndNum(activityID)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return false
	end
	local achieveDay = self:getAchieveDay(activityID)
	local total = self:getRechargeTotal(activityID)
	for ctype = 1, 2 do
		local rechargeList = self:getRechargeList(activityID, ctype)
		for i, data in ipairs(rechargeList) do
			local cfg = data.cfg
			local isReceived = self:checkBoxReceived(activityID, cfg.Index)
			if not isReceived then
				if data.type == 1 and achieveDay >= cfg.days then
					return true, -1
				end
				if data.type == 2 and total >= cfg.amount then
					return true, -1
				end
			end
		end
	end
	return false
end
return activity_9001486_Ctrl

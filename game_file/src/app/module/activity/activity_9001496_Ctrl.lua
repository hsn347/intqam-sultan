local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001496_Ctrl = class("activity_9001496_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001496_Ctrl:ctor(properties)
	activity_9001496_Ctrl.super.ctor(self, properties)
	self:resetData()
end
function activity_9001496_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BUILD_THRIVING_MODULE, gCmd.REQ_BUILD_THRIVING_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_BUILD_THRIVING_MODULE, gCmd.REQ_BUILD_THRIVING_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_BUILD_THRIVING_MODULE, gCmd.REQ_BUILD_THRIVING_GIFT, handler(self, self.reqGiftRsp))
	self:registerNotify()
end
function activity_9001496_Ctrl:Logout()
	activity_9001496_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001496_Ctrl:resetData()
	;(nil).giftRecord, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	self.initData, (nil).taskRecord, _UPVALUE0_, (nil).rechargePrice = nil, nil, nil, 0
end
function activity_9001496_Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==activity_9001496_Ctrl:initClientData==", 10)
	self.initData = data
end
function activity_9001496_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BUILD_THRIVING, handler(self, self.notifyHandler))
end
function activity_9001496_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001496_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "buyGift" then
			if notifyData.success then
				paymentManager.loopForFinishTransaction()
				local reward = notifyData.reward
				local rid = notifyData.rid
				local record = self:getGiftCount(rid)
				self.initData.giftRecord[tostring(rid)] = record + 1
				_ENV = tostring(rid)
				_ENV, tostring(rid).msg = record + 1, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
				;(record + 1).result = true
				;(record + 1).rid = rid
				tostring(rid).data, (record + 1).itemList = record + 1, reward
				SoraDSendMessage((tostring(rid)))
			end
		elseif notifyType == "updateData" then
			self.initData.rechargePrice = notifyData.rechargePrice
			_ENV = notifyData.rechargePrice
			notifyData.rechargePrice.msg = "MESSAGE_ACTIVITY_9001496_UPDATE"
			notifyData.rechargePrice.key = "rechargePrice"
			SoraDSendMessage(notifyData.rechargePrice)
		end
	end
end
function activity_9001496_Ctrl:sendReqInitDataMsg(...)
	self:reqData()
end
function activity_9001496_Ctrl:reqData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_BUILD_THRIVING_MODULE, gCmd.REQ_BUILD_THRIVING_DATA, nil)
end
function activity_9001496_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001496_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
	end
end
function activity_9001496_Ctrl:reqReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_BUILD_THRIVING_MODULE, gCmd.REQ_BUILD_THRIVING_REWARD, nil)
end
function activity_9001496_Ctrl:reqRewardRsp(content)
	dump(content, "activity_9001496_Ctrl:reqRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local index = content.data.index
		local indexType = content.rspdata.indexType
		self.initData.taskRecord[tostring(index)] = indexType
		_ENV = nil
		;(nil).reward = content.rspdata.reward
		uiManager:show("Activity_9001496_Reward", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001496_UPDATE"
		SoraDSendMessage(uiManager)
	end
end
function activity_9001496_Ctrl:reqGift(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_BUILD_THRIVING_MODULE, gCmd.REQ_BUILD_THRIVING_GIFT, nil)
end
function activity_9001496_Ctrl:reqGiftRsp(content)
	dump(content, "activity_9001496_Ctrl:reqGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		paymentManager.purchase(rspdata.rechargeID, rspdata.orderID)
	end
end
function activity_9001496_Ctrl:getTaskRecord(index)
	local taskRecord = self.initData.taskRecord
	return taskRecord[tostring(index)] or 0
end
function activity_9001496_Ctrl:getTaskList(...)
	local activity_9001496_Read = include("activity_9001496_Read")
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local rechargePrice = self:getRechargePrice()
	local taskConfig = activity_9001496_Read.getTaskConfig()
	local _ENV, lvMap
	for i, v in ipairs(taskConfig) do
		local ctype = v.lv[1]
		if not lvMap[ctype] then
			_ENV = lvMap[ctype]
		end
		lvMap[ctype] = lvMap[ctype]
		if ctype == 1 then
			local bid = v.lv[2]
			local starLv = SoraDGetBuildStarLv(bid)
			lvMap[ctype][bid] = starLv
		elseif ctype == 2 then
			local jinnType = v.lv[2]
			local jinnLv = magicLampCtrl:getJinnLv(jinnType)
			lvMap[ctype][jinnType] = jinnLv
		end
	end
	local _ENV, taskList = (for generator), ipairs(taskConfig)
	for i, v in ipairs(taskConfig) do
		local curStarLv = lvMap[v.lv[1]][v.lv[2]] or 0
		local stateLv, statePrice, btnState, unLockPrice = self:getTaskState(v.index, v.lv[3], curStarLv, v.price, rechargePrice)
		_ENV = rechargePrice
		rechargePrice.cfg = v
		rechargePrice.stateLv = stateLv
		rechargePrice.statePrice = statePrice
		rechargePrice.btnState = btnState
		rechargePrice.unLockPrice = unLockPrice
		rechargePrice.curStarLv = curStarLv
		table.insert(taskList, rechargePrice)
	end
	return taskList
end
function activity_9001496_Ctrl:getTaskState(index, starLv, curStarLv, price, rechargePrice)
	local taskRecord = self:getTaskRecord(index)
	local stateLv, statePrice
	if taskRecord == 2 then
		stateLv = gBtnTargetStatusDef.GOT
	elseif taskRecord == 1 then
		stateLv = gBtnTargetStatusDef.GOT
	elseif starLv <= curStarLv then
		stateLv = gBtnTargetStatusDef.GET
	else
		stateLv = gBtnTargetStatusDef.GO
	end
	local unLockPrice = price <= rechargePrice
	if taskRecord == 2 then
		statePrice = gBtnTargetStatusDef.GOT
	elseif stateLv == gBtnTargetStatusDef.GOT or stateLv == gBtnTargetStatusDef.GET then
		if price <= rechargePrice then
			statePrice = gBtnTargetStatusDef.GET
		else
			statePrice = gBtnTargetStatusDef.GO
		end
	else
		statePrice = gBtnTargetStatusDef.GO
	end
	local btnState
	if stateLv == gBtnTargetStatusDef.GO then
		btnState = gBtnTargetStatusDef.GO
	elseif stateLv == gBtnTargetStatusDef.GET then
		btnState = gBtnTargetStatusDef.GET
	elseif stateLv == gBtnTargetStatusDef.GOT then
		if statePrice == gBtnTargetStatusDef.GO then
			btnState = gBtnTargetStatusDef.GO
		elseif statePrice == gBtnTargetStatusDef.GET then
			btnState = gBtnTargetStatusDef.GET
		elseif statePrice == gBtnTargetStatusDef.GOT then
			btnState = gBtnTargetStatusDef.GOT
		end
	end
	return stateLv, statePrice, btnState, unLockPrice
end
function activity_9001496_Ctrl:getRechargePrice(...)
	return self.initData.rechargePrice
end
function activity_9001496_Ctrl:getGiftCount(rid)
	local giftRecord = self.initData.giftRecord
	return giftRecord[tostring(rid)] or 0
end
function activity_9001496_Ctrl:getReceiveStatusAndNum(activityID)
	local num = 0
	local taskList = self:getTaskList()
	for i, task in ipairs(taskList) do
		if task.btnState == gBtnTargetStatusDef.GET then
			num = num + 1
		end
	end
	return 0 < num, num
end
return activity_9001496_Ctrl

local gametop = gModuleMgr.getObject("gametop")
local GameModule = include("GameModule")
local purchaseRebateCtrl = class("purchaseRebateCtrl", GameModule)
local msgCtrl = include("msgCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
local timerList = gModuleMgr.getObject("timerList")
function purchaseRebateCtrl:ctor(properties)
	purchaseRebateCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.TREASURE_PACKAGE
end
function purchaseRebateCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PURCHASE_REBATE_MODULE, gCmd.REQ_PURCHASE_REB_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_PURCHASE_REBATE_MODULE, gCmd.REQ_PURCHASE_GET_TASK_REWARD, handler(self, self.reqClaimRewardRsp))
	msgCtrl.register(gCmd.CMD_PURCHASE_REBATE_MODULE, gCmd.REQ_PURCHASE_GET_REBATE_REWARD, handler(self, self.reqClaimRebateRewardRsp))
	self:resetData()
	self:registerNotify()
end
function purchaseRebateCtrl:initClientData(data)
	if not data then
		return
	end
	self.activityData = data
	self:updateRebateTime(self.activityData.rebateTime)
end
function purchaseRebateCtrl:resetData()
	self.activityData = nil
	self.rebateTimeNode = nil
end
function purchaseRebateCtrl:Logout()
	self:resetData()
	purchaseRebateCtrl.super.Logout(self)
end
function purchaseRebateCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PURCHASE_REBATE, handler(self, self.notifyHandler))
end
function purchaseRebateCtrl:notifyHandler(event)
	dump(event.data, "purchaseRebateCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			if content.type == "missionUpdate" then
				if self.activityData then
					for k, v in pairs(self.activityData.taskData) do
						for j, m in ipairs(content.data) do
							if v.taskID == m.taskID then
								v.status = m.status
							end
						end
					end
					for k, v in pairs(self.activityData.taskData) do
						print("weljrlwejrkjwelrewj222", v.status, self.activityData.rebateTime, serviceFunctions.systemTime())
						if v.status == gTreasurePackageType.CLAIMED and self.activityData.rebateTime <= serviceFunctions.systemTime() then
							self.activityData.rebateTime = serviceFunctions.systemTime()
							self:updateRebateTime(self.activityData.rebateTime)
							break
						end
					end
				end
				_ENV = pairs(self.activityData.taskData)
				pairs(self.activityData.taskData).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
				pairs(self.activityData.taskData).eventID = self.activityID
				SoraDSendMessage(pairs(self.activityData.taskData))
			elseif content.type == "refreshReceive" then
			elseif content.type == "initDataRefresh" then
				self.activityData = content.data
				self:updateRebateTime(self.activityData.rebateTime)
				_ENV = self
				self.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
				SoraDSendMessage(self)
			end
			_ENV = self
			self.msg = "MESSAGE_TREASURE_PACKAGE_REFRESH"
			SoraDSendMessage(self)
		end
	end
end
function purchaseRebateCtrl:updateRebateTime(rebateTime)
	local dispatchQueueEvent = function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
	local leftTime = rebateTime - serviceFunctions.systemTime()
	print("xgflsj", leftTime, type(leftTime))
	if self.rebateTimeNode then
		timerList:modifyTime(self.rebateTimeNode, leftTime)
	else
		local ok, node = timerList:createTimer(leftTime, timerHandler(dispatchQueueEvent))
		if ok then
			self.rebateTimeNode = node
		end
	end
end
function purchaseRebateCtrl:reqInitInfo()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PURCHASE_REBATE_MODULE, gCmd.REQ_PURCHASE_REB_INIT, data)
end
function purchaseRebateCtrl:reqClaimReward(taskID)
	serverproxy = nil
	local (nil).taskID, data = taskID, nil
	serverproxy:Request(gCmd.CMD_PURCHASE_REBATE_MODULE, gCmd.REQ_PURCHASE_GET_TASK_REWARD, data)
end
function purchaseRebateCtrl:reqClaimRebateReward(taskID)
	serverproxy = nil
	local (nil).taskID, data = taskID, nil
	serverproxy:Request(gCmd.CMD_PURCHASE_REBATE_MODULE, gCmd.REQ_PURCHASE_GET_REBATE_REWARD, data)
end
function purchaseRebateCtrl:reqInitRsp(content)
	dump(content, "purchaseRebateCtrl:reqInitRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData = content.rspdata.initdata
		self:updateRebateTime(self.activityData.rebateTime)
		_ENV = self
		self.msg = "MESSAGE_TREASURE_PACKAGE_INIT_BACK"
		SoraDSendMessage(self)
	end
end
function purchaseRebateCtrl:reqClaimRewardRsp(content)
	dump(content, "purchaseRebateCtrl:reqClaimRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		for k, v in pairs(self.activityData.taskData) do
			if v.taskID == content.rspdata.taskdata.taskID then
				v.status = content.rspdata.taskdata.status
			end
		end
		if content.rspdata.rewardInfo then
			SoraDMailGainItems(content.rspdata.rewardInfo, true)
		end
		_ENV = content.rspdata.rewardInfo
		content.rspdata.rewardInfo.msg = "MESSAGE_TREASURE_PACKAGE_CLAIM_REWARD"
		SoraDSendMessage(content.rspdata.rewardInfo)
		_ENV = content.rspdata.rewardInfo
		content.rspdata.rewardInfo.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.rewardInfo.eventID = self.activityID
		SoraDSendMessage(content.rspdata.rewardInfo)
	end
end
function purchaseRebateCtrl:reqClaimRebateRewardRsp(content)
	dump(content, "purchaseRebateCtrl:reqClaimRebateRewardRsp===", 10)
	if content.err == gErrDef.Err_None then
		self.activityData.rebateData = content.rspdata.rebateData
		if content.rspdata.reward then
			SoraDMailGainItems(content.rspdata.reward, true)
		end
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_TREASURE_PACKAGE_CLAIM_REBATE_REWARD"
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.reward.eventID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function purchaseRebateCtrl:getUnlockTime()
	return self.activityData and self.activityData.rebateTime or 0
end
function purchaseRebateCtrl:getRebateTaskData()
	local _ENV, taskData
	local unlockTime = self:getUnlockTime() - serviceFunctions.systemTime()
	print("weoiroiweuroiweur", unlockTime)
	if 0 < unlockTime then
		if not self.activityData or not self.activityData.taskData then
			_ENV = self.activityData.taskData
		end
		for k, v in pairs(self.activityData.taskData) do
			table.insert(taskData, v)
		end
	else
		if not self.activityData or not self.activityData.taskData then
			_ENV = self.activityData.taskData
		end
		for k, v in pairs(self.activityData.taskData) do
			if v.status == gTreasurePackageType.CLAIMED then
				table.insert(taskData, v)
			end
		end
	end
	table.sort(taskData, function(l, r)
		return l.taskID < r.taskID
	end)
	dump(taskData, "wkejhrjkwehjwkehr", 10)
	return taskData
end
function purchaseRebateCtrl:getRebateTime()
	return self.activityData and self.activityData.endTime or 0
end
function purchaseRebateCtrl:getClaimedData()
	if not self.activityData or not self.activityData.rebateData then
		_UPVALUE0_ = self.activityData.rebateData
	end
	return self.activityData.rebateData
end
function purchaseRebateCtrl:getWhichDayToday()
	local rewardDay = 0
	if self.activityData and self.activityData.endTime and self.activityData.rebateTime then
		local curTime = serviceFunctions.systemTime()
		if curTime >= self.activityData.rebateTime and curTime <= self.activityData.endTime then
			local difTime = curTime - self.activityData.rebateTime
			if math.fmod(difTime, 86400) == 0 then
				if difTime == 0 then
					rewardDay = 1
				else
					rewardDay = difTime / 86400
				end
			else
				rewardDay = math.floor(difTime / 86400) + 1
			end
		end
	end
	return rewardDay
end
function purchaseRebateCtrl:isTodayRewardClaim(taskID)
	local curDay = self:getWhichDayToday()
	local claimData = self:getClaimedData()
	local isClaim = false
	for k, v in pairs(claimData) do
		if claimData[tostring(curDay)] and claimData[tostring(curDay)][tostring(taskID)] then
			isClaim = true
		end
	end
	return isClaim
end
function purchaseRebateCtrl:isAllPackageNotBought()
	local unlockTime = self:getUnlockTime() - serviceFunctions.systemTime()
	local isNotAllBought = true
	if 0 < unlockTime then
		return false
	end
	if not self.activityData or not self.activityData.taskData then
		_ENV = self.activityData.taskData
	end
	for k, v in pairs(self.activityData.taskData) do
		if v.status ~= 1 then
			isNotAllBought = false
			break
		end
	end
	return isNotAllBought
end
function purchaseRebateCtrl:getTodayClaimRemainTime()
	local curTime = serviceFunctions.systemTime()
	local curDay = self:getWhichDayToday()
	local oneDayTime = 86400
	local remainTime = self:getUnlockTime() + curDay * oneDayTime - curTime
	print("sdkjfhfhkjsdfh", self:getUnlockTime() + curDay * oneDayTime - curTime)
	return remainTime
end
function purchaseRebateCtrl:getReceiveStatusAndNum()
	local unlockTime = self:getUnlockTime() - serviceFunctions.systemTime()
	print("purchaseRebateCtrl", unlockTime)
	if 0 < unlockTime then
		return self:getTaskNum()
	else
		return self:getTodayReward()
	end
end
function purchaseRebateCtrl:getTaskNum()
	local num = 0
	if not self.activityData or not self.activityData.taskData then
		_ENV = self.activityData.taskData
	end
	for k, v in pairs(self.activityData.taskData) do
		if v.status == gTreasurePackageType.UNLOCK then
			num = num + 1
		end
	end
	print("purchaseRebateCtrl", num)
	return 0 < num, num
end
function purchaseRebateCtrl:getTodayReward()
	local num = 0
	if not self.activityData or not self.activityData.taskData then
		_ENV = self.activityData.taskData
	end
	for k, v in pairs(self.activityData.taskData) do
		if v.status == gTreasurePackageType.CLAIMED and not self:isTodayRewardClaim(v.taskID) then
			num = num + 1
		end
	end
	print("purchaseRebateCtrl", num)
	return 0 < num, num
end
return purchaseRebateCtrl

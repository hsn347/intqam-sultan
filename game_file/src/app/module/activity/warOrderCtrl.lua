local warOrderRead = include("warOrderRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local warOrderCtrl = class("warOrderCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function warOrderCtrl:ctor(properties)
	warOrderCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	self:resetData()
end
function warOrderCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.reqActivityInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_BUY, handler(self, self.reqWarOrderBuyRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_RECEIVE, handler(self, self.reqWarOrderReceiveRsp))
	self:registerNotify()
end
function warOrderCtrl:Logout()
	warOrderCtrl.super.Logout(self)
	self:resetData()
end
function warOrderCtrl:resetData()
	self.initData, _UPVALUE0_ = nil, nil
end
function warOrderCtrl:initClientData(data)
	dump(data, "==warOrderCtrl:initClientData==", 10)
	if not data then
		return
	end
	self.initData = data
end
function warOrderCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function warOrderCtrl:notifyHandler(event)
	dump(event.data, "warOrderCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.activityID == self.activityID then
			if v.notifyType == "buyGift" then
				if v.notifyData.rechargeInfo.success then
					paymentManager.loopForFinishTransaction()
					local reward = v.notifyData.rechargeInfo.reward
					local rid = v.notifyData.rechargeInfo.rid
					local mailid = v.notifyData.rechargeInfo.mailid
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					;(nil).eventID = self.activityID
					SoraDSendMessage(nil)
					_ENV = nil
					_ENV, (nil).msg = self.activityID, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					self.activityID.result = true
					self.activityID.rid = rid
					self.activityID.itemList = reward
					;(nil).data, self.activityID.mailID = self.activityID, mailid
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_ACTIVITY_9001562_BUY_GIFT"
					;(nil).activityID = self.activityID
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_ACTIVITY_9001581_BUY_GIFT"
					;(nil).activityID = self.activityID
					SoraDSendMessage(nil)
				end
				self:initClientData(v.notifyData)
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001562_REFRESH"
				self.activityID = self.activityID
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001581_REFRESH"
				self.activityID = self.activityID
				SoraDSendMessage(self)
			elseif v.notifyType == "updateData" then
				self:initClientData(v.notifyData)
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001562_REFRESH"
				self.activityID = self.activityID
				SoraDSendMessage(self)
				_ENV = self
				self.msg = "MESSAGE_ACTIVITY_9001581_REFRESH"
				self.activityID = self.activityID
				SoraDSendMessage(self)
			end
		end
	end
end
function warOrderCtrl:reqWarOrderBuy(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_BUY, nil)
end
function warOrderCtrl:reqWarOrderBuyRsp(content)
	dump(content, "warOrderCtrl:reqWarOrderBuyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		paymentManager.purchase(content.data.rid, rspdata.orderID)
	end
end
function warOrderCtrl:reqWarOrderReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WAR_ORDER_RECEIVE, nil)
end
function warOrderCtrl:reqWarOrderReceiveRsp(content)
	dump(content, "warOrderCtrl:reqWarOrderReceiveRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata.initData)
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001562_REFRESH"
		content.rspdata.reward.activityID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_ACTIVITY_9001581_REFRESH"
		content.rspdata.reward.activityID = self.activityID
		SoraDSendMessage(content.rspdata.reward)
	end
end
function warOrderCtrl:sendReqInitDataMsg()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function warOrderCtrl:reqActivityInitDataRsp(target, data)
	dump(data, "reqActivityInitDataRsp")
	if data.activityID == self.activityID then
		self:initClientData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001562_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001581_REFRESH"
		self.activityID = self.activityID
		SoraDSendMessage(self)
	end
end
function warOrderCtrl:getGroupIndex()
	return SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)
end
function warOrderCtrl:getTaskList()
	local taskList = warOrderRead.getTaskListByIndex(self.activityID, self:getGroupIndex())
	table.sort(taskList, function(l, r)
		local lState = self:getTaskState(l)
		local rState = self:getTaskState(r)
		if lState == rState then
			return l < r
		else
			return lState < rState
		end
	end)
	return taskList
end
function warOrderCtrl:getTaskState(taskID)
	return self:isTaskClaimed(taskID) and gBtnTargetStatusDef.GOT or self:isTaskFinished(taskID) and gBtnTargetStatusDef.GET or gBtnTargetStatusDef.GO
end
function warOrderCtrl:isTaskClaimed(taskID)
	local questComponent = self:getQuestComponent()
	if questComponent then
		return questComponent:isTaskClaimed(taskID)
	end
	return false
end
function warOrderCtrl:isTaskFinished(taskID)
	local questComponent = self:getQuestComponent()
	if questComponent then
		return questComponent:isTaskFinished(taskID)
	end
	return false
end
function warOrderCtrl:getTaskProgress(taskID)
	local questComponent = self:getQuestComponent()
	if questComponent then
		return questComponent:getTaskProgress(taskID)
	end
	return 0
end
function warOrderCtrl:getQuestComponent(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local questComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	return questComponent
end
function warOrderCtrl:getExp()
	return self.initData.curExp or 0
end
function warOrderCtrl:getLevel()
	return self.initData.curLv or 0
end
function warOrderCtrl:getLvRewardStatusAndNum()
	local num = 0
	for i, lvInfo in ipairs(warOrderRead.getLvAwardList(self.activityID, self:getGroupIndex())) do
		local lv = lvInfo.lv
		if lv then
			if self:getRewardState(1, lv) == gBtnTargetStatusDef.GET then
				num = num + math.ceil(#lvInfo.bronzeAward / 2)
			end
			if self:getRewardState(2, lv) == gBtnTargetStatusDef.GET then
				num = num + math.ceil(#lvInfo.goldAward1 / 2)
			end
			if self:getRewardState(3, lv) == gBtnTargetStatusDef.GET then
				num = num + math.ceil(#lvInfo.goldAward2 / 2)
			end
		end
	end
	return num
end
function warOrderCtrl:getRewardLevel(type)
	return self.initData.lv and self.initData.lv[type] or 0
end
function warOrderCtrl:isRewardUnlock(type)
	if type - 1 == 0 then
		return true
	end
	local info = warOrderRead.getGiftAwardInfo(self.activityID, type - 1)
	if info then
		local gifyID = info.RechargeID
		if self.initData.buyGift and self.initData.buyGift[tostring(gifyID)] == 1 then
			return true
		end
	end
	return false
end
function warOrderCtrl:getRewardState(type, lv)
	local maxLv = table.nums(warOrderRead.getLvAwardList(self.activityID, self:getGroupIndex()))
	if lv == maxLv then
		if self:getRewardLevel(type) >= self:getLevel() then
			return gBtnTargetStatusDef.GO
		elseif self:isRewardUnlock(type) and lv <= self:getLevel() then
			return gBtnTargetStatusDef.GET
		end
	elseif lv <= self:getRewardLevel(type) then
		return gBtnTargetStatusDef.GOT
	elseif self:isRewardUnlock(type) and lv <= self:getLevel() then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function warOrderCtrl:getTaskStatusAndNum()
	local questComponent = self:getQuestComponent()
	local redNum = 0
	if questComponent then
		local _
		_, redNum = questComponent:getReceiveStatusAndNumByQuestList(warOrderRead.getTaskListByIndex(self.activityID, self:getGroupIndex()))
	end
	return redNum
end
function warOrderCtrl:getReceiveStatusAndNum(activityID)
	local redNum = self:getTaskStatusAndNum()
	redNum = redNum + self:getLvRewardStatusAndNum()
	return 0 < redNum, redNum
end
function warOrderCtrl:getBuffType()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return 0
	end
	local buffType = 0
	local defaultLv = 10
	if self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		defaultLv = 1
	end
	if defaultLv <= self:getLevel() then
		buffType = 1
	end
	for i = 1, 2 do
		local info = warOrderRead.getGiftAwardInfo(self.activityID, i)
		if info then
			local gifyID = info.RechargeID
			if self.initData.buyGift and self.initData.buyGift[tostring(gifyID)] == 1 then
				buffType = i + 1
			end
		end
	end
	return buffType
end
function warOrderCtrl:getBuffTypeEx(...)
	return self:getBuffType()
end
function warOrderCtrl:isBuffEffect(buffType)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false
	end
	local index = self:getBuffType()
	if 0 < index then
		local effectInfo = warOrderRead.getBuffInfo(self.activityID, buffType, index)
		if effectInfo then
			local oriLv = self:getInitBuildLv(buffType)
			local lv = self:getNowLvByBuffType(buffType)
			print("effectInfo.CastleLv[1]", buffType, effectInfo.CastleLv[1], effectInfo.CastleLv[2], lv, oriLv)
			if lv >= effectInfo.CastleLv[1] and lv <= effectInfo.CastleLv[2] and oriLv >= effectInfo.CastleLv[1] and oriLv <= effectInfo.CastleLv[2] then
				return true
			end
		end
	end
	return false
end
function warOrderCtrl:getNowLvByBuffType(buffType)
	return SoraDGetNowLvByBuffType(buffType)
end
function warOrderCtrl:getBuffVale(effectType)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return 0
	end
	local value = 0
	local index = self:getBuffType()
	for _, buffType in pairs(BUILD_ENUM) do
		for i = 1, 3 do
			if i <= index and self:isBuffEffect(buffType) then
				local effectInfo = warOrderRead.getBuffInfo(self.activityID, buffType, i)
				if not effectInfo or not effectInfo.PrivilegeEffect then
					local _ENV, privilegeEffect = effectInfo.PrivilegeEffect, effectInfo.PrivilegeEffect
				end
				local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
				for _, v in ipairs(privilegeEffect) do
					if buffltCtrl:getEffectType(v) == effectType then
						local effect, _ = buffltCtrl:getEffect(v)
						value = value + effect
						print("warOrderCtrl:getBuffVale-3", effect, effectType, value, i, buffType, v)
						break
					end
				end
			end
		end
	end
	return value
end
function warOrderCtrl:getInitBuildLv(buffType)
	return self.initData.initBuildLv and self.initData.initBuildLv[buffType] or 0
end
function warOrderCtrl:isMaxLvByType(buffType)
	local index = self:getBuffType()
	if 0 < index then
		local effectInfo = warOrderRead.getBuffInfo(self.activityID, buffType, index)
		if effectInfo then
			local lv = self:getNowLvByBuffType(buffType)
			if lv >= effectInfo.CastleLv[2] then
				return true, self:getLvStrByBuffType(buffType, effectInfo.CastleLv[2])
			end
		end
	end
	return false
end
function warOrderCtrl:getLvStrByBuffType(buffType, lv)
	if buffType == BUILD_ENUM.CASTLE then
		return include("buildLogic").getBuildLvStr(lv)
	elseif buffType == BUILD_ENUM.CASTLE_STAR then
		_ENV = nil
		;(nil).LV = lv
		return i18n("gemEnchant_text_39", nil)
	elseif buffType == BUILD_ENUM.GLORIOUS_STATUE then
		return lv
	elseif buffType == BUILD_ENUM.MAGIC_LAMP then
		return lv
	end
end
function warOrderCtrl:getCurCtrl(activityID)
	if activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		return SoraDGetCtrl("activity_9001565_Ctrl")
	elseif activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		return SoraDGetCtrl("warHornCtrl")
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 then
		return SoraDGetCtrl("activity_9001601_Ctrl")
	elseif activityID == gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY then
		return SoraDGetCtrl("activity_9001656_Ctrl")
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		return SoraDGetCtrl("activity_9001683_Ctrl")
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		return SoraDGetCtrl("activity_9001701_Ctrl")
	else
		return SoraDGetCtrl("warOrderCtrl")
	end
end
return warOrderCtrl

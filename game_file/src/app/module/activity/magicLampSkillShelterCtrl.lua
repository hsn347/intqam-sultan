local GameModule = include("GameModule")
local magicLampSkillShelterCtrl = class("magicLampSkillShelterCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function magicLampSkillShelterCtrl:ctor(properties)
	magicLampSkillShelterCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY
	self.poolID = include("constantRead").getConstValue("DIVINE_PROTECTION_POOLID", 1)
end
function magicLampSkillShelterCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_SHELTER_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_SHELTER_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_SHELTER_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_SHELTER_DRAW, handler(self, self.reqDrawRsp))
	msgCtrl.register(gCmd.CMD_MAGIC_LAMP_SKILL_SHELTER_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_SHELTER_REWARD, handler(self, self.reqRewardRsp))
	self:resetData()
	self:registerNotify()
	self:sendInit()
end
function magicLampSkillShelterCtrl:initClientData(data)
	dump(data, "magicLampSkillShelterCtrl:initClientData===")
end
function magicLampSkillShelterCtrl:resetData()
	self.rewards, _ENV = nil, nil
	self.poolData, _ENV, self.totalTimes = nil, nil, 0
	_ENV = self.poolID
	self.poolID.N = 0
	self.poolID.M = 0
	self.poolID.cycleTimes = 0
	self.poolID.cycleBeginTime = 0
	self.poolID.cycleTime = 0
	self.poolData[tostring(self.poolID)], self.poolID.isFirstN = self.poolID, false
end
function magicLampSkillShelterCtrl:Logout()
	magicLampSkillShelterCtrl.super.Logout(self)
	self:resetData()
end
function magicLampSkillShelterCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.MAGIC_LAMP_SKILL_SHELTER, handler(self, self.notifyHandler))
end
function magicLampSkillShelterCtrl:notifyHandler(content)
	dump(content, "magicLampSkillShelterCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_MAGICLAMPDRAW_UPDATE"
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
end
function magicLampSkillShelterCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_SHELTER_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_SHELTER_INIT, nil)
end
function magicLampSkillShelterCtrl:sendDraw(magicPoolId, times, isFree, isNoAct)
	serverproxy = nil
	;(nil).magicPoolId = magicPoolId
	;(nil).times = times
	;(nil).isFree = isFree or false
	;(nil).isNoAct = isNoAct or false
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_SHELTER_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_SHELTER_DRAW, nil)
end
function magicLampSkillShelterCtrl:sendReward(idx)
	serverproxy = nil
	;(nil).idx = idx
	serverproxy:Request(gCmd.CMD_MAGIC_LAMP_SKILL_SHELTER_MODULE, gCmd.REQ_MAGIC_LAMP_SKILL_SHELTER_REWARD, nil)
end
function magicLampSkillShelterCtrl:reqInitRsp(content)
	dump(content, "==magicLampSkillShelterCtrl:reqInitRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.rewards = content.rspdata.rewards
		self.totalTimes = content.rspdata.totalTimes
		if content.rspdata[tostring(self.poolID)] then
			self.poolData[tostring(self.poolID)] = content.rspdata[tostring(self.poolID)]
		end
	end
	_ENV = tostring(self.poolID)
	tostring(self.poolID).msg = "MESSAGE_ACTIVITY_MAGICLAMPDRAW_UPDATE"
	SoraDSendMessage((tostring(self.poolID)))
end
function magicLampSkillShelterCtrl:reqDrawRsp(content)
	dump(content, "==magicLampSkillShelterCtrl:reqDrawRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.totalTimes = content.rspdata.totalTimes
		self.poolData[tostring(self.poolID)] = content.rspdata.poolLottryInfo
		content.rspdata.isNoAct = content.data.isNoAct
		_ENV = content.data.isNoAct
		content.data.isNoAct.msg = "MESSAGE_ACTIVITY_MAGICLAMPDRAW_DRAWBACK"
		content.data.isNoAct.data = content.rspdata
		SoraDSendMessage(content.data.isNoAct)
	elseif content.err == gErrDef.Err_MAGIC_LAMP_SKILL_SPACE_ENOUGH then
		SoraDShowMsgTip(i18n("Magic_draw_text_08"))
	end
	_ENV = i18n("Magic_draw_text_08")
	i18n("Magic_draw_text_08").msg = "MESSAGE_ACTIVITY_MAGICLAMPDRAW_UPDATE"
	SoraDSendMessage(i18n("Magic_draw_text_08"))
end
function magicLampSkillShelterCtrl:reqRewardRsp(content)
	dump(content, "==magicLampSkillShelterCtrl:reqRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		SoraDMailGainItems(content.rspdata.rewards, true)
		self.rewards[tostring(content.data.idx)] = 1
	end
	_ENV = tostring(content.data.idx)
	tostring(content.data.idx).msg = "MESSAGE_ACTIVITY_MAGICLAMPDRAW_UPDATE"
	SoraDSendMessage((tostring(content.data.idx)))
end
function magicLampSkillShelterCtrl:getReceiveStatusAndNum()
	local ret = false
	local num = 0
	local gLv = include("constantRead").getConstValue("DIVINE_PROTECTION_LV_LIMIT", 0)
	if gLv > SoraDGetBuildStarLv() then
		return ret, num
	end
	local divineProtectionRead = include("divineProtectionRead")
	local poolCfg = divineProtectionRead.getPoolCfg(self.poolID)
	if self:checkFree(poolCfg.freeTime) then
		ret = true
	end
	local costItemID = poolCfg.drwaCost1[1]
	if 0 < SoraDGetCtrl("backpackCtrl"):getItemCount(costItemID) then
		ret = true
	end
	local cfgList = divineProtectionRead.getAccruedCfgList()
	for k, v in ipairs(cfgList) do
		if self:getTotalTimes() >= v.Integral and not self:isReward(v.index) then
			ret = true
		end
	end
	return ret, -1
end
function magicLampSkillShelterCtrl:getTotalTimes()
	return self.totalTimes
end
function magicLampSkillShelterCtrl:checkFree(freeTime)
	local ret = false
	local lastFreeTime = self:getLastFreeTime()
	if lastFreeTime + freeTime < serviceFunctions.systemTime() then
		ret = true
	end
	return ret
end
function magicLampSkillShelterCtrl:getLastFreeTime()
	return self.poolData[tostring(self.poolID)].lastFreeTime or 0
end
function magicLampSkillShelterCtrl:getToSTimes()
	return self.poolData[tostring(self.poolID)].N or 0
end
function magicLampSkillShelterCtrl:isFirstN()
	return self.poolData[tostring(self.poolID)].isFirstN or false
end
function magicLampSkillShelterCtrl:isReward(index)
	return self.rewards[tostring(index)] and true or false
end
return magicLampSkillShelterCtrl

local gametop = gModuleMgr.getObject("gametop")
local warOrderCtrl = include("warOrderCtrl")
local activity_9001565_Ctrl = class("activity_9001565_Ctrl", warOrderCtrl)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local warOrderRead = include("warOrderRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
function activity_9001565_Ctrl:ctor(properties)
	activity_9001565_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY
	local constantRead = include("constantRead")
	self.unlockLv = constantRead.getConstValue("MAGIC_LAMP_DECREE_BUFF_UNLOCK_LV", 10)
	self:resetData()
end
function activity_9001565_Ctrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.reqActivityInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_LAMP_ORDER_BUY, handler(self, self.reqWarOrderBuyRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_LAMP_ORDER_RECEIVE, handler(self, self.reqWarOrderReceiveRsp))
	self:registerNotify()
end
function activity_9001565_Ctrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "==activity_9001565_Ctrl:initClientData==", 10)
	self.initData = data
end
function activity_9001565_Ctrl:reqWarOrderBuy(rid)
	serverproxy = nil
	;(nil).rid = rid
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_LAMP_ORDER_BUY, nil)
end
function activity_9001565_Ctrl:reqWarOrderReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_LAMP_ORDER_RECEIVE, nil)
end
function activity_9001565_Ctrl:getGroupIndex()
	return self.initData.classType or 1
end
function activity_9001565_Ctrl:getReceiveStatusAndNum(activityID)
	if not self:checkActivityCondition() then
		return false, 0
	end
	return activity_9001565_Ctrl.super.getReceiveStatusAndNum(self, activityID)
end
function activity_9001565_Ctrl:getLvRewardStatusAndNum()
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
		end
	end
	return num
end
function activity_9001565_Ctrl:isRewardUnlock(type)
	if type == 1 then
		return true
	end
	local classType = self:getGroupIndex()
	local gifyID = warOrderRead.getRechargeIDByIndex(self.activityID, classType)
	if gifyID and self.initData.buyGift and self.initData.buyGift[tostring(gifyID)] == 1 then
		return true
	end
	return false
end
function activity_9001565_Ctrl:getBuffType()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return 0
	end
	if self:getLevel() < self:getUnlockBuffLv() then
		return 0
	end
	local buffType = self:getBuffTypeEx()
	local classMax = warOrderRead.getClassTypeMax(self.activityID)
	if buffType <= classMax then
		return 0
	end
	return buffType
end
function activity_9001565_Ctrl:getBuffTypeEx(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return 0
	end
	local buffType = self:getGroupIndex()
	local classMax = warOrderRead.getClassTypeMax(self.activityID)
	for class = 1, classMax do
		local gifyID = warOrderRead.getRechargeIDByIndex(self.activityID, class)
		if gifyID and self.initData.buyGift and self.initData.buyGift[tostring(gifyID)] == 1 then
			buffType = classMax + class
		end
	end
	return buffType
end
function activity_9001565_Ctrl:isBuffEffect(buffType)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return false
	end
	local index = self:getBuffType()
	if 0 < index then
		local lv = self:getNowLvByBuffType(buffType)
		if lv > warOrderRead.getStarLvMax(self.activityID) then
			return false
		end
		local effectInfo = warOrderRead.getBuffInfo(self.activityID, buffType, index)
		if effectInfo then
			local oriLv = self:getInitBuildLv(buffType)
			if oriLv >= effectInfo.CastleLv[1] and oriLv <= effectInfo.CastleLv[2] then
				return true
			end
		end
	end
	return false
end
function activity_9001565_Ctrl:getUnlockBuffLv(...)
	return self.unlockLv
end
function activity_9001565_Ctrl:checkActivityCondition(...)
	return SoraDGetBuildStarLv() >= 54
end
function activity_9001565_Ctrl:getBuffVale(effectType)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		return 0
	end
	local value = 0
	local index = self:getBuffType()
	for _, buffType in pairs(BUILD_ENUM) do
		if 1 <= index and self:isBuffEffect(buffType) then
			local effectInfo = warOrderRead.getBuffInfo(self.activityID, buffType, index)
			if not effectInfo or not effectInfo.PrivilegeEffect then
				local _ENV, privilegeEffect = effectInfo.PrivilegeEffect, effectInfo.PrivilegeEffect
			end
			for _, v in ipairs(privilegeEffect) do
				if buffltCtrl:getEffectType(v) == effectType then
					local effect, _ = buffltCtrl:getEffect(v)
					value = value + effect
					print("activity_9001565_Ctrl:getBuffVale-3", effect, effectType, value, buffType, v)
					break
				end
			end
		end
	end
	return value
end
function activity_9001565_Ctrl:getGroupId()
	return self.initData.groupId or 1
end
return activity_9001565_Ctrl

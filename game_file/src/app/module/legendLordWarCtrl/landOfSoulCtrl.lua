local gamemodulec = include("GameModule")
local landOfSoulCtrl = class("landOfSoulCtrl", gamemodulec)
local msgCtrl = include("msgCtrl")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local armyltCtrl = include("armyltCtrl")
local landOfSoulRead = include("landOfSoulRead")
function landOfSoulCtrl:ctor(properties)
	landOfSoulCtrl.super.ctor(self, properties)
end
function landOfSoulCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LAND_OF_SOUL_MODULE, gCmd.REQ_SOUL_GET_DEAD_ARMY_LIST, handler(self, self.reqDeadArmyRsp))
	msgCtrl.register(gCmd.CMD_LAND_OF_SOUL_MODULE, gCmd.REQ_SOUL_SUMMON_DEAD_ARMY, handler(self, self.reqInvolkeRsp))
	self:resetData()
	self:reqDeadArmyList(gActivityTimeActivityID.LEGEND_LORD)
	self:reqDeadArmyList(gActivityTimeActivityID.KING_STAR_BATTLE)
	self:reqDeadArmyList(gActivityTimeActivityID.LEGEND_HEGEMON_1)
	self:reqDeadArmyList(gActivityTimeActivityID.LEGEND_LORD_9001646)
	self:reqDeadArmyList(gActivityTimeActivityID.LEGEND_LORD_9001647)
end
function landOfSoulCtrl:resetData()
	self.deadArmyData = nil
	self.cureArmyData = nil
	self.blessArmyData = nil
end
function landOfSoulCtrl:Logout()
	landOfSoulCtrl.super.Logout(self)
	self:resetData()
end
function landOfSoulCtrl:reqDeadArmyList(activityId)
	serverproxy = nil
	local (nil).activityId, data = activityId, nil
	serverproxy:Request(gCmd.CMD_LAND_OF_SOUL_MODULE, gCmd.REQ_SOUL_GET_DEAD_ARMY_LIST, data)
end
function landOfSoulCtrl:reqInvolkeDeadArmy(activityId, armyList)
	serverproxy = nil
	;(nil).activityId = activityId
	local (nil).armyList, data = armyList, nil
	serverproxy:Request(gCmd.CMD_LAND_OF_SOUL_MODULE, gCmd.REQ_SOUL_SUMMON_DEAD_ARMY, data)
end
function landOfSoulCtrl:reqDeadArmyRsp(content)
	dump(content, "landOfSoulCtrl:reqDeadArmyRsp", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		if not self.deadArmyData or rspdata.settleTime ~= 0 then
			self.deadArmyData = content.rspdata
		end
		_ENV = "landOfSoulCtrl:reqDeadArmyRsp"
		;("landOfSoulCtrl:reqDeadArmyRsp").msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_INIT"
		SoraDSendMessage("landOfSoulCtrl:reqDeadArmyRsp")
		_ENV = "landOfSoulCtrl:reqDeadArmyRsp"
		;("landOfSoulCtrl:reqDeadArmyRsp").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage("landOfSoulCtrl:reqDeadArmyRsp")
	end
end
function landOfSoulCtrl:reqInvolkeRsp(content)
	dump(content, "landOfSoulCtrl:reqInvolkeRsp", 10)
	if content.err == gErrDef.Err_None then
		self.deadArmyData = content.rspdata
		self.cureArmyData = content.data.armyList
		self.blessArmyData = content.rspdata.blessArmyList
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function landOfSoulCtrl:getDeadArmyList()
	local _UPVALUE0_, deadArmyList
	if self.deadArmyData and self.deadArmyData.deadArmyList then
		deadArmyList = self.deadArmyData.deadArmyList
	end
	return deadArmyList
end
function landOfSoulCtrl:getBlessValue()
	local bless = 0
	if self.deadArmyData and self.deadArmyData.belss then
		bless = self.deadArmyData.belss
	end
	return bless
end
function landOfSoulCtrl:getSoulRemainTime(activityID)
	local time = 0
	local constantTime = self:getLegendaryKingSoulTime(activityID)
	if self.deadArmyData and self.deadArmyData.settleTime then
		time = self.deadArmyData.settleTime + constantTime - serviceFunctions.systemTime()
	end
	return time
end
function landOfSoulCtrl:getLegendaryKingSoulTime(activityID)
	local constantRead = include("constantRead")
	local constantTime = constantRead.getConstValue("LEGENDARYKING_SOUL_TIME")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityID and (activityID == gActivityCenterUIEnum.LEGEND_HEGEMON or activityShowCtrl:isHegemonGroupID(activityID)) then
		constantTime = constantRead.getConstValue("LEGENDHEGEMON_SOUL_TIME")
	end
	return constantTime
end
function landOfSoulCtrl:getBlessArmyList()
	local _UPVALUE0_, blessArmyList
	if self.blessArmyData then
		blessArmyList = self.blessArmyData
	end
	return blessArmyList
end
function landOfSoulCtrl:getCureArmyList()
	local _UPVALUE0_, cureArmyList
	if self.cureArmyData then
		cureArmyList = self.cureArmyData
	end
	return cureArmyList
end
function landOfSoulCtrl:getDeadArmyIDList()
	local _ENV, armyIDList
	if self.deadArmyData and self.deadArmyData.deadArmyList then
		for k, v in pairs(self.deadArmyData.deadArmyList) do
			table.insert(armyIDList, k)
		end
	end
	return armyIDList
end
function landOfSoulCtrl:getRestoreNeedSoulNum(armyTable, activityID)
	if not armyTable then
		return 0
	end
	local needSoulNum = 0
	for armyId, num in pairs(armyTable) do
		local _, level = armyltCtrl.getArmyTypeAndLv(tonumber(armyId))
		local soulNum = landOfSoulRead:getNeedSoulNum(level)
		if activityID and activityID ~= gActivityTimeActivityID.LEGEND_LORD then
			if activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
				soulNum = landOfSoulRead:getNeedSoulNumKingStar(level)
			elseif activityID == gActivityTimeActivityID.LEGEND_LORD_9001646 or activityID == gActivityTimeActivityID.LEGEND_LORD_9001647 then
				soulNum = landOfSoulRead:getNeedSoulNumKingStar_new(level)
			else
				soulNum = landOfSoulRead:getNeedSoulNumHegemon(level)
			end
		end
		needSoulNum = needSoulNum + soulNum * num
	end
	return needSoulNum
end
function landOfSoulCtrl:getReceiveStatusAndNum(activityID)
	local bAward = false
	local num = -1
	local retShopRed = false
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local soulNum = backpackCtrl:getItemCount(723001)
	local deadArmyList = self:getDeadArmyList()
	local remainTime = self:getSoulRemainTime(activityID)
	if activityID and activityID == gActivityCenterUIEnum.LEGEND_HEGEMON then
		soulNum = backpackCtrl:getItemCount(725101)
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityID == gActivityTimeActivityID.LEGEND_LORD then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE or legendLordState == ACTIVITY_STATE.SETTLE then
			local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
			retShopRed = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.LEGEND_LORD)
			local legendStageRewardCtrl = SoraDGetCtrl("legendStageRewardCtrl")
			retShopRed = retShopRed or legendStageRewardCtrl:getReceiveStatusAndNum()
		end
	elseif activityID == gActivityTimeActivityID.KING_STAR_BATTLE then
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
		local legendLordState = param.curState
		if legendLordState == ACTIVITY_STATE.ACTIVE or legendLordState == ACTIVITY_STATE.SETTLE then
			local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
			retShopRed = activityExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.KING_STAR_BATTLE)
		end
	end
	if next(deadArmyList) and 0 < soulNum and 0 < remainTime or retShopRed then
		bAward = true
	end
	return bAward, num
end
function landOfSoulCtrl:getActivityRemainTime(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(activityID)
	local leftTime = 0
	if param.curState == ACTIVITY_STATE.ACTIVE then
		local constantTime = self:getLegendaryKingSoulTime(activityID)
		local endTime = param.timeConfig.settleTime
		leftTime = endTime + constantTime - serviceFunctions.systemTime()
	elseif param.curState == ACTIVITY_STATE.SETTLE then
		leftTime = self:getSoulRemainTime(activityID)
	end
	return leftTime
end
function landOfSoulCtrl:getActivityEndTime(activityID)
	local remainTime = self:getActivityRemainTime(activityID)
	return serviceFunctions.systemTime() + remainTime
end
return landOfSoulCtrl

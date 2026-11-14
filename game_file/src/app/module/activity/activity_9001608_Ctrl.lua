local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001608_Ctrl = class("activity_9001608_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001608_Ctrl:ctor(properties)
	activity_9001608_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_ACTIVITY
	self:resetData()
end
function activity_9001608_Ctrl:EnterGame()
end
function activity_9001608_Ctrl:Logout()
	activity_9001608_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001608_Ctrl:resetData()
end
function activity_9001608_Ctrl:getClassType(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	return activityShowCtrl:getParamClassType(self.activityID)
end
function activity_9001608_Ctrl:getReceiveStatusAndNum(activityID)
	if activityID == self.activityID then
		return self:getReceiveStatusAndNumAll()
	else
		local stringCtrl = string.format("activity_%d_Ctrl", activityID)
		local tempCtrl = SoraDGetCtrl(stringCtrl)
		if tempCtrl and tempCtrl.getReceiveStatusAndNum then
			return tempCtrl:getReceiveStatusAndNum(activityID)
		end
	end
	return false
end
function activity_9001608_Ctrl:getReceiveStatusAndNumAll()
	local retNum = 0
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityGroup = activityShowCtrl:getActivityGroup(self.activityID)
	for activityID, __ in pairs(activityGroup) do
		if clientEventMgr.judgeIsOpen(activityID) then
			local _ret, _retNum = self:getReceiveStatusAndNum(activityID)
			if _ret then
				if _retNum and 0 < _retNum then
					retNum = retNum + _retNum
				else
					retNum = retNum + 1
				end
			end
		end
	end
	return 0 < retNum, retNum
end
function activity_9001608_Ctrl:checkHonorBackTime(honorBackTime)
	if not honorBackTime then
		return false
	end
	local constantRead = include("constantRead")
	local ALLIANCE_RECOMMEND_TIME = constantRead.getConstValue("ALLIANCE_RECOMMEND_TIME", 30)
	if honorBackTime + ALLIANCE_RECOMMEND_TIME * 3600 * 24 > serviceFunctions.systemTime() then
		return true
	else
		return false
	end
end
function activity_9001608_Ctrl:getActivityEnemyShow(activityID)
	return true
end
function activity_9001608_Ctrl:isHonorBackActivity(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityGroup = activityShowCtrl:getActivityGroup(self.activityID)
	return activityGroup[activityID] or false
end
function activity_9001608_Ctrl:jumpHonorBackActivity(activityID)
	if uiManager:getProxy("Activity_9001608_Main") then
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001608_JUMP_ACTIVITY"
		uiManager.activityID = activityID
		SoraDSendMessage(uiManager)
	else
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("Activity_9001608_Main", nil)
	end
end
return activity_9001608_Ctrl

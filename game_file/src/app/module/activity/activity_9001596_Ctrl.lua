local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001596_Ctrl = class("activity_9001596_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001596_Read = include("activity_9001596_Read")
function activity_9001596_Ctrl:ctor(properties)
	activity_9001596_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RAMADAN_BUILD_SALYUT_ACTIVITY
	self:resetData()
end
function activity_9001596_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_BUILD_SALYUT_MERGE, handler(self, self.reqSalyutMergeRsp))
end
function activity_9001596_Ctrl:Logout()
	activity_9001596_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001596_Ctrl:resetData()
	self.processData, _UPVALUE0_ = nil, nil
end
function activity_9001596_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	if activityData and next(activityData) then
		self.processData = activityData.processData
		dump(self.processData, "==activity_9001596_Ctrl:initClientData==", 10)
	end
end
function activity_9001596_Ctrl:sendSalyutMerge(placeID)
	serverproxy = nil
	;(nil).placeID = placeID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_RAMADAN_BUILD_SALYUT_MERGE, nil)
end
function activity_9001596_Ctrl:reqSalyutMergeRsp(content)
	dump(content, "activity_9001596_Ctrl:reqSalyutMergeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.processData = content.rspdata.processData
		local rewards = content.rspdata.rewards
		if rewards and 0 < #rewards then
			SoraDMailGainItems(rewards, true)
		end
		_ENV = rewards
		rewards.msg = "MESSAGE_ACTIVITY_9001596_UPDATE"
		SoraDSendMessage(rewards)
	end
end
function activity_9001596_Ctrl:getReceiveStatusAndNum()
	local ret = false
	local num = 0
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	for k, v in pairs(activity_9001596_Read.partType) do
		if not self:isMerged(v) then
			local itemID = activity_9001596_Read.getPartID(v)
			local count = backpackCtrl:getItemCount(itemID)
			local need = activity_9001596_Read.getPartNum(v)
			if count >= need then
				ret = true
				num = num + 1
			end
		end
	end
	return ret, num
end
function activity_9001596_Ctrl:isMerged(part)
	return self.processData[tostring(part)] and true or false
end
return activity_9001596_Ctrl

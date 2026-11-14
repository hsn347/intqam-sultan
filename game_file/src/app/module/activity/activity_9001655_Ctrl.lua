local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001655_Ctrl = class("activity_9001655_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001655_Ctrl:ctor(properties)
	activity_9001655_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEW_STAR_MOON_TREASURE_ACTIVITY
	self:resetData()
end
function activity_9001655_Ctrl:EnterGame()
	msgCtrl.register(gCmd.REQ_NEW_STAR_MOON_TREASURE_MODULE, gCmd.REQ_NEW_STAR_MOON_TREASURE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.REQ_NEW_STAR_MOON_TREASURE_MODULE, gCmd.REQ_NEW_STAR_MOON_TREASURE_SEARCH, handler(self, self.reqSearchRsp))
end
function activity_9001655_Ctrl:Logout()
	activity_9001655_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001655_Ctrl:resetData()
	self.history, _UPVALUE0_, self.count = nil, nil, 0
end
function activity_9001655_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.REQ_NEW_STAR_MOON_TREASURE_MODULE, gCmd.REQ_NEW_STAR_MOON_TREASURE_INIT, nil)
end
function activity_9001655_Ctrl:reqSearchMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.REQ_NEW_STAR_MOON_TREASURE_MODULE, gCmd.REQ_NEW_STAR_MOON_TREASURE_SEARCH, nil)
end
function activity_9001655_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001655_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.count = content.rspdata.data.count
		self.history = content.rspdata.data.history
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001655_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001655_Ctrl:reqSearchRsp(content)
	dump(content, "activity_9001655_Ctrl:reqSearchRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local position
		local history = content.rspdata.data.history
		local historyMap = self:getHistoryMap()
		for k, v in ipairs(history) do
			if not historyMap[v] then
				position = v
				break
			end
		end
		self.count = content.rspdata.data.count
		self.history = history
		local rewards = content.rspdata.rewards
		if rewards and next(rewards) then
			SoraDPopGainItem(rewards.id, rewards.count)
		end
		_ENV = rewards.id
		rewards.id.msg = "MESSAGE_ACTIVITY_9001655_UPDATE"
		rewards.id.isSearch = true
		rewards.id.position = position
		SoraDSendMessage(rewards.id)
	end
end
function activity_9001655_Ctrl:getRound()
	return self.count + 1
end
function activity_9001655_Ctrl:getHistory()
	return self.history
end
function activity_9001655_Ctrl:getHistoryMap()
	local _ENV, historyMap
	for _, position in ipairs(self.history) do
		historyMap[position] = true
	end
	return historyMap
end
return activity_9001655_Ctrl

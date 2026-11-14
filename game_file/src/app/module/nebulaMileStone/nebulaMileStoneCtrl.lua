local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local nebulaMileStoneCtrl = class("nebulaMileStoneCtrl", GameModule)
local nebulaMileStoneRead = include("nebulaMileStoneRead")
function nebulaMileStoneCtrl:ctor(properties)
	nebulaMileStoneCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
end
function nebulaMileStoneCtrl:EnterGame()
	print("nebulaMileStoneCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_NEBUL_APALACE_MILESTONE_MODULE, gCmd.REQ_NEBUL_APALACE_MILESTONE_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_NEBUL_APALACE_MILESTONE_MODULE, gCmd.REQ_NEBUL_APALACE_MILESTONE_RECEIVE, handler(self, self.sendreceiveRsp))
	self:resetData()
	self:registerNotify()
end
function nebulaMileStoneCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEBULA_MILE_STONE, handler(self, self.notifyHandler))
end
function nebulaMileStoneCtrl:notifyHandler(event)
	dump(event.data, "nebulaMileStoneCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
	end
end
function nebulaMileStoneCtrl:initClientData(data)
	dump(data, "nebulaMileStoneCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function nebulaMileStoneCtrl:Logout()
	self:resetData()
	nebulaMileStoneCtrl.super.Logout(self)
end
function nebulaMileStoneCtrl:resetData()
	self.data = nil
	self.buffList = nil
	self.skillList = nil
end
function nebulaMileStoneCtrl:setData(data)
	self.data = data
	if self.data then
		dump(self.data.plusData, "nebulaMileStoneCtrl:setData", 10)
	end
end
function nebulaMileStoneCtrl:sendDataMsg()
	serverproxy:Request(gCmd.CMD_NEBUL_APALACE_MILESTONE_MODULE, gCmd.REQ_NEBUL_APALACE_MILESTONE_INIT)
end
function nebulaMileStoneCtrl:sendreceive(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_NEBUL_APALACE_MILESTONE_MODULE, gCmd.REQ_NEBUL_APALACE_MILESTONE_RECEIVE, nil)
end
function nebulaMileStoneCtrl:sendReqInitRsp(content)
	dump(content, "nebulaMileStoneCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_UPDATE_BASE"
		SoraDSendMessage(self)
		return
	end
end
_ENV, nebulaMileStoneCtrl.sendreceiveRsp = function(self, content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end, function(self, content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
;(function(self, content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end)[gNebulaMileStoneUnlockType.GLORIOUS_STATUE_LEVEL_MAX] = gTechnologyType.TECH_GLORIOUS_STATUE_LEVEL_MAX
local (function(self, content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end)[gNebulaMileStoneUnlockType.LORD_LEVEL_MAX], type2Tech = gTechnologyType.TECH_LORD_LEVEL_MAX, function(self, content)
	dump(content, "==sendreceiveRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_NEBULA_MILESTONE"
		self.subMsg = "init"
		SoraDSendMessage(self)
		return
	end
end
function nebulaMileStoneCtrl:getPlusByUnlockType(unlockType, level, kid)
	local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
	local ret2 = activity_9001656_Ctrl:getPlusByUnlockType(unlockType, level)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local kid = kid or lordInfoCtrl:getMapSourceKid()
	local key = tostring(kid) .. "_" .. tostring(unlockType)
	local ret = self.data and self.data.plusData[key]
	if ret2 and not ret then
		_ENV = tostring(unlockType)
		ret, tostring(unlockType).value = tostring(unlockType), ret2
	end
	if type2Tech[unlockType] == nil then
		local value1 = type(ret) == "table" and tonumber(ret.value) or ret
		return value1, ret
	end
	local value1 = self.data and type(ret) == "table" and tonumber(ret.value) or 0
	local value2 = level and level or 0
	local technologyCtrl = SoraDGetCtrl("technologyCtrl")
	local effectType = unlockType and type2Tech[unlockType]
	if effectType then
		value2 = value2 + technologyCtrl:getTechnologyPower(effectType)
	end
	return math.max(value1, value2, ret2)
end
function nebulaMileStoneCtrl:getPlusByUnlockTypeEx(unlockType, level, kid)
	local nebulaMileStoneLimit
	local tmp, nebulaMileStoneData = self:getPlusByUnlockType(unlockType, level, kid)
	if nebulaMileStoneData and nebulaMileStoneData.value2 and nebulaMileStoneData.value2 ~= 0 then
		nebulaMileStoneLimit = nebulaMileStoneData.value2
	else
		nebulaMileStoneLimit = nebulaMileStoneData and nebulaMileStoneData.value or 0
	end
	return nebulaMileStoneLimit
end
function nebulaMileStoneCtrl:getMileStoneDatas()
	return self.data and self.data.mileStoneData.totalTaskData or nil
end
function nebulaMileStoneCtrl:getTaskData(taskID)
	if not self.data or not self.data.mileStoneData.totalTaskData then
		return
	end
	for k, v in pairs(self.data.mileStoneData.totalTaskData) do
		if v.taskID == taskID then
			return v
		end
	end
	return nil
end
function nebulaMileStoneCtrl:getIsRewardGot(taskID)
	if not self.data then
		return false
	end
	return self.data.record[tostring(taskID)] or false
end
function nebulaMileStoneCtrl:getCanGetRewardNum()
	do return 0 end
	local mileStoneDatas = self:getMileStoneDatas()
	if mileStoneDatas == nil then
		return 0
	end
	local num = 0
	for k, v in pairs(mileStoneDatas) do
		if (v.status == "end" or v.status == "begin") and v.curCompleteTime ~= 0 and not self:getIsRewardGot(v.taskID) then
			num = num + 1
		end
	end
	return num
end
function nebulaMileStoneCtrl:getIsTaskBeginTime(taskID)
	local taskData = self:getTaskData(taskID)
	if taskData == nil then
		return 0
	end
	return taskData.begin_timestamp
end
function nebulaMileStoneCtrl:getCurSeason()
	return self.data and self.data.mileStoneData.season
end
return nebulaMileStoneCtrl

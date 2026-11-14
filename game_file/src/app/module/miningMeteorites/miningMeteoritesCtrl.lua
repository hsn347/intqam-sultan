local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local miningMeteoritesCtrl = class("miningMeteoritesCtrl", GameModule)
function miningMeteoritesCtrl:ctor(properties)
	miningMeteoritesCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MINING_METEORITES_ACTIVITY
end
function miningMeteoritesCtrl:EnterGame()
	print("miningMeteoritesCtrl:EnterGame")
	msgCtrl.register(gCmd.CMD_MINING_METEORITES_MODULE, gCmd.REQ_MINING_METEORITES_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_MINING_METEORITES_MODULE, gCmd.REQ_MINING_METEORITES_CHOICE, handler(self, self.sendChoiceRsp))
	msgCtrl.register(gCmd.CMD_MINING_METEORITES_MODULE, gCmd.REQ_MINING_METEORITES_MINING, handler(self, self.sendMiningRsp))
	self:resetData()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.onLoginFinish))
end
function miningMeteoritesCtrl:onLoginFinish()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:sendReqInitDataMsg()
	end
end
function miningMeteoritesCtrl:initClientData(data)
	dump(data, "miningMeteoritesCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function miningMeteoritesCtrl:Logout()
	self:resetData()
	miningMeteoritesCtrl.super.Logout(self)
end
function miningMeteoritesCtrl:resetData()
	self.openCount = 0
end
function miningMeteoritesCtrl:setData(data)
	self.groupData = data.groupData and data.groupData or self.groupData
	self.openCount = data.openCount and data.openCount or self.openCount
end
function miningMeteoritesCtrl:sendReqInitDataMsg()
	print("miningMeteoritesCtrl:sendReqInitDataMsg")
	serverproxy:Request(gCmd.CMD_MINING_METEORITES_MODULE, gCmd.REQ_MINING_METEORITES_INIT)
end
function miningMeteoritesCtrl:sendChoice(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_MINING_METEORITES_MODULE, gCmd.REQ_MINING_METEORITES_CHOICE, nil)
end
function miningMeteoritesCtrl:sendMining(type, time)
	serverproxy = nil
	;(nil).type = type
	;(nil).time = time
	serverproxy:Request(gCmd.CMD_MINING_METEORITES_MODULE, gCmd.REQ_MINING_METEORITES_MINING, nil)
end
function miningMeteoritesCtrl:sendReqInitRsp(content)
	dump(content, "miningMeteoritesCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_MINING_METEORITES"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		return
	end
end
function miningMeteoritesCtrl:sendChoiceRsp(content)
	dump(content, "==sendChoiceRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_UPDATE_MINING_METEORITES"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		return
	end
end
function miningMeteoritesCtrl:sendMiningRsp(content)
	dump(content, "==sendMiningRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		local curIdx = tostring(content.data.type)
		if not self.groupData[curIdx] then
			self.groupData[curIdx], _ENV = 20, 20
		end
		self.groupData[curIdx].curScore = data.curScore
		self.groupData[curIdx].curStage = data.curStage
		_ENV = data.curStage
		data.curStage.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		data.curStage.eventID = self.activityID
		SoraDSendMessage(data.curStage)
		_ENV = data.curStage
		data.curStage.msg = "MESSAGE_MINING_METEORITES_REWARD"
		data.curStage.rewards = data
		SoraDSendMessage(data.curStage)
		return
	end
end
function miningMeteoritesCtrl:getCurScore(index)
	return self.groupData[tostring(index)] and self.groupData[tostring(index)].curScore or 0
end
function miningMeteoritesCtrl:getCurStage(index)
	return self.groupData[tostring(index)] and self.groupData[tostring(index)].curStage or 1
end
function miningMeteoritesCtrl:getOpenCount()
	return self.openCount
end
function miningMeteoritesCtrl:getGroupData()
	return self.groupData
end
function miningMeteoritesCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local num = backpackCtrl:getItemCount(847901)
	local num2 = backpackCtrl:getItemCount(855501)
	return 0 < num or 0 < num2, -1
end
return miningMeteoritesCtrl

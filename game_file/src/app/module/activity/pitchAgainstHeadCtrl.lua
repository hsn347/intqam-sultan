local GameModule = include("GameModule")
local pitchAgainstHeadCtrl = class("pitchAgainstHeadCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function pitchAgainstHeadCtrl:ctor(properties)
	pitchAgainstHeadCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.PITCH_AGAINST_HEAD_ACTIVITY
end
function pitchAgainstHeadCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PITCH_AGAINST_HEAD_MODULE, gCmd.REQ_PITCH_AGAINST_HEAD_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_PITCH_AGAINST_HEAD_MODULE, gCmd.REQ_PITCH_AGAINST_HEAD_DRAW, handler(self, self.reqDrawRsp))
	msgCtrl.register(gCmd.CMD_PITCH_AGAINST_HEAD_MODULE, gCmd.REQ_PITCH_AGAINST_HEAD_RESET, handler(self, self.reqResetRsp))
	self:resetData()
end
function pitchAgainstHeadCtrl:resetData()
	self.classType = 1
	self.cellList, (nil)["2"], _UPVALUE0_, (nil)["1"], _UPVALUE0_, _UPVALUE0_, self.openCount = nil, nil, nil, nil, nil, nil, 1
end
function pitchAgainstHeadCtrl:initClientData(data)
	dump(data, "pitchAgainstHeadCtrl:initClientData====")
end
function pitchAgainstHeadCtrl:sendInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PITCH_AGAINST_HEAD_MODULE, gCmd.REQ_PITCH_AGAINST_HEAD_INIT, nil)
end
function pitchAgainstHeadCtrl:sendDraw(_type, _index)
	serverproxy = nil
	;(nil).type = _type
	;(nil).index = _index
	serverproxy:Request(gCmd.CMD_PITCH_AGAINST_HEAD_MODULE, gCmd.REQ_PITCH_AGAINST_HEAD_DRAW, nil)
end
function pitchAgainstHeadCtrl:sendReset()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PITCH_AGAINST_HEAD_MODULE, gCmd.REQ_PITCH_AGAINST_HEAD_RESET, nil)
end
function pitchAgainstHeadCtrl:reqInitRsp(content)
	dump(content, "==pitchAgainstHeadCtrl:reqInitRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.classType = content.rspdata.classType
		self.openCount = content.rspdata.openCount
		self.cellList = content.rspdata.cellList
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_PITCHAGAINST_UPDATE"
	gErrDef.Err_None.isInit = true
	SoraDSendMessage(gErrDef.Err_None)
end
function pitchAgainstHeadCtrl:reqDrawRsp(content)
	dump(content, "==pitchAgainstHeadCtrl:reqDrawRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.cellList = content.rspdata.cellList
		local reward = content.rspdata.reward
		local exReward = content.rspdata.exReward
		if reward and next(reward) and exReward and next(exReward) then
			local _ENV, itemArray = next(exReward), next(exReward)
			_ENV = nil
			;(nil).id = reward.id
			;(nil).count = reward.count
			table.insert(itemArray, nil)
			_ENV = nil
			;(nil).id = exReward.id
			;(nil).count = exReward.count
			table.insert(itemArray, nil)
			SoraDMailGainItems(itemArray, true)
		else
			if reward and next(reward) then
				SoraDPopGainItem(reward.id, reward.count)
			end
			if exReward and next(exReward) then
				SoraDPopGainItem(exReward.id, exReward.count)
			end
		end
	end
	_ENV = content.rspdata.exReward
	content.rspdata.exReward.msg = "MESSAGE_ACTIVITY_PITCHAGAINST_UPDATE"
	content.rspdata.exReward.index = content.data.index
	content.rspdata.exReward.cType = content.data.type
	SoraDSendMessage(content.rspdata.exReward)
end
function pitchAgainstHeadCtrl:reqResetRsp(content)
	dump(content, "==pitchAgainstHeadCtrl:reqResetRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.cellList, content.err["2"], _ENV, content.err["1"], _ENV, _ENV = content.err, gErrDef.Err_None, gErrDef.Err_None, gErrDef.Err_None, gErrDef.Err_None, content.err
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_PITCHAGAINST_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function pitchAgainstHeadCtrl:getCellInfo(_type, _index)
	return self.cellList[tostring(_type)] and self.cellList[tostring(_type)][_index]
end
function pitchAgainstHeadCtrl:isAwardPitch(_type, _index)
	if self.cellList[tostring(_type)] and self.cellList[tostring(_type)][_index] then
		local target = self.cellList[tostring(_type)][_index][1]
		local ret = false
		for i = 1, 10 do
			if self.cellList[tostring(3 - _type)][i] and self.cellList[tostring(3 - _type)][i][1] == target then
				ret = true
				break
			end
		end
		return ret
	else
		return false
	end
end
function pitchAgainstHeadCtrl:isAllShow(_type)
	local ret = true
	for i = 1, 10 do
		if not self.cellList[tostring(_type)][i] then
			ret = false
			break
		end
	end
	return ret
end
function pitchAgainstHeadCtrl:getDrawIndex(_type)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local _ENV, array = math.randomseed, math.randomseed
	for i = 1, 10 do
		if not self.cellList[tostring(_type)][i] then
			table.insert(array, i)
		end
	end
	local rIndex = math.random(#array)
	dump(array, "array===" .. rIndex)
	return array[rIndex]
end
return pitchAgainstHeadCtrl

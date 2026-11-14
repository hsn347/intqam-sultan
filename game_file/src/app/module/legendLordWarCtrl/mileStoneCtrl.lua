local GameModule = include("GameModule")
local mileStoneCtrl = class("mileStoneCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local legendMDesRead = include("legendMDesRead")
function mileStoneCtrl:ctor(properties)
	mileStoneCtrl.super.ctor(self, properties)
end
function mileStoneCtrl:EnterGame()
	print("mileStoneCtrl:EnterGame()---")
	mileStoneCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_MILE_STONE_MODULE, gCmd.REQ_MILE_STONE_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_MILE_STONE_MODULE, gCmd.REQ_MILE_STONE_RECEIVE, handler(self, self.reqRewardRsp))
	self:resetData()
	self:registerNotify()
end
function mileStoneCtrl:resetData()
	self.personData, _UPVALUE0_, self.mileStoneData, _UPVALUE0_ = nil, nil, nil, nil
end
function mileStoneCtrl:Logout()
	self:resetData()
	mileStoneCtrl.super.Logout(self)
end
function mileStoneCtrl:initClientData(retdata)
	dump(retdata, "mileStoneCtrl:initClientData", 10)
	if retdata then
		self.mileStoneData = retdata.mileStoneData
		self.personData = retdata.personData
	end
end
function mileStoneCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MILE_STONE, handler(self, self.noitfyDataRsp))
end
function mileStoneCtrl:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "mileStoneCtrl:noitfyDataRsp(content)@@@", 10)
	for _, notifyMsg in ipairs(notifydata) do
		self.mileStoneData = notifyMsg.mileStoneData
		self.personData = notifyMsg.personData
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_LEGENDM_MILESTONE_INIT_BACK"
	ipairs(notifydata).pageType = legendMDesRead.PageType.MILESTONE
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(ipairs(notifydata))
end
function mileStoneCtrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MILE_STONE_MODULE, gCmd.REQ_MILE_STONE_INIT, nil)
end
function mileStoneCtrl:reqReward(taskID)
	serverproxy = nil
	;(nil).taskID = taskID
	serverproxy:Request(gCmd.CMD_MILE_STONE_MODULE, gCmd.REQ_MILE_STONE_RECEIVE, nil)
end
function mileStoneCtrl:reqInitDataRsp(ret)
	dump(ret, "mileStoneCtrl:reqInitDataRsp(ret)", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.mileStoneData = ret.rspdata.mileStoneData
		self.personData = ret.rspdata.personData
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDM_MILESTONE_INIT_BACK"
	gErrDef.Err_None.pageType = legendMDesRead.PageType.MILESTONE
	SoraDSendMessage(gErrDef.Err_None)
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(gErrDef.Err_None)
end
function mileStoneCtrl:reqRewardRsp(ret)
	dump(ret, "mileStoneCtrl:reqRewardRsp(ret)", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.mileStoneData = ret.rspdata.mileStoneData
		self.personData = ret.rspdata.personData
		local reward = ret.rspdata.reward
		SoraDMailGainItems(reward, true)
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_LEGENDM_MILESTONE_REWARD_BACK"
	SoraDMailGainItems.pageType = legendMDesRead.PageType.MILESTONE
	SoraDSendMessage(SoraDMailGainItems)
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(SoraDMailGainItems)
end
function mileStoneCtrl:getMileStoneData()
	return self.mileStoneData
end
function mileStoneCtrl:getPersonData()
	return self.personData
end
function mileStoneCtrl:getCurTask()
	return self.mileStoneData.curTaskID
end
function mileStoneCtrl:getTaskData(id)
	return self.mileStoneData.completeData[tostring(id)]
end
function mileStoneCtrl:isRewarded(id)
	return self.personData.record[tostring(id)] ~= nil
end
function mileStoneCtrl:isHaveGift()
	local ret = false
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownAid = tostring(allianceMgr:getOwnAid())
	for k, v in pairs(self.mileStoneData.completeData) do
		if v.completeTime and v.completeTime > 0 and not self.personData.record[k] then
			if v.finishAids and v.finishAids[ownAid] and v.finishAids[ownAid] >= v.target then
				ret = true
				break
			end
			if not v.finishAids then
				ret = true
			end
			break
		end
	end
	return ret
end
return mileStoneCtrl

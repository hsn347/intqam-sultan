local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001631_Ctrl = class("activity_9001631_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001631_Ctrl:ctor(properties)
	activity_9001631_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.PREPARING_FEAST_2024
	self:resetData()
end
function activity_9001631_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PREPARING_FEAST_2024_MODULE, gCmd.REQ_PREPARING_FEAST_2024_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_PREPARING_FEAST_2024_MODULE, gCmd.REQ_PREPARING_FEAST_2024_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	self:registerNotify()
end
function activity_9001631_Ctrl:Logout()
	activity_9001631_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001631_Ctrl:resetData()
	_UPVALUE0_ = nil
	_UPVALUE0_, (nil).allianceScore = nil, 0
	;(nil).opencount = 0
	self.initData, (nil).data, (nil).questData, _UPVALUE0_, (nil).questIds, _UPVALUE0_, (nil).classtype = nil, nil, nil, nil, nil, nil, 1
end
function activity_9001631_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PREPARING_FEAST_2024, handler(self, self.notifyHandler))
end
function activity_9001631_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001631_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self:updateQuestData(v)
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_9001631_UPDATE"
		SoraDSendMessage(self)
	end
end
function activity_9001631_Ctrl:updateQuestData(data)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local questComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
	questComponent:setQuestData(data.questData)
end
function activity_9001631_Ctrl:sendReqInitDataMsg(...)
	self:reqData()
end
function activity_9001631_Ctrl:reqData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PREPARING_FEAST_2024_MODULE, gCmd.REQ_PREPARING_FEAST_2024_DATA, nil)
end
function activity_9001631_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001631_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:updateQuestData(content.rspdata.data)
		self.initData.allianceScore = content.rspdata.allianceScore
		_ENV = content.rspdata.allianceScore
		content.rspdata.allianceScore.msg = "MESSAGE_ACTIVITY_9001631_UPDATE"
		content.rspdata.allianceScore.subMsg = "score"
		SoraDSendMessage(content.rspdata.allianceScore)
	end
end
function activity_9001631_Ctrl:reqTaskReward(questID)
	serverproxy = nil
	;(nil).questID = questID
	serverproxy:Request(gCmd.CMD_PREPARING_FEAST_2024_MODULE, gCmd.REQ_PREPARING_FEAST_2024_TASK_REWARD, nil)
end
function activity_9001631_Ctrl:reqTaskRewardRsp(content)
	dump(content, "activity_9001631_Ctrl:reqTaskRewardRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local allianceMgr = SoraDGetCtrl("allianceMgr")
		local reward = content.rspdata.reward
		if reward then
			if allianceMgr:hasJoinAlliance() then
				SoraDMailGainItems(reward, true)
			else
				local _ENV, temp = SoraDMailGainItems, SoraDMailGainItems
				for __, v in ipairs(reward) do
					if v.id ~= gIDDef.PREPARING_FEAST_2024_SCORE then
						table.insert(temp, v)
					end
				end
				SoraDMailGainItems(temp, true)
			end
		end
		self:updateQuestData(content.rspdata.data)
		local allianceScore = content.rspdata.allianceScore
		if allianceMgr:hasJoinAlliance() and reward then
			for __, v in ipairs(reward) do
				if v.id == gIDDef.PREPARING_FEAST_2024_SCORE then
					allianceScore = allianceScore + v.count
				end
			end
		end
		self.initData.allianceScore = allianceScore
		_ENV = ipairs(reward)
		ipairs(reward).msg = "MESSAGE_ACTIVITY_9001631_UPDATE"
		SoraDSendMessage(ipairs(reward))
	end
end
function activity_9001631_Ctrl:getAllianceScore(...)
	return self.initData.allianceScore or 0
end
return activity_9001631_Ctrl

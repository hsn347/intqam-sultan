local gametop = gModuleMgr.getObject("gametop")
local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local activityTaskComponentCtrl = class("activityTaskComponentCtrl", gamemodulec)
function activityTaskComponentCtrl:ctor(properties)
	activityTaskComponentCtrl.super.ctor(self, properties)
	self.questComponentMap, activityTaskComponentCtrl = activityTaskComponentCtrl.super.ctor, activityTaskComponentCtrl.super.ctor
	self:resetData()
end
function activityTaskComponentCtrl:resetData()
	for _, v in pairs(self.questComponentMap) do
		if v.resetData then
			v:resetData()
		end
	end
end
function activityTaskComponentCtrl:resetActivityData(activityID)
	local questComponent = self.questComponentMap[tostring(activityID)]
	if questComponent then
		questComponent:resetData()
	end
end
function activityTaskComponentCtrl:Logout()
	activityTaskComponentCtrl.super.Logout(self)
	self:resetData()
	self.questComponentMap, activityTaskComponentCtrl = self.resetData, self.resetData
end
function activityTaskComponentCtrl:EnterGame()
	local msgCtrl = include("msgCtrl")
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ACTIVITY_CLAIM_REWARD, handler(self, self.reqRuestClaimRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_PUMPKIN_ACTIVITY_RECEIVE, handler(self, self.sendReqGetRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WISH_REBATE_GET_WISH_REWARD, handler(self, self.sendReqGetWishStageRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WISH_REBATE_GET_EXPLOSIVE_REWARD, handler(self, self.sendReqGetWishStageRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WISH_REBATE_GET_STAGE_REWARD, handler(self, self.sendReqGetWishStageRewardRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ACTIVITY_INIT_DATA, handler(self, self.sendReqInitRsp))
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.noitfyDataRsp))
	self:sendReqInit()
end
function activityTaskComponentCtrl:getQuestComponent(activityID)
	if self.questComponentMap[tostring(activityID)] then
		return self.questComponentMap[tostring(activityID)]
	else
		local questComponent = self:createQuestComponent(activityID)
		self.questComponentMap[tostring(activityID)] = questComponent
		return self.questComponentMap[tostring(activityID)]
	end
end
function activityTaskComponentCtrl:createQuestComponent(activityID)
	local activityTaskComponent = include("activityTaskComponent")
	local questComponent = activityTaskComponent.new()
	questComponent:setActivityID(activityID)
	return questComponent
end
function activityTaskComponentCtrl:getQuestData(activityID)
	local questComponent = self:getQuestComponent(activityID)
	if questComponent then
		return questComponent:getQuestData()
	end
end
function activityTaskComponentCtrl:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "activityTaskComponentCtrl:noitfyDataRsp")
	for _, notifyMsg in ipairs(notifydata) do
		local notifyType = notifyMsg.notifyType
		local notifyData = notifyMsg.notifyData
		local notifyFunc = "onNotify_" .. notifyType
		local activityID = notifyMsg.activityID
		local questComponent = self:getQuestComponent(activityID)
		if questComponent and questComponent[notifyFunc] then
			questComponent[notifyFunc](self, notifyData)
		end
		if not self[notifyFunc] then
		else
			self[notifyFunc](self, notifyData, activityID)
		end
		_ENV = self
		self.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_QUEST_DATA"
		self.activityID = tonumber(activityID)
		self.notifyMsg = notifyMsg
		SoraDSendMessage(self)
	end
end
function activityTaskComponentCtrl:onNotify_updateData(content, activityID)
	if not self.userActivityModule[tostring(activityID)] then
		local _ENV, activityIDInfo = self.userActivityModule[tostring(activityID)], self.userActivityModule[tostring(activityID)]
	end
	for key, value in pairs(content) do
		activityIDInfo[key] = value
	end
	self.userActivityModule[tostring(activityID)] = activityIDInfo
	_ENV = tostring(activityID)
	tostring(activityID).msg = "MESSAGE_ACTIVITY_MODULE_INIT"
	tostring(activityID).activityID = tonumber(activityID)
	tostring(activityID).updateData = content
	tostring(activityID).initData = content
	SoraDSendMessage((tostring(activityID)))
end
function activityTaskComponentCtrl:onNotify_progressUpdate(notifyData)
	if not notifyData or not notifyData.activityID then
		return
	end
	local questComponent = self:getQuestComponent(tonumber(notifyData.activityID))
	if questComponent and questComponent.onNotify_progressUpdate then
		questComponent:onNotify_progressUpdate(notifyData)
	end
end
function activityTaskComponentCtrl:onNotify_reset(notifyData)
	if not notifyData or not notifyData.activityID then
		return
	end
	if notifyData.activityID == gActivityTimeActivityID.GLORY_ROAD_ACTIVITY and not SoraDGetCtrl("roadToGloryCtrl"):isResetEveryday() then
		return
	end
	if notifyData.activityID == gActivityTimeActivityID.CHANGE_DAY_ACTIVITY and not SoraDGetCtrl("newDayTaskCtrl"):isResetEveryday() then
		return
	end
	if notifyData.activityID == gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY and not SoraDGetCtrl("cavalryRiseCtrl"):isResetEveryday() then
		return
	end
	if notifyData.activityID == gActivityTimeActivityID.IRON_BLOOD_ACTIVITY and not SoraDGetCtrl("bloodyHeroesCtrl"):isResetEveryday() then
		return
	end
	local questComponent = self:getQuestComponent(tonumber(notifyData.activityID))
	if questComponent and questComponent.onNotify_reset then
		questComponent:onNotify_reset(notifyData)
	end
end
function activityTaskComponentCtrl:reqRuestClaimRewardRsp(ret)
	dump(ret, "activityTaskComponentCtrl:reqRuestClaimRewardRsp")
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		local activityID = ret.rspdata.activityID
		local questComponent = self:getQuestComponent(tonumber(activityID))
		if questComponent and questComponent.reqRuestClaimRewardRsp then
			questComponent:reqRuestClaimRewardRsp(ret)
		end
		_ENV = questComponent
		questComponent.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		questComponent.eventID = activityID
		SoraDSendMessage(questComponent)
	end
end
function activityTaskComponentCtrl:initClientData(userActivityModule)

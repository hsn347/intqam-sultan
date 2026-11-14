local GameModule = include("GameModule")
local weaponSprctrumCtrl = class("weaponSprctrumCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function weaponSprctrumCtrl:ctor(properties)
	weaponSprctrumCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
end
function weaponSprctrumCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WEAPON_SPECTRUM_THEME_REWARD, handler(self, self.reqWeaponThemeRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WEAPON_SPECTRUM_FINAL_REWARD, handler(self, self.reqWeaponFinalRsp))
	self:resetData()
	self:registerNotify()
end
function weaponSprctrumCtrl:resetData()
	self.themeReward, _UPVALUE0_ = nil, nil
	self.weaponPoint = 0
	self.questData, _UPVALUE0_, self.finalRewardFlag = nil, nil, false
end
function weaponSprctrumCtrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self:setActivityData(data[tostring(self.activityID)])
	end
end
function weaponSprctrumCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.USER_ACTIVITY, handler(self, self.notifyHandler))
end
function weaponSprctrumCtrl:notifyHandler(content)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		local activityID = notifyMsg.activityID
		if tonumber(activityID) ~= self.activityID then
			return
		end
		self:setActivityData(notifyMsg.notifyData)
		if notifyMsg.notifyType == "progressUpdate" then
			local questComponent = activityTaskComponentCtrl:getQuestComponent(self.activityID)
			questComponent:onNotify_progressUpdate(notifyMsg.notifyData)
		end
		_ENV = questComponent.onNotify_progressUpdate
		questComponent.onNotify_progressUpdate.msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
		questComponent.onNotify_progressUpdate.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
		SoraDSendMessage(questComponent.onNotify_progressUpdate)
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = gActivityTimeActivityID.EQUIP_ACTIVITY
	SoraDSendMessage(ipairs(notifydata))
end
function weaponSprctrumCtrl:setActivityData(activityData)
	if not activityData then
		return
	end
	if activityData.themeReward then
		self.themeReward = activityData.themeReward
	end
	if activityData.weaponPoint then
		self.weaponPoint = activityData.weaponPoint
	end
	if activityData.finalRewardFlag then
		self.finalRewardFlag = activityData.finalRewardFlag
	end
	if activityData.questData then
		self.questData = activityData.questData
	end
end
function weaponSprctrumCtrl:getClaimStatus(eType)
	local ret = false
	if self.themeReward[tostring(eType)] and serviceFunctions.isSameDay(self.themeReward[tostring(eType)]) then
		ret = true
	end
	return ret
end
function weaponSprctrumCtrl:getWeaponPoint()
	return self.weaponPoint
end
function weaponSprctrumCtrl:isFinalRewardReceived()
	return self.finalRewardFlag
end
function weaponSprctrumCtrl:isTypeRewardReceived(eType)
	return self.themeReward[tostring(eType)]
end
function weaponSprctrumCtrl:getTypeQuestClaimNum(eType)
	local weaponSprctrumRead = include("weaponSprctrumRead")
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	local questList = weaponSprctrumRead.getTypeTask(eType)
	local retNum = 0
	for k, v in ipairs(questList) do
		if questData and questData.finishedQuest[tostring(v.questID)] and not questData.claimedQuest[tostring(v.questID)] then
			retNum = retNum + 1
		end
	end
	return retNum
end
function weaponSprctrumCtrl:getTypeQuestFinishNum(eType)
	local weaponSprctrumRead = include("weaponSprctrumRead")
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	local questList = weaponSprctrumRead.getTypeTask(eType)
	local retNum = 0
	for k, v in ipairs(questList) do
		if questData and questData.finishedQuest[tostring(v.questID)] then
			retNum = retNum + 1
		end
	end
	return retNum
end
function weaponSprctrumCtrl:getReceiveStatusAndNum()
	local retNum = 0
	for k, v in pairs(gWeaponTaskType) do
		local typeNum = self:getTypeQuestClaimNum(v)
		retNum = retNum + typeNum
	end
	for k, v in pairs(gWeaponTaskType) do
		local cur = self:getTypeQuestFinishNum(v)
		if 4 <= cur and not self:getClaimStatus(v) then
			retNum = retNum + 1
			print("主题奖励======", 1)
		end
	end
	local weaponSprctrumRead = include("weaponSprctrumRead")
	if not self.finalRewardFlag and self.weaponPoint >= weaponSprctrumRead.getFinalRewardNum() then
		retNum = retNum + 1
		print("终极大奖======", 1)
	end
	return 0 < retNum, retNum
end
function weaponSprctrumCtrl:sendReqGetWeaponThemeReward(eType)
	serverproxy = nil
	;(nil).type = eType
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WEAPON_SPECTRUM_THEME_REWARD, nil)
end
function weaponSprctrumCtrl:sendReqGetWeaponFinalReward(data)
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_WEAPON_SPECTRUM_FINAL_REWARD)
end
function weaponSprctrumCtrl:reqWeaponThemeRsp(content)
	dump(content, "==weaponSprctrumCtrl:reqWeaponThemeRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.initdata
		self.finalRewardFlag = data.finalRewardFlag
		self.questData = data.questData
		self.themeReward = data.themeReward
		self.weaponPoint = data.weaponPoint
		local weaponSprctrumRead = include("weaponSprctrumRead")
		local reward = weaponSprctrumRead.getTypeReward(tonumber(content.data.type))
		_UPVALUE2_ = tonumber(content.data.type)
		tonumber(content.data.type)[1] = "id"
		tonumber(content.data.type)[2] = "count"
		local rewardList = serviceFunctions.tableFormat(reward, tonumber(content.data.type))
		SoraDMailGainItems(rewardList, true)
		SoraDShowMsgTip(i18n("spectrum_text_04"))
		_ENV = i18n("spectrum_text_04")
		i18n("spectrum_text_04").msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		i18n("spectrum_text_04").activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
		SoraDSendMessage(i18n("spectrum_text_04"))
		_ENV = i18n("spectrum_text_04")
		i18n("spectrum_text_04").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		i18n("spectrum_text_04").eventID = gActivityTimeActivityID.EQUIP_ACTIVITY
		SoraDSendMessage(i18n("spectrum_text_04"))
	end
end
function weaponSprctrumCtrl:reqWeaponFinalRsp(content)
	dump(content, "==weaponSprctrumCtrl:reqWeaponFinalRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.initdata
		self.finalRewardFlag = data.finalRewardFlag
		self.questData = data.questData
		self.themeReward = data.themeReward
		self.weaponPoint = data.weaponPoint
		local weaponSprctrumRead = include("weaponSprctrumRead")
		local reward = weaponSprctrumRead.getFinalReward()
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		local rewardList = serviceFunctions.tableFormat(reward, nil)
		SoraDMailGainItems(rewardList, true)
		_ENV = rewardList
		rewardList.msg = "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD"
		rewardList.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
		SoraDSendMessage(rewardList)
		_ENV = rewardList
		rewardList.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		rewardList.eventID = gActivityTimeActivityID.EQUIP_ACTIVITY
		SoraDSendMessage(rewardList)
	end
end
return weaponSprctrumCtrl

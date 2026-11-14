local GameModule = include("GameModule")
local decryptionCtrl = class("decryptionCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function decryptionCtrl:ctor(properties)
	decryptionCtrl.super.ctor(self, properties)
end
function decryptionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_DECRYPTION_MODULE, gCmd.REQ_DECRYPTION_GET_INFO, handler(self, self.sendReqGetInfoRsp))
	msgCtrl.register(gCmd.CMD_DECRYPTION_MODULE, gCmd.REQ_DECRYPTION_GET_REWARD, handler(self, self.sendReqGetRewardRsp))
	self:resetData()
	self:registerNotify()
end
function decryptionCtrl:resetData()
	;(nil).extCount, _UPVALUE0_, (nil).rewardFlag, _UPVALUE0_, (nil).taskInfos, _UPVALUE0_, _UPVALUE0_, self.handle_notify = nil, nil, nil, nil, nil, nil, nil, nil
	self.decryptionData, (nil).unCollected = nil, 0
end
function decryptionCtrl:Logout()
	self:resetData()
	decryptionCtrl.super.Logout(self)
end
function decryptionCtrl:initClientData(data)
	dump(data, "==decryptionCtrl:initClientData==")
	if data and data.unCollected then
		self.decryptionData.unCollected = data.unCollected
	end
end
function decryptionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.DECRYPTION, handler(self, self.notifyHandler))
end
function decryptionCtrl:notifyHandler(event)
	if event and event.data then
		dump(event.data, "decryptionCtrl:notifyHandler")
		for i, v in ipairs(event.data) do
			if v.finish then
				local nIndex = self:refreshSingleTaskInfo(v.finish) or 0
				_ENV = v.finish
				v.finish.msg = "MESSAGE_DECRYPTION_REFRESH_TASK"
				v.finish.nIndex = nIndex
				SoraDSendMessage(v.finish)
				if v.finish.plan >= v.finish.nNum then
					local taskId = v.finish.taskId or 0
					local decryptionRead = include("decryptionRead")
					local str = string.format([[
%s%s
%s]], i18n("Secret_explore_text_16"), i18n(decryptionRead.getTaskDes(taskId)), i18n("anniversary_uncover_tip_01"))
					SoraDShowMsgTip(str, "#icon_activity_9001516.png")
				end
			end
			self:setDecryptionData(v)
		end
	end
end
function decryptionCtrl:sendReqGetInfo()
	serverproxy:Request(gCmd.CMD_DECRYPTION_MODULE, gCmd.REQ_DECRYPTION_GET_INFO)
end
function decryptionCtrl:sendReqGetInfoRsp(content)
	dump(content, "decryptionCtrl:sendReqGetInfoRsp", 10)
	if gErrDef.Err_None == content.err then
		self:setDecryptionData(content.data)
		_ENV = self
		self.msg = "MESSAGE_DECRYPTION_INFO_BACK"
		SoraDSendMessage(self)
	end
end
function decryptionCtrl:sendReqGetReward(nType, nIndex)
	serverproxy = nil
	;(nil).nType = nType
	local (nil).nIndex, data = nIndex, nil
	serverproxy:Request(gCmd.CMD_DECRYPTION_MODULE, gCmd.REQ_DECRYPTION_GET_REWARD, data)
end
function decryptionCtrl:sendReqGetRewardRsp(content)
	dump(content, "decryptionCtrl:sendReqGetRewardRsp", 10)
	if gErrDef.Err_None == content.err and content.data then
		self:setDecryptionData(content.data)
		SoraDMailGainItems(content.data.rewardinfo, true)
		_ENV = content.data.rewardinfo
		content.data.rewardinfo.msg = "MESSAGE_DECRYPTION_RECEIVE_BACK"
		content.data.rewardinfo.nType = content.data.nType
		content.data.rewardinfo.nIndex = content.data.nIndex
		SoraDSendMessage(content.data.rewardinfo)
	end
end
function decryptionCtrl:setDecryptionData(data)
	if data then
		if data.rewardFlag then
			self.decryptionData.rewardFlag = data.rewardFlag
		end
		if data.extCount then
			self.decryptionData.extCount = data.extCount
		end
		if data.taskInfo then
			self:refreshSingleTaskInfo(data.taskInfo)
		end
		if data.taskInfos then
			self.decryptionData.taskInfos = data.taskInfos
		end
		if data.unCollected and data.unCollected ~= self.decryptionData.unCollected then
			self.decryptionData.unCollected = data.unCollected
			_ENV = data.unCollected
			data.unCollected.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			SoraDSendMessage(data.unCollected)
		end
	end
end
function decryptionCtrl:refreshSingleTaskInfo(taskInfo)
	for i, v in ipairs(self.decryptionData.taskInfos) do
		if v.taskId == taskInfo.taskId then
			self.decryptionData.taskInfos[i] = taskInfo
			return i
		end
	end
end
function decryptionCtrl:getTaskInfos(...)
	return self.decryptionData.taskInfos
end
function decryptionCtrl:getTaskInfoByIndex(index)
	return self.decryptionData.taskInfos[index]
end
function decryptionCtrl:checkBoxState(index)
	local count = self.decryptionData.extCount[index]
	if index == 9 and 16 <= count then
		return true
	elseif index < 9 and 4 <= count then
		return true
	end
end
function decryptionCtrl:checkBoxReceiveState(index)
	return self.decryptionData.rewardFlag[index] ~= 0
end
function decryptionCtrl:checkTaskFinishAndNotGet(taskInfo)
	if taskInfo then
		return taskInfo.plan >= taskInfo.nNum and self:checkTaskNotGet(taskInfo)
	end
end
function decryptionCtrl:checkTaskNotGet(taskInfo)
	if taskInfo then
		return not taskInfo.bFlag or taskInfo.bFlag == 0
	end
end
function decryptionCtrl:getReceiveStatusAndNum(...)
	local num = self.decryptionData.unCollected or 0
	return 0 < num, num
end
return decryptionCtrl

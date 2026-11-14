local chatBaseMgr = include("chatBaseMgr")
local chatUnReadMgr = class("chatUnReadMgr", chatBaseMgr)
_ENV = "chatUnReadMgr"
;("chatUnReadMgr").firstPageSize = 20
local ("chatUnReadMgr").otherPageSize, _defaultParam = 100, "chatUnReadMgr"
function chatUnReadMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
	self:reset()
	_ENV = self.reset
	self.reset[gChatChannel.KINGDOM] = false
	self.reset[gChatChannel.ALLIANCE] = false
	_ENV, self.tbMarkRequestAllMsg, self.reset[gChatChannel.TEAM] = self.reset, self.reset, false
	self.reset[gChatChannel.KINGDOM], _ENV = "chatSendMgr", "chatSendMgr"
	self.reset[gChatChannel.ALLIANCE], _ENV = "chatSendMgr", "chatSendMgr"
	self.tbRequestAllMsgInfo, self.reset[gChatChannel.TEAM], _ENV = self.reset, "chatSendMgr", "chatSendMgr"
end
function chatUnReadMgr:reset()
	self.unReadInfos, _UPVALUE0_ = nil, nil
end
function chatUnReadMgr:clean()
	self:reset()
end
function chatUnReadMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatUnReadMgr:registerMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_UN_READ_BACK", handler(self, self.sMsgUnReadBack))
end
function chatUnReadMgr:getUnReadInfo(chatChannel)
	local unReadInfo = self.unReadInfos[chatChannel]
	return unReadInfo
end
function chatUnReadMgr:reqUnReadInfo(chatChannel)
	print("发起请求:未读消息数量")
	local chatDataModuleAPI = include("chatDataModuleAPI")
	chatDataModuleAPI:reqPromptInfo(chatChannel)
end
function chatUnReadMgr:sMsgUnReadBack(target, data)
	dump(data, "未读消息返回", 10)
	local channel = data.channel
	local chatId = data.chatId
	local num = data.num
	local hasRedPacket = data.hasRedPacket
	local redEnvelopesType = data.redEnvelopesType
	_ENV = nil
	;(nil).chatId = chatId
	;(nil).num = num
	;(nil).hasRedPacket = hasRedPacket
	local (nil).redEnvelopesType, unReadData = redEnvelopesType, nil
	self.unReadInfos[channel] = unReadData
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_UPDATE_TIP"
	;(nil).chatChannel = channel
	SoraDSendMessage(nil)
end
function chatUnReadMgr:requestAllHistoryData(param, unReadInfo)
	if self.tbMarkRequestAllMsg[param.chatChannel] then
		print("已经加载所有消息...")
		return
	end
	self.tbMarkRequestAllMsg[param.chatChannel] = true
	local num = unReadInfo.num
	local chatId = unReadInfo.chatId
	local index = 1
	local requestInfo = self.tbRequestAllMsgInfo[param.chatChannel]
	_ENV = param.chatChannel
	param.chatChannel.chatId = chatId
	param.chatChannel.pageSize = _defaultParam.firstPageSize
	param.chatChannel.isRequesting = false
	requestInfo[index], param.chatChannel.isLoaded = param.chatChannel, false
	requestInfo.maxRequestIndex = 1
	if num <= _defaultParam.firstPageSize then
		return
	end
	index = index + 1
	local remainNum = num - _defaultParam.firstPageSize
	while true do
		if remainNum < _defaultParam.otherPageSize then
			_ENV = _defaultParam.otherPageSize
			requestInfo[index], _defaultParam.otherPageSize.pageSize = _defaultParam.otherPageSize, remainNum
			requestInfo.maxRequestIndex = requestInfo.maxRequestIndex + 1
			break
		else
			_ENV = requestInfo.maxRequestIndex + 1
			;(requestInfo.maxRequestIndex + 1).pageSize = _defaultParam.otherPageSize
			;(requestInfo.maxRequestIndex + 1).isRequesting = false
			requestInfo[index], (requestInfo.maxRequestIndex + 1).isLoaded = requestInfo.maxRequestIndex + 1, false
			index = index + 1
			remainNum = remainNum - _defaultParam.otherPageSize
			requestInfo.maxRequestIndex = requestInfo.maxRequestIndex + 1
		end
	end
	requestInfo.curRequestIndex = 1
	dump(requestInfo, "requestInfo预生成的请求信息", 10)
	self:requestHistoryPart(param, requestInfo.curRequestIndex)
end
function chatUnReadMgr:requestHistoryPart(param, requestIndex)
	print("chatUnReadMgr:requestHistoryPart: param, requestIndex = ", requestIndex)
	local requestInfos = self.tbRequestAllMsgInfo[param.chatChannel]
	local pageSize = requestInfos[requestIndex].pageSize
	local chatId = requestInfos[requestIndex].chatId
	_ENV = nil
	;(nil).chatChannel = param.chatChannel
	;(nil).chatSet = param.chatSet
	;(nil).key = param.key
	;(nil).startId = chatId
	;(nil).direction = gDirection.BACKWARDS
	local (nil).pageSize, requestParam = pageSize, nil
	dump(requestParam, "requestParam", 10)
	self.chatSendMgr:requestHistory(requestParam)
end
function chatUnReadMgr:requestHistoryPartRsp(param)
	local chatId = param.chatId
	local requestInfo = self.tbRequestAllMsgInfo[param.chatChannel]
	if requestInfo.curRequestIndex < requestInfo.maxRequestIndex then
		requestInfo.curRequestIndex = requestInfo.curRequestIndex + 1
		requestInfo[requestInfo.curRequestIndex].chatId = chatId
		self:requestHistoryPart(param, requestInfo.curRequestIndex)
	end
end
function chatUnReadMgr:getCurRequestIndex(param)
	local requestInfo = self.tbRequestAllMsgInfo[param.chatChannel]
	return requestInfo.curRequestIndex
end
function chatUnReadMgr:getUnReadInsertIndex(param)
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local requestInfo = self.tbRequestAllMsgInfo[param.chatChannel]
	local targetData = self.chatDataMgr:getData(chatChannel, chatSet, key)
	if not requestInfo.insertChatId then
		if #targetData == 0 then
			return 1
		end
		requestInfo.insertChatId = targetData[#targetData].chatId
		local insertIndex = #targetData + 1
		return insertIndex
	end
	local insertChatId = requestInfo.insertChatId
	local insertIndex = self:getInsertIndex(targetData, insertChatId)
	return insertIndex
end
function chatUnReadMgr:getInsertIndex(targetData, chatId)
	if #targetData == 0 then
		return 1
	end
	local findIndex = 1
	local isFind = false
	for i = 1, #targetData do
		if isFind == false and targetData[i].chatId == chatId then
			findIndex = i
			isFind = true
		elseif isFind == true then
			if gFakeDataTypeMap[targetData[i].dataType] then
				findIndex = i
			elseif not gFakeDataTypeMap[targetData[i].dataType] then
				break
			end
		end
	end
	return findIndex + 1
end
function chatUnReadMgr:getReuestPageSize(index)
	if index == 1 then
		return _defaultParam.firstPageSize
	end
	return _defaultParam.otherPageSize
end
function chatUnReadMgr:getMaxRequestIndex(param)
	local requestInfo = self.tbRequestAllMsgInfo[param.chatChannel]
	return requestInfo.maxRequestIndex
end
function chatUnReadMgr:reqReadChatMsg(param)
	print("发起频道的阅读请求")
	dump(param, "chatUnReadMgr:reqReadChatMsg(param)")
	local readChatId = self.chatDataMgr:getReadChatId(param)
	local chatDataModuleAPI = include("chatDataModuleAPI")
	print("readChatId = ", readChatId)
	if readChatId then
		chatDataModuleAPI:readChatMsg(param.chatChannel, readChatId)
	end
end
return chatUnReadMgr

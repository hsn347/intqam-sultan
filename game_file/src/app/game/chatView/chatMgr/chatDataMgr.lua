local chatBaseMgr = include("chatBaseMgr")
local chatDataMgr = class("chatDataMgr", chatBaseMgr)
local chatDataParser = include("chatDataParser")
local gametop = gModuleMgr.getObject("gametop")
local chatFunctions = include("chatFunctions")
function chatDataMgr:init()
	print("chatDataMgr:init()-----------------------------------")
	self.chatTranslateMgr = gChatMgrs:getMgr("chatTranslateMgr")
	_ENV, self.chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr"), gChatMgrs:getMgr("chatUnReadMgr")
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.KINGDOM] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ALLIANCE] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.TEAM] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.MAIL] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ALLIANCEMSG] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.CHATROOM] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ESCORTKINGDOM] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ESCORTALLIANCE] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.TEAMMSG] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.DJ] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.CAMP] = false
	_ENV, self._needKey, gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.VIEWER] = gChatMgrs:getMgr("chatUnReadMgr"), gChatMgrs:getMgr("chatUnReadMgr"), false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.KINGDOM] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ALLIANCE] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.TEAM] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.MAIL] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ALLIANCEMSG] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.CHATROOM] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ESCORTKINGDOM] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.ESCORTALLIANCE] = false
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.TEAMMSG] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.DJ] = true
	gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.CAMP] = true
	self._needCheckExist, gChatMgrs:getMgr("chatUnReadMgr")[gChatChannel.VIEWER] = gChatMgrs:getMgr("chatUnReadMgr"), true
	self.mChatChannel = gChatChannel.KINGDOM
	self:reset()
end
function chatDataMgr:reset()
	self:resetClientData()
end
function chatDataMgr:clean()
	self:reset()
end
function chatDataMgr:registerMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_LOAD_SUCCESS", handler(self, self.onLoadSuccess))
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_NEW_MESSAGE", handler(self, self.onNewMessage))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_NEW_ALLIANCE_MSG", handler(self, self.sMsgNewAllianceMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_DEL_ALLIANCE_MSG", handler(self, self.sMsgDelAllianceMsg))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_HISTORY_ALLIANCE_MSG", handler(self, self.sMsgHistoryAllianceMsg))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_LOG_GET_MSG_SUCCESS", handler(self, self.sMsgEscortLogGetMsgSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_LOG_NEW_MSG", handler(self, self.sMsgEscortNewMsg))
end
function chatDataMgr:resetClientData()
	_ENV = nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatSet.NOTICE], _ENV = nil, nil
	;(nil)[gChatSet.RED_PACKET], _ENV = nil, nil
	;(nil)[gChatChannel.KINGDOM], (nil)[gChatSet.DROP_BOX], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatSet.NOTICE], _ENV = nil, nil
	;(nil)[gChatChannel.ALLIANCE], (nil)[gChatSet.RED_PACKET], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatSet.NOTICE], _ENV = nil, nil
	;(nil)[gChatChannel.TEAM], (nil)[gChatSet.RED_PACKET], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.DJ], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.MAIL], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.ALLIANCEMSG], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.TEAMMSG], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.CHATROOM], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.ESCORTKINGDOM], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatChannel.ESCORTALLIANCE], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatChannel.CAMP], (nil)[gChatSet.NOTICE], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	_ENV, self.setData, (nil)[gChatChannel.VIEWER], (nil)[gChatSet.NOTICE], _ENV = nil, nil, nil, nil, nil
	_ENV = nil
	self.setParam, (nil)[gChatChannel.ALLIANCEMSG], (nil)[gChatSet.TOTAL], _ENV = nil, nil, nil, nil
	self.chatChannel = gChatChannel.KINGDOM
	self.escortChannel = gEscortIntelChannel.KINGDOM
	_ENV, self.tbChatChannelInfoStack, _ENV, self.escortType = gChatTypeUI.escortKingdom, gChatTypeUI.escortKingdom, gChatTypeUI.escortKingdom, gChatTypeUI.escortKingdom
	_ENV = nil
	_ENV = nil
	gChatTypeUI.escortKingdom[gChatChannel.KINGDOM], (nil)[gChatSet.TOTAL], (nil).realNum = nil, nil, 0
	_ENV = nil
	_ENV = nil
	gChatTypeUI.escortKingdom[gChatChannel.ALLIANCE], (nil)[gChatSet.TOTAL], (nil).realNum = nil, nil, 0
	_ENV = nil
	_ENV = nil
	_ENV, self.extraData, gChatTypeUI.escortKingdom[gChatChannel.TEAM], (nil)[gChatSet.TOTAL], (nil).realNum = gChatTypeUI.escortKingdom, gChatTypeUI.escortKingdom, nil, nil, 0
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatSet.NOTICE], _ENV = nil, nil
	gChatTypeUI.escortKingdom[gChatChannel.KINGDOM], (nil)[gChatSet.RED_PACKET], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatSet.NOTICE], _ENV = nil, nil
	gChatTypeUI.escortKingdom[gChatChannel.ALLIANCE], (nil)[gChatSet.RED_PACKET], _ENV = nil, nil, nil
	_ENV = nil
	;(nil)[gChatSet.TOTAL], _ENV = nil, nil
	;(nil)[gChatSet.NOTICE], _ENV = nil, nil
	self.existData, gChatTypeUI.escortKingdom[gChatChannel.TEAM], (nil)[gChatSet.RED_PACKET], _ENV = gChatTypeUI.escortKingdom
	self.curChatChannelInfo = nil
end
function chatDataMgr:cleanData(chatChannel, chatSet, key)
	if key then
		self.setData[chatChannel][chatSet][key] = nil
	else
		self.setData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
	end
end
function chatDataMgr:getData(chatChannel, chatSet, key)
	if self._needKey[chatChannel] then
		if not self.setData[chatChannel] then
			self.setData[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.setData[chatChannel][chatSet] then
			self.setData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		if key then
			if not self.setData[chatChannel][chatSet][key] then
				self.setData[chatChannel][chatSet][key], _UPVALUE0_ = nil, nil
			end
			return self.setData[chatChannel][chatSet][key]
		end
	else
		if not self.setData[chatChannel] then
			self.setData[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.setData[chatChannel][chatSet] then
			self.setData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		return self.setData[chatChannel][chatSet]
	end
end
function chatDataMgr:getDataSet(chatChannel, chatSet)
	if not self.setData[chatChannel] then
		self.setData[chatChannel], _UPVALUE0_ = nil, nil
	end
	if not self.setData[chatChannel][chatSet] then
		self.setData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
	end
	return self.setData[chatChannel][chatSet]
end
function chatDataMgr:hasData(chatChannel, chatSet, key)
	if self._needKey[chatChannel] then
		if not self.setData[chatChannel] then
			return false
		end
		if not self.setData[chatChannel][chatSet] then
			return false
		end
		if key then
			if not self.setData[chatChannel][chatSet][key] then
				return false
			end
		else
			return false
		end
	else
		if not self.setData[chatChannel] then
			return false
		end
		if not self.setData[chatChannel][chatSet] then
			return false
		end
	end
	return true
end
function chatDataMgr:getExtraData(chatChannel, chatSet, key)
	if self._needKey[chatChannel] then
		if not self.extraData[chatChannel] then
			self.extraData[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.extraData[chatChannel][chatSet] then
			self.extraData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		if not self.extraData[chatChannel][chatSet][key] then
			self.extraData[chatChannel][chatSet][key], _UPVALUE0_ = nil, nil
		end
		return self.extraData[chatChannel][chatSet][key]
	else
		if not self.extraData[chatChannel] then
			self.extraData[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.extraData[chatChannel][chatSet] then
			self.extraData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		return self.extraData[chatChannel][chatSet]
	end
end
function chatDataMgr:getExistData(chatChannel, chatSet, key)
	if self._needKey[chatChannel] then
		if not self.existData[chatChannel] then
			self.existData[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.existData[chatChannel][chatSet] then
			self.existData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		if not self.existData[chatChannel][chatSet][key] then
			self.existData[chatChannel][chatSet][key], _UPVALUE0_ = nil, nil
		end
		return self.existData[chatChannel][chatSet][key]
	else
		if not self.existData[chatChannel] then
			self.existData[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.existData[chatChannel][chatSet] then
			self.existData[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		return self.existData[chatChannel][chatSet]
	end
end
function chatDataMgr:hasExistData(chatChannel, chatSet, key, chatId)
	local existData = self:getExistData(chatChannel, chatSet, key)
	if existData[chatId] then
		return true, existData[chatId]
	end
	return false
end
function chatDataMgr:getExistDataByChatId(chatChannel, chatSet, key, chatId)
	local isExist, data = self:hasExistData(chatChannel, chatSet, key, chatId)
	if isExist then
		return data
	end
end
function chatDataMgr:addExtraRealNum(chatChannel, chatSet, key, realNum)
	local tbExtra = self:getExtraData(chatChannel, chatSet, key)
	if not tbExtra.realNum then
		tbExtra.realNum = realNum
	else
		tbExtra.realNum = tbExtra.realNum + realNum
	end
end
function chatDataMgr:getExtraRealNum(chatChannel, chatSet, key)
	local tbExtra = self:getExtraData(chatChannel, chatSet, key)
	return tbExtra.realNum or 0
end
function chatDataMgr:addChatData(param)
	local isHistory = param.isHistory
	if isHistory then
		self:addChatDataToEnd(param)
	else
		self:addChatDataToBegin(param)
	end
end
function chatDataMgr:delChatData(param)
	local msgID = param.msgID
	local chatChannel = param.chatChannel
	local chatDataSet = param.chatDataSet
	local allianceId = param.target
	local key = self:getAllianceMsgChatKey(chatChannel, chatDataSet, allianceId)
	local _ENV, tmpArray = self, self
	local index = 1
	for k, v in ipairs(self.setData[gChatChannel.ALLIANCEMSG]) do
		local aData = v[key]
		if aData then
			for ki, vi in ipairs(aData) do
				if vi.chatId ~= msgID then
					tmpArray[index] = vi
					index = index + 1
				end
			end
			self.setData[gChatChannel.ALLIANCEMSG][k][key] = tmpArray
		end
	end
	_ENV = ipairs(self.setData[gChatChannel.ALLIANCEMSG])
	ipairs(self.setData[gChatChannel.ALLIANCEMSG]).msg = "MESSAGE_ALLIANCE_DEL_ALLIANCE_MSG_REFRESH"
	ipairs(self.setData[gChatChannel.ALLIANCEMSG]).chatChannel = chatChannel
	ipairs(self.setData[gChatChannel.ALLIANCEMSG]).chatSet = chatDataSet
	ipairs(self.setData[gChatChannel.ALLIANCEMSG]).key = key
	SoraDSendMessage(ipairs(self.setData[gChatChannel.ALLIANCEMSG]))
end
function chatDataMgr:addChatDataToBeginSingle()
end
function chatDataMgr:addChatDataToBegin(param)
	print("chatDataMgr:addChatDataToBegin(param)")
	local dataArray = param.data
	local chatChannel = param.chatChannel
	local chatSet = param.chatDataSet or param.chatSet
	local direction = param.direction
	local more = param.more
	local isHistory = param.isHistory
	local target = param.target
	local isWrapped = param.isWrapped
	local isNeedScroll = param.isNeedScroll
	local _ENV, custom
	custom.target = target
	if chatChannel == gChatChannel.TEAMMSG then
		custom.key = param.key
	end
	local chatTypeUI = gChatChannel2ChatTypeUI[chatChannel]
	local _ENV, chatDataArray
	if dataArray == nil or #dataArray == 0 then
		print("这里返回1111")
		return
	end
	local curDate, preDate
	local isExist = false
	local targetData
	local key = param.key
	print("targetData key", key)
	targetData = self:getData(chatChannel, chatSet, key)
	if not targetData then
		return
	end
	local realNum = 0
	for i = 1, #dataArray do
		local index = i
		local isReverse = gDataDirectionCfg[chatChannel] == gDataDirection.reverse and true or false
		if isReverse then
			index = #dataArray - i + 1
		end
		local dataItem
		if isWrapped then
			dataItem = dataArray[index]
			dataItem.key = key
		else
			dataItem = chatDataParser.wrapChatData(chatTypeUI, dataArray[index], false, custom)
			dataItem.chatSet = chatSet
			dataItem.key = key
		end
		dataItem.isHistoryMsg = isHistory
		if self._needCheckExist[chatChannel] then
			print("------进来了111-----")
			if false == self:updateIfExistSending(targetData, dataItem) then
				print("------进来了222-----")
				curDate = dataItem.date
				preDate = nil
				if targetData[1] ~= nil then
					preDate = targetData[1].date
				end
				if gNeedInsertDate[chatChannel] and (preDate == nil or false == chatFunctions:getIsSameDay(curDate, preDate)) then
					local day = chatDataParser.wrapDateData(dataItem)
					table.insert(targetData, 1, day)
					table.insert(chatDataArray, 1, day)
				end
				table.insert(targetData, 1, dataItem)
				table.insert(chatDataArray, 1, dataItem)
			else
				isExist = true
			end
			if not gFakeDataTypeMap[dataItem.dataType] then
				realNum = realNum + 1
				if gNeedCountExist[chatChannel] and gNeedCountExist[chatChannel][chatSet] then
					local existData = self:getExistData(chatChannel, chatSet, key)
					existData[dataItem.chatId] = dataItem
				end
			end
		else
			table.insert(targetData, 1, dataItem)
			table.insert(chatDataArray, 1, dataItem)
		end
	end
	if #chatDataArray == 0 then
		print("这里返回22222")
		return
	end
	if gNeedCountRealNum[chatChannel] then
		self:addExtraRealNum(chatChannel, chatSet, key, realNum)
	end
	local chatType = chatDataArray[1].chatType
	if 1 <= #chatDataArray then
		_ENV = #chatDataArray
		;(#chatDataArray)[gChatChannel.KINGDOM] = true
		;(#chatDataArray)[gChatChannel.ALLIANCE] = true
		;(#chatDataArray)[gChatChannel.MAIL] = true
		;(#chatDataArray)[gChatChannel.CHATROOM] = true
		;(#chatDataArray)[gChatChannel.TEAM] = true
		local (#chatDataArray)[gChatChannel.CAMP], config = true, #chatDataArray
		if config[chatChannel] then
			_ENV = chatSet
			chatSet.msg = "MESSAGE_CHAT_UPDATE_CHAT_BOX"
			chatSet.chatChannel = chatChannel
			chatSet.chatSet = chatSet
			chatSet.content = targetData[1]
			SoraDSendMessage(chatSet)
		end
	end
	print("chatType = ", chatType, ", isExist = ", isExist, #chatDataArray, chatChannel)
	if isExist == false then
		local _ENV, chatData = print, print
		chatData.data = chatDataArray
		chatData.isHistoryMsg = isHistory
		_ENV = chatType
		chatType.msg = "MESSAGE_CHAT_ADD_MESSAGE"
		chatType.chatData = chatData
		chatType.chatType = chatType
		chatType.chatSet = chatSet
		chatType.chatChannel = chatChannel
		chatType.direction = direction
		chatType.key = key
		chatType.more = more
		chatType.isNeedScroll = isNeedScroll
		SoraDSendMessage(chatType)
	end
end
function chatDataMgr:addChatDataToEnd(param)
	print("要添加的个数: param.data", #param.data)
	local dataArray = param.data
	local direction = param.direction
	local more = param.more
	local isHistory = param.isHistory
	local target = param.target
	local isWrapped = param.isWrapped
	local isNeedScroll = param.isNeedScroll
	local chatChannel = param.chatChannel
	local chatTypeUI = gChatChannel2ChatTypeUI[chatChannel]
	local chatSet = param.chatDataSet or param.chatSet
	local _ENV, custom
	custom.target = target
	if chatChannel == gChatChannel.TEAMMSG then
		custom.key = param.key
	end
	local _ENV, chatDataArray = param.key, param.key
	if dataArray == nil or #dataArray == 0 then
		return
	end
	local curDate, preDate, targetData
	local key = param.key
	print("chatDataMgr:addChatDataToEnd(param): chatChannel, chatSet, key", chatChannel, chatSet, key)
	targetData = self:getData(chatChannel, chatSet, key)
	if not targetData then
		return
	end
	print("地址:targetData", tostring(targetData))
	local insertIndex = #targetData + 1
	local isBackWard = false
	if direction == gDirection.BACKWARDS then
		isBackWard = true
		_ENV = tostring(targetData)
		tostring(targetData).chatChannel = chatChannel
		tostring(targetData).chatSet = chatSet
		tostring(targetData).key = key
		insertIndex = self.chatUnReadMgr:getUnReadInsertIndex(tostring(targetData))
		print("chatDataMgr:addChatDataToEnd insertIndex = ", insertIndex)
	end
	local realNum = 0
	local nextBackWardChatId
	for i = 1, #dataArray do
		local index = i
		local isReverse = gDataDirectionCfg[chatChannel] == gDataDirection.reverse and true or false
		if isReverse then
			index = #dataArray - i + 1
		end
		local _ENV, dataItem = #dataArray - i, #dataArray - i
		if isWrapped then
			dataItem = dataArray[index]
			dataItem.key = key
		else
			dataItem = chatDataParser.wrapChatData(chatTypeUI, dataArray[index], false, custom)
			dataItem.chatSet = chatSet
			dataItem.key = key
		end
		local isExist = false
		if not gFakeDataTypeMap[dataItem.dataType] and gNeedCountExist[chatChannel] and gNeedCountExist[chatChannel][chatSet] then
			isExist = self:hasExistData(chatChannel, chatSet, key, dataItem.chatId)
		end
		if not isExist then
			if not gFakeDataTypeMap[dataItem.dataType] then
				realNum = realNum + 1
				if gNeedCountExist[chatChannel] and gNeedCountExist[chatChannel][chatSet] then
					local existData = self:getExistData(chatChannel, chatSet, key)
					existData[dataItem.chatId] = dataItem
				end
			end
			dataItem.isHistoryMsg = isHistory
			curDate = dataItem.date
			if preDate == nil then
				preDate = curDate
			end
			if gNeedInsertDate[chatChannel] and false == chatFunctions:getIsSameDay(curDate, preDate) then
				local day = chatDataParser.wrapDateData(chatDataArray[#chatDataArray])
				table.insert(targetData, insertIndex, day)
				insertIndex = insertIndex + 1
				table.insert(chatDataArray, #chatDataArray + 1, day)
				preDate = curDate
			else
			end
			table.insert(targetData, insertIndex, dataItem)
			insertIndex = insertIndex + 1
			table.insert(chatDataArray, #chatDataArray + 1, dataItem)
		else
		end
		if isBackWard and i == 1 then
			nextBackWardChatId = dataItem.chatId
		end
	end
	if 1 <= realNum and gNeedInsertDate[chatChannel] then
		local dataItem = chatDataParser.wrapDateData(chatDataArray[#chatDataArray])
		table.insert(targetData, insertIndex, dataItem)
		insertIndex = insertIndex + 1
		table.insert(chatDataArray, #chatDataArray + 1, dataItem)
	end
	if gNeedCountRealNum[chatChannel] then
		self:addExtraRealNum(chatChannel, chatSet, key, realNum)
	end
	if 1 <= #chatDataArray then
		_ENV = #chatDataArray
		;(#chatDataArray)[gChatChannel.KINGDOM] = true
		;(#chatDataArray)[gChatChannel.ALLIANCE] = true
		;(#chatDataArray)[gChatChannel.MAIL] = true
		;(#chatDataArray)[gChatChannel.CHATROOM] = true
		;(#chatDataArray)[gChatChannel.TEAM] = true
		local (#chatDataArray)[gChatChannel.CAMP], config = true, #chatDataArray
		if config[chatChannel] then
			_ENV = chatChannel
			chatChannel.msg = "MESSAGE_CHAT_UPDATE_CHAT_BOX"
			chatChannel.chatChannel = chatChannel
			chatChannel.chatSet = chatSet
			chatChannel.content = targetData[1]
			SoraDSendMessage(chatChannel)
		end
	end
	local _ENV, chatData = config, #chatDataArray
	chatData.data = chatDataArray
	chatData.isHistoryMsg = isHistory
	_ENV = chatChannel
	chatChannel.msg = "MESSAGE_CHAT_ADD_MESSAGE"
	chatChannel.chatData = chatData
	chatChannel.chatSet = chatSet
	chatChannel.chatChannel = chatChannel
	chatChannel.key = key
	chatChannel.direction = direction
	chatChannel.more = more
	chatChannel.isBackWard = isBackWard
	SoraDSendMessage(chatChannel)
	print("结束后:", #targetData)
	if isBackWard == true then
		_ENV = #targetData
		;(#targetData).chatChannel = chatChannel
		local curRequestIndex = self.chatUnReadMgr:getCurRequestIndex(#targetData)
		if curRequestIndex == 1 then
			_ENV = #targetData
			;(#targetData).msg = "MESSAGE_CHAT_SCROLL_JUMPTO_TOP"
			;(#targetData).chatSet = chatSet
			;(#targetData).chatChannel = chatChannel
			;(#targetData).key = key
			SoraDSendMessage(#targetData)
		end
		_ENV = SoraDSendMessage
		SoraDSendMessage.chatSet = chatSet
		SoraDSendMessage.chatChannel = chatChannel
		SoraDSendMessage.key = key
		local SoraDSendMessage.chatId, requestParam = nextBackWardChatId, SoraDSendMessage
		self.chatUnReadMgr:requestHistoryPartRsp(requestParam)
	end
end
function chatDataMgr:updateIfExistSending(dataArray, dataItem)
	local isExist = false
	local isSelf = chatFunctions.getIsPlayerSelf(dataItem.playerId)
	if isSelf then
		for _, v in ipairs(dataArray) do
			local isPlayerSelf = chatFunctions.getIsPlayerSelf(v.playerId)
			if isPlayerSelf and v.chatIndex ~= nil and v.chatIndex == dataItem.chatIndex then
				if v.netStatus == gChatNetStatus.sending or v.netStatus == gChatNetStatus.warn_sending or v.netStatus == gChatNetStatus.warn_uploading then
					print("检测到是自己发送的消息返回-----------------")
					v.netStatus = gChatNetStatus.normal
					if v.itemNode and v.itemNode.updateNetStatus then
						v.itemNode:updateNetStatus()
					end
					isExist = true
				end
				self:updateChatId(v, dataItem)
				break
			end
		end
	end
	return isExist
end
function chatDataMgr:updateChatId(localData, serverData)
	localData.chatId = serverData.chatId
end
function chatDataMgr:onLoadSuccess(target, data)
	print("历史消息返回----")
	local direction = data.direction or gDirection.FORWARD
	local chatChannel = data.chatChannel
	local chatDataSet = data.chatDataSet or data.chatSet
	local more = data.more
	local requestId = data.requestId
	local startId = data.startId
	local key = data.key
	if direction == gDirection.FORWARD and (more == false or #data.data == 0) then
		print("没有历史消息了----")
		_ENV = "没有历史消息了----"
		;("没有历史消息了----").msg = "MESSAGE_CHAT_HISTORY_END"
		;("没有历史消息了----").direction = direction
		;("没有历史消息了----").chatChannel = chatChannel
		;("没有历史消息了----").chatSet = chatDataSet
		;("没有历史消息了----").key = key
		;("没有历史消息了----").more = more
		;("没有历史消息了----").requestId = requestId
		;("没有历史消息了----").startId = startId
		SoraDSendMessage("没有历史消息了----")
	end
	data.isHistory = true
	self:addChatData(data)
	if data.isLogin then
		local chatCtrl = gametop.playertop_:getModule("chatCtrl")
		local severChannel = chatCtrl:getChatChannel()
		if severChannel == nil or severChannel == 0 then
			print("没有获取到服务器记录的聊天频道~~~~~~~~~~~~~~")
			if self.mChatChannel == nil then
				self.mChatChannel = gChatChannel.KINGDOM
			end
			self:saveGChatChannel()
		else
			self.mChatChannel = gServer2ChatChannel[severChannel]
		end
		_ENV = self
		self.msg = "MESSAGE_CHAT_GO_TO_CHANNEL"
		self.channel = self.mChatChannel
		SoraDSendMessage(self)
	end
end
function chatDataMgr:onNewMessage(target, data)
	print("收到新的消息----")
	local direction = data.direction
	local chatChannel = data.chatChannel
	local chatDataSet = data.chatDataSet
	local chatTypeUI = gChatChannel2ChatTypeUI[chatChannel]
	data.isHistory = false
	self:addChatData(data)
end
function chatDataMgr:onDelMessage(target, data)
	print("删除消息----")
	data.isHistory = false
	self:delChatData(data)
end
function chatDataMgr:cleanDataNode(chatChannel, chatSet, key)
	local dataArray = self:getData(chatChannel, chatSet, key)
	if dataArray then
		for i = 1, #dataArray do
			local dataItem = dataArray[i]
			if dataItem.itemNode then
				dataItem.itemNode = nil
			end
		end
	end
end
function chatDataMgr:resetMetaInfo(data)
	if data then
		data.metaInfo = nil
		data.tMetaInfo = nil
	end
end
function chatDataMgr:getAllianceData(chatSet)
	return self:getData(gChatChannel.ALLIANCE, chatSet)
end
function chatDataMgr:getTeamData(chatSet)
	return self:getData(gChatChannel.TEAM, chatSet)
end
function chatDataMgr:getKingdomData(chatSet)
	return self:getData(gChatChannel.KINGDOM, chatSet)
end
function chatDataMgr:setChatChannelInfo(channelInfo)
	self.curChatChannelInfo = channelInfo
end
function chatDataMgr:getChatChannel()
	return self.curChatChannelInfo and self.curChatChannelInfo.chatChannel or 0
end
function chatDataMgr:getChatChannelInfo()
	if not self.curChatChannelInfo then
		_UPVALUE0_ = self.curChatChannelInfo
	end
	return self.curChatChannelInfo
end
function chatDataMgr:saveGChatChannel()
	local chatCtrl = gametop.playertop_:getModule("chatCtrl")
	chatCtrl:setChatChannel(gChatChannel2Server[self.mChatChannel])
end
function chatDataMgr:getGChatChannel()
	return self.mChatChannel
end
function chatDataMgr:setGChatChannel(chatChannel)
	self.mChatChannel = chatChannel
end
function chatDataMgr:pushChatChannelInfo()
	if self.curChatChannelInfo then
		table.insert(self.tbChatChannelInfoStack, self.curChatChannelInfo)
	end
end
function chatDataMgr:popChatChannelInfo()
	return table.remove(self.tbChatChannelInfoStack)
end
function chatDataMgr:refreshLanguage()
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local oriCurl = settingCtrl:getTranslateLanguage()
	local allianceData = self:getData(gChatChannel.ALLIANCE, gChatSet.TOTAL)
	local kingdomData = self:getData(gChatChannel.KINGDOM, gChatSet.TOTAL)
	local teamData = self:getData(gChatChannel.TEAM, gChatSet.TOTAL)
	gametop = self
	self.isAutoTranslate = true
	local self.ignoreUpdateScroll, customData = true, self
	_UPVALUE3_ = gChatSet.TOTAL
	gChatSet.TOTAL[1] = allianceData
	gChatSet.TOTAL[2] = kingdomData
	gChatSet.TOTAL[3] = teamData
	for _, dataArray in ipairs(gChatSet.TOTAL) do
		for i = 1, #dataArray do
			local dataItem = dataArray[i]
			dataItem.isShowTranslate = false
			if not dataItem.isSelf and oriCurl and dataItem.translation then
				self.chatTranslateMgr:refreshTranslation(dataItem, dataItem.translation, customData)
			end
		end
	end
end
function chatDataMgr:cleanKingdomAllianceDataNode()
	self:cleanDataNode(gChatChannel.ALLIANCE, gChatSet.TOTAL)
	self:cleanDataNode(gChatChannel.ALLIANCE, gChatSet.NOTICE)
	self:cleanDataNode(gChatChannel.TEAM, gChatSet.TOTAL)
	self:cleanDataNode(gChatChannel.TEAM, gChatSet.NOTICE)
	self:cleanDataNode(gChatChannel.KINGDOM, gChatSet.TOTAL)
	self:cleanDataNode(gChatChannel.KINGDOM, gChatSet.NOTICE)
	self:cleanDataNode(gChatChannel.DJ, gChatSet.TOTAL, 1)
	self:cleanDataNode(gChatChannel.DJ, gChatSet.TOTAL, 2)
end
function chatDataMgr:cleanDJNodeData()
	self:cleanDataNode(gChatChannel.DJ, gChatSet.TOTAL, 1)
	self:cleanDataNode(gChatChannel.DJ, gChatSet.TOTAL, 2)
end
function chatDataMgr:cleanDJData()
	self:cleanData(gChatChannel.DJ, gChatSet.TOTAL, 1)
	self:cleanData(gChatChannel.DJ, gChatSet.TOTAL, 2)
end
function chatDataMgr:cleanTeamData()
	self:cleanData(gChatChannel.TEAM, gChatSet.TOTAL)
	self:cleanData(gChatChannel.TEAM, gChatSet.NOTICE)
end
function chatDataMgr:cleanAllianceData()
	self:cleanData(gChatChannel.ALLIANCE, gChatSet.TOTAL)
	self:cleanData(gChatChannel.ALLIANCE, gChatSet.NOTICE)
end
function chatDataMgr:getStartId(chatChannel, chatSet, key)
	local datas = self:getData(chatChannel, chatSet, key)
	if datas and 0 < #datas then
		dump(datas[#datas], "getStartId(chatChannel, chatSet, key)", 10)
		return datas[#datas].chatId
	end
	return 0
end
function chatDataMgr:getSetParam(chatChannel, chatSet, key)
	if self._needKey[chatChannel] then
		if not self.setParam[chatChannel] then
			self.setParam[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.setParam[chatChannel][chatSet] then
			self.setParam[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		if not self.setParam[chatChannel][chatSet][key] then
			self.setParam[chatChannel][chatSet][key], _UPVALUE0_ = nil, nil
		end
		return self.setParam[chatChannel][chatSet][key]
	else
		if not self.setParam[chatChannel] then
			self.setParam[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.setParam[chatChannel][chatSet] then
			self.setParam[chatChannel][chatSet], _UPVALUE0_ = nil, nil
		end
		return self.setParam[chatChannel][chatSet]
	end
end
function chatDataMgr:setSetParam(chatChannel, chatSet, key, tbInfo)
	local param = self:getSetParam(chatChannel, chatSet, key)
	for k, v in pairs(tbInfo) do
		param[k] = v
	end
end
function chatDataMgr:cleanSetParam(chatChannel, chatSet, key)
	if self._needKey[chatChannel] then
		if not self.setParam[chatChannel] then
			self.setParam[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.setParam[chatChannel][chatSet] then
			self.setParam[chatChannel][chatSet], _UPVALUE0_ = nil, nil
			return
		end
		self.setParam[chatChannel][chatSet][key] = nil
	else
		if not self.setParam[chatChannel] then
			self.setParam[chatChannel], _UPVALUE0_ = nil, nil
		end
		if not self.setParam[chatChannel][chatSet] then
			self.setParam[chatChannel][chatSet], _UPVALUE0_ = nil, nil
			return
		end
		self.setParam[chatChannel][chatSet], _UPVALUE0_ = nil, nil
	end
end
function chatDataMgr:getReadChatId(param)
	local chatChannel = param.chatChannel
	local chatSet = param.chatSet
	local key = param.key
	local targetData = self:getData(chatChannel, chatSet, key)
	if targetData and 0 < #targetData then
		local isFind = false
		local item
		for i = 1, #targetData do
			item = targetData[i]
			if item.chatId and 0 < item.chatId then
				return item.chatId
			end
		end
	end
end
function chatDataMgr:getAllianceMsgData(key)
	return self:getData(gChatChannel.ALLIANCEMSG, gChatSet.TOTAL, key)
end
function chatDataMgr:cleanAllianceMsgData(key)
	self:cleanData(gChatChannel.ALLIANCEMSG, gChatSet.TOTAL, key)
end
function chatDataMgr:sMsgNewAllianceMsg(target, data)
	local newMsg = data.allianceMsg
	local playerId = newMsg.uid
	local isNeedScroll = false
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if lordInfoCtrl ~= nil and lordInfoCtrl:getLordInfo() and lordInfoCtrl:getLordInfo().base ~= nil and lordInfoCtrl:getLordInfo().base.uid ~= nil and lordInfoCtrl:getLordInfo().base.uid == playerId then
		isNeedScroll = true
	end
	local chatChannel = gChatChannel.ALLIANCEMSG
	local chatDataSet = gChatSet.TOTAL
	local curChatChannelInfo = self.curChatChannelInfo
	local allianceId = curChatChannelInfo.allianceId
	local key = self:getAllianceMsgChatKey(chatChannel, chatDataSet, allianceId)
	_ENV, gametop = chatChannel, self
	self.data, chatChannel[1] = chatChannel, newMsg
	self.chatChannel = chatChannel
	self.chatDataSet = chatDataSet
	self.key = key
	self.target = allianceId
	local self.isNeedScroll, param = isNeedScroll, self
	self:onNewMessage(target, param)
end
function chatDataMgr:sMsgDelAllianceMsg(target, data)
	dump(data, "chatDataMgr:sMsgDelAllianceMsg(target, data)", 10)
	local msgID = data.msgID
	local isNeedScroll = true
	local chatChannel = gChatChannel.ALLIANCEMSG
	local chatDataSet = gChatSet.TOTAL
	local curChatChannelInfo = self.curChatChannelInfo
	local allianceId = curChatChannelInfo.allianceId
	local key = self:getAllianceMsgChatKey(chatChannel, chatDataSet, allianceId)
	_ENV = self
	self.msgID = msgID
	self.chatChannel = chatChannel
	self.chatDataSet = chatDataSet
	self.key = key
	self.target = allianceId
	local self.isNeedScroll, param = isNeedScroll, self
	self:onDelMessage(target, param)
end
function chatDataMgr:getAllianceMsgChatKey(chatChannel, chatSet, allianceId)
	return string.format("%d_%d_%s", chatChannel, chatSet, tostring(allianceId))
end
function chatDataMgr:sMsgHistoryAllianceMsg(target, data)
	print("请求消息回来了!---------------")
	local retdata = data.retdata
	local nextIndex = data.nextindex
	local chatChannel = gChatChannel.ALLIANCEMSG
	local chatDataSet = gChatSet.TOTAL
	local curChatChannelInfo = self.curChatChannelInfo
	if not curChatChannelInfo then
		return
	end
	local allianceId = curChatChannelInfo.allianceId
	local key = self:getAllianceMsgChatKey(chatChannel, chatDataSet, allianceId)
	_ENV = nil
	;(nil).nextIndex = nextIndex
	self:setSetParam(chatChannel, chatDataSet, key, nil)
	local allianceMsgList = retdata.msglist
	local more
	if nextIndex == nil then
		more = false
	else
		more = true
	end
	_ENV = chatChannel
	chatChannel.data = allianceMsgList
	chatChannel.chatChannel = chatChannel
	chatChannel.chatDataSet = chatDataSet
	chatChannel.key = key
	chatChannel.more = more
	chatChannel.target = allianceId
	local chatChannel.isNeedScroll, param = false, chatChannel
	self:onLoadSuccess(target, param)
end
function chatDataMgr:getMailChatData(key)
	return self:getData(gChatChannel.MAIL, gChatSet.TOTAL, key)
end
function chatDataMgr:cleanMailChatData()
	local channelInfo = self:getChatChannelInfo()
	if channelInfo then
		self:cleanDataNode(channelInfo.chatChannel, gChatSet.TOTAL, channelInfo.key)
	end
end
function chatDataMgr:getMailChatKey(target)
	local key
	key = gMailType.CHAT .. "@" .. target
	return key
end
function chatDataMgr:getMailStartMid(param)
	if not self:getMailChatData(param.key) then
		local _UPVALUE0_, mailChatData = self:getMailChatData(param.key), self:getMailChatData(param.key)
	end
	local numOfChatData = #mailChatData
	local mid
	if 0 < numOfChatData then
		mid = mailChatData[numOfChatData].mid
		if mid == nil and 1 < numOfChatData then
			mid = mailChatData[numOfChatData - 1].mid
		end
	else
		mid = nil
	end
	return mid
end
function chatDataMgr:getChatRoomData(key)
	return self:getData(gChatChannel.CHATROOM, gChatSet.TOTAL, key)
end
function chatDataMgr:cleanChatRoomData(key)
	self:cleanData(gChatChannel.CHATROOM, gChatSet.TOTAL, key)
end
function chatDataMgr:getChatRoomStartId(param)
	local chatRoomData = self:getChatRoomData(param.key)
	local numOfData = #chatRoomData
	local realNumber = 0
	if 1 <= numOfData then
		for _, v in ipairs(chatRoomData) do
			if v.dataType ~= gChatDataType.dataType_date then
				realNumber = realNumber + 1
			end
		end
	end
	numOfData = realNumber
	local iBegin = numOfData + 1
	return iBegin
end
function chatDataMgr:getKingdomEscortData()
	return self:getData(gChatChannel.ESCORTKINGDOM, gChatSet.TOTAL)
end
function chatDataMgr:getAllianceEscortData()
	return self:getData(gChatChannel.ESCORTALLIANCE, gChatSet.TOTAL)
end
function chatDataMgr:cleanEscortData()
	self:cleanData(gChatChannel.ESCORTKINGDOM, gChatSet.TOTAL)
	self:cleanData(gChatChannel.ESCORTALLIANCE, gChatSet.TOTAL)
end
function chatDataMgr:setEscortChannel(channel)
	self.escortChannel = channel
end
function chatDataMgr:getEscortChannel()
	if not self.escortChannel then
		self.escortChannel = SoraDConfigGet("Escort:logView:channel~integer")
	end
	return self.escortChannel
end
function chatDataMgr:saveEscortChannel()
	if self.escortChannel then
		SoraDConfigSet("Escort:logView:channel~integer", self.escortChannel)
	end
end
function chatDataMgr:setCurrentEscortType(chatType)
	self.escortType = chatType
end
function chatDataMgr:getCurrentEscortType()
	return self.escortType
end
function chatDataMgr:sMsgEscortLogGetMsgSuccess(target, data)
	print("function chatDataMgr:sMsgEscortLogGetMsgSuccess(target, data)")
	dump(data, "军情历史数据")
	local escortIntelCtrl = gametop.playertop_:getModule("escortIntelCtrl")
	local iBegin = data.iBegin
	local nCount = data.nCount
	local chatChannel = data.chatChannel
	local _ENV, msgs
	if chatChannel == gChatChannel.ESCORTKINGDOM then
		if escortIntelCtrl.kingdomIntel then
			msgs = escortIntelCtrl.kingdomIntel:getMsgs(iBegin, nCount)
		end
	elseif chatChannel == gChatChannel.ESCORTALLIANCE and escortIntelCtrl.allianceIntel then
		msgs = escortIntelCtrl.allianceIntel:getMsgs(iBegin, nCount)
	end
	local isNeedScroll = false
	local more = true
	if msgs == nil then
		msgs, _ENV = iBegin, iBegin
		more = false
	end
	dump(msgs, "军情")
	local _ENV, chatSet = msgs, data.chatSet or gChatSet.TOTAL
	msgs.data = msgs
	msgs.chatChannel = chatChannel
	msgs.chatSet = chatSet
	msgs.more = more
	local msgs.isNeedScroll, param = isNeedScroll, msgs
	self:onLoadSuccess(target, param)
end
function chatDataMgr:sMsgEscortNewMsg(target, data)
	print("function chatDataMgr:sMsgEscortNewMsg(target, data)")
	local msgs = data.data
	local isNeedScroll = false
	if #msgs <= 0 then
		return
	end
	local chatChannel = data.chatChannel
	local _ENV, chatSet = nil, data.chatSet or gChatSet.TOTAL
	;(nil).data = msgs
	;(nil).chatChannel = chatChannel
	;(nil).chatSet = chatSet
	local (nil).isNeedScroll, param = isNeedScroll, nil
	self:onNewMessage(target, param)
end
function chatDataMgr:getTeamMsgData(key)
	return self:getData(gChatChannel.TEAMMSG, gChatSet.TOTAL, key)
end
function chatDataMgr:cleanTeamMsgData(key)
	self:cleanData(gChatChannel.TEAMMSG, gChatSet.TOTAL, key)
end
return chatDataMgr

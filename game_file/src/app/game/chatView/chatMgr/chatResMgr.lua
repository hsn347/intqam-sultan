local chatBaseMgr = include("chatBaseMgr")
local chatResMgr = class("chatResMgr", chatBaseMgr)
function chatResMgr:init()
	self:reset()
end
function chatResMgr:reset()
	self.tbKeyFileListener, _UPVALUE0_, self.tbFileListener, _UPVALUE0_, self.tbKeyRes, _UPVALUE0_, self.tbRes, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil
end
function chatResMgr:clean()
	self:reset()
end
function chatResMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatResMgr:registerMessageListener()
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.onFileDownloadSuccess))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.onKeyFileDownloadSuccess))
end
function chatResMgr:hasRes(resKey)
	if resKey == "" then
		return
	end
	if self.tbRes[resKey] ~= nil then
		return self.tbRes[resKey]
	end
	local _, isExist = SoraDIsFileExistByFileName(resKey, true)
	if isExist == false then
	end
	self.tbRes[resKey] = true
	return self.tbRes[resKey]
end
function chatResMgr:hasKeyRes(resKey)
	if self.tbKeyRes[resKey] ~= nil then
		return self.tbKeyRes[resKey]
	end
	local isExist = SoraDIsFileExistByKey(resKey)
	if isExist == false then
	end
	self.tbKeyRes[resKey] = isExist
	return self.tbKeyRes[resKey]
end
function chatResMgr:setHasRes(resKey, value)
	self.tbRes[resKey] = value
end
function chatResMgr:setHasKeyRes(resKey, value)
	self.tbKeyRes[resKey] = value
end
function chatResMgr:onFileDownloadSuccess(target, data)
	local file = data.file
	if file then
		if self.tbRes[file] == nil then
			return
		end
		self:setHasRes(file, true)
		self:notifyFileLoadSuccess(file)
		self.tbFileListener[file] = nil
	end
end
function chatResMgr:onKeyFileDownloadSuccess(target, data)
	local key = data.key
	if key then
		if self.tbKeyRes[key] == nil then
			return
		end
		self:setHasKeyRes(key, true)
		self:notifyKeyFileLoadSuccess(key)
		self.tbKeyFileListener[key] = nil
	end
end
function chatResMgr:addFileListener(itemData, file, fileType)
	if not self.tbFileListener[file] then
		self.tbFileListener[file], _ENV = nil, nil
	end
	_ENV = nil
	;(nil).itemData = itemData
	;(nil).fileType = fileType
	table.insert(self.tbFileListener[file], nil)
end
function chatResMgr:addKeyFileListener(itemData, file, fileType)
	if not self.tbKeyFileListener[file] then
		self.tbKeyFileListener[file], _ENV = nil, nil
	end
	_ENV = nil
	;(nil).itemData = itemData
	;(nil).fileType = fileType
	table.insert(self.tbKeyFileListener[file], nil)
end
function chatResMgr:notifyFileLoadSuccess(file)
	local listeners = self.tbFileListener[file]
	local _ENV, chatChannelMap
	if listeners then
		for _, v in ipairs(listeners) do
			local fileType = v.fileType
			local itemData = v.itemData
			local chatChannel = itemData.chatChannel
			local chatSet = itemData.chatSet
			local key = itemData.key
			if fileType ~= nil and itemData.itemWidth and itemData.itemHeight and itemData.itemWidth > 0 then
				if not chatChannelMap[chatChannel] then
					chatChannelMap[chatChannel], _ENV = chatChannelMap[chatChannel], chatChannelMap[chatChannel]
				end
				if not key then
					chatChannelMap[chatChannel][chatSet] = true
				else
					if not chatChannelMap[chatChannel][chatSet] then
						chatChannelMap[chatChannel][chatSet], _ENV = nil, nil
					end
					chatChannelMap[chatChannel][chatSet][key] = true
				end
			end
			if itemData and itemData.itemNode then
				local itemNode = itemData.itemNode
				if itemNode.onNotifyFileDownloaded then
					itemNode:onNotifyFileDownloaded(file, v.fileType)
				end
			end
		end
		for chatChannel, tbChatSet in pairs(chatChannelMap) do
			for chatSet, v in pairs(tbChatSet) do
				if type(v) == "table" then
					for key, _ in pairs(v) do
						self:delayUpdateScroll(chatChannel, chatSet, key)
					end
				else
					self:delayUpdateScroll(chatChannel, chatSet)
				end
			end
		end
	end
end
function chatResMgr:notifyKeyFileLoadSuccess(file)
	local listeners = self.tbKeyFileListener[file]
	local _ENV, chatChannelMap
	if listeners then
		for _, v in ipairs(listeners) do
			local fileType = v.fileType
			local itemData = v.itemData
			local chatChannel = itemData.chatChannel
			local chatSet = itemData.chatSet
			local key = itemData.key
			if fileType ~= nil and itemData.itemWidth and itemData.itemHeight and itemData.itemWidth > 0 then
				if not chatChannelMap[chatChannel] then
					chatChannelMap[chatChannel], _ENV = chatChannelMap[chatChannel], chatChannelMap[chatChannel]
				end
				if not key then
					chatChannelMap[chatChannel][chatSet] = true
				else
					if not chatChannelMap[chatChannel][chatSet] then
						chatChannelMap[chatChannel][chatSet], _ENV = nil, nil
					end
					chatChannelMap[chatChannel][chatSet][key] = true
				end
			end
			if itemData and itemData.itemNode then
				local itemNode = itemData.itemNode
				if itemNode.onNotifyKeyFileDownloaded then
					itemNode:onNotifyKeyFileDownloaded(file, v.fileType)
				end
			end
		end
		for chatChannel, tbChatSet in pairs(chatChannelMap) do
			for chatSet, v in pairs(tbChatSet) do
				if type(v) == "table" then
					for key, _ in pairs(v) do
						self:delayUpdateScroll(chatChannel, chatSet, key)
					end
				else
					self:delayUpdateScroll(chatChannel, chatSet)
				end
			end
		end
	end
end
function chatResMgr:delayUpdateScroll(chatChannel, chatSet, key)
	local uniqueKey = string.format("delayUpdateScroll_%d_%d", chatChannel, chatSet)
	if key then
		uniqueKey = uniqueKey .. tostring(key)
	end
	SoraDDelayCallOnce(uniqueKey, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		;(nil).chatChannel = chatChannel
		;(nil).chatSet = chatSet
		SoraDSendMessage(nil)
	end, 0.3)
end
return chatResMgr

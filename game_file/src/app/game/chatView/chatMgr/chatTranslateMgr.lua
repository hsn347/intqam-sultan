local chatBaseMgr = include("chatBaseMgr")
local chatTranslateMgr = class("chatTranslateMgr", chatBaseMgr)
local chatConst = include("chatConst")
local schedulerTime = require(cc.PACKAGE_NAME .. ".scheduler")
function chatTranslateMgr:init()
	self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
	self.chatMsgMgr = gChatMgrs:getMgr("chatMsgMgr")
	self:reset()
end
function chatTranslateMgr:reset()
	self.translateData, _ENV, self.tblReqTranslate, _ENV, self.deltaCheckTranslateTime = nil, nil, nil, nil, 5
	if self.translateTimer then
		for _, v in ipairs(self.translateTimer) do
			schedulerTime.unscheduleGlobal(v)
		end
	end
	self.translateTimer, _ENV = ipairs(self.translateTimer)
end
function chatTranslateMgr:clean()
	self:reset()
end
function chatTranslateMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatTranslateMgr:registerMessageListener()
	self:removeMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_TRANSLATE_BACK", handler(self, self.sMsgTranslateBack))
end
function chatTranslateMgr:translateTimeOutManage(chatId, chatChannel, chatSet, key)
	local timeHandle = schedulerTime.performWithDelayGlobal(function(dt)
		self:translateTimeOut(dt)
	end, self.deltaCheckTranslateTime)
	print("translate timeout manage:", chatId, chatChannel)
	schedulerTime = chatId
	chatId.chatId = chatId
	chatId.chatChannel = chatChannel
	chatId.chatSet = chatSet
	chatId.key = key
	table.insert(self.translateData, chatId)
	table.insert(self.translateTimer, timeHandle)
end
function chatTranslateMgr:translateTimeOut(dt)
	if #self.translateData <= 0 then
		return
	end
	local dataItem = self.translateData[1]
	local chatChannel = dataItem.chatChannel
	local from = gChatChannel2From[chatChannel]
	local key = dataItem.key
	local curItemData = self:getItemDatasFrom(from, key)
	if not curItemData then
		return
	end
	local fromkey = from .. dataItem.chatId
	for _, v in ipairs(curItemData) do
		if v.chatId and dataItem.chatId == v.chatId then
			if v.netStatus == gChatNetStatus.translating then
				v.netStatus = gChatNetStatus.normal
				if v.itemNode and v.itemNode.updateNetStatus then
					v.itemNode:updateNetStatus()
				end
				self.tblReqTranslate[fromkey] = nil
				print("翻译超时没有返回，解除掉限制------,fromkey =", fromkey)
			end
			break
		end
	end
	if #self.translateData > 0 then
		table.remove(self.translateData, 1)
		table.remove(self.translateTimer, 1)
	end
end
function chatTranslateMgr:getTranslateKey(data)
	local from = gChatChannel2From[data.chatChannel]
	local tIndex = self:getTranslateId(data)
	tIndex = tIndex or 0
	local key = from .. tIndex
	return key, tIndex
end
function chatTranslateMgr:getTranslateId(data)
	local tIndex = data.chatId
	dump(data, "getTranslateId")
	local from = gChatChannel2From[data.chatChannel]
	if from == gChatTypeUIFrom.mail then
		tIndex = data.mid
	elseif from == gChatTypeUIFrom.chatRoom then
		tIndex = data.serverMsg.msgid
	end
	return tIndex
end
function chatTranslateMgr:isReqTranslating(data)
	local key = self:getTranslateKey(data)
	if self.tblReqTranslate[key] then
		return true
	end
	return false
end
function chatTranslateMgr:reqTranslate(param)
	local from = param.from
	local dataItemList = param.dataItemList
	local isAutoTranslate = param.isAutoTranslate
	local dataKey = param.dataKey
	local gametop = gModuleMgr.getObject("gametop")
	_ENV = "gametop"
	;("gametop").from = from
	;("gametop").isAutoTranslate = isAutoTranslate
	local ("gametop").dataKey, customData = dataKey, "gametop"
	local _ENV, chatIdArray
	for _, dataItem in ipairs(dataItemList) do
		local key, tIndex = self:getTranslateKey(dataItem)
		print("chatTranslateMgr:reqTranslate:", key)
		if self.tblReqTranslate[key] then
			print("already requesting ..., please wait:", key)
			return
		end
		self.tblReqTranslate[key] = dataItem
		dataItem.netStatus = gChatNetStatus.translating
		if dataItem.itemNode and dataItem.itemNode.updateNetStatus then
			dataItem.itemNode:updateNetStatus()
		end
		self:translateTimeOutManage(tIndex, dataItem.chatChannel, dataItem.chatSet, dataItem.key)
		if from == gChatTypeUIFrom.mail then
		elseif from == gChatTypeUIFrom.chatRoom then
			dump(dataItem, "serverMsg")
			if dataItem.serverMsg.chatroom then
				customData.crid = dataItem.serverMsg.chatroom.crid
			end
		end
		if from == gChatTypeUIFrom.teamMsg then
			chatIdArray[tostring(tIndex)] = dataItem.content
		else
			table.insert(chatIdArray, tIndex)
		end
	end
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	translateCtrl:translate(chatIdArray, customData)
end
function chatTranslateMgr:sMsgTranslateBack(target, data)
	local translation = data.translation
	local customData = data.target
	self:rspTranslate(translation, customData)
end
function chatTranslateMgr:getItemDatasFrom(from, key)
	local chatChannel = gChatTypeUIFrom2Channel[from]
	return self.chatDataMgr:getData(chatChannel, gChatSet.TOTAL, key)
end
function chatTranslateMgr:rspTranslate(translationList, customData)
	if not customData or not translationList then
		return
	end
	local from = customData.from
	local dataKey = customData.dataKey
	local isAutoTranslate = customData.isAutoTranslate
	customData.ignoreUpdateScroll = true
	local listItems = self:getItemDatasFrom(from, dataKey)
	for i, translation in ipairs(translationList) do
		if listItems and 0 < #listItems then
			for _, v in ipairs(listItems) do
				if v.chatId == translation.chatId and (v.dataType == gChatDataType.dataType_text or v.dataType == gChatDataType.dataType_dj) then
					self:updateTranslation(v, translation)
					v.netStatus = gChatNetStatus.normal
					self:refreshTranslation(v, customData)
					local key = from .. v.chatId
					self.tblReqTranslate[key] = nil
				end
			end
		end
	end
	local chatChannel = gChatTypeUIFrom2Channel[from]
	if 0 < #translationList then
		print("发送刷新scrollView消息-----")
		_ENV = "发送刷新scrollView消息-----"
		;("发送刷新scrollView消息-----").msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
		;("发送刷新scrollView消息-----").chatChannel = chatChannel
		;("发送刷新scrollView消息-----").chatSet = gChatSet.TOTAL
		;("发送刷新scrollView消息-----").key = dataKey
		SoraDSendMessage("发送刷新scrollView消息-----")
		_ENV = "发送刷新scrollView消息-----"
		;("发送刷新scrollView消息-----").msg = "MESSAGE_CHAT_TRANSLATION_CHANGED"
		;("发送刷新scrollView消息-----").chatChannel = chatChannel
		;("发送刷新scrollView消息-----").chatSet = gChatSet.TOTAL
		;("发送刷新scrollView消息-----").key = dataKey
		;("发送刷新scrollView消息-----").translationList = translationList
		;("发送刷新scrollView消息-----").isAutoTranslate = isAutoTranslate
		SoraDSendMessage("发送刷新scrollView消息-----")
	end
end
function chatTranslateMgr:updateTranslation(data, translation)
	if not data.translation then
		data.translation = translation
	else
		for k, _ in pairs(translation.tText) do
			data.translation.tText[k] = translation.tText[k]
		end
	end
end
function chatTranslateMgr:setDataIsShowTranslate(data, isShowTranslate)
	local chatChannel = data.chatChannel
	data.isShowTranslate = isShowTranslate
	if chatChannel == gChatChannel.MAIL then
		if data.mail then
			data.mail.property.data.isShowTranslate = isShowTranslate
		end
	elseif chatChannel == gChatChannel.CHATROOM and data.serverMsg and data.serverMsg.data then
		data.serverMsg.data.isShowTranslate = isShowTranslate
	end
end
function chatTranslateMgr:refreshTranslation(data, customData)
	local chatDataParser = include("chatDataParser")
	local isShowTranslate = self:canShowTranslation(data.translation, customData)
	if isShowTranslate == true then
		data.translation.translateInfo = chatDataParser.getTranlsateInfo(data.translation)
		self:showTranslate(data, customData)
	else
		self:showOrigin(data, customData)
	end
end
function chatTranslateMgr:langNeedAutoTranslate(sl)
	local gametop = gModuleMgr.getObject("gametop")
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local tlList = settingCtrl:getTLList()
	if sl then
		return tlList[sl]
	end
end
function chatTranslateMgr:canShowTranslation(translation, customData)
	if not translation then
		return false
	end
	local gametop = gModuleMgr.getObject("gametop")
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local tl = settingCtrl:getTranslateLanguage()
	local isShowTranslate = false
	if not customData.isAutoTranslate then
		if translation and translation.tText and translation.tText[tl] ~= nil then
			isShowTranslate = true
		end
	else
		local isNeedTranslate, _ = translateCtrl:needTranslate(translation)
		if isNeedTranslate == false and translation.tText ~= nil and translation.tText[tl] ~= nil and self:langNeedAutoTranslate(translation.sl) then
			isShowTranslate = true
		end
	end
	return isShowTranslate
end
function chatTranslateMgr:showTranslate(data, customData)
	local gametop = gModuleMgr.getObject("gametop")
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local ignoreUpdateScroll = customData.ignoreUpdateScroll
	local isAutoTranslate = customData.isAutoTranslate
	if isAutoTranslate == false and ignoreUpdateScroll == nil then
		ignoreUpdateScroll = false
	end
	local tl = settingCtrl:getTranslateLanguage()
	local chatDataParser = include("chatDataParser")
	self:setDataIsShowTranslate(data, true)
	data.itemWidth = 0
	data.itemHeight = 0
	data.contentSize = nil
	data.topSize = nil
	data.topTextSize = nil
	data.bottomSize = nil
	data.bottomTipSize = nil
	if not data.tHtmlText then
		data.tHtmlText = chatDataParser.wrapHtmlRichText(data, data.translation.tText[tl].text)
		data.translation.translateInfo = chatDataParser.getTranlsateInfo(data.translation)
	end
	data.text = data.tHtmlText
	local itemNode = data.itemNode
	if itemNode and itemNode.reInit then
		itemNode:reInit(ignoreUpdateScroll)
	end
end
function chatTranslateMgr:showOrigin(data, customData)
	local ignoreUpdateScroll = customData.ignoreUpdateScroll
	local isAutoTranslate = customData.isAutoTranslate
	if isAutoTranslate == false and ignoreUpdateScroll == nil then
		ignoreUpdateScroll = false
	end
	if data.isShowTranslate == false then
		if data.itemNode and data.itemNode.updateNetStatus then
			data.itemNode:updateNetStatus()
		end
		return
	else
		self:setDataIsShowTranslate(data, false)
	end
	local itemNode = data.itemNode
	if itemNode then
		data.text = data.htmlText
		data.itemWidth = 0
		data.itemHeight = 0
		data.contentSize = nil
		data.topSize = nil
		data.topTextSize = nil
		data.bottomSize = nil
		data.bottomTipSize = nil
		itemNode:reInit(ignoreUpdateScroll)
	end
end
function chatTranslateMgr:toggleTranslate(data, customData)
	print("data.isShowTranslate = ", data.isShowTranslate)
	if data.isShowTranslate == false then
		self:showTranslate(data, customData)
	else
		self:showOrigin(data, customData)
	end
end
function chatTranslateMgr:needAutoTranslate(data)
	local gametop = gModuleMgr.getObject("gametop")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local isAutoTranslateOn = translateCtrl:isAutoTranslateOpen()
	if not isAutoTranslateOn then
		return false
	end
	local from = gChatChannel2From[data.chatChannel]
	if not gChatAutoTranslate[from] then
		return false
	end
	return self:needTranslate(data)
end
function chatTranslateMgr:needTranslate(data)
	if data.isSelf then
		return false
	end
	if data.isSysMsg then
		return false
	end
	if data.dataType ~= gChatDataType.dataType_text then
		return false
	end
	if data.serverMsg and type(data.serverMsg.content) == "table" and data.serverMsg.content.textType ~= gChatTextType.text_plain then
		return false
	end
	if data.translation == nil then
		return true
	end
	local gametop = gModuleMgr.getObject("gametop")
	local translateCtrl = gametop.playertop_:getModule("translateCtrl")
	local isNeedTranslate, _ = translateCtrl:needTranslate(data.translation)
	return isNeedTranslate
end
return chatTranslateMgr

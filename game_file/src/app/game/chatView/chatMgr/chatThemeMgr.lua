local chatBaseMgr = include("chatBaseMgr")
local chatThemeMgr = class("chatThemeMgr", chatBaseMgr)
function chatThemeMgr:init()
	gCurrentChatTheme = SoraDConfigGet("ChatTheme~integer")
	_ENV, self.chatDataMgr = gChatMgrs:getMgr("chatDataMgr"), gChatMgrs:getMgr("chatDataMgr")
	gChatMgrs:getMgr("chatDataMgr")[gBubbleId.BUBBLE_ID_SELF] = true
	gChatMgrs:getMgr("chatDataMgr")[gBubbleId.BUBBLE_ID_SELF_NIGHT] = true
	gChatMgrs:getMgr("chatDataMgr")[gBubbleId.BUBBLE_ID_OTHER] = true
	gChatMgrs:getMgr("chatDataMgr")[gBubbleId.BUBBLE_ID_OTHER_NIGHT] = true
	gChatMgrs:getMgr("chatDataMgr")[gBubbleId.BUBBLE_ID_SYSTEM] = true
	self.bubbleThemeMap, gChatMgrs:getMgr("chatDataMgr")[gBubbleId.BUBBLE_ID_SYSTEM_NIGHT] = gChatMgrs:getMgr("chatDataMgr"), true
	self:reset()
end
function chatThemeMgr:reset()
end
function chatThemeMgr:clean()
	self:reset()
end
function chatThemeMgr:removeMessageListener()
	SoraDRemoveMessageByTarget(self)
end
function chatThemeMgr:registerMessageListener()
end
function chatThemeMgr:getCurChatTheme()
	return gCurrentChatTheme
end
function chatThemeMgr:saveCurChatTheme()
	SoraDConfigSet("ChatTheme~integer", gCurrentChatTheme)
end
function chatThemeMgr:changeToChatTheme(theme)
	gCurrentChatTheme = theme
	self:saveCurChatTheme()
	print("切换到-----", gCurrentChatTheme)
	_ENV = "切换到-----"
	;("切换到-----").msg = "MESSAGE_CHAT_THEME_CHANGED"
	SoraDSendMessage("切换到-----")
	self:updateBubbleTheme(gChatChannel.KINGDOM, gChatSet.TOTAL)
	self:updateBubbleTheme(gChatChannel.ALLIANCE, gChatSet.TOTAL)
	self:updateBubbleTheme(gChatChannel.TEAM, gChatSet.TOTAL)
	self:updateBubbleTheme(gChatChannel.DJ, gChatSet.TOTAL, 1)
	self:updateBubbleTheme(gChatChannel.KINGDOM, gChatSet.NOTICE)
	self:updateBubbleTheme(gChatChannel.ALLIANCE, gChatSet.NOTICE)
	self:updateBubbleTheme(gChatChannel.TEAM, gChatSet.NOTICE)
	self:updateBubbleThemeSet(gChatChannel.MAIL, gChatSet.TOTAL)
	self:updateBubbleThemeSet(gChatChannel.ALLIANCEMSG, gChatSet.TOTAL)
	self:updateBubbleThemeSet(gChatChannel.CHATROOM, gChatSet.TOTAL)
end
function chatThemeMgr:updateBubbleTheme(chatChannel, chatSet, key)
	if not self.chatDataMgr:hasData(chatChannel, chatSet, key) then
		return
	end
	local dataArray = self.chatDataMgr:getData(chatChannel, chatSet, key)
	local chatFunctions = include("chatFunctions")
	for _, localData in ipairs(dataArray) do
		if localData.bubbleId and self.bubbleThemeMap[localData.bubbleId] then
			_ENV, localData.bubbleId = localData.oriBubbleId, localData.oriBubbleId
			localData.oriBubbleId.checkRes = false
			local localData.oriBubbleId.data, bubbleParam = localData, localData.oriBubbleId
			localData.bubbleId = chatFunctions.getShowBubbleId(bubbleParam)
			localData.showBubbleId = localData.bubbleId
			if localData.itemNode then
				localData.itemNode:reInit(true)
			end
		elseif localData.itemNode and localData.itemNode.onThemeUpdate then
			localData.itemNode:onThemeUpdate()
		end
	end
	_ENV = ipairs(dataArray)
	ipairs(dataArray).msg = "MESSAGE_CHAT_UPDATE_SCROLLVIEW"
	ipairs(dataArray).chatChannel = chatChannel
	ipairs(dataArray).chatSet = chatSet
	ipairs(dataArray).key = key
	SoraDSendMessage(ipairs(dataArray))
end
function chatThemeMgr:updateBubbleThemeSet(chatChannel, chatSet)
	local setArray = self.chatDataMgr:getDataSet(chatChannel, chatSet)
	for key, _ in pairs(setArray) do
		self:updateBubbleTheme(chatChannel, chatSet, key)
	end
end
return chatThemeMgr

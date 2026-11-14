local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatConst = include("chatConst")
local mailFunctions = include("mailFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local chatRedPacketView = class("chatRedPacketView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatRedPacketView")
	end
	return target
end)
function chatRedPacketView:ctor()
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.scrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatScrollView_node", true)
	local realScroll = self.scrollView.scrollView
	local newSize = cc.size(realScroll:getContentSize().width, realScroll:getContentSize().height + 172)
	realScroll:setContentSize(newSize)
end
function chatRedPacketView:onMessageListener()
end
function chatRedPacketView:init(data)
	self.chatChannel = data.chatChannel
	self.chatSet = data.chatSet
	chatDataMgr = nil
	;(nil).chatChannel = self.chatChannel
	;(nil).chatSet = self.chatSet
	self.scrollView:initWithChatChannel(nil)
	local itemsData = chatDataMgr:getData(self.chatChannel, self.chatSet)
	if not itemsData or #itemsData == 0 then
		self.scrollView:requestMore()
	end
	self._isInit = true
end
function chatRedPacketView:onExitPanel()
	chatDataMgr:cleanDataNode(self.chatChannel, self.chatSet)
	chatDataMgr:cleanData(self.chatChannel, self.chatSet)
	local chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
	chatUnReadMgr:reqUnReadInfo(self.chatChannel)
end
return chatRedPacketView

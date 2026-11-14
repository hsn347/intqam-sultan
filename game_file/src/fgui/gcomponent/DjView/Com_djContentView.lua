local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatConst = include("chatConst")
local mailFunctions = include("mailFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_djContentView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_djContentView", Com_djContentView)
function Com_djContentView:onInit()
	self._isInit = false
	self.scrollView = self.fields.djScrollView
	self.nodeHead = self.fields.djHead
	self.bottomViewNode = self.fields.djBottomView
	self.djTopic = self.fields.djTopic
	if self.bottomViewNode then
		self.bottomViewNode:setViewType("chatView")
	end
	self.chatSet = gChatSet.TOTAL
end
function Com_djContentView:onShow()
end
function Com_djContentView:isInit()
	return self._isInit
end
function Com_djContentView:init(data)
	self.chatChannel = data.chatChannel
	self.chatDelegate = data.chatDelegate
	self:updateView()
	self._isInit = true
end
function Com_djContentView:onHide()
end
function Com_djContentView:updateView()
	self.bottomViewNode:initData(gChatDJShowType.CHAT_VIEW)
	self.bottomViewNode:setChatDelegate(self.chatDelegate)
	self.nodeHead:initData(nil, gChatDJShowType.CHAT_VIEW)
	_ENV = nil
	;(nil).chatChannel = self.chatChannel
	;(nil).chatSet = gChatSet.TOTAL
	;(nil).showType = gChatDJShowType.CHAT_VIEW
	;(nil).headNode = self.nodeHead
	self.scrollView:initWithChatChannel(nil)
	self.djTopic:initData(gChatDJShowType.CHAT_VIEW)
end
function Com_djContentView:initInputView(chatInputType)
	self.bottomViewNode:setChatInputType(chatInputType)
end
function Com_djContentView:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function Com_djContentView:onOffsetUI(data)
end
return Com_djContentView

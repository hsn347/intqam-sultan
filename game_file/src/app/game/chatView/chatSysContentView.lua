_ENV = nil
;(nil).dayColor = cc.c3b(172, 151, 129)
local (nil).nightColor, _defaultParam = cc.c3b(84, 75, 64), nil
local chatSysContentView = class("chatSysContentView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatSysContentView")
	end
	return target
end)
function chatSysContentView:ctor()
	SoraDDeviceFitOffset(self)
	self.scrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_chatScrollView_node", true)
	self.btnToggle = SoraDGetChildByName(self, "Button_toggle")
	self.btnToggle:addTouchEventListener(handler(self, self.onBtnToggle))
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg", true)
	self.targetY = self:getPanelOffsetHeight()
	local realScroll = self.scrollView.scrollView
	local newSize = cc.size(realScroll:getContentSize().width, realScroll:getContentSize().height + 30)
	realScroll:setContentSize(newSize)
	self:updateTheme()
end
function chatSysContentView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_THEME_CHANGED", handler(self, self.msgThemeChanged))
end
function chatSysContentView:init(data)
	self.chatChannel = data.chatChannel
	self:setPosition(cc.p(0, self.targetY))
	_UPVALUE1_ = cc.p(0, self.targetY)
	cc.p(0, self.targetY)[1] = cca.delay(0.21)
	cc.p(0, self.targetY)[2] = cca.callFunc(function()
		self = nil
		;(nil).chatChannel = self.chatChannel
		;(nil).chatSet = gChatSet.NOTICE
		self.scrollView:initWithChatChannel(nil)
	end)
	cc.p(0, self.targetY)[3] = cca.callFunc(function()
		self = nil
		;(nil).chatChannel = self.chatChannel
		;(nil).chatSet = gChatSet.NOTICE
		self.scrollView:initWithChatChannel(nil)
	end)
	self:runAction(cca.seq(cc.p(0, self.targetY)))
end
function chatSysContentView:onBtnToggle(target, event)
	if event == ccui.TouchEventType.ended then
		self:onHide()
	end
end
function chatSysContentView:onShow()
	self:runAction(cca.moveTo(0.2, 0, 0))
end
function chatSysContentView:onHide()
	self:runAction(cca.moveTo(0.2, 0, self.targetY))
end
function chatSysContentView:msgThemeChanged(target, data)
	self:updateTheme()
end
function chatSysContentView:updateTheme()
	self.ccsNightBg:updateTheme()
end
return chatSysContentView

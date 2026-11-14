local chatJoinAlliance = class("chatJoinAlliance", function(target)
	if target == nil then
		return SoraDCreateBasePanel("chatJoinAlliance")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel("chatJoinAlliance")
	end
	return target
end)
function chatJoinAlliance:ctor()
	SoraDDeviceFitOffset(self)
	self.contentPanel = SoraDGetChildByName(self, "Size_JoinAlliance_Node")
	self.btnJoin = SoraDGetChildByName(self, "btnJoin")
	self.textTip = SoraDGetChildByName(self, "textTip")
	if self.btnJoin then
		self.btnJoin:addTouchEventListener(handler(self, self.onBtnJoin))
		self.btnJoin:setPressedActionEnabled(true)
	end
	self.btnJoin:setTitleText(i18n("common_text_068"))
	self.textTip:setString(i18n("common_text_067"))
	local contentSize = self.contentPanel:getContentSize()
	self.btnJoin:setPositionY(contentSize.height / 2)
	self.textTip:setPositionY(contentSize.height / 2 + 90)
end
function chatJoinAlliance:onBtnJoin(ref, event)
	if event == ccui.TouchEventType.ended then
		print("going to alliance")
		SoraDPlaySound()
		_ENV = "going to alliance"
		;("going to alliance").msg = "MESSAGE_CHAT_OPEN_UI_ALLIANCE"
		;("going to alliance").info = "From Chat"
		SoraDSendMessage("going to alliance")
	end
end
return chatJoinAlliance

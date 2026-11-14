local bubblePopView = class("bubblePopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubblePopView")
end)
function bubblePopView:ctor(properties)
	self:setBackGround(0)
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.centerNode:setVisible(false)
	self.enableTouchCloseSelf = true
	self.btnOpen = SoraDGetChildByName(self, "Button_Open")
	self.btnOpen:addTouchEventListener(handler(self, self.btnOpenClick))
	self:setCloseCallBack(handler(self, self.showMsgTip))
	local spine_npc = sp.SkeletonAnimation:create("spine/daqiqiuhuodong.skel", "spine/daqiqiuhuodong.atlas", 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:setPosition(cc.p(0, -150))
	spine_npc:addTo(self.centerNode)
	local fingerNode = SoraDFingerAction()
	fingerNode:addTo(self.centerNode)
	fingerNode:setPosition(0, -115)
	_UPVALUE1_ = -115
	;(-115)[1] = cca.delay(1)
	;(-115)[2] = cca.callFunc(function()
		self:showBubble()
	end)
	;(-115)[3] = cca.callFunc(function()
		self:showBubble()
	end)
	self:runAction(cca.seq(-115))
end
function bubblePopView:onMessageListener()
end
function bubblePopView:btnOpenClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:close(self, eventType)
		SoraDCreatePanel("bubbleRewardPopView"):show()
	end
end
function bubblePopView:showMsgTip(eventType)
	if eventType == MSGBOX_CALLBACK_CANCEL and self.centerNode:isVisible() then
		SoraDShowMsgTip(i18n("bubbleActivity_text_01"))
	end
end
function bubblePopView:showBubble()
	self.centerNode:setVisible(true)
end
return bubblePopView

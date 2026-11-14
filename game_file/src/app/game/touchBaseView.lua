local touchBaseView = class("touchBaseView", function(ccsFileName)
	return SoraDCreateBasePanel(ccsFileName)
end)
function touchBaseView:ctor()
	self:setContentSize(display.realSize)
	self:setPosition(cc.p(display.rcx, display.rcy))
	self._ccsView:setPositionY(display.iPhoneXBottom)
	self.isTranslucentView = true
	self:setBackGround(204.0)
	self.isHidePrePanel = false
	self.isMsgBoxMode = false
	self:addTouchEventListener(handler(self, self.layerClickCallBack))
	self.handleCloseCallBack = nil
	self.touchActionPanel = nil
	self.enableTouchCloseSelf = false
end
function touchBaseView:setCloseCallBack(handl)
	self.handleCloseCallBack = handl
end
function touchBaseView:openMsgBoxMode()
	self.isMsgBoxMode = true
end
function touchBaseView:layerClickCallBack(layer, type)
	if type == ccui.TouchEventType.began then
		if self.isMsgBoxMode then
			if self.enableTouchCloseSelf then
				return
			end
			self:setVisible(false)
			_ENV = self
			self.msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
			SoraDSendMessage(self)
			if self.handleCloseCallBack then
				self.handleCloseCallBack(MSGBOX_CALLBACK_CANCEL)
			end
		end
	elseif type == ccui.TouchEventType.ended then
		if not self.isMsgBoxMode and self.handleCloseCallBack then
			self.handleCloseCallBack(MSGBOX_CALLBACK_CANCEL)
		end
		if self.enableTouchCloseSelf then
			return
		end
		SoraDPlaySound("uicontrol", 1)
		if self.touchActionPanel then
			_ENV = 0.3
			;(0.3).easing = "IN"
			;(0.3).onComplete = function()
				self:close(layer, type)
			end
			transition.execute(self.touchActionPanel, cca.scaleTo(0.3, 0.1), 0.3)
		else
			self:close(layer, type)
		end
	end
end
return touchBaseView

local cityBuildMoveTip = class("cityBuildMoveTip", function(cssFile)
	return SoraDCreateBasePanel("cityBuildMoveTip")
end)
function cityBuildMoveTip:ctor()
	self.textTip = SoraDGetChildByName(self, "textTip")
	self.btnClose = SoraDGetChildByName(self, "btnClose")
	self.imgBg = SoraDGetChildByName(self, "ImgBg")
	if self.imgBg then
		self.imgBg:setFillType(1)
	end
	self.callBackHandle = nil
	self.btnClose:addTouchEventListener(handler(self, self.btnCloseCallBack))
	self._close = self.close
	function self:close(ref, type)
		if type == ccui.TouchEventType.ended then
			if self.callBackHandle then
				self.callBackHandle()
			elseif self._close then
				self:_close(ref, type)
			end
		end
	end
end
function cityBuildMoveTip:showTip(strTip)
	if self:getParent() == nil then
		self:show()
	end
	if nil == self.textTip then
		return
	end
	self.textTip:setString(strTip)
end
function cityBuildMoveTip:setCallBackHandle(handle)
	self.callBackHandle = handle
end
function cityBuildMoveTip:btnCloseCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.callBackHandle then
			self.callBackHandle()
		end
		SoraCollectgarbage(self.__cname)
	end
end
return cityBuildMoveTip

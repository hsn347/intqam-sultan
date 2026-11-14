local EliminateGameBox = class("eliminateGameBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eliminateGameBox")
	end
	return target
end)
function EliminateGameBox:ctor()
	self.btn1 = SoraDGetChildByName(self, "btn1")
	self.btn2 = SoraDGetChildByName(self, "btn2")
	self.text1 = SoraDGetChildByName(self, "text1")
	self.text2 = SoraDGetChildByName(self, "text2")
	self.icon1 = SoraDGetChildByName(self, "icon1")
	self.icon2 = SoraDGetChildByName(self, "icon2")
	self.text = SoraDGetChildByName(self, "text")
	self.btn1:addTouchEventListener(handler(self, self.onBtn1))
	self.btn2:addTouchEventListener(handler(self, self.onBtn2))
	self:addTouchEventListener(handler(self, self.onClose))
	self:setBackGround(153.0)
	self.isHidePrePanel = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_676"))
end
function EliminateGameBox:initData(btnNum, content, param1, param2)
	if content then
		self.text:setString(content)
	end
	if btnNum == 1 then
		self.btn2:setVisible(false)
		self.btn1:setPositionX(0)
	end
	self.param1 = param1
	self.param2 = param2
	if self.param1 then
		if self.param1.text then
			self.text1:setString(self.param1.text)
		end
		if self.param1.textColor then
			self.text1:setColor(self.param1.textColor)
		end
		if self.param1.icon then
			self.icon1:setSpriteFrame(self.param1.icon)
		else
			self.icon1:setVisible(false)
			self.text1:setAnchorPoint(cc.p(0.5, 0.5))
			self.text1:setPosition(cc.p(78, 33))
		end
		if self.param1.noTouch then
			self.btn1:setTouchEnabled(false)
			self.btn1:setBright(false)
		end
	end
	if self.param2 then
		if self.param2.text then
			self.text2:setString(self.param2.text)
		end
		if self.param2.textColor then
			self.text2:setColor(self.param2.textColor)
		end
		if self.param2.icon then
			self.icon2:setSpriteFrame(self.param2.icon)
		else
			self.icon2:setVisible(false)
			self.text2:setAnchorPoint(cc.p(0.5, 0.5))
			self.text2:setPosition(cc.p(78, 33))
		end
		if self.param2.noTouch then
			self.btn2:setTouchEnabled(false)
			self.btn2:setBright(false)
		end
	end
end
function EliminateGameBox:addMessage(msgName, cb)
	SoraDAddMessage(self, msgName, cb)
end
function EliminateGameBox:onBtn1(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.param1.cb then
			self.param1.cb()
		end
		if not self.param1.notClose then
			self:close(sender, eventType)
		end
	end
end
function EliminateGameBox:onBtn2(sender, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.param2.cb then
			self.param2.cb()
		end
		if not self.param2.notClose then
			self:close(sender, eventType)
		end
	end
end
function EliminateGameBox:onClose(sender, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(sender, type)
	end
end
return EliminateGameBox

local GameSettingCommonSwitch = class("gameSettingCommonSwitch", function(target)
	if target == nil then
		return SoraDCreateBasePanel("gameSettingCommonSwitch")
	end
	return target
end)
function GameSettingCommonSwitch:ctor()
	self.handlCall = nil
	self.switchTag = nil
	self.swFlag = true
	self.btnTouch = SoraDGetChildByName(self, "Button_touch")
	self.btnTouch:setPressedActionEnabled(false)
	self.spOn = SoraDGetChildByName(self, "Sprite_on")
	self.spOff = SoraDGetChildByName(self, "Sprite_off")
	self.btnTouch:addTouchEventListener(handler(self, self.btnTouchClick))
end
function GameSettingCommonSwitch:setVal(bool)
	self.swFlag = bool
	if bool then
		self.btnTouch:setBright(true)
		self.spOn:setVisible(true)
		self.spOff:setVisible(false)
	else
		self.btnTouch:setBright(false)
		self.spOn:setVisible(false)
		self.spOff:setVisible(true)
	end
end
function GameSettingCommonSwitch:getVal()
	return self.swFlag
end
function GameSettingCommonSwitch:setIsEqup(isEquip)
	self.isEquip = isEquip
end
function GameSettingCommonSwitch:setEnabledTouch(canTouch)
	self.btnTouch:setTouchEnabled(canTouch)
end
function GameSettingCommonSwitch:setCallBack(handl)
	self.handlCall = handl
end
function GameSettingCommonSwitch:btnTouchClick(button, event)
	if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.isEquip then
			self.swFlag = not self.swFlag
		else
			self:setVal(not self.swFlag)
		end
		if self.handlCall then
			self.handlCall(self.swFlag, self:getTag())
		end
	end
end
return GameSettingCommonSwitch

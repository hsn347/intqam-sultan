local allianceActiveStageBox = class("allianceActiveStageBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceActiveStageBox")
	end
	return target
end)
function allianceActiveStageBox:ctor()
	self.Image_1 = SoraDGetChildByName(self, "Image_1")
	self.Image_2 = SoraDGetChildByName(self, "Image_2")
	self.icon_box = SoraDGetChildByName(self, "icon_box")
	self.Text_score = SoraDGetChildByName(self, "Text_score")
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:addTouchEventListener(handler(self, self.onTouchClick))
end
function allianceActiveStageBox:initData(info, curPoint)
	self.info = info
	curPoint = curPoint or 0
	self.Text_score:setString(self.info.activeNum)
	if curPoint >= self.info.activeNum then
		self:setNormal()
	else
		self:setGray()
	end
end
function allianceActiveStageBox:setGray()
	self.icon_box:setColor(cc.c3b(150, 150, 150))
end
function allianceActiveStageBox:setNormal()
	self.icon_box:setColor(cc.c3b(255, 255, 255))
end
function allianceActiveStageBox:onTouchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("allianceActiveGiftView")
		panel:initData(self.info.reward)
		panel:show()
	end
end
return allianceActiveStageBox

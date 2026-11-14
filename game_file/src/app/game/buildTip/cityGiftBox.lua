local cityGiftBox = class("cityGiftBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("cityGiftBox")
	end
	return target
end)
function cityGiftBox:ctor()
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Node_bar = SoraDGetChildByName(self, "Node_bar")
	self.Node_bar:setVisible(false)
	self.LoadingBar_bar = SoraDGetChildByName(self.Node_bar, "LoadingBar_bar")
	self.Text_time = SoraDGetChildByName(self.Node_bar, "textTime")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Button_gift = SoraDGetChildByName(self, "Button_gift")
	self.Button_gift:setSwallowTouches(false)
	self.Button_gift:addTouchEventListener(handler(self, self.onBtnGiftClick))
	self.spriteBox = SoraDGetChildByName(self, "gift")
end
function cityGiftBox:initData(tag)
	self.tag = tag or 1
	self.Node_bar:setVisible(false)
	self.Node_effect:setVisible(true)
	self.Node_bar:setVisible(false)
	self.Node_effect:setVisible(true)
	self.spriteBox:setVisible(true)
	self.Node_effect:setVisible(true)
end
function cityGiftBox:onBtnGiftClick(target, event)
	if event == ccui.TouchEventType.ended and self.tag == 1 then
		SoraDCreatePanel("celebratePopWindow"):show()
	end
end
return cityGiftBox

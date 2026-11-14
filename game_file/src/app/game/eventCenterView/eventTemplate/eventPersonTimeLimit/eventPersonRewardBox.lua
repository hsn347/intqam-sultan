local eventPersonRewardBox = class("eventPersonRewardBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventPersonRewardBox")
	end
	return target
end)
function eventPersonRewardBox:ctor()
	self.handler = nil
	self.boxStatus = true
	self.img_box = SoraDGetChildByName(self, "Image_box")
	self.btn_box = SoraDGetChildByName(self, "Button_box")
	self.btn_box:addTouchEventListener(handler(self, self.btnBoxClickCallBack))
	self:refreshView()
end
function eventPersonRewardBox:setBoxStatus(status)
	self.boxStatus = status
	self:refreshView()
end
function eventPersonRewardBox:setBoxHandler(handler)
	self.handler = handler
end
function eventPersonRewardBox:setBoxData(data)
	self.data = data
end
function eventPersonRewardBox:getBoxData()
	return self.data
end
function eventPersonRewardBox:refreshView()
	if self.boxStatus == true then
		self.img_box:loadTexture("et_cumulative_consum_01.png", ccui.TextureResType.plistType)
		self.img_box:getVirtualRenderer():setState(0)
	elseif self.boxStatus == false then
		self.img_box:loadTexture("et_cumulative_consum_02.png", ccui.TextureResType.plistType)
		self.img_box:getVirtualRenderer():setState(1)
	end
end
function eventPersonRewardBox:btnBoxClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended and self.handler then
		SoraDPlaySound()
		self.handler(self)
	end
end
return eventPersonRewardBox

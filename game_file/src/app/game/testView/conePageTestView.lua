local ConePageTestView = class("conePageTestView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("conePageTestView")
	end
	return target
end)
function ConePageTestView:ctor()
	SoraDGetChildByName(self, "Top_Size_Image_bg"):setFillType(1)
	self.nodeSlider = SoraDGetChildByName(self, "Node_slider")
	self.nodeButton = SoraDGetChildByName(self, "Node_button")
	if btn then
		btn:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.tabSlider, _ENV = btn.addTouchEventListener, btn.addTouchEventListener
	_ENV, _ENV = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).max = 100
	handler(self, self.btnClickCallBack).cur = 0
	_ENV, handler(self, self.btnClickCallBack)[1], handler(self, self.btnClickCallBack).str = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).max = 100
	handler(self, self.btnClickCallBack).cur = 0
	_ENV, handler(self, self.btnClickCallBack)[2], handler(self, self.btnClickCallBack).str = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).max = 100
	handler(self, self.btnClickCallBack).cur = 0
	_ENV, handler(self, self.btnClickCallBack)[3], handler(self, self.btnClickCallBack).str = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).max = 100
	handler(self, self.btnClickCallBack).cur = 0
	_ENV, handler(self, self.btnClickCallBack)[4], handler(self, self.btnClickCallBack).str = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).max = 100
	handler(self, self.btnClickCallBack).cur = 0
	handler(self, self.btnClickCallBack)[5], handler(self, self.btnClickCallBack).str = handler(self, self.btnClickCallBack)
	self:createSliderByList(handler(self, self.btnClickCallBack))
	self.nodeSlider:setVisible(false)
	self.tabButton, _ENV = self.nodeSlider.setVisible, self.nodeSlider.setVisible
end
function ConePageTestView:createBtnByList(list)
	self.btnSlider = SoraDGetChildByName(self, "Button_test")
	for i, v in ipairs(list) do
		local btn = self.btnSlider:clone()
		slider:addTo(self.nodeButton)
		slider:setShowType(5)
		slider:setPosition(250, y * i + 50)
		slider:initData(0, v.max, v.cur)
		slider:setMaxStr(v.str)
		self.tabSlider[i] = slider
	end
end
function ConePageTestView:createSliderByList(list)
	local y = 50
	for i, v in ipairs(list) do
		local slider = include("commonCustomSlider").new()
		slider:addTo(self.nodeSlider)
		slider:setShowType(5)
		slider:setPosition(250, y * i + 50)
		slider:initData(0, v.max, v.cur)
		slider:setMaxStr(v.str)
		self.tabSlider[i] = slider
	end
end
function ConePageTestView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		print("btn click")
	end
end
return ConePageTestView

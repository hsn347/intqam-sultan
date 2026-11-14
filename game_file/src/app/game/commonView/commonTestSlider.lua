local CommonTestSlider = class("commonTestSlider", function(target)
	if target == nil then
		return display.newNode()
	end
	return target
end)
function CommonTestSlider:ctor()
	self.sliderData, _UPVALUE0_ = nil, nil
end
function CommonTestSlider:initData(data, testNode)
	self.sliderData = data
	self.testNode = testNode
	self:createSlider()
end
function CommonTestSlider:createSlider()
	for i, v in ipairs(self.sliderData) do
		local slider = SoraDCreateCSBNode("commonSliderA")
		slider:addTo(self)
		slider:setPosition(0, (i - 1) * 80)
		slider.slider = SoraDGetChildByName(slider, "Slider_slider")
		slider.btnUp = SoraDGetChildByName(slider, "Button_up")
		slider.btnDown = SoraDGetChildByName(slider, "Button_down")
		slider.labelInput = SoraDGetChildByName(slider, "TextField_sliderInput")
		SoraDGetChildByName(slider, "Text_max"):setString(v.funcName or v.name)
		if slider.labelInput then
			slider.labelInput:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
			slider.labelInput:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			slider.labelInput:addEventListener(handler(self, self.OnInputChangeEnd))
		end
		slider.slider:addEventListener(handler(self, self.OnSliderChangeEnd))
		slider.slider:addTouchEventListener(handler(self, self.OnSliderTouchClick))
		slider.btnUp:addTouchEventListener(handler(self, self.OnSliderBtnClick))
		slider.btnDown:addTouchEventListener(handler(self, self.OnSliderBtnClick))
		slider.slider:setTag(i)
		slider.btnUp:setTag(i)
		slider.btnDown:setTag(i)
		slider.labelInput:setTag(i)
		self.sliderData[i].slider = slider
		if self.sliderData[i].precision == nil then
			self.sliderData[i].precision = 0.1
		end
		if self.sliderData[i].maxValue == nil then
			self.sliderData[i].maxValue = 999
		end
		if self.sliderData[i].minValue == nil then
			self.sliderData[i].minValue = 0
		end
		if self.sliderData[i].curValue == nil then
			self.sliderData[i].curValue = 0
		end
		self:updateSlier(i, self.sliderData[i].curValue)
	end
	dump(self.sliderData, "self.sliderData", 10)
end
function CommonTestSlider:OnInputChangeEnd(textField, eventType)
	local data = self.sliderData[textField:getTag()]
	local input = textField:getString()
	input = math.floor(tonumber(input) or 0)
	if input > data.maxValue then
		input = data.maxValue
	end
	textField:setString(input)
	if eventType == ccui.TextFiledEventType.detach_with_ime then
		if input == nil or input < data.minValue then
			input = data.minValue
		end
		self:updateSlier(textField:getTag(), input)
	end
end
function CommonTestSlider:OnSliderBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		local data = self.sliderData[button:getTag()]
		local slider = data.slider.slider
		if button == data.slider.btnUp then
			data.curValue = data.curValue + 1 / (data.precision * 10)
		elseif button == data.slider.btnDown then
			data.curValue = data.curValue - 1 / (data.precision * 10)
		end
		self:updateSlier(button:getTag(), data.curValue)
	end
end
function CommonTestSlider:OnSliderTouchClick(button, type)
	if type == ccui.TouchEventType.ended then
		local data = self.sliderData[button:getTag()]
		local slider = data.slider.slider
		local baseValue = data.maxValue - data.minValue
		self:updateSlier(button:getTag(), data.minValue + slider:getPercent() * baseValue / 100)
	end
end
function CommonTestSlider:OnSliderChangeEnd(slider, eventType)
	local data = self.sliderData[slider:getTag()]
	local slider = data.slider.slider
	local baseValue = data.maxValue - data.minValue
	local curValue = data.minValue + slider:getPercent() * baseValue / 100
	self:updateSlier(slider:getTag(), curValue)
end
function CommonTestSlider:updateSlier(index, curValue, other)
	if curValue then
		self.sliderData[index].curValue = curValue
	end
	if self.sliderData[index].curValue < self.sliderData[index].minValue then
		self.sliderData[index].curValue = self.sliderData[index].minValue
	end
	if self.sliderData[index].curValue > self.sliderData[index].maxValue then
		self.sliderData[index].curValue = self.sliderData[index].maxValue
	end
	local baseValue = self.sliderData[index].maxValue - self.sliderData[index].minValue
	print(100 * (self.sliderData[index].curValue - self.sliderData[index].minValue) / baseValue)
	self.sliderData[index].slider.slider:setPercent(100 * (self.sliderData[index].curValue - self.sliderData[index].minValue) / baseValue)
	if self.sliderData[index].handle and (not other or not other.notBack) then
		self.sliderData[index].handle(self.sliderData[index].curValue)
	end
	if self.sliderData[index].slider.labelInput then
		if self.sliderData[index].slider.labelInput.setString then
			self.sliderData[index].slider.labelInput:setString(self.sliderData[index].curValue)
		elseif self.sliderData[index].slider.setText then
			self.sliderData[index].slider.labelInput:setText(self.sliderData[index].curValue)
		end
	end
	if self.sliderData[index].funcName and self.testNode then
		self.testNode[self.sliderData[index].funcName](self.testNode, self.sliderData[index].curValue)
		print("", self.sliderData[index].funcName .. "  " .. self.sliderData[index].curValue)
	elseif self.sliderData[index].name then
		print("", self.sliderData[index].name .. "  " .. self.sliderData[index].curValue)
	end
end
return CommonTestSlider

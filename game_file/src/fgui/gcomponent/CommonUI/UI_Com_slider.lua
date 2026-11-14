local baseComponent = require("fgui.base.baseComponent")
local UI_Com_slider = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_slider", UI_Com_slider)
function UI_Com_slider:onInit()
	self.fields.slider:addEventListener(fgui.UIEventType.Changed, handler(self, self.onSliderChangeEnd))
	self.fields.Button_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Button_del:addClickListener(handler(self, self.onDelClick))
	self.input = self.fields.input:getChild("input")
	self.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	if self.fields.Text_max then
		self.fields.Text_max:setAlign(0)
	end
end
function UI_Com_slider:onShow()
	self.fields.slider:fixPos()
	self.fields.Button_del:setPositionX(self.fields.slider:getPositionX() - self.fields.slider:getWidth() / 2 - 54)
	self.fields.Button_add:setPositionX(self.fields.slider:getPositionX() + self.fields.slider:getWidth() / 2 + 47)
	self.fields.input:setPositionX(SoraDFIsRA() and 5 or self.fields.Button_add:getPositionX() + 30)
end
function UI_Com_slider:initData(sliderData)
	local allowZero = sliderData.allowZero
	local _minVal = allowZero and 0 or 1
	local minValue = sliderData.minValue or _minVal
	local maxValue = sliderData.maxValue or _minVal
	local curValue = math.min(sliderData.curValue or _minVal, maxValue)
	self.minValue = math.max(_minVal, math.min(minValue, maxValue))
	self.maxValue = math.max(_minVal, maxValue)
	self.curValue = math.max(self.minValue, math.min(curValue, self.maxValue))
	self.fields.slider:setMin(self.minValue)
	self.fields.slider:setMax(self.maxValue)
	if self.fields.Text_max then
		self.fields.Text_max:setString("/" .. self.maxValue)
	end
	self.fields.slider:setValue(self.curValue)
	self.input:setText(self.curValue)
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function UI_Com_slider:setMinValue(value)
	self.minValue = value
	self.fields.slider:setMin(self.minValue)
end
function UI_Com_slider:setMaxValue(value)
	self.maxValue = value
	self.fields.slider:setMax(self.maxValue)
	if self.fields.Text_max then
		self.fields.Text_max:setString("/" .. self.maxValue)
	end
end
function UI_Com_slider:setMaxText(text)
	if self.fields.Text_max then
		self.fields.Text_max:setString(text)
	end
end
function UI_Com_slider:getSliderCurValue()
	return self.fields.slider:getValue()
end
function UI_Com_slider:setSliderCurValue(value, otherData)
	self.curValue = math.max(self.minValue, math.min(value, self.maxValue))
	self.fields.slider:setValue(self.curValue)
	self.input:setText(self.curValue)
	if (not otherData or not otherData.notBack) and self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function UI_Com_slider:setSliderCallBack(handle)
	self.handleChangeBack = handle
end
function UI_Com_slider:onSliderChangeEnd(Context)
	self.curValue = self.fields.slider:getValue()
	if self.handleChangeBack and self.handleChangeBack(self.curValue, Context) then
		Context:preventDefault()
	end
	self.input:setText(self.curValue)
end
function UI_Com_slider:onAddClick()
	SoraDPlaySound()
	self.curValue = math.min(self.maxValue, self.curValue + 1)
	self.fields.slider:setValue(self.curValue)
	self.input:setText(self.curValue)
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function UI_Com_slider:onDelClick()
	SoraDPlaySound()
	self.curValue = math.max(self.minValue, self.curValue - 1)
	self.fields.slider:setValue(self.curValue)
	self.input:setText(self.curValue)
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function UI_Com_slider:onChanged(Context)
end
function UI_Com_slider:onSubmit(Context)
	local inputValue = self.input:getText()
	if tonumber(inputValue) then
		self.curValue = math.max(self.minValue, math.min(tonumber(inputValue), self.maxValue))
		self.input:setText(self.curValue)
		self.fields.slider:setValue(self.curValue)
		if self.handleChangeBack then
			self.handleChangeBack(self.curValue)
		end
	else
		self.input:setText(self.curValue)
		self.fields.slider:setValue(self.curValue)
	end
end
return UI_Com_slider

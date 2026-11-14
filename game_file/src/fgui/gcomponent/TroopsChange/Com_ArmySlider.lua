local baseComponent = require("fgui.base.baseComponent")
local Com_ArmySlider = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://TroopsChange/Com_ArmySlider", Com_ArmySlider)
function Com_ArmySlider:onInit()
	print("Com_ArmySlider")
	self.fields.slider:addEventListener(fgui.UIEventType.Changed, handler(self, self.onSliderChangeEnd))
	self.fields.Button_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Button_del:addClickListener(handler(self, self.onDelClick))
	self.fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	self.fields.textCost:setString(i18n("armyExchange_text_036"))
	_UPVALUE4_ = self.fields.textCost
	self.fields.textCost[1] = "input"
	self.fields.textCost[2] = "textCost"
	self.fields.textCost[3] = "n4"
	self.fields.textCost[4] = "textNum"
	for _, name in ipairs(self.fields.textCost) do
		self.fields[name]:fixPos()
	end
end
function Com_ArmySlider:onShow()
end
function Com_ArmySlider:initData(sliderData)
	self.moduleValue = sliderData.moduleValue or 1
	local minValue = sliderData.minValue or 1
	self.minValue = math.max(1, minValue)
	local maxValue = sliderData.maxValue or 1
	self.maxValue = math.max(1, maxValue)
	local curValue = sliderData.curValue or 1
	self.curValue = math.max(minValue, math.min(curValue, maxValue))
	self.fields.slider:setMin(self.minValue)
	self.fields.slider:setMax(self.maxValue)
	self.fields.slider:setValue(self.curValue)
	self.fields.input:setText(self.curValue)
	self.fields.textNum:setString(string.formatnumberthousands(self.curValue * self.moduleValue))
end
function Com_ArmySlider:getSliderCurValue()
	return self.fields.slider:getValue()
end
function Com_ArmySlider:setSliderCallBack(handle)
	self.handleChangeBack = handle
end
function Com_ArmySlider:onSliderChangeEnd(Context)
	self.curValue = self.fields.slider:getValue()
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
	self.fields.input:setText(self.curValue)
	self.fields.textNum:setString(string.formatnumberthousands(self.curValue * self.moduleValue))
end
function Com_ArmySlider:onAddClick()
	SoraDPlaySound()
	self.curValue = math.min(self.maxValue, self.curValue + 1)
	self.fields.slider:setValue(self.curValue)
	self.fields.input:setText(self.curValue)
	self.fields.textNum:setString(string.formatnumberthousands(self.curValue * self.moduleValue))
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_ArmySlider:onDelClick()
	SoraDPlaySound()
	self.curValue = math.max(self.minValue, self.curValue - 1)
	self.fields.slider:setValue(self.curValue)
	self.fields.input:setText(self.curValue)
	self.fields.textNum:setString(string.formatnumberthousands(self.curValue * self.moduleValue))
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_ArmySlider:onChanged(Context)
	print("onChanged=====", self.fields.input:getText())
end
function Com_ArmySlider:onSubmit(Context)
	local inputValue = self.fields.input:getText()
	if tonumber(inputValue) then
		self.curValue = math.max(self.minValue, math.min(tonumber(inputValue), self.maxValue))
		self.fields.input:setText(self.curValue)
		self.fields.textNum:setString(string.formatnumberthousands(self.curValue * self.moduleValue))
		self.fields.slider:setValue(self.curValue)
	elseif self.curValue then
		self.fields.input:setText(self.curValue)
		self.fields.textNum:setString(string.formatnumberthousands(self.curValue * self.moduleValue))
		self.fields.slider:setValue(self.curValue)
	end
end
return Com_ArmySlider

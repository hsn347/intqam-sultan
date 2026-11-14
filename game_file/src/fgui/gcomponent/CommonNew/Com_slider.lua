local baseComponent = require("fgui.base.baseComponent")
local Com_slider = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_slider", Com_slider)
fgui.register_extension("ui://CommonNew/Com_slider2", Com_slider)
fgui.register_extension("ui://CommonNew/Com_slider3", Com_slider)
fgui.register_extension("ui://CommonNew/Com_sliderSoldier", Com_slider)
fgui.register_extension("ui://CommonNew/Com_sliderSp", Com_slider)
fgui.register_extension("ui://CommonNew/Com_sliderNoInput", Com_slider)
fgui.register_extension("ui://Activity2112/Com_slider", Com_slider)
fgui.register_extension("ui://ShopSingleBuy/Com_slider", Com_slider)
fgui.register_extension("ui://Anniversary2022/Com_slider", Com_slider)
fgui.register_extension("ui://Anniversary2022/Com_sliderSp", Com_slider)
fgui.register_extension("ui://soldiersCampView/Com_slider", Com_slider)
fgui.register_extension("ui://Intetior/Com_Slider", Com_slider)
fgui.register_extension("ui://HeroJail/Com_slider", Com_slider)
fgui.register_extension("ui://NewUseEffect/Com_slider", Com_slider)
fgui.register_extension("ui://DessertsKing/Com_slider", Com_slider)
fgui.register_extension("ui://NebulaEmperorOfficer/Com_slider", Com_slider)
fgui.register_extension("ui://CommonDispatch/Com_slide", Com_slider)
fgui.register_extension("ui://CommonDispatch/Com_slide2", Com_slider)
function Com_slider:onInit()
	self.fields.slider:addEventListener(fgui.UIEventType.Changed, handler(self, self.onSliderChangeEnd))
	self.fields.Button_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Button_del:addClickListener(handler(self, self.onDelClick))
	if self.fields.input then
		self.fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
		self.fields.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	end
end
function Com_slider:setInpuBoxFixPos(inputOffset, bgOffset, maxOffset)
	if SoraDGetDefaultLanguage() ~= "ar" then
		self:fixChildrenPos()
		local posX = self.fields.Button_del:getPositionX()
		self.fields.Button_del:setPositionX(self.fields.Button_add:getPositionX())
		self.fields.Button_add:setPositionX(posX)
		local inputOff = inputOffset or 80
		local bgOff = bgOffset or 80
		if self.fields.n4 then
			self.fields.n4:setPositionX(posX + bgOff)
		end
		if self.fields.input then
			self.fields.input:setPositionX(posX + inputOff)
		end
		if self.fields.n3 and self.fields.input then
			self.fields.input:setPositionX(self.fields.n3:getPositionX() + 2)
		end
		if self.fields.n5 then
			self.fields.n5:setPositionX(posX + bgOff)
		end
		if self.fields.text_max then
			local maxOffset = maxOffset or 80
			self.fields.text_max:setAlign(0)
			self.fields.text_max:setPositionX(posX + maxOffset)
		end
		if self.fields.title then
			self.fields.title:setPositionX(self.fields.n4:getPositionX() + 70)
		end
	end
end
function Com_slider:onShow()
end
function Com_slider:initData(sliderData)
	local allowZero = sliderData.allowZero
	local minValue = sliderData.minValue or 1
	if allowZero then
		self.minValue = math.max(0, minValue)
	else
		self.minValue = math.max(1, minValue)
	end
	local maxValue = sliderData.maxValue or 1
	if allowZero then
		self.maxValue = math.max(0, maxValue)
	else
		self.maxValue = math.max(1, maxValue)
	end
	local curValue = sliderData.curValue or 1
	self.curValue = math.max(minValue, math.min(curValue, maxValue))
	self.fields.slider:setMin(self.minValue)
	self.fields.slider:setMax(self.maxValue)
	if self.fields.text_max then
		self.fields.text_max:setString("/" .. self.maxValue)
	end
	self.fields.slider:setValue(self.curValue)
	print("slider===", self.minValue, self.maxValue, self.curValue)
	print("===", self.fields.slider:getMin(), self.fields.slider:getMax(), self.fields.slider:getValue())
	if self.fields.input then
		self.fields.input:setText(self.curValue)
	end
	if self.fields.Text_totalCount then
		self.fields.Text_totalCount:setString("/" .. tostring(self.maxValue))
	end
	if self.handleChangeBack and not sliderData.notBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_slider:setMinValue(value)
	self.minValue = value
	self.fields.slider:setMin(self.minValue)
end
function Com_slider:setMaxValue(value)
	self.maxValue = value
	self.fields.slider:setMax(self.maxValue)
	if self.fields.text_max then
		self.fields.text_max:setString("/" .. self.maxValue)
	end
end
function Com_slider:setMaxText(text)
	if self.fields.text_max then
		self.fields.text_max:setString(text)
	end
end
function Com_slider:getSliderCurValue()
	return self.fields.slider:getValue()
end
function Com_slider:setSliderCurValue(value, otherData)
	self.curValue = math.max(self.minValue, math.min(value, self.maxValue))
	self.fields.slider:setValue(self.curValue)
	if self.fields.input then
		self.fields.input:setText(self.curValue)
	end
	if (not otherData or not otherData.notBack) and self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_slider:setSliderCallBack(handle)
	self.handleChangeBack = handle
end
function Com_slider:onSliderChangeEnd(Context)
	self.curValue = self.fields.slider:getValue()
	if self.handleChangeBack and self.handleChangeBack(self.curValue, Context) then
		Context:preventDefault()
	end
	if self.fields and self.fields.input then
		self.fields.input:setText(self.curValue)
	end
end
function Com_slider:onAddClick()
	SoraDPlaySound()
	self.curValue = math.min(self.maxValue, self.curValue + 1)
	self.fields.slider:setValue(self.curValue)
	if self.fields.input then
		self.fields.input:setText(self.curValue)
	end
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_slider:onDelClick()
	SoraDPlaySound()
	self.curValue = math.max(self.minValue or 0, self.curValue - 1)
	self.fields.slider:setValue(self.curValue)
	if self.fields.input then
		self.fields.input:setText(self.curValue)
	end
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_slider:onChanged(Context)
	print("onChanged=====", self.fields.input:getText())
end
function Com_slider:onSubmit(Context)
	print("onSubmit=====", self.fields.input:getText())
	local inputValue = self.fields.input:getText()
	if tonumber(inputValue) then
		self.curValue = math.max(self.minValue, math.min(tonumber(inputValue), self.maxValue))
		self.fields.input:setText(self.curValue)
		self.fields.slider:setValue(self.curValue)
		if self.handleChangeBack then
			self.handleChangeBack(self.curValue)
		end
	else
		self.fields.input:setText(self.curValue)
		self.fields.slider:setValue(self.curValue)
	end
end
return Com_slider

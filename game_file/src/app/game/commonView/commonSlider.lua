local ON_PERCENTAGE_CHANGED = 0
local CommonSlider = class("commonSlider", function(target)
	if target == nil then
		print("该类只用于控制")
	end
	return target
end)
function CommonSlider:ctor()
	_ENV = nil
	;(nil).maxValue = 1
	;(nil).minValue = 1
	self.tableSliderData, (nil).curValue = nil, 1
	self.slider = SoraDGetChildByName(self, "Slider_slider")
	self.labelMax = SoraDGetChildByName(self, "Text_max")
	self.btnUp = SoraDGetChildByName(self, "Button_up")
	self.btnDown = SoraDGetChildByName(self, "Button_down")
	self.newInput = nil
	if self.btnUp then
		self.btnUp:addTouchEventListener(handler(self, self.OnSliderBtnClick))
		self.btnDown:addTouchEventListener(handler(self, self.OnSliderBtnClick))
	end
	self.labelInput = SoraDGetChildByName(self, "TextField_sliderInput")
	if self.labelInput then
		self.labelInput:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		self.labelInput:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.labelInput:addEventListener(handler(self, self.OnInputChangeEnd))
	end
	self.labelInputInit = false
	self.slider:addEventListener(handler(self, self.OnSliderChangeEnd))
	self.slider:addTouchEventListener(handler(self, self.OnSliderTouchClick))
	self.handleChangeBack = nil
	self.scroll = nil
	SoradCreateTimer(self, handler(self, self.update), true)
end
function CommonSlider:setArmyMassCfg(lvCfg)
	self.lvCfg = lvCfg
end
function CommonSlider:setMask(parent, zOder)
	if parent and self.mask == nil then
		self.mask = ccui.Layout:create()
		self.mask:setAnchorPoint(cc.p(0, 0))
		self.mask:setPosition(cc.p(0, 0))
		self.mask:setContentSize(display.size)
		self.mask:setTouchEnabled(true)
		self.mask:setSwallowTouches(true)
		self.mask:addTo(parent, zOder and zOder or 999)
		self.mask:setVisible(false)
	else
		print("parent is nil or self.mask is create")
	end
end
function CommonSlider:update()
	if self.newInput then
		self:updateSlier(self.newInput)
		self.newInput = nil
		_ENV = self
		self.msg = "MESSAGE_UI_COMMON_EDITBOX_CLOSE"
		SoraDSendMessage(self)
		if self.mask then
			self.mask:setVisible(false)
		end
	end
end
function CommonSlider:setSliderCallBack(handle)
	self.handleChangeBack = handle
end
function CommonSlider:setScroll(scroll)
	self.scroll = scroll
end
function CommonSlider:setMaxValue(value)
	self.tableSliderData.maxValue = value
	self:updateSlier(nil)
end
function CommonSlider:setFloatMode(isFloat)
	self.isFloat = isFloat
end
function CommonSlider:getFindIndex(val)
	local index = math.floor(val)
	for k, v in ipairs(self.lvCfg) do
		if v == val then
			index = k
			break
		end
	end
	return index
end
function CommonSlider:getInputValue(inputValue)
	local value = tonumber(inputValue) or 0
	if not self.isFloat then
		value = math.floor(value)
	end
	if self.lvCfg then
		local val = tonumber(string.format("%.1f", inputValue))
		if not SoraDisInList(val, self.lvCfg) then
			value = self:getFindIndex(math.floor(val + 0.5))
		else
			value = self:getFindIndex(val)
		end
	end
	return value
end
function CommonSlider:getSliderCurValue()
	if self.labelInput.setDetachWithIME then
		self.labelInput:setDetachWithIME(true)
	end
	return self.tableSliderData.curValue
end
function CommonSlider:getSliderData()
	if self.labelInput.setDetachWithIME then
		self.labelInput:setDetachWithIME(true)
	end
	return self.tableSliderData
end
function CommonSlider:getEditBox()
	if self.labelInput:getDescription() == "EditBox" then
		return self.labelInput
	else
		return nil
	end
end
function CommonSlider:changeToEditBox(data)
	if not self.labelInputInit then
		self.labelInputInit = true
		local size = self.labelInput:getContentSize()
		local pos = cc.p(self.labelInput:getPositionX(), self.labelInput:getPositionY())
		local ap = self.labelInput:getAnchorPoint()
		local editBox = ccui.EditBox:create(size, "bg_transparent.png", ccui.TextureResType.plistType)
		editBox:setPosition(pos)
		editBox:setAnchorPoint(ap)
		editBox:setFontColor(display.COLOR_BLACK)
		if self.labelInput:getMaxLength() > 0 then
			editBox:setMaxLength(self.labelInput:getMaxLength())
		end
		editBox:addTouchEventListener(handler(self, self.OnEditBoxTouch))
		editBox:addTo(self.labelInput:getParent())
		editBox:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
		editBox:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
		self.labelInput:removeFromParent()
		self.labelInput = editBox
		if data and data.color then
			editBox:setFontColor(data.color)
		end
	end
end
function CommonSlider:OnEditBoxTouch(target, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		target:touchDownAction(target, type)
	end
end
function CommonSlider:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "began" then
		if self.mask then
			self.mask:setVisible(true)
		end
	elseif event == "changed" then
	elseif event == "ended" or event == "return" then
		local oldInput = editBox:getText()
		local newInput = self:getInputValue(oldInput)
		if newInput > self.tableSliderData.maxValue then
			newInput = self.tableSliderData.maxValue
		end
		if newInput == nil or newInput < self.tableSliderData.minValue then
			newInput = self.tableSliderData.minValue
		end
		self.newInput = newInput
	end
end
function CommonSlider:initData(sliderData)
	self.tableSliderData = sliderData
	self.tableSliderData.maxValue = math.max(self.tableSliderData.maxValue, 0)
	if self.tableSliderData.openEditBox or self.tableSliderData.openEditBox == nil then
		self:changeToEditBox(self.tableSliderData.editBoxData)
	end
	if self.labelMax then
		self.labelMax:setString("/" .. string.formatnumberthousands(self.tableSliderData.maxValue))
	end
	self:updateSlier(nil)
end
function CommonSlider:setAllSwallowTouches(flg)
	if self.btnUp then
		self.btnUp:setSwallowTouches(flg)
	end
	if self.btnDown then
		self.btnDown:setSwallowTouches(flg)
	end
	if self.labelInput then
		self.labelInput:setSwallowTouches(flg)
	end
end
function CommonSlider:updateSlier(curValue, other)
	if curValue then
		self.tableSliderData.curValue = curValue
	end
	if self.tableSliderData.curValue < self.tableSliderData.minValue then
		self.tableSliderData.curValue = self.tableSliderData.minValue
	end
	if self.tableSliderData.curValue > self.tableSliderData.maxValue then
		self.tableSliderData.curValue = self.tableSliderData.maxValue
	end
	local baseValue = self.tableSliderData.maxValue - self.tableSliderData.minValue
	if not other or not other.notUpdateSlider then
		if self.tableSliderData.maxValue ~= self.tableSliderData.minValue then
			self.slider:setPercent(100 * (self.tableSliderData.curValue - self.tableSliderData.minValue) / baseValue)
		else
			self.slider:setPercent(100)
		end
	end
	if self.handleChangeBack and (not other or not other.notBack) then
		self.handleChangeBack(self.tableSliderData.curValue)
	end
	if self.labelInput then
		local curVal = self.tableSliderData.curValue
		if self.lvCfg then
			curVal = self.lvCfg[self.tableSliderData.curValue]
			if self.labelInput.setString then
				self.labelInput:setString(curVal)
			elseif self.labelInput.setText then
				self.labelInput:setText(curVal)
			end
		elseif self.labelInput.setString then
			self.labelInput:setString(math.floor(curVal))
		elseif self.labelInput.setText then
			self.labelInput:setText(math.floor(curVal))
		end
	end
end
function CommonSlider:setZeroShow()
	self.slider:setPercent(0)
end
function CommonSlider:OnSliderTouchClick(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		local baseValue = self.tableSliderData.maxValue - self.tableSliderData.minValue
		local curPercent = self.slider:getPercent()
		local oldPercent = 100
		if self.tableSliderData.maxValue ~= self.tableSliderData.minValue then
			oldPercent = math.modf(100 * (self.tableSliderData.curValue - self.tableSliderData.minValue) / baseValue)
		end
		if curPercent ~= oldPercent then
			if self.tableSliderData.isChristmas then
				self:updateSlier(math.floor(curPercent * self.tableSliderData.maxValue / 100 / self.tableSliderData.minValue) * self.tableSliderData.minValue)
				return
			end
			if self.isFloat then
				self:updateSlier(curPercent * self.tableSliderData.maxValue / 100)
				return
			end
			self:updateSlier(math.floor(curPercent * self.tableSliderData.maxValue / 100))
		end
	end
end
function CommonSlider:OnSliderChangeEnd(slider, eventType)
	if eventType == ON_PERCENTAGE_CHANGED then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(slider, self.scroll, ccui.TouchEventType.began) then
			print("node is not on view :OnSliderChangeEnd")
			slider:setPercent(100 * self.tableSliderData.curValue / self.tableSliderData.maxValue)
			return
		end
		if self.tableSliderData.isChristmas then
			local curValue = math.floor(slider:getPercent() * self.tableSliderData.maxValue / 100 / self.tableSliderData.minValue)
			if curValue ~= self.tableSliderData.curValue then
				ON_PERCENTAGE_CHANGED = nil
				;(nil).notUpdateSlider = true
				self:updateSlier(curValue * self.tableSliderData.minValue, nil)
			end
			return
		end
		if self.isFloat then
			ON_PERCENTAGE_CHANGED = self.tableSliderData.maxValue
			self.tableSliderData.maxValue.notUpdateSlider = true
			self:updateSlier(slider:getPercent() * self.tableSliderData.maxValue / 100, self.tableSliderData.maxValue)
			return
		end
		local curValue = math.floor(slider:getPercent() * self.tableSliderData.maxValue / 100)
		if curValue ~= self.tableSliderData.curValue then
			ON_PERCENTAGE_CHANGED = nil
			;(nil).notUpdateSlider = true
			self:updateSlier(curValue, nil)
		end
	end
end
function CommonSlider:OnSliderBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if button == self.btnUp then
			if not self.tableSliderData.isChristmas then
				self.tableSliderData.curValue = self.tableSliderData.curValue + 1
			else
				self.tableSliderData.curValue = self.tableSliderData.curValue + self.tableSliderData.minValue
			end
		elseif button == self.btnDown then
			if not self.tableSliderData.isChristmas then
				self.tableSliderData.curValue = self.tableSliderData.curValue - 1
			else
				self.tableSliderData.curValue = self.tableSliderData.curValue - self.tableSliderData.minValue
			end
		end
		self:updateSlier(self.tableSliderData.curValue)
	end
end
function CommonSlider:OnInputChangeEnd(textField, eventType)
	if eventType == ccui.TextFiledEventType.attach_with_ime and self.scroll and not SoraDIsNodeVisibleOnScroll(textField, self.scroll) then
		print("node is not on view")
		if textField.closeIME then
			textField:closeIME()
		end
	end
	local input = self.labelInput:getString()
	input = self:getInputValue(input)
	if input > self.tableSliderData.maxValue then
		input = self.tableSliderData.maxValue
	end
	textField:setString(input)
	if eventType == ccui.TextFiledEventType.detach_with_ime then
		if input == nil or input < self.tableSliderData.minValue then
			input = self.tableSliderData.minValue
		end
		self:updateSlier(input)
	end
end
return CommonSlider

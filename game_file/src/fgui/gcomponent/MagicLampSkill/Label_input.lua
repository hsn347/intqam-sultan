local baseComponent = require("fgui.base.baseComponent")
local Label_input = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Label_input2", Label_input)
function Label_input:onInit()
	self.fields.Button_all:addClickListener(handler(self, self.onClickBtnAll))
	self.fields.Button_all:setVisible(false)
	self.textField = self.fields.input
	self.textField:setControlType(1)
	if device.platform == "mac" then
		self.fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	else
		self.textField:registerScriptEditBoxHandler(handler(self, self.editBoxTextEvent))
	end
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Label_input:onShow()
end
function Label_input:onClickBtnAll(...)
	SoraDPlaySound()
	self:cleanInput()
	if self.cleanHandler then
		self.cleanHandler()
	end
end
function Label_input:onInputChanged(...)
	local searchName = self.fields.input:getText()
	if string.utf8len(searchName) <= 0 then
		self.fields.Button_all:setVisible(false)
		if self.cleanHandler then
			self.cleanHandler()
		end
	else
		self.fields.Button_all:setVisible(true)
	end
end
function Label_input:getText(...)
	return self.fields.input:getText()
end
function Label_input:setString(...)
	self.fields.input:setString(...)
	self:onInputChanged()
end
function Label_input:initInputData(data)
	if data.maxLength then
		self.fields.input:setMaxLength(data.maxLength)
	end
	if data.prompt then
		self.fields.input:setPrompt(data.prompt)
	end
	if data.cleanHandler then
		self.cleanHandler = data.cleanHandler
	end
	if data.mask then
		self.mask = data.mask
		self.mask:addClickListener(handler(self, self.onClickMask))
	end
end
function Label_input:cleanInput(...)
	self:setString("")
end
function Label_input:getTextField(...)
	return self.fields.input:displayObject()
end
function Label_input:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	if strEventName == "began" then
		self.mask:setVisible(true)
	elseif strEventName == "changed" then
		self:onInputChanged()
	elseif strEventName == "return" then
	end
end
function Label_input:onClickMask(...)
	self:closeKeyboard()
end
function Label_input:closeKeyboard(...)
	self.textField:closeKeyboard()
	self.mask:setVisible(false)
end
return Label_input

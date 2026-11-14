local baseComponent = require("fgui.gcomponent.CommonUI.UI_input_small")
local UI_input_close = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_input_close", UI_input_close)
function UI_input_close:onInit()
	UI_input_close.super.onInit(self)
	self.fields.Button_all:addClickListener(handler(self, self.onClick_Button_all))
	self.fields.Button_all:setVisible(false)
	self.fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function UI_input_close:onShow()
	UI_input_close.super.onShow(self)
	self:clearInput()
end
function UI_input_close:clearInput(...)
	UI_input_close.super.clearInput(self, ...)
	self:onInputChanged()
end
function UI_input_close:setInputText(...)
	UI_input_close.super.setInputText(self, ...)
	self:onInputChanged()
end
function UI_input_close:onClick_Button_all(context)
	SoraDPlaySound()
	self.fields.input:setString("")
	self:onInputChanged()
	if self.cleanHandler then
		self.cleanHandler()
	end
end
function UI_input_close:onInputChanged(...)
	local searchName = self.fields.input:getText()
	if string.utf8len(searchName) <= 0 then
		self.fields.Button_all:setVisible(false)
	else
		self.fields.Button_all:setVisible(true)
	end
	if self.onChangedHandler then
		self.onChangedHandler(searchName)
	end
end
function UI_input_close:initInputData(data)
	if data.maxLength then
		self.fields.input:setMaxLength(data.maxLength)
	end
	if data.prompt then
		self.fields.input:setPrompt(data.prompt)
	end
	if data.cleanHandler then
		self.cleanHandler = data.cleanHandler
	end
	if data.onChangedHandler then
		self.onChangedHandler = data.onChangedHandler
	end
end
return UI_input_close

local baseComponent = require("fgui.base.baseComponent")
local UI_item_add115 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_item_add115", UI_item_add115)
function UI_item_add115:onInit()
	self.fields.Com_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Com_item:setClickCallback(handler(self, self.btnAddClick))
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
end
function UI_item_add115:onShow()
end
function UI_item_add115:initData(index, data)
	self.index = index
	local isItem = data and data.id
	self.controllers.c1:setSelectedIndex(isItem and 1 or 0)
	if isItem then
		self.fields.Com_item:initData(data.id, data.count)
	end
end
function UI_item_add115:btnAddClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_ITEM_CLICK"
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
function UI_item_add115:btnRemoveClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_ITEM_CLICK"
	;(nil).index = self.index
	;(nil).isRemove = true
	SoraDSendMessage(nil)
end
return UI_item_add115

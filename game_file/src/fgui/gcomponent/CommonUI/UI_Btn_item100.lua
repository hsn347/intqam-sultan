local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_item100 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_item100", UI_Btn_item100)
fgui.register_extension("ui://CommonUI/UI_Btn_item90", UI_Btn_item100)
fgui.register_extension("ui://CommonUI/UI_Btn_item80", UI_Btn_item100)
fgui.register_extension("ui://CommonUI/UI_Btn_item70", UI_Btn_item100)
fgui.register_extension("ui://CommonUI/UI_Btn_item60", UI_Btn_item100)
fgui.register_extension("ui://CommonUI/UI_Btn_itemTitle132", UI_Btn_item100)
fgui.register_extension("ui://Activity_9001678/UI_Btn_item100_snow", UI_Btn_item100)
function UI_Btn_item100:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function UI_Btn_item100:onShow()
end
function UI_Btn_item100:initData(id, num, needNum)
	self.id = id
	self.fields.item:initData(id, num, needNum)
	if self.fields.title then
		self.fields.title:setString(publicRead.getName(id))
	end
end
function UI_Btn_item100:setIcon(iconPng, num, isGray)
	self.fields.item:setIcon(iconPng, num, isGray)
end
function UI_Btn_item100:setSelectShow(ret)
	self.isShowSelect = ret
	if self.controllers.c_show then
		self.controllers.c_show:setSelectedIndex(ret and 1 or 0)
	end
end
function UI_Btn_item100:setEffect(value)
	self.fields.item:setEffect(value)
end
function UI_Btn_item100:hideEffect()
	self.fields.item:hideEffect()
end
function UI_Btn_item100:setClickCallback(callback)
	self.fields.item:setClickCallback(callback)
end
function UI_Btn_item100:btnClick()
	if self.isShowSelect then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_ITEM_CHOOSE"
		;(nil).id = self.id
		SoraDSendMessage(nil)
	end
end
return UI_Btn_item100

local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_equip100 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_equip100", UI_Btn_equip100)
fgui.register_extension("ui://CommonUI/UI_Btn_equip90", UI_Btn_equip100)
function UI_Btn_equip100:onInit()
	self.longClick = nil
	self:addLongPressListener(handler(self, self.onLongPress))
end
function UI_Btn_equip100:onShow()
end
function UI_Btn_equip100:initData(equip)
	self.equip = equip
	self.fields.equip:initData(equip)
end
function UI_Btn_equip100:initDataEX(equip)
	self.equip = equip
	self.fields.equip:initDataEX(equip)
end
function UI_Btn_equip100:setSelectShow(ret)
	if self.controllers.c_show then
		self.controllers.c_show:setSelectedIndex(ret and 1 or 0)
	end
end
function UI_Btn_equip100:setLongClick(handle)
	self.longClick = handle
end
function UI_Btn_equip100:onLongPress(button, startPos, endPos)
	if self.longClick then
		SoraDPlaySound()
		self.longClick(self.equip)
	end
end
return UI_Btn_equip100

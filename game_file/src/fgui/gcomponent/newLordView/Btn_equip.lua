local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_equip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Btn_equip", Btn_equip)
function Btn_equip:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_equip:onShow()
end
function Btn_equip:initData(part, curPart)
	self.part = part
	self.fields.icon:setSpriteFrame(equipDesRead.getPartIcon(self.part))
	self.controllers.c1:setSelectedIndex(part == curPart and 1 or 0)
end
function Btn_equip:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_EQUIP_MENU_SELECT"
	;(nil).part = self.part
	SoraDSendMessage(nil)
end
return Btn_equip

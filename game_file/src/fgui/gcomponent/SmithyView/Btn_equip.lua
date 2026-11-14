local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_equip = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_equip", Btn_equip)
function Btn_equip:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_equip:onShow()
end
function Btn_equip:initData(partEnum, part)
	self.partEnum = partEnum
	self:setSelected(self.partEnum == part)
	self.fields.icon:setSpriteFrame(equipDesRead.getPartIcon(self.partEnum))
end
function Btn_equip:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_EQUIP_MENU_PART_SELECT"
	;(nil).part = self.partEnum
	SoraDSendMessage(nil)
end
return Btn_equip

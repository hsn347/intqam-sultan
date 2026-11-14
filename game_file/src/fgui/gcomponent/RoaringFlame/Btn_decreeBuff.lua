local baseComponent = require("fgui.base.baseComponent")
local Btn_decreeBuff = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/Btn_decreeBuff", Btn_decreeBuff)
function Btn_decreeBuff:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
end
function Btn_decreeBuff:onShow()
end
function Btn_decreeBuff:initData(cfg)
	self.cfg = cfg
	self.fields.icon:setSpriteFrame(cfg.icon)
end
function Btn_decreeBuff:onLongPress(button, startPos, endPos)
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).pos = startPos
	;(nil).customName = ""
	;(nil).customTip = i18n(self.cfg.des)
	SoraDSendMessage(nil)
end
return Btn_decreeBuff

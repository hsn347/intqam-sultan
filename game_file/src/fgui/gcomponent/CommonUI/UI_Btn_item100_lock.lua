local baseComponent = require("fgui.base.baseComponent")
local UI_Btn_item100_lock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Btn_item100_lock", UI_Btn_item100_lock)
fgui.register_extension("ui://CommonUI/UI_Btn_item60_lock", UI_Btn_item100_lock)
fgui.register_extension("ui://CommonUI/UI_Btn_item70_lock", UI_Btn_item100_lock)
fgui.register_extension("ui://CommonUI/UI_Btn_item80_lock", UI_Btn_item100_lock)
function UI_Btn_item100_lock:onInit()
	self.fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
	self.fields.Ani_item:setBlendFunc(gl.ONE, gl.ONE)
end
function UI_Btn_item100_lock:onShow()
end
function UI_Btn_item100_lock:initData(...)
	self.fields.Com_item:initData(...)
end
function UI_Btn_item100_lock:setStatus(status)
	self.controllers.c1:setSelectedIndex(status)
end
return UI_Btn_item100_lock

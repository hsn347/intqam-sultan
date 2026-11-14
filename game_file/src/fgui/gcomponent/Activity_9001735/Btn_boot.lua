local baseComponent = require("fgui.base.baseComponent")
local Btn_boot = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001735/Btn_boot", Btn_boot)
function Btn_boot:onInit()
	self.fields.mv_js:setAllFrameName("dh_jiesuosjb_%.2d.png", 1)
	self.fields.mv_js:setVisible(false)
end
function Btn_boot:onShow()
end
function Btn_boot:playUnlock(callback)
	self.fields.mv_js:setVisible(true)
	self.fields.mv_js:setPlaySettings(0, -1, 1, -1, callback)
end
return Btn_boot

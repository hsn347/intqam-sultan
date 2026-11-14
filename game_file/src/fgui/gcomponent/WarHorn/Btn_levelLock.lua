local baseComponent = require("fgui.base.baseComponent")
local Btn_levelLock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarHorn/Btn_levelLock", Btn_levelLock)
function Btn_levelLock:onInit()
	self.fields.Ani_lock:setAllFrameName("dh_Tex_XL_xykh03_%.3d.png", 0)
end
function Btn_levelLock:onShow()
end
return Btn_levelLock

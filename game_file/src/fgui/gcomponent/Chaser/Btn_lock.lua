local baseComponent = require("fgui.base.baseComponent")
local Btn_lock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Btn_lock", Btn_lock)
function Btn_lock:onInit()
end
function Btn_lock:onShow()
end
function Btn_lock:setLockStatus(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
return Btn_lock

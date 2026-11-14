local baseComponent = require("fgui.base.baseComponent")
local Button_levelLock = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CommonUI/Button_levelLock", Button_levelLock)
function Button_levelLock:onInit()
	self.fields.Ani_lock:setAllFrameName("dh_zbhd1_%.2d.png", 1)
	self.fields.Ani_normal:setAllFrameName("dh_weijiesuo1_%02d.png", 1)
end
function Button_levelLock:onShow()
end
function Button_levelLock:setStatus(engouh)
	self.controllers.state:setSelectedIndex(engouh and 0 or 1)
end
function Button_levelLock:showUnlockEffect(callback)
	self.transitions.t0:play(function(...)
		if callback then
			callback()
		end
	end)
end
function Button_levelLock:resetUnlockEffect(...)
	self.transitions.t0:play(1, 0, 0, 0)
end
return Button_levelLock

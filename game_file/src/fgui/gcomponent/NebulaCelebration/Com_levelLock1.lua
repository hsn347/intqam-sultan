local baseComponent = require("fgui.base.baseComponent")
local Com_levelLock1 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaCelebration/Com_levelLock1", Com_levelLock1)
function Com_levelLock1:onInit()
	self.fields.Ani_lock:setAllFrameName("dh_zbhd1_%.2d.png", 1)
	self.fields.Ani_normal:setAllFrameName("dh_weijiesuo1_%02d.png", 1)
end
function Com_levelLock1:showUnlockEffect(callback)
	self.transitions.t0:play(1, 0.5, 0, -1, function()
		if callback then
			callback()
		end
	end)
end
function Com_levelLock1:onShow()
end
return Com_levelLock1

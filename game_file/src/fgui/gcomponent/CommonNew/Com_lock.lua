local baseComponent = require("fgui.base.baseComponent")
local Com_lock = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_lock", Com_lock)
function Com_lock:onInit()
end
function Com_lock:onShow()
end
function Com_lock:setStatus(status)
	if status == gHeroStoryUnLockType.LOCK then
		self.controllers.c1:setSelectedIndex(0)
	elseif status == gHeroStoryUnLockType.UNLOCK then
		self.transitions.t1:stop()
		self.controllers.c1:setSelectedIndex(1)
		self.transitions.t0:play(-1, 0, 0, -1)
	elseif status == gHeroStoryUnLockType.ACTIVED then
		self.transitions.t0:stop()
		self.controllers.c1:setSelectedIndex(2)
		self.transitions.t1:play(-1, 0, 0, -1)
	end
end
return Com_lock

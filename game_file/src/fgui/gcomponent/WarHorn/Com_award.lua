local baseComponent = require("fgui.base.baseComponent")
local Com_award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarHorn/Com_award", Com_award)
function Com_award:onInit()
	self.fields.icon_lock:fixPos()
end
function Com_award:onShow()
end
function Com_award:initData(id, count, state, isLock)
	self.fields.item:initData(id, count)
	self.fields.item:setMovieBorder(state == gBtnTargetStatusDef.GET, cc.c3b(255, 255, 255))
	self.fields.item:setEffectShow(state == gBtnTargetStatusDef.GET)
	self.controllers.statue:setSelectedIndex(state)
	self.controllers.c1:setSelectedIndex(isLock and 1 or 0)
end
return Com_award

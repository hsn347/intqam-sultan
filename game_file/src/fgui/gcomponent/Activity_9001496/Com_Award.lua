local baseComponent = require("fgui.base.baseComponent")
local Com_Award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001496/Com_Award", Com_Award)
function Com_Award:onInit()
end
function Com_Award:onShow()
end
function Com_Award:initData(id, count, state, unLock)
	self.fields.Com_Item:initData(id, count)
	self.fields.Com_Item:setMovieBorder(state == gBtnTargetStatusDef.GET)
	self.fields.Com_Item:setEffectShow(state == gBtnTargetStatusDef.GET)
	self.controllers.state:setSelectedIndex(state)
	self.controllers.c1:setSelectedIndex(unLock and 1 or 0)
end
return Com_Award

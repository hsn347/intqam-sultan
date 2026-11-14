local wiseTutorRead = include("wiseTutorRead")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Award = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/Com_Award", Com_Award)
fgui.register_extension("ui://RadiantDecree/Com_Award", Com_Award)
function Com_Award:onInit()
end
function Com_Award:onShow()
end
function Com_Award:initData(id, count, state, isSpecial, actCtrl)
	self.fields.Com_Item:initData(id, count)
	self.fields.Com_Item:setMovieBorder(state == gBtnTargetStatusDef.GET, isSpecial and cc.c3b(255, 207, 157) or cc.c3b(255, 255, 255))
	self.fields.Com_Item:setEffectShow(state == gBtnTargetStatusDef.GET)
	self.controllers.state:setSelectedIndex(state)
	if actCtrl == nil then
		self.controllers.c1:setSelectedIndex(not (not wiseTutorCtrl:isUnLock() and isSpecial) and 1 or 0)
	else
		self.controllers.c1:setSelectedIndex(not (not actCtrl:isUnLock() and isSpecial) and 1 or 0)
	end
end
return Com_progres

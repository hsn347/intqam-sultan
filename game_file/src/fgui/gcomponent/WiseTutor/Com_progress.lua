local wiseTutorRead = include("wiseTutorRead")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_progress = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/Com_progress", Com_progress)
function Com_progress:onInit()
	self:fixChildrenPos()
end
function Com_progress:onShow()
end
function Com_progress:initData()
	local maxValue = wiseTutorRead.getNextExp(wiseTutorCtrl:getLevel(), wiseTutorCtrl:getLevelIndex())
	self.fields.ProgressBar_Level:setValue(wiseTutorCtrl:getExp(), maxValue)
	self.fields.Text_Level:setString(wiseTutorCtrl:getLevel())
end
return Com_progres

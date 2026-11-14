local Com_Task = require("fgui.gcomponent.CommonNew.Com_Task")
local Com_taskSingle = fgui.extension_class(fgui.GComponent, Com_Task)
fgui.register_extension("ui://CommonNew/Com_taskSingle", Com_taskSingle)
fgui.register_extension("ui://CommonNew/Com_taskSingle_pop", Com_taskSingle)
fgui.register_extension("ui://Activity_9001629/Com_9001629_task", Com_taskSingle)
function Com_taskSingle:onInit()
	Com_taskSingle.super.onInit(self)
	self.scheduValeColor = "#6DDE00"
end
return Com_taskSingle

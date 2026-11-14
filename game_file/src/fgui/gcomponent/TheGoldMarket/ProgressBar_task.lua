local baseComponent = require("fgui.base.baseComponent")
local ProgressBar_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TheGoldMarket/ProgressBar_task", ProgressBar_task)
function ProgressBar_task:onInit()
	self.fields.com_bar:fixPos()
	self.fields.com_bar:getChildByName("icon"):fixPos()
end
function ProgressBar_task:onShow()
end
function ProgressBar_task:setBarValue(val)
	self.fields.com_bar:setContentSize(cc.size(559 * val / 100, 18))
end
return ProgressBar_task

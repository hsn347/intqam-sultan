local baseComponent = require("fgui.base.baseComponent")
local Btn_operate = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_operate", Btn_operate)
function Btn_operate:onInit()
	self.fields.timer:setVisible(false)
	self.fields.timer:setTimeEndListener(function()
		self.fields.timer:setVisible(false)
	end)
end
function Btn_operate:onShow()
end
function Btn_operate:setTime(time)
	if 0 < time then
		self.fields.timer:setVisible(true)
		self.fields.timer:beginTime(time)
	else
		self.fields.timer:setVisible(false)
	end
end
return Btn_operate

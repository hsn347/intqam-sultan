local baseComponent = require("fgui.base.baseComponent")
local Btn_bubble = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001663/Btn_bubble", Btn_bubble)
function Btn_bubble:onInit()
end
function Btn_bubble:onShow()
end
function Btn_bubble:initData(id)
	self.id = id
	self.fields.item:initData(self.id)
end
function Btn_bubble:playT0()
	self.transitions.t0:play()
end
return Btn_bubble

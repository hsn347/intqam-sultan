local baseComponent = require("fgui.base.baseComponent")
local Btn_manageBig = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoaringFlame/Btn_manageBig", Btn_manageBig)
function Btn_manageBig:onInit()
	self.fields.title:fixPos()
end
function Btn_manageBig:onShow()
end
function Btn_manageBig:setTime(time)
	self.controllers.c1:setSelectedIndex(0 < time and 1 or 0)
	if time then
		self.fields.Label_time:beginTime(time)
	end
end
return Btn_manageBig

local baseComponent = require("fgui.base.baseComponent")
local Btn_predict = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001734/Btn_predict", Btn_predict)
function Btn_predict:onInit()
	self:fixChildrenPos()
end
function Btn_predict:onShow()
end
function Btn_predict:setOddsColorIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
return Btn_predict

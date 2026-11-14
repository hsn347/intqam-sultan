local baseComponent = require("fgui.base.baseComponent")
local Btn_rewardPre = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://IceDragonLost/Btn_rewardPre", Btn_rewardPre)
function Btn_rewardPre:onInit()
	self.fields.title:fixPos()
	self.fields.n0:fixPos()
end
function Btn_rewardPre:onShow()
end
return Btn_rewardPre

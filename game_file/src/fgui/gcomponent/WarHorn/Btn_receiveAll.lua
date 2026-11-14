local baseComponent = require("fgui.base.baseComponent")
local Btn_receiveAll = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarHorn/Btn_receiveAll", Btn_receiveAll)
function Btn_receiveAll:onInit()
	self.fields.Label_reddot:setVisible(false)
end
function Btn_receiveAll:onShow()
end
function Btn_receiveAll:setEnabled(ret)
	self.fields.Img_bg:setGrayed(not ret)
	self:setTouchEnabled(ret)
end
function Btn_receiveAll:setRed(num)
	self.fields.Label_reddot:initData(0 < num, num)
end
return Btn_receiveAll

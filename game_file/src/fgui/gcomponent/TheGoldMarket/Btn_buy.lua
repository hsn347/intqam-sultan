local baseComponent = require("fgui.base.baseComponent")
local Btn_buy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://TheGoldMarket/Btn_buy", Btn_buy)
function Btn_buy:onInit()
end
function Btn_buy:onShow()
end
function Btn_buy:setBright(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
return Btn_buy

local baseComponent = require("fgui.base.baseComponent")
local Button_recharge = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://StarryNightCarnival/Button_recharge", Button_recharge)
function Button_recharge:onInit()
end
function Button_recharge:initData(nowPri, oriPri)
	self.fields.textNowPrice:setString(nowPri)
	self.fields.oriShowPrice:setString(oriPri)
end
function Button_recharge:onShow()
end
return Button_recharge

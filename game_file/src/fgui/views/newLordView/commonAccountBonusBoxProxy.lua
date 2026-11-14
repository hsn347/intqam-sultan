local baseProxy = require("fgui.base.baseProxy")
local commonAccountBonusBoxProxy = class("commonAccountBonusBoxProxy", baseProxy)
function commonAccountBonusBoxProxy:onRegisterEvent()
	print("=======commonAccountBonusBoxProxy:onRegisterEvent")
end
return commonAccountBonusBoxProxy

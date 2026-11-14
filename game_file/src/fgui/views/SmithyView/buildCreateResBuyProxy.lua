local baseProxy = require("fgui.base.baseProxy")
local buildCreateResBuyProxy = class("buildCreateResBuyProxy", baseProxy)
function buildCreateResBuyProxy:onRegisterEvent()
	print("=======buildCreateResBuyProxy:onRegisterEvent")
end
return buildCreateResBuyProxy

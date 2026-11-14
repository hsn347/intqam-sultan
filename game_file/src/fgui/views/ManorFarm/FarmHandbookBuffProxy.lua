local baseProxy = require("fgui.base.baseProxy")
local FarmHandbookBuffProxy = class("FarmHandbookBuffProxy", baseProxy)
function FarmHandbookBuffProxy:onRegisterEvent()
	print("=======FarmHandbookBuffProxy:onRegisterEvent")
end
return FarmHandbookBuffProxy

local baseProxy = require("fgui.base.baseProxy")
local WarGemTotalInfoProxy = class("WarGemTotalInfoProxy", baseProxy)
function WarGemTotalInfoProxy:onRegisterEvent()
	print("=======WarGemTotalInfoProxy:onRegisterEvent")
end
return WarGemTotalInfoProxy

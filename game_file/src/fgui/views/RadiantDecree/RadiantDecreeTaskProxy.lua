local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeTaskProxy = class("RadiantDecreeTaskProxy", baseProxy)
function RadiantDecreeTaskProxy:onRegisterEvent()
	print("=======RadiantDecreeTaskProxy:onRegisterEvent")
end
return RadiantDecreeTaskProxy

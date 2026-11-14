local baseProxy = require("fgui.base.baseProxy")
local newItemSingleUseProxy = class("newItemSingleUseProxy", baseProxy)
function newItemSingleUseProxy:onRegisterEvent()
	print("=======newItemSingleUseProxy:onRegisterEvent")
end
return newItemSingleUseProxy

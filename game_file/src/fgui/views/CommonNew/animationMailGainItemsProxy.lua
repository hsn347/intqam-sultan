local baseProxy = require("fgui.base.baseProxy")
local animationMailGainItemsProxy = class("animationMailGainItemsProxy", baseProxy)
function animationMailGainItemsProxy:onRegisterEvent()
	print("=======animationMailGainItemsProxy:onRegisterEvent")
end
return animationMailGainItemsProxy

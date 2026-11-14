local baseProxy = require("fgui.base.baseProxy")
local LifeSpringsSwitchSettingProxy = class("LifeSpringsSwitchSettingProxy", baseProxy)
function LifeSpringsSwitchSettingProxy:onRegisterEvent()
	print("=======LifeSpringsSwitchSettingProxy:onRegisterEvent")
end
return LifeSpringsSwitchSettingProxy

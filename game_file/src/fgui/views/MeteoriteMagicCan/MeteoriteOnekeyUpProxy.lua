local baseProxy = require("fgui.base.baseProxy")
local MeteoriteOnekeyUpProxy = class("MeteoriteOnekeyUpProxy", baseProxy)
function MeteoriteOnekeyUpProxy:onRegisterEvent()
	print("=======MeteoriteOnekeyUpProxy:onRegisterEvent")
end
return MeteoriteOnekeyUpProxy

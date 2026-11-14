local baseProxy = require("fgui.base.baseProxy")
local MeteoriteRecountProxy = class("MeteoriteRecountProxy", baseProxy)
function MeteoriteRecountProxy:onRegisterEvent()
	print("=======MeteoriteRecountProxy:onRegisterEvent")
end
return MeteoriteRecountProxy

local baseProxy = require("fgui.base.baseProxy")
local MeteoriteTipsProxy = class("MeteoriteTipsProxy", baseProxy)
function MeteoriteTipsProxy:onRegisterEvent()
	print("=======MeteoriteTipsProxy:onRegisterEvent")
end
return MeteoriteTipsProxy

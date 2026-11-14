local baseProxy = require("fgui.base.baseProxy")
local MeteoriteStrategyProxy = class("MeteoriteStrategyProxy", baseProxy)
function MeteoriteStrategyProxy:onRegisterEvent()
	print("=======MeteoriteStrategyProxy:onRegisterEvent")
end
return MeteoriteStrategyProxy

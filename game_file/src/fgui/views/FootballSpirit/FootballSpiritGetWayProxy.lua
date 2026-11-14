local baseProxy = require("fgui.base.baseProxy")
local FootballSpiritGetWayProxy = class("FootballSpiritGetWayProxy", baseProxy)
function FootballSpiritGetWayProxy:onRegisterEvent()
	print("=======FootballSpiritGetWayProxy:onRegisterEvent")
end
return FootballSpiritGetWayProxy

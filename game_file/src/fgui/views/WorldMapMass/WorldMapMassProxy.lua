local baseProxy = require("fgui.base.baseProxy")
local WorldMapMassProxy = class("WorldMapMassProxy", baseProxy)
function WorldMapMassProxy:onRegisterEvent()
	print("=======WorldMapMassProxy:onRegisterEvent")
end
return WorldMapMassProxy

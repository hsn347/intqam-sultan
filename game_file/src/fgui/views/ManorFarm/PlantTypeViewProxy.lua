local baseProxy = require("fgui.base.baseProxy")
local PlantTypeViewProxy = class("PlantTypeViewProxy", baseProxy)
function PlantTypeViewProxy:onRegisterEvent()
	print("=======PlantTypeViewProxy:onRegisterEvent")
end
return PlantTypeViewProxy

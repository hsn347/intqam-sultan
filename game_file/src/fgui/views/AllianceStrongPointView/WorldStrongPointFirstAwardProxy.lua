local baseProxy = require("fgui.base.baseProxy")
local WorldStrongPointFirstAwardProxy = class("WorldStrongPointFirstAwardProxy", baseProxy)
function WorldStrongPointFirstAwardProxy:onRegisterEvent()
	print("=======WorldStrongPointFirstAwardProxy:onRegisterEvent")
end
return WorldStrongPointFirstAwardProxy

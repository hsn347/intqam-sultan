local baseProxy = require("fgui.base.baseProxy")
local WorldMapNewPlayerMoveCitySettingProxy = class("WorldMapNewPlayerMoveCitySettingProxy", baseProxy)
function WorldMapNewPlayerMoveCitySettingProxy:onRegisterEvent()
	print("=======WorldMapNewPlayerMoveCitySettingProxy:onRegisterEvent")
end
return WorldMapNewPlayerMoveCitySettingProxy

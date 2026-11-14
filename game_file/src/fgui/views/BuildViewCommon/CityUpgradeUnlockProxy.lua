local baseProxy = require("fgui.base.baseProxy")
local CityUpgradeUnlockProxy = class("CityUpgradeUnlockProxy", baseProxy)
function CityUpgradeUnlockProxy:onRegisterEvent()
	print("=======CityUpgradeUnlockProxy:onRegisterEvent")
end
return CityUpgradeUnlockProxy

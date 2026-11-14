local baseProxy = require("fgui.base.baseProxy")
local SeedCultivateSimProxy = class("SeedCultivateSimProxy", baseProxy)
function SeedCultivateSimProxy:onRegisterEvent()
	print("=======SeedCultivateSimProxy:onRegisterEvent")
end
return SeedCultivateSimProxy

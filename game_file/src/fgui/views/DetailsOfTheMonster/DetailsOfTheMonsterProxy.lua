local baseProxy = require("fgui.base.baseProxy")
local DetailsOfTheMonsterProxy = class("DetailsOfTheMonsterProxy", baseProxy)
function DetailsOfTheMonsterProxy:onRegisterEvent()
	print("=======DetailsOfTheMonsterProxy:onRegisterEvent")
end
return DetailsOfTheMonsterProxy

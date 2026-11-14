local baseProxy = require("fgui.base.baseProxy")
local DessertThiefRewardProxy = class("DessertThiefRewardProxy", baseProxy)
function DessertThiefRewardProxy:onRegisterEvent()
	print("=======DessertThiefRewardProxy:onRegisterEvent")
end
return DessertThiefRewardProxy

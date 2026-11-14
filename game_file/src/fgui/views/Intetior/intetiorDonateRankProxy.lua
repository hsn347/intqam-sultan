local baseProxy = require("fgui.base.baseProxy")
local intetiorDonateRankProxy = class("intetiorDonateRankProxy", baseProxy)
function intetiorDonateRankProxy:onRegisterEvent()
	print("=======intetiorDonateRankProxy:onRegisterEvent")
end
return intetiorDonateRankProxy

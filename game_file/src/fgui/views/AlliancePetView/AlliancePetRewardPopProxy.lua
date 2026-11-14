local baseProxy = require("fgui.base.baseProxy")
local AlliancePetRewardPopProxy = class("AlliancePetRewardPopProxy", baseProxy)
function AlliancePetRewardPopProxy:onRegisterEvent()
	print("=======AlliancePetRewardPopProxy:onRegisterEvent")
end
return AlliancePetRewardPopProxy

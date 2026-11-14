local baseProxy = require("fgui.base.baseProxy")
local evilPalaceRewardViewProxy = class("evilPalaceRewardViewProxy", baseProxy)
function evilPalaceRewardViewProxy:onRegisterEvent()
	print("=======evilPalaceRewardViewProxy:onRegisterEvent")
end
return evilPalaceRewardViewProxy

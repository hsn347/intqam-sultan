local baseProxy = require("fgui.base.baseProxy")
local PetFeedResultViewProxy = class("PetFeedResultViewProxy", baseProxy)
function PetFeedResultViewProxy:onRegisterEvent()
	print("=======PetFeedResultViewProxy:onRegisterEvent")
end
return PetFeedResultViewProxy

local baseProxy = require("fgui.base.baseProxy")
local PetItemFeedViewProxy = class("PetItemFeedViewProxy", baseProxy)
function PetItemFeedViewProxy:onRegisterEvent()
	print("=======PetItemFeedViewProxy:onRegisterEvent")
end
return PetItemFeedViewProxy

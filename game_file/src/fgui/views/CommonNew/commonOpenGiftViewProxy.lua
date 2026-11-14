local baseProxy = require("fgui.base.baseProxy")
local commonOpenGiftViewProxy = class("commonOpenGiftViewProxy", baseProxy)
function commonOpenGiftViewProxy:onRegisterEvent()
	print("=======commonOpenGiftViewProxy:onRegisterEvent")
end
return commonOpenGiftViewProxy

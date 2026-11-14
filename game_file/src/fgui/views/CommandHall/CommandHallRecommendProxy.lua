local baseProxy = require("fgui.base.baseProxy")
local CommandHallRecommendProxy = class("CommandHallRecommendProxy", baseProxy)
function CommandHallRecommendProxy:onRegisterEvent()
	print("=======CommandHallRecommendProxy:onRegisterEvent")
end
return CommandHallRecommendProxy

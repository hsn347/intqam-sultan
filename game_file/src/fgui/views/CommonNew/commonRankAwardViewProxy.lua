local baseProxy = require("fgui.base.baseProxy")
local commonRankAwardViewProxy = class("commonRankAwardViewProxy", baseProxy)
function commonRankAwardViewProxy:onRegisterEvent()
	print("=======commonRankAwardViewProxy:onRegisterEvent")
end
return commonRankAwardViewProxy

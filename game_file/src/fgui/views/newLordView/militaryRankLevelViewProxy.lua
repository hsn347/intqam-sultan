local baseProxy = require("fgui.base.baseProxy")
local militaryRankLevelViewProxy = class("militaryRankLevelViewProxy", baseProxy)
function militaryRankLevelViewProxy:onRegisterEvent()
	print("=======militaryRankLevelViewProxy:onRegisterEvent")
end
return militaryRankLevelViewProxy

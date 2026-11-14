local baseProxy = require("fgui.base.baseProxy")
local CommonRankStageViewProxy = class("CommonRankStageViewProxy", baseProxy)
function CommonRankStageViewProxy:onRegisterEvent()
	print("=======CommonRankStageViewProxy:onRegisterEvent")
end
return CommonRankStageViewProxy

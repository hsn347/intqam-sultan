local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildConditionProxy = class("AllianceBuildConditionProxy", baseProxy)
function AllianceBuildConditionProxy:onRegisterEvent()
	print("=======AllianceBuildConditionProxy:onRegisterEvent")
end
return AllianceBuildConditionProxy

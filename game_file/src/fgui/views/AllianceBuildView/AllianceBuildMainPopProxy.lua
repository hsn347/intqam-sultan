local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildMainPopProxy = class("AllianceBuildMainPopProxy", baseProxy)
function AllianceBuildMainPopProxy:onRegisterEvent()
	print("=======AllianceBuildMainPopProxy:onRegisterEvent")
end
return AllianceBuildMainPopProxy

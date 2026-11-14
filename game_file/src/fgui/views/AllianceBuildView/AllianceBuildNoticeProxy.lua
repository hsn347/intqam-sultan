local baseProxy = require("fgui.base.baseProxy")
local AllianceBuildNoticeProxy = class("AllianceBuildNoticeProxy", baseProxy)
function AllianceBuildNoticeProxy:onRegisterEvent()
	print("=======AllianceBuildNoticeProxy:onRegisterEvent")
end
return AllianceBuildNoticeProxy

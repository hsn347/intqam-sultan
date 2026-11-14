local baseProxy = require("fgui.base.baseProxy")
local collegeStudyingViewProxy = class("collegeStudyingViewProxy", baseProxy)
function collegeStudyingViewProxy:onRegisterEvent()
	print("=======collegeStudyingViewProxy:onRegisterEvent")
end
return collegeStudyingViewProxy

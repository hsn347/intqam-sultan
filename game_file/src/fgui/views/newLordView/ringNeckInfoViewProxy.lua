local baseProxy = require("fgui.base.baseProxy")
local ringNeckInfoViewProxy = class("ringNeckInfoViewProxy", baseProxy)
function ringNeckInfoViewProxy:onRegisterEvent()
	print("=======ringNeckInfoViewProxy:onRegisterEvent")
end
return ringNeckInfoViewProxy

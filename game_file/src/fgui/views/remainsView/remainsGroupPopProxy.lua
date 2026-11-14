local baseProxy = require("fgui.base.baseProxy")
local remainsGroupPopProxy = class("remainsGroupPopProxy", baseProxy)
function remainsGroupPopProxy:onRegisterEvent()
	print("=======remainsGroupPopProxy:onRegisterEvent")
end
return remainsGroupPopProxy

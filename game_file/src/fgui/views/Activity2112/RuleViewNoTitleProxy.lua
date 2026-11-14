local baseProxy = require("fgui.base.baseProxy")
local RuleViewNoTitleProxy = class("RuleViewNoTitleProxy", baseProxy)
function RuleViewNoTitleProxy:onRegisterEvent()
	print("=======RuleViewNoTitleProxy:onRegisterEvent")
end
return RuleViewNoTitleProxy

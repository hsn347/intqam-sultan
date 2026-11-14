local baseProxy = require("fgui.base.baseProxy")
local DivineBeastRuleProxy = class("DivineBeastRuleProxy", baseProxy)
function DivineBeastRuleProxy:onRegisterEvent()
	print("=======DivineBeastRuleProxy:onRegisterEvent")
end
return DivineBeastRuleProxy

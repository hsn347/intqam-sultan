local baseProxy = require("fgui.base.baseProxy")
local RuleViewProxy = class("RuleViewProxy", baseProxy)
function RuleViewProxy:onRegisterEvent()
	print("=======RuleViewProxy:onRegisterEvent")
end
function RuleViewProxy:onRemoveView()
	print("=======RuleViewProxy:onRemoveView")
end
return RuleViewProxy

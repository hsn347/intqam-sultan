local baseProxy = require("fgui.base.baseProxy")
local gamePolicyAndTermsProxy = class("gamePolicyAndTermsProxy", baseProxy)
function gamePolicyAndTermsProxy:onRegisterEvent()
	print("=======gamePolicyAndTermsProxy:onRegisterEvent")
end
return gamePolicyAndTermsProxy

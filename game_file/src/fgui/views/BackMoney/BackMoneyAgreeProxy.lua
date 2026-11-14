local baseProxy = require("fgui.base.baseProxy")
local BackMoneyAgreeProxy = class("BackMoneyAgreeProxy", baseProxy)
function BackMoneyAgreeProxy:onRegisterEvent()
	print("=======BackMoneyAgreeProxy:onRegisterEvent")
end
return BackMoneyAgreeProxy

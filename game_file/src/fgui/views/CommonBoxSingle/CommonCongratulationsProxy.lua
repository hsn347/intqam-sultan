local baseProxy = require("fgui.base.baseProxy")
local CommonCongratulationsProxy = class("CommonCongratulationsProxy", baseProxy)
function CommonCongratulationsProxy:onRegisterEvent()
	print("=======CommonCongratulationsProxy:onRegisterEvent")
end
return CommonCongratulationsProxy

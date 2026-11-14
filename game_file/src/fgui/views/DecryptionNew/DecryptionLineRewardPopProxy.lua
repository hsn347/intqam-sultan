local baseProxy = require("fgui.base.baseProxy")
local DecryptionLineRewardPopProxy = class("DecryptionLineRewardPopProxy", baseProxy)
function DecryptionLineRewardPopProxy:onRegisterEvent()
	print("=======DecryptionLineRewardPopProxy:onRegisterEvent")
end
return DecryptionLineRewardPopProxy

local baseProxy = require("fgui.base.baseProxy")
local DecryptionRewardPopProxy = class("DecryptionRewardPopProxy", baseProxy)
function DecryptionRewardPopProxy:onRegisterEvent()
	print("=======DecryptionRewardPopProxy:onRegisterEvent")
end
return DecryptionRewardPopProxy

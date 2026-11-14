local baseProxy = require("fgui.base.baseProxy")
local CommonRewardPreviewProxy = class("CommonRewardPreviewProxy", baseProxy)
function CommonRewardPreviewProxy:onRegisterEvent()
	print("=======CommonRewardPreviewProxy:onRegisterEvent")
end
return CommonRewardPreviewProxy

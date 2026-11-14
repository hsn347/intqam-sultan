local baseProxy = require("fgui.base.baseProxy")
local SultanCoinGiftPopProxy = class("SultanCoinGiftPopProxy", baseProxy)
function SultanCoinGiftPopProxy:onRegisterEvent()
	print("=======SultanCoinGiftPopProxy:onRegisterEvent")
end
return SultanCoinGiftPopProxy

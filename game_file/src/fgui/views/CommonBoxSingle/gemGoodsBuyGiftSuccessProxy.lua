local baseProxy = require("fgui.base.baseProxy")
local gemGoodsBuyGiftSuccessProxy = class("gemGoodsBuyGiftSuccessProxy", baseProxy)
function gemGoodsBuyGiftSuccessProxy:onRegisterEvent()
	print("=======gemGoodsBuyGiftSuccessProxy:onRegisterEvent")
end
return gemGoodsBuyGiftSuccessProxy

local baseProxy = require("fgui.base.baseProxy")
local ItemComposeViewProxy = class("ItemComposeViewProxy", baseProxy)
function ItemComposeViewProxy:onRegisterEvent()
	print("=======ItemComposeViewProxy:onRegisterEvent")
end
return ItemComposeViewProxy

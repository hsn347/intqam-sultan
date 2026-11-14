local baseProxy = require("fgui.base.baseProxy")
local ItemSendPopProxy = class("ItemSendPopProxy", baseProxy)
function ItemSendPopProxy:onRegisterEvent()
	print("=======ItemSendPopProxy:onRegisterEvent")
end
return ItemSendPopProxy

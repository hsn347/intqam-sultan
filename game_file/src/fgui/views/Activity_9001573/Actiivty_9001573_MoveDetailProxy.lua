local baseProxy = require("fgui.base.baseProxy")
local Actiivty_9001573_MoveDetailProxy = class("Actiivty_9001573_MoveDetailProxy", baseProxy)
function Actiivty_9001573_MoveDetailProxy:onRegisterEvent()
	print("=======Actiivty_9001573_MoveDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function Actiivty_9001573_MoveDetailProxy:serverMessage_RequestMapInstaceInfo(taget, data)
	self.view:updateData(data)
end
return Actiivty_9001573_MoveDetailProxy

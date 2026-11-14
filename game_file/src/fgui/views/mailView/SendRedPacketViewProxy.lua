local baseProxy = require("fgui.base.baseProxy")
local SendRedPacketViewProxy = class("SendRedPacketViewProxy", baseProxy)
function SendRedPacketViewProxy:onRegisterEvent()
	print("=======SendRedPacketViewProxy:onRegisterEvent")
end
return SendRedPacketViewProxy

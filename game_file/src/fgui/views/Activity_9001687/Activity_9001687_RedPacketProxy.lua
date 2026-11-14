local baseProxy = require("fgui.base.baseProxy")
local Activity_9001687_RedPacketProxy = class("Activity_9001687_RedPacketProxy", baseProxy)
function Activity_9001687_RedPacketProxy:onRegisterEvent()
	print("=======Activity_9001687_RedPacketProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_CLAIM_RED_PACKET", handler(self, self.sMsgClaimRedPacket))
end
function Activity_9001687_RedPacketProxy:sMsgClaimRedPacket()
	self.view:close()
end
return Activity_9001687_RedPacketProxy

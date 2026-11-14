local baseProxy = require("fgui.base.baseProxy")
local caracalUpgradeProxy = class("caracalUpgradeProxy", baseProxy)
function caracalUpgradeProxy:onRegisterEvent()
	print("=======caracalUpgradeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_REFRESH", handler(self, self.recviceData))
end
function caracalUpgradeProxy:recviceData(target, data)
	if data.name == "unlock" then
		self.view:close()
	end
end
return caracalUpgradeProxy

local baseProxy = require("fgui.base.baseProxy")
local Activity_9001615_ChooseProxy = class("Activity_9001615_ChooseProxy", baseProxy)
function Activity_9001615_ChooseProxy:onRegisterEvent()
	print("=======Activity_9001615_ChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_SMELT_CHOOSE_EQUIP", function()
		self.view:close()
	end)
end
return Activity_9001615_ChooseProxy

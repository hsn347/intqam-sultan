local baseProxy = require("fgui.base.baseProxy")
local testProxy = class("testProxy", baseProxy)
function testProxy:onRegisterEvent()
	print("=======testProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHEAT_ADDITEM_SUCCESS", function()
		SoraDShowMsgTip("搞定！")
	end)
end
return testProxy

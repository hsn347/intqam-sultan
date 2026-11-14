local baseProxy = require("fgui.base.baseProxy")
local EmbassyViewProxy = class("EmbassyViewProxy", baseProxy)
function EmbassyViewProxy:onRegisterEvent()
	print("=======EmbassyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS", handler(self, self.initData))
end
function EmbassyViewProxy:initData(...)
	self.view:initData(...)
end
return EmbassyViewProxy

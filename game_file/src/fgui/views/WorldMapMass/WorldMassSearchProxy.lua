local baseProxy = require("fgui.base.baseProxy")
local WorldMassSearchProxy = class("WorldMassSearchProxy", baseProxy)
function WorldMassSearchProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_MASS_SETTING_WHITE_LIST_SEARCH", handler(self, self.onMsgSearchBack))
end
function WorldMassSearchProxy:onMsgSearchBack(target, data)
	self.view:onMsgSearchBack(data.list)
end
return WorldMassSearchProxy

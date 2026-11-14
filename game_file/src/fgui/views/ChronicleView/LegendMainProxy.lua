local baseProxy = require("fgui.base.baseProxy")
local LegendMainProxy = class("LegendMainProxy", baseProxy)
function LegendMainProxy:onRegisterEvent()
	print("=======LegendMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_LEGENDM_LOADPAGE", handler(self, self.msgLoadPage))
end
function LegendMainProxy:msgLoadPage(target, data)
	local pageType = data.pageType
	local pageData = data.pageData
	self.view:loadNextPage(pageType, pageData)
end
return LegendMainProxy

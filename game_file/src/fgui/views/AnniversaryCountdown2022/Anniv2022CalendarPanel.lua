local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Anniv2022CalendarPanel = class("Anniv2022CalendarPanel", baseFguiPanel)
function Anniv2022CalendarPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Anniv2022CalendarPanel:ctor", self.viewName)
end
function Anniv2022CalendarPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Anniv2022CalendarPanel:onInit()
	print("=======Anniv2022CalendarPanel:onInit")
end
function Anniv2022CalendarPanel:onShow()
	print("=======Anniv2022CalendarPanel:onShow")
end
return Anniv2022CalendarPanel

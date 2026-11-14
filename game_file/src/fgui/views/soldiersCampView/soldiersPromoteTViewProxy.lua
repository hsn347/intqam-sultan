local baseProxy = require("fgui.base.baseProxy")
local soldiersPromoteTViewProxy = class("soldiersPromoteTViewProxy", baseProxy)
function soldiersPromoteTViewProxy:onRegisterEvent()
	print("=======soldiersPromoteTViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WARFRAME_PROMOTE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_COMMON_ICON_TIP", handler(self, self.updateCommonIconTip))
end
function soldiersPromoteTViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function soldiersPromoteTViewProxy:updateCommonIconTip(target, data)
	self.view:hideTips()
end
return soldiersPromoteTViewProxy

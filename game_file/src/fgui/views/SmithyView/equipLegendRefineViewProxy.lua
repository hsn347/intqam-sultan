local baseProxy = require("fgui.base.baseProxy")
local equipLegendRefineViewProxy = class("equipLegendRefineViewProxy", baseProxy)
function equipLegendRefineViewProxy:onRegisterEvent()
	print("=======equipLegendRefineViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LEGEND_LEVELUP", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemCount))
end
function equipLegendRefineViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function equipLegendRefineViewProxy:updateItemCount(target, data)
	self.view:updateItemCount(target, data)
end
return equipLegendRefineViewProxy

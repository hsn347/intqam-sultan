local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeGetTreasureProxy = class("StarEnergyCubeGetTreasureProxy", baseProxy)
function StarEnergyCubeGetTreasureProxy:onRegisterEvent()
	print("=======StarEnergyCubeGetTreasureProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_STAR_ENERGY_CUBE", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItem))
end
function StarEnergyCubeGetTreasureProxy:updateItem(target, data)
	if self.view then
		self.view:updateItem()
		self.view:updateGetBtnState()
	end
end
function StarEnergyCubeGetTreasureProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
return StarEnergyCubeGetTreasureProxy

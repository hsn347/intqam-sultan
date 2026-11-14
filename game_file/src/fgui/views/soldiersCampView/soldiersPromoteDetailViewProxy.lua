local baseProxy = require("fgui.base.baseProxy")
local soldiersPromoteDetailViewProxy = class("soldiersPromoteDetailViewProxy", baseProxy)
function soldiersPromoteDetailViewProxy:onRegisterEvent()
	print("=======soldiersPromoteDetailViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ARMY_TOOL_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_ARMY", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FORG_WARFRAME_BACK", handler(self, self.initWarframeView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_BACK", handler(self, self.initWarframeView))
end
function soldiersPromoteDetailViewProxy:initData()
	self.view:initData()
end
function soldiersPromoteDetailViewProxy:updateView()
	self.view:updateView()
end
function soldiersPromoteDetailViewProxy:initWarframeView()
	self.view:initWarframeView()
end
return soldiersPromoteDetailViewProxy

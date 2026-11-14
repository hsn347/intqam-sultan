local baseProxy = require("fgui.base.baseProxy")
local StarEnergyCubeProxy = class("StarEnergyCubeProxy", baseProxy)
function StarEnergyCubeProxy:onRegisterEvent()
	print("=======StarEnergyCubeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_STAR_ENERGY_CUBE", handler(self, self.refreshView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshItem))
end
function StarEnergyCubeProxy:refreshView(target, data)
	if self.view then
		self.view:refreshView(data)
	end
end
function StarEnergyCubeProxy:refreshItem()
	if self.view then
		self.view:initData()
	end
end
function StarEnergyCubeProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.STAR_CUBE_ACTIVITY) then
		SoraDRemoveAllPanelFromManager()
	end
end
return StarEnergyCubeProxy

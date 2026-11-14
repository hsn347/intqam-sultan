local baseProxy = require("fgui.base.baseProxy")
local RamadanWorldExplorerProxy = class("RamadanWorldExplorerProxy", baseProxy)
function RamadanWorldExplorerProxy:onRegisterEvent()
	print("=======RamadanWorldExplorerProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RAMADAN_WORLD_EXPLORER_TASK_UPDATE", handler(self, self.onUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanWorldExplorerProxy:onUpdateView()
	self.view:updateView()
end
function RamadanWorldExplorerProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RamadanWorldExplorerProxy

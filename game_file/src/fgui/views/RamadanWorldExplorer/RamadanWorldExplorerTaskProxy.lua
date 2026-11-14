local baseProxy = require("fgui.base.baseProxy")
local RamadanWorldExplorerTaskProxy = class("RamadanWorldExplorerTaskProxy", baseProxy)
function RamadanWorldExplorerTaskProxy:onRegisterEvent()
	print("=======RamadanWorldExplorerTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
	SoraDAddMessage(self, "MESSAGE_RAMADAN_WORLD_EXPLORER_CLOSE_TASK_VIEW", handler(self, self.onCloseBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function RamadanWorldExplorerTaskProxy:onResultClose(target, data)
	if data.isWin then
		SoraDGetCtrl("ramadanWorldExplorerCtrl"):reqRamadanWorldExplorerCompleteTask(self.param.taskIdx)
		_ENV = self.param.taskIdx
		self.param.taskIdx.taskIdx = 0
		self.view:updateView(self.param.taskIdx)
	end
end
function RamadanWorldExplorerTaskProxy:onCloseBack()
	self.view:close()
end
function RamadanWorldExplorerTaskProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return RamadanWorldExplorerTaskProxy

local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasureUIProxy = class("NebulaTreasureUIProxy", baseProxy)
function NebulaTreasureUIProxy:onRegisterEvent()
	print("=======NebulaTreasureUIProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULA_EXPLORATION_ACTIVITY", handler(self, self.ctrlListenBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NebulaTreasureUIProxy:ctrlListenBack(target, data)
	SoraDCloseLoading()
	if data.subMsg == "Explore" then
		local rspdata = data.rspdata
		self.view:showAllItemEffect(rspdata.newProgress)
		if rspdata.curLevel then
		else
		end
	elseif data.subMsg == "Claim" then
		self.view:refreshBox()
	end
end
function NebulaTreasureUIProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_EXPLORATION_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return NebulaTreasureUIProxy

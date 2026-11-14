local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarShowProxy = class("NebulaAllStarShowProxy", baseProxy)
function NebulaAllStarShowProxy:onRegisterEvent()
	print("=======NebulaAllStarShowProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgRefreshData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_GET_RANK", handler(self, self.onMsgGetPlayerRank))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_EXCHANGE_RECORD_BACK", handler(self, self.updateShopRed))
end
function NebulaAllStarShowProxy:onMsgCommonRefresh(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaAllStarShowProxy:onMsgRefreshData(...)
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if not nebulaAllStarUtil.checkSettleState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
	self.view:updateActivityState(...)
end
function NebulaAllStarShowProxy:onMsgGetPlayerRank(target, event)
	if event.from ~= "NebulaAllStarShow" then
		return
	end
	if event.rankType ~= self.view.rankType then
		return
	end
	SoraDCloseLoading(self.view:displayObject())
	if not event.rspdata.rankList then
		local _ENV, rankList = event.rspdata.rankList, event.rspdata.rankList
	end
	self.view:refreshRankData(rankList)
end
function NebulaAllStarShowProxy:updateShopRed(target, data)
	self.view:updateShopRed(target, data)
end
return NebulaAllStarShowProxy

local baseProxy = require("fgui.base.baseProxy")
local KingStarBattleProxy = class("KingStarBattleProxy", baseProxy)
function KingStarBattleProxy:onRegisterEvent()
	print("=======KingStarBattleProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_KING_DATA_BACK", handler(self, self.sMsgActivityDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_INFO", handler(self, self.showOccupierInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_OCCUPIER_CHANGE", handler(self, self.reqOccupierInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.sMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_INIT", handler(self, self.refreshIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_HEROIC_LAND_REFRESH", handler(self, self.refreshIcon))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_SHOP_REFRESH", handler(self, self.updateExchangeNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.updateExchangeNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WAR_DATA", handler(self, self.onMsgUpdateLegendData))
end
function KingStarBattleProxy:sMsgActivityDataBack(target, data)
	print("数据返回了 ----------")
	SoraDCloseLoading(self.view)
	self.view:initView()
end
function KingStarBattleProxy:showOccupierInfo(target, data)
	SoraDCloseLoading(self.view)
	self.view:showOccupierInfo(target, data)
end
function KingStarBattleProxy:reqOccupierInfo(target, data)
	SoraDCloseLoading(self.view)
	self.view:reqOccupierInfo(target, data)
end
function KingStarBattleProxy:sMsgCommonRefresh(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	if data.activityID and type(data.activityID) == "table" then
		for i, v in ipairs(data.activityID) do
			if tonumber(v) == self.view.activityID then
				local activityState = activityShowCtrl:getStateByID(self.view.activityID)
				if activityState == gActivityState.CLOSE then
					SoraDRemoveAllPanelFromManager()
					break
				end
				if activityState == gActivityState.OPEN then
					local param = activityShowCtrl:getParamByID(self.view.activityID)
					local legendState = param.curState
					if legendState == ACTIVITY_STATE.PREPARE then
						SoraDRemoveAllPanelFromManager()
						break
					end
					if legendState == ACTIVITY_STATE.ACTIVE then
						SoraDRemoveAllPanelFromManager()
						break
					end
					if legendState == ACTIVITY_STATE.SETTLE then
						SoraDRemoveAllPanelFromManager()
					end
				end
				break
			end
		end
	end
end
function KingStarBattleProxy:msgGetLordInfo(target, data)
	SoraDCloseLoading(self.view)
	if data.clientData and data.lord then
		local keyName = "fromLegendaryKingView_" .. self.view.viewType
		local keyValue = data.clientData[keyName]
		if keyValue == true then
			SoraDOpenLordView(data.lord)
		end
	end
end
function KingStarBattleProxy:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	SoraDCloseLoading(self.view)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "KingStarBattlePanel" then
			local kid = alliance:getProperty("sourceKid")
			SoraDOpenAllianceInfoView(alliance, kid)
		end
	end
end
function KingStarBattleProxy:refreshIcon(target, data)
	self.view:refreshIcon()
end
function KingStarBattleProxy:updateExchangeNum(target, data)
	self.view:updateExchangeNum()
end
function KingStarBattleProxy:onMsgUpdateLegendData(...)
	self.view:onMsgUpdateLegendData(...)
end
return KingStarBattleProxy

local baseProxy = require("fgui.base.baseProxy")
local LegendMPopListProxy = class("LegendMPopListProxy", baseProxy)
function LegendMPopListProxy:onRegisterEvent()
	print("=======LegendMPopListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_CONTENT", handler(self, self.sMsgRoadMembersDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_CONTENT", handler(self, self.sMsgRoadMembersDataBack))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function LegendMPopListProxy:sMsgRoadMembersDataBack(target, data)
	print("legendMPopList:sMsgRoadMembersDataBack(target, data)")
	dump(data, "data----")
	local achieveID = data.achieveID
	print("self.achieveID = ", self.view.achieveID, ", achieveID = ", achieveID)
	if self.view.achieveID ~= achieveID then
		print("legendMPopList:sMsgRoadMembersDataBack(target, data) 类型不匹配--------------------")
		return
	end
	SoraDCloseLoading()
	self.view:updateList(data)
end
function LegendMPopListProxy:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading()
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function LegendMPopListProxy:sMsgReqInfoBack(target, data)
	SoraDCloseLoading()
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "LegendMPopList" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
return LegendMPopListProxy

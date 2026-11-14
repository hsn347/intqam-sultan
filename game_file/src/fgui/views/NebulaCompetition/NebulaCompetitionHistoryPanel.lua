local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCompetitionHistoryPanel = class("NebulaCompetitionHistoryPanel", baseFguiPanel)
local title_url = "ui://NebulaCompetition/Label_historyTitle"
local rank_url = "ui://NebulaCompetition/NebulaKingHistoryItem"
function NebulaCompetitionHistoryPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCompetitionHistoryPanel:ctor", self.viewName)
end
function NebulaCompetitionHistoryPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaCompetition"
	end
	return self._packageList
end
function NebulaCompetitionHistoryPanel:onInit()
	print("=======NebulaCompetitionHistoryPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2713"))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaCompetitionHistoryPanel:onItemProvider(index)
	local data = self.historyList[index + 1]
	if type(data) == "number" then
		return title_url
	else
		return rank_url
	end
end
function NebulaCompetitionHistoryPanel:onItemRenderer(index, obj)
	local data = self.historyList[index + 1]
	if type(data) == "number" then
		_ENV = nil
		;(nil).num = data
		obj:setString(i18n("Nebulaking_text_02", nil))
	else
		obj:initData(data)
	end
end
function NebulaCompetitionHistoryPanel:onShow()
	print("=======NebulaCompetitionHistoryPanel:onShow")
	SoraDGetCtrl("nebulaCompetitionCtrl"):sendReqHistoryRank()
end
function NebulaCompetitionHistoryPanel:updateRank(historyRankInfo)
	self.historyList, _ENV = nil, nil
	for i, list in ipairs(historyRankInfo) do
		table.insert(self.historyList, i)
		for index, value in ipairs(list) do
			table.insert(self.historyList, value)
		end
	end
	if #self.historyList > 0 then
		self.fields.List:setNumItems(#self.historyList)
	else
		self.fields.Text_noRank:setString(i18n("Nebulaking_text_01"))
	end
end
return NebulaCompetitionHistoryPanel

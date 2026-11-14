local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaKingHistoryPanel = class("NebulaKingHistoryPanel", baseFguiPanel)
local title_url = "ui://NebulaKing/Label_historyTitle"
local rank_url = "ui://NebulaKing/NebulaKingHistoryItem"
function NebulaKingHistoryPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaKingHistoryPanel:ctor", self.viewName)
end
function NebulaKingHistoryPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaKingHistoryPanel:onInit()
	print("=======NebulaKingHistoryPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2713"))
	self.fields.List:setItemProvider(handler(self, self.onItemProvider))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaKingHistoryPanel:onItemProvider(index)
	local data = self.historyList[index + 1]
	if type(data) == "number" then
		return title_url
	else
		return rank_url
	end
end
function NebulaKingHistoryPanel:onItemRenderer(index, obj)
	local data = self.historyList[index + 1]
	if type(data) == "number" then
		_ENV = nil
		;(nil).num = data
		obj:setString(i18n("Nebulaking_text_02", nil))
	else
		obj:initData(data)
	end
end
function NebulaKingHistoryPanel:onShow()
	print("=======NebulaKingHistoryPanel:onShow")
	SoraDGetCtrl("nebulaKingCtrl"):sendReqHistoryRank()
end
function NebulaKingHistoryPanel:updateRank(historyRankInfo)
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
return NebulaKingHistoryPanel

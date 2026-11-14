local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleHistoryPanel = class("kingdomBattleHistoryPanel", baseFguiPanel)
function kingdomBattleHistoryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleHistoryPanel:ctor", self.viewName)
end
function kingdomBattleHistoryPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleHistoryPanel:onInit()
	self.historyList, _ENV = nil, nil
	self.fields.Com_title:initData(i18n("common_text_3032"), handler(self, self.onClickClose))
	self.fields.Com_rankTitle:fixChildrenPos()
	local titleFields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	titleFields.Text_atk:setString(i18n("common_text_3034"))
	titleFields.Text_def:setString(i18n("common_text_3033"))
	titleFields.Text_result:setString(i18n("common_text_3035"))
	self.fields.Top_Size_ScrollView_content:setItemRenderer(handler(self, self.onItemRenderer))
	print("=======kingdomBattleHistoryPanel:onInit")
end
function kingdomBattleHistoryPanel:onShow()
	conquestWarCtrl:reqGetConquestWarBattleResult()
	SoraDShowLoading()
	print("=======kingdomBattleHistoryPanel:onShow")
end
function kingdomBattleHistoryPanel:initScroll(list)
	self.historyList = list
	self.fields.Top_Size_ScrollView_content:setNumItems(#list)
end
function kingdomBattleHistoryPanel:onItemRenderer(index, target)
	target:initdata(self.historyList[index + 1])
end
return kingdomBattleHistoryPanel

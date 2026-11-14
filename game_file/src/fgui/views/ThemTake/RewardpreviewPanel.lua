local loudlyDressRead = include("loudlyDressRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RewardpreviewPanel = class("RewardpreviewPanel", baseFguiPanel)
function RewardpreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RewardpreviewPanel:ctor", self.viewName)
end
function RewardpreviewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RewardpreviewPanel:onInit()
	print("=======RewardpreviewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	_ENV = i18n("decrypt_text_03")
	i18n("decrypt_text_03").num = loudlyDressRead.getCfgNum()
	self.fields.Text_cumu:setString(i18n("Loudlydressed_text_12", i18n("decrypt_text_03")))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function RewardpreviewPanel:onItemRenderer(index, obj)
	obj:initData(index + 1)
end
function RewardpreviewPanel:onShow()
	print("=======RewardpreviewPanel:onShow")
	local index, reward = loudlyDressRead.getCumuReward()
	self.fields.com_cumu:initData(reward[1].id, reward[1].count)
	self.fields.List:setNumItems(loudlyDressRead.getCfgNum())
end
return RewardpreviewPanel

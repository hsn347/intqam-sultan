local footballClothesCtrl = SoraDGetCtrl("footballClothesCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local jerseyRewardPanel = class("jerseyRewardPanel", baseFguiPanel)
function jerseyRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("jerseyRewardPanel:ctor", self.viewName)
end
function jerseyRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function jerseyRewardPanel:onInit()
	print("=======jerseyRewardPanel:onInit")
	self.fields.panel_normal:setTitle(i18n("decrypt_text_03"))
	self.fields.btn_get:addClickListener(handler(self, self.onClickGet))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRederer))
end
function jerseyRewardPanel:onShow()
	print("=======jerseyRewardPanel:onShow")
	self.data = self.proxy.param.data
	self.status = self.proxy.param.status
	if self.status == gBtnTargetStatusDef.GOT then
		self.fields.btn_get:setString(i18n("common_text_1892"))
	else
		self.fields.btn_get:setString(i18n("common_text_854"))
	end
	self.fields.btn_get:setEnabled(self.status == gBtnTargetStatusDef.GET)
	self.fields.scroll:setNumItems(#self.data.reward)
end
function jerseyRewardPanel:onClickGet()
	SoraDPlaySound()
	print("onClickGet", self.data.type, self.data.id)
	footballClothesCtrl:reqFootballClothesReceiveReward(self.data.type, self.data.num)
	self:closePanel()
end
function jerseyRewardPanel:onItemRederer(index, target)
	target:initData(self.data.reward[index + 1].id, self.data.reward[index + 1].count)
end
return jerseyRewardPanel

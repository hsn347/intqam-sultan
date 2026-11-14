local ramadanWorldExplorerRead = include("ramadanWorldExplorerRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanWorldExplorerGetAwardPanel = class("RamadanWorldExplorerGetAwardPanel", baseFguiPanel)
function RamadanWorldExplorerGetAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RamadanWorldExplorerGetAwardPanel:ctor", self.viewName)
end
function RamadanWorldExplorerGetAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanWorldExplorerGetAwardPanel:onInit()
	print("=======RamadanWorldExplorerGetAwardPanel:onInit")
	self.fields.bg:setString(i18n("god_beast_text_04"))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.rewards = self.proxy.param.rewards
	self.fields.List_award:setNumItems(#self.rewards)
	self.fields.Btn_reward:addClickListener(handler(self, self.onClickButton))
	if self.proxy.param.statue == gBtnTargetStatusDef.GET then
		self.fields.Btn_reward:setEnabled(true)
		self.fields.Btn_reward:setString(i18n("common_text_1146"))
	elseif self.proxy.param.statue == gBtnTargetStatusDef.GOT then
		self.fields.Btn_reward:setEnabled(false)
		self.fields.Btn_reward:setString(i18n("common_text_1892"))
	else
		self.fields.Btn_reward:setEnabled(false)
		self.fields.Btn_reward:setString(i18n("common_text_2139"))
	end
end
function RamadanWorldExplorerGetAwardPanel:onShow()
	print("=======RamadanWorldExplorerGetAwardPanel:onShow")
end
function RamadanWorldExplorerGetAwardPanel:onHide()
	print("=======RamadanWorldExplorerGetAwardPanel:onHide")
end
function RamadanWorldExplorerGetAwardPanel:onDispose()
	print("=======RamadanWorldExplorerGetAwardPanel:onDispose")
end
function RamadanWorldExplorerGetAwardPanel:onItemRenderer(index, target)
	target:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function RamadanWorldExplorerGetAwardPanel:onClickButton()
	SoraDGetCtrl("ramadanWorldExplorerCtrl"):reqRamadanWorldExplorerPlanReward(self.proxy.param.index)
	self:close()
end
return RamadanWorldExplorerGetAwardPanel

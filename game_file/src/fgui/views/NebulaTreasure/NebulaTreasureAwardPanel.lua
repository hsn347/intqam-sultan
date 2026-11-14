local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasureAwardPanel = class("NebulaTreasureAwardPanel", baseFguiPanel)
function NebulaTreasureAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaTreasureAwardPanel:ctor", self.viewName)
end
function NebulaTreasureAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasureAwardPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======NebulaTreasureAwardPanel:onInit")
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:addClickEventListener(handler(self, self.onGetClick))
	self.fields.Btn_reward:setTitle(i18n("common_text_1146"))
	self.fields.bg:setTitle(i18n("common_text_059"))
end
function NebulaTreasureAwardPanel:updateView()
	if not self.isOpen then
		self.fields.Btn_reward:setTitle(i18n("common_text_2139"))
	end
	if self.isGot then
		self.fields.Btn_reward:setTitle(i18n("common_text_1892"))
	end
	self.fields.Btn_reward:setEnabled(self.isOpen and not self.isGot)
	_UPVALUE2_ = self.isOpen and not self.isGot
	;(self.isOpen and not self.isGot)[1] = "id"
	;(self.isOpen and not self.isGot)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(self.cfg.reward, self.isOpen and not self.isGot)
	self.fields.List_award:setNumItems(#self.rewards)
end
function NebulaTreasureAwardPanel:onShow()
	print("=======NebulaTreasureAwardPanel:onShow")
	dump(self.param, "self.param")
	self.cfg = self.param.cfg
	self.isOpen = self.param.isOpen
	self.isGot = self.param.isGot
	self.stage = self.cfg.stage
	self:updateView()
end
function NebulaTreasureAwardPanel:onItemRenderer(index, obj)
	local award = self.rewards[index + 1]
	obj:initData(award.id, award.count)
end
function NebulaTreasureAwardPanel:onGetClick()
	SoraDPlaySound()
	local nebulaTreasureCtrl = SoraDGetCtrl("nebulaTreasureCtrl")
	nebulaTreasureCtrl:sendreceive(self.stage)
	SoraDMailGainItems(self.rewards, true)
	self:close()
end
return NebulaTreasureAwardPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertMiningGetRewardPanel = class("DesertMiningGetRewardPanel", baseFguiPanel)
function DesertMiningGetRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DesertMiningGetRewardPanel:ctor", self.viewName)
end
function DesertMiningGetRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertMiningGetRewardPanel:onInit()
	print("=======DesertMiningGetRewardPanel:onInit")
	self.fields.title:setString(i18n("Lucky_treasure_text_05"))
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	if not self.proxy.param.reward then
		_ENV = self.proxy.param.reward
	end
	self.reward = self.proxy.param.reward
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
	self.fields.Button_Confirm:setString(i18n("common_text_204"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(#self.reward)
	if #self.reward <= 20 then
		self.fields.List:resizeToFit(#self.reward)
	else
		self.fields.List:setHeight(420)
	end
	self.fields.Button_Confirm:addClickListener(handler(self, self.onClickConfirm))
end
function DesertMiningGetRewardPanel:onShow()
	print("=======DesertMiningGetRewardPanel:onShow")
	if self.param and self.param.showAction then
		self:showAction()
	end
end
function DesertMiningGetRewardPanel:onItemRenderer(index, obj)
	local item = self.reward[index + 1]
	obj:initData(item.id, item.count)
end
function DesertMiningGetRewardPanel:onClickConfirm()
	SoraDPlaySound()
	self:removeFromParent()
end
function DesertMiningGetRewardPanel:showAction(...)
	self.Bg_black:setVisible(false)
	self.view:setScale(0)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.scaleTo(0.2, 1.12, 1.12)
	;(nil)[2] = ffa.scaleTo(0.4666666666666667, 1, 1)
	;(nil)[3] = ffa.scaleTo(0.4666666666666667, 1, 1)
	;(nil)[4] = ffa.scaleTo(0.4666666666666667, 1, 1)
	;(nil)[5] = ffa.scaleTo(0.4666666666666667, 1, 1)
	self.view:runAction(ffa.seq(nil))
end
return DesertMiningGetRewardPanel

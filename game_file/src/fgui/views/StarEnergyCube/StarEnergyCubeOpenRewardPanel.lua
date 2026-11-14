local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubeOpenRewardPanel = class("StarEnergyCubeOpenRewardPanel", baseFguiPanel)
function StarEnergyCubeOpenRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyCubeOpenRewardPanel:ctor", self.viewName)
end
function StarEnergyCubeOpenRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarEnergyCubeOpenRewardPanel:onInit()
	self.view:setScale(0)
	print("=======StarEnergyCubeOpenRewardPanel:onInit")
	self.controllers.c1:setSelectedIndex(SoraDGetDefaultLanguage() == "ar" and 0 or 1)
	self.fields.title:setString(i18n("Martial_arts_text_09"))
	self.fields.Button_confirm:setTitleText(i18n("common_text_204"))
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickClose))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function StarEnergyCubeOpenRewardPanel:initData(data)
	self.reward = data.reward
	if self.reward and next(self.reward) then
		self.fields.List_reward:setNumItems(table.nums(self.reward))
	end
	_UPVALUE2_ = self.fields.List_reward
	self.fields.List_reward[1] = ffa.callFunc(function(...)
		self.view:setScale(0)
	end)
	self.fields.List_reward[2] = ffa.scaleTo(0.09166666666666666, 1.05, 1.05)
	self.fields.List_reward[3] = ffa.scaleTo(0.18333333333333332, 1, 1)
	self.fields.List_reward[4] = ffa.scaleTo(0.18333333333333332, 1, 1)
	self.fields.List_reward[5] = ffa.scaleTo(0.18333333333333332, 1, 1)
	self.fields.List_reward[6] = ffa.scaleTo(0.18333333333333332, 1, 1)
	local seq = ffa.seq(self.fields.List_reward)
	_UPVALUE2_ = ffa.callFunc(function(...)
		self.view:setScale(0)
	end)
	ffa.callFunc(function(...)
		self.view:setScale(0)
	end)[1] = ffa.fadeIn(0.06666666666666667)
	ffa.callFunc(function(...)
		self.view:setScale(0)
	end)[2] = seq
	local spawn = ffa.spawn((ffa.callFunc(function(...)
		self.view:setScale(0)
	end)))
	self.view:runAction(spawn)
end
function StarEnergyCubeOpenRewardPanel:onItemRenderer(index, object)
	object:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function StarEnergyCubeOpenRewardPanel:onClickClose()
	SoraDPlaySound()
	self:close()
end
function StarEnergyCubeOpenRewardPanel:onShow()
	print("=======StarEnergyCubeOpenRewardPanel:onShow")
	self:initData(self.proxy.param)
end
return StarEnergyCubeOpenRewardPanel

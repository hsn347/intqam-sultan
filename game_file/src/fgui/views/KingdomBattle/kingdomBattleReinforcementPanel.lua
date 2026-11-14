local constantRead = include("constantRead")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleReinforcementPanel = class("kingdomBattleReinforcementPanel", baseFguiPanel)
function kingdomBattleReinforcementPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleReinforcementPanel:ctor", self.viewName)
end
function kingdomBattleReinforcementPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleReinforcementPanel:onInit()
	print("=======kingdomBattleReinforcementPanel:onInit")
	self.fields.Com_title:initData(i18n("conquestwar_text_10"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function kingdomBattleReinforcementPanel:onShow()
	print("=======kingdomBattleReinforcementPanel:onShow")
	if conquestWarCtrl:isDoubleReward() then
		conquestWarReinforcementsCtrl:reqConquestWarMatchReinforce()
	else
		conquestWarCtrl:reqAgreeReinforcementsInfo()
	end
end
function kingdomBattleReinforcementPanel:updateView(data)
	local power = 0
	self.reinforceList, _ENV = nil, nil
	for i, v in pairs(data.reinforcements) do
		power = power + v.strength
		table.insert(self.reinforceList, v)
	end
	table.sort(self.reinforceList, function(l, r)
		if l.strength ~= r.strength then
			return l.strength > r.strength
		else
			return l.uid < r.uid
		end
	end)
	local num = table.nums(self.reinforceList)
	self.fields.List:setNumItems(#self.reinforceList)
	local diff = data.totalCanInviteStrength or 0
	_ENV = self.reinforceList
	self.reinforceList.num1 = conquestWarCtrl:getNumString(power)
	_ENV, _ENV, self.reinforceList.num2 = conquestWarCtrl, conquestWarCtrl:getNumString(diff), conquestWarCtrl:getNumString(diff)
	_ENV, conquestWarCtrl:getNumString(diff).num1, conquestWarCtrl.color = conquestWarCtrl, conquestWarCtrl, "#FFD719"
	conquestWarCtrl:getNumString(diff).__default, conquestWarCtrl.color = conquestWarCtrl, "#FEF9EC"
	self.fields.Text_Power:setString(i18n_html("conquestwar_text_14", self.reinforceList, (conquestWarCtrl:getNumString(diff))))
	_ENV = i18n_html("conquestwar_text_14", self.reinforceList, (conquestWarCtrl:getNumString(diff)))
	i18n_html("conquestwar_text_14", self.reinforceList, (conquestWarCtrl:getNumString(diff))).num1 = num
	_ENV, _ENV, i18n_html("conquestwar_text_14", self.reinforceList, (conquestWarCtrl:getNumString(diff))).num2 = "CONQUESTWAR_REINFORCEMENT_AGREE", constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10), constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10)
	_ENV, constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10).num1, ("CONQUESTWAR_REINFORCEMENT_AGREE").color = "CONQUESTWAR_REINFORCEMENT_AGREE", "CONQUESTWAR_REINFORCEMENT_AGREE", "#FFD719"
	constantRead.getConstValue("CONQUESTWAR_REINFORCEMENT_AGREE", 10).__default, ("CONQUESTWAR_REINFORCEMENT_AGREE").color = "CONQUESTWAR_REINFORCEMENT_AGREE", "#FEF9EC"
	self.fields.Text_Num:setString(i18n_html("conquestwar_text_15", i18n_html("conquestwar_text_14", self.reinforceList, (conquestWarCtrl:getNumString(diff)))))
end
function kingdomBattleReinforcementPanel:onItemRender(index, target)
	target:initData(self.reinforceList[index + 1])
end
return kingdomBattleReinforcementPanel

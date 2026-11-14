local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneAffirmPanel = class("RuneAffirmPanel", baseFguiPanel)
function RuneAffirmPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneAffirmPanel:ctor", self.viewName)
end
function RuneAffirmPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneAffirmPanel:onInit()
	print("=======RuneAffirmPanel:onInit")
	self.tabIndex = 1
	self.precent = artifactRuneRead.getRuneHeritRatio()
	_ENV = nil
	;(nil).var = fguiHelper.getColorString("#70C723", self.precent)
	local str1 = i18n("%{var}%", nil)
	_ENV = fguiHelper.getColorString("#70C723", self.precent)
	fguiHelper.getColorString("#70C723", self.precent).var = fguiHelper.getColorString("#70C723", 100)
	local str2 = i18n("%{var}%", (fguiHelper.getColorString("#70C723", self.precent)))
	_ENV = 100
	;(100).num1 = str1
	;(100).num2 = str2
	self.fields.Text_tip:setString(i18n("Weapon_Rune_tips_057", 100))
	self.fields.Text_review:setString(i18n("Weapon_Rune_tips_058"))
	self.fields.Btn_normal:setString(i18n("Weapon_Rune_button_009"))
	self.fields.Btn_normal:addClickListener(handler(self, self.onNormalClick))
	self.fields.list:setAlignCenter(true)
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_111"))
	self.fields.Text_none:setVisible(false)
end
function RuneAffirmPanel:onShow()
	print("=======RuneAffirmPanel:onShow")
	local info = artifactRuneRead.getRuneInfo(self.param.sourceData.rid)
	local ret_item, ret_rune, ret_exp = artifactRuneRead.getInheritPre(info.ExpGrowingType, self.param.sourceData.level, self.tabIndex == 1 and 100 or self.precent, self.param.sourceData.exp)
	local ret_cost = artifactRuneRead.getInheritPreCost(self.param.sourceData.extraProperty, self.tabIndex == 1 and 100 or self.precent)
	dump(self.param.sourceData, "self.param.sourceData===")
	self.result, _ENV = dump, dump
	for k, v in ipairs(ret_item) do
		table.insert(self.result, v)
	end
	for k, v in ipairs(ret_cost) do
		table.insert(self.result, v)
	end
	for k, v in ipairs(ret_rune) do
		table.insert(self.result, v)
	end
	for k, v in ipairs(ret_exp) do
		table.insert(self.result, v)
	end
	self.fields.Text_review:setVisible(#self.result > 0)
	self.fields.list:setNumItems(#self.result)
	self.fields.Text_none:setVisible(#self.result == 0)
end
function RuneAffirmPanel:onItemRenderer(index, obj)
	obj:initData(self.result[index + 1].id, self.result[index + 1].count)
end
function RuneAffirmPanel:onNormalClick()
	SoraDPlaySound()
	godArmsRuneCtrl:sendInherit(self.param.sourceData.uid, self.param.targetData.uid)
	self:close()
end
return RuneAffirmPanel

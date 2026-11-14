local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactRuneRead = include("artifactRuneRead")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneRebornPopPanel = class("RuneRebornPopPanel", baseFguiPanel)
function RuneRebornPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneRebornPopPanel:ctor", self.viewName)
end
function RuneRebornPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneRebornPopPanel:onInit()
	print("=======RuneRebornPopPanel:onInit")
	local precent = artifactRuneRead.getRuneHeritRatio()
	_ENV = nil
	;(nil).var = precent
	local str1 = i18n("%{var}%", nil)
	_ENV = nil
	;(nil).var = 100
	local str2 = i18n("%{var}%", nil)
	_ENV = nil
	;(nil).num1 = str1
	;(nil).num2 = str2
	self.fields.Text_des:setString(i18n("Weapon_Rune_tips_070", nil))
	self.fields.Btn_normal:setString(i18n("Weapon_Rune_tips_078"))
	self.fields.Btn_normal:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Btn_senior:setString(i18n("Weapon_Rune_tips_096"))
	self.fields.Btn_senior:addClickListener(handler(self, self.onBtnSeniroClick))
end
function RuneRebornPopPanel:onShow()
	print("=======RuneRebornPopPanel:onShow")
	local id, num = artifactRuneRead.getReturnCost(self.param.data.rid, self.param.data.level)
	local itemCount = backpackCtrl:getItemCount(id)
	self.costID = id
	self.isSeniorEnough = num <= itemCount
	self.fields.Btn_senior:setCostIcon(id)
	self.fields.Btn_senior:updateCostNum(num, id)
	self.fields.Btn_senior:setGrayed(not self.isSeniorEnough)
end
function RuneRebornPopPanel:onBtnNormalClick()
	SoraDPlaySound()
	godArmsRuneCtrl:sendReborn(self.param.data.uid)
	if self.param.parent then
		self.param.parent:close()
	end
	self:close()
end
function RuneRebornPopPanel:onBtnSeniroClick()
	SoraDPlaySound()
	if self.isSeniorEnough then
		godArmsRuneCtrl:sendReborn(self.param.data.uid, true)
		if self.param.parent then
			self.param.parent:close()
		end
		self:close()
	else
		local sources = itemDesRead.getOutput(self.costID)
		_ENV = nil
		;(nil).sources = sources
		uiManager:show("CommonSourceGuide", nil)
	end
end
return RuneRebornPopPanel

local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactRuneRead = include("artifactRuneRead")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneAdvancePopPanel = class("RuneAdvancePopPanel", baseFguiPanel)
function RuneAdvancePopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneAdvancePopPanel:ctor", self.viewName)
end
function RuneAdvancePopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneAdvancePopPanel:onInit()
	print("=======RuneAdvancePopPanel:onInit")
	local precent = artifactRuneRead.getRuneHeritRatio()
	_ENV = nil
	;(nil).var = fguiHelper.getColorString("#70C723", precent)
	local str1 = i18n("%{var}%", nil)
	_ENV = fguiHelper.getColorString("#70C723", precent)
	fguiHelper.getColorString("#70C723", precent).var = fguiHelper.getColorString("#70C723", 100)
	local str2 = i18n("%{var}%", (fguiHelper.getColorString("#70C723", precent)))
	_ENV = 100
	;(100).num1 = str1
	;(100).num2 = str2
	self.fields.Text_des:setString(i18n("Weapon_Rune_tips_075", 100))
	self.fields.Btn_normal:setString(i18n("common_text_2921"))
	self.fields.Btn_normal:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Btn_senior:setString(i18n("Weapon_Rune_tips_100"))
	self.fields.Btn_senior:addClickListener(handler(self, self.onBtnSeniroClick))
end
function RuneAdvancePopPanel:onShow()
	print("=======RuneAdvancePopPanel:onShow")
	local seniorCostNum = 0
	local itemID = 207501
	for k, v in ipairs(self.param.uidList) do
		local runeInfo = godArmsRuneCtrl:getRuneInfo(v)
		local isGrowUp = godArmsRuneCtrl:isRuneGrowup(v)
		if isGrowUp then
			local id, num = artifactRuneRead.getReturnCost(runeInfo.rid, runeInfo.level)
			itemID = id
			seniorCostNum = seniorCostNum + num
		end
	end
	local itemCount = backpackCtrl:getItemCount(itemID)
	self.costID = itemID
	self.isSeniorEnough = seniorCostNum <= itemCount and 0 < seniorCostNum
	self.fields.Btn_senior:setCost(itemID, seniorCostNum)
	self.fields.Btn_senior:setGrayed(not self.isSeniorEnough)
	self.controllers.c1:setSelectedIndex(0 < seniorCostNum and 0 or 1)
end
function RuneAdvancePopPanel:onBtnNormalClick()
	SoraDPlaySound()
	godArmsRuneCtrl:sendAdvance(self.param.data.uid, self.param.uidList)
	self:close()
end
function RuneAdvancePopPanel:onBtnSeniroClick()
	SoraDPlaySound()
	if self.isSeniorEnough then
		godArmsRuneCtrl:sendAdvance(self.param.data.uid, self.param.uidList, true)
		self:close()
	else
		local sources = itemDesRead.getOutput(self.costID)
		_ENV = true
		;(true).sources = sources
		uiManager:show("CommonSourceGuide", true)
	end
end
return RuneAdvancePopPanel

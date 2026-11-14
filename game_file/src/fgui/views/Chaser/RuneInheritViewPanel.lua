local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactRuneRead = include("artifactRuneRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneInheritViewPanel = class("RuneInheritViewPanel", baseFguiPanel)
function RuneInheritViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneInheritViewPanel:ctor", self.viewName)
end
function RuneInheritViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneInheritViewPanel:onInit()
	print("=======RuneInheritViewPanel:onInit")
	self.sourceData = nil
	self.targetData = nil
	self.fields.Com_title:initData(i18n("Weapon_Rune_inherit_001"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("Weapon_Rune_rule_002"))
	self.fields.Btn_inherit:setString(i18n("Weapon_Rune_button_009"))
	self.fields.Btn_inherit:setEnabled(false)
	self.fields.Btn_inherit:addClickListener(handler(self, self.onInheritClick))
	self.fields.Com_cost:addClickListener(handler(self, self.onAddClick))
	self.fields.Com_cost1:addClickListener(handler(self, self.onAddClick))
	self.fields.Com_cost2:addClickListener(handler(self, self.onAddClick))
end
function RuneInheritViewPanel:onShow()
	print("=======RuneInheritViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.targetData = self.param and self.param.target
	if self.targetData then
		self.fields.Com_target:setRuneInfo(self.targetData, 1)
	else
		self.fields.Com_target:setNoneInfo(i18n("Weapon_Rune_tips_034"), 1)
	end
	self.fields.Com_source:setNoneInfo(i18n("Weapon_Rune_tips_030"), 0)
	self.fields.Com_source:setCurData(self.sourceData, self.targetData)
	self.fields.Com_target:setCurData(self.sourceData, self.targetData)
end
function RuneInheritViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Weapon_Rune_rule_002")
	uiManager:show("RuleView", nil)
end
function RuneInheritViewPanel:onAddClick()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("Weapon_Rune_tips_060"))
end
function RuneInheritViewPanel:setCost()
	if self.sourceData then
		self.controllers.c1:setSelectedIndex(0)
		self.isEnough = true
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function RuneInheritViewPanel:setTarget(target, data)
	local myCount = backpackCtrl:getItemCount(data.id)
	backpackCtrl = nil
	;(nil).var1 = fguiHelper.getColorString(myCount >= data.count and "#FFFFFF" or "#BE2828", myCount)
	;(nil).var2 = data.count
	target:setString(i18n("%{var1}/%{var2}", nil))
	target:setIcon(publicRead.getIcon(data.id))
	return myCount >= data.count
end
function RuneInheritViewPanel:updateView(target, data)
	if data.msg == "MESSAGE_UI_RUNE_INHERIT_CHOOSE_SOURCE" then
		self.sourceData = data.data
		self.fields.Com_source:setRuneInfo(self.sourceData, 0)
	elseif data.msg == "MESSAGE_UI_RUNE_INHERIT_CHOOSE_TARGET" then
		self.targetData = data.data
		self.fields.Com_target:setRuneInfo(self.targetData, 1)
	end
	self.fields.Com_source:setCurData(self.sourceData, self.targetData)
	self.fields.Com_target:setCurData(self.sourceData, self.targetData)
	self:setCost()
	if self.sourceData and self.targetData then
		self.fields.Btn_inherit:setEnabled(self.isEnough)
	else
		self.fields.Btn_inherit:setEnabled(false)
	end
end
function RuneInheritViewPanel:closeView()
	self:close()
end
function RuneInheritViewPanel:onInheritClick()
	SoraDPlaySound()
	print("传承====预览弹窗")
	_ENV = nil
	;(nil).sourceData = self.sourceData
	;(nil).targetData = self.targetData
	uiManager:show("RuneAffirm", nil)
end
return RuneInheritViewPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastRead = include("divineBeastRead")
local DivineBeastRulePanel = class("DivineBeastRulePanel", baseFguiPanel)
local constantRead = include("constantRead")
function DivineBeastRulePanel:ctor(...)
	DivineBeastRulePanel.super.ctor(self, ...)
	print("DivineBeastRulePanel:ctor", self.viewName)
end
function DivineBeastRulePanel:onInit()
	self.beastId = self.param.beastId
	print("=======DivineBeastRulePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Divine_beast_mark_text_44"))
	if self.param and self.param.type == 1 then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.txt_rule:setString(i18n("Divine_beast_mark_text_52"))
	else
		_ENV, self.ccs_tab = self.fields.com_Tab, self.fields.com_Tab
		self.fields.com_Tab.tabNum = 2
		_ENV, _ENV, self.fields.com_Tab.defaultClick = i18n("Divine_beast_mark_text_52")
		i18n("Divine_beast_mark_text_52").title = i18n("Divine_beast_mark_text_45")
		_ENV, self.fields.txt_rule[1], i18n("Divine_beast_mark_text_52").tag = i18n("Divine_beast_mark_text_52")
		i18n("Divine_beast_mark_text_52").title = i18n("Divine_beast_mark_text_46")
		self.fields.com_Tab.tabsetArray, self.fields.txt_rule[2], i18n("Divine_beast_mark_text_52").tag = self.fields.txt_rule, i18n("Divine_beast_mark_text_52")
		local self.fields.com_Tab.callback, param = handler(self, self.onClickTab), self.fields.com_Tab
		self.ccs_tab:initView(param)
	end
end
function DivineBeastRulePanel:onShow()
	print("=======DivineBeastRulePanel:onShow")
end
function DivineBeastRulePanel:onClickTab(tag)
	if tag == 1 then
		local lockStepLv = divineBeastRead.getMarkUnlockStepLv(self.beastId)
		divineBeastRead = nil
		;(nil).num = lockStepLv
		;(nil).num2 = constantRead.getConstValue("DIVINE_BEAST_MARK_EXP_RETAIN") .. "%"
		self.fields.txt_rule:setString(i18n("Divine_beast_mark_text_47", nil))
	else
		local str = string.format([[
%s
%s
%s
%s]], i18n("Divine_beast_mark_text_48"), i18n("Divine_beast_mark_text_49"), i18n("Divine_beast_mark_text_50"), i18n("Divine_beast_mark_text_51"))
		self.fields.txt_rule:setString(str)
	end
end
return DivineBeastRulePanel

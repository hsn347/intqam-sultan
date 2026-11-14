local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local buildLogic = include("buildLogic")
local kohMigrateRead = include("kohMigrateRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateHelpViewPanel = class("kohMigrateHelpViewPanel", baseFguiPanel)
function kohMigrateHelpViewPanel:ctor(...)
	kohMigrateHelpViewPanel.super.ctor(self, ...)
	print("kohMigrateHelpViewPanel:ctor", self.viewName)
end
function kohMigrateHelpViewPanel:onInit()
	print("=======kohMigrateHelpViewPanel:onInit")
	local _fields = fguiHelper.get_fields(self.fields.ScrollView_info)
	_fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_fields.Text_name:setString(i18n("arossDesc_text_001"))
	local scale = 0.8125
	_fields.kohMigrateResGroup:initViewScale(scale)
end
function kohMigrateHelpViewPanel:onShow()
	print("=======kohMigrateHelpViewPanel:onShow")
	self:initData()
end
function kohMigrateHelpViewPanel:initData(...)
	local kohMigrateCtrl, textConfig
	local lvLimit = kohMigrateCtrl:getLvLimit()
	kohMigrateCtrl = nil
	;(nil).var1 = buildLogic.getBuildLvStr(lvLimit)
	table.insert(textConfig, i18n("migrant_move_rule1", nil))
	local kidStr = kohMigrateRead.getMinAndMaxKidStr()
	local legendNum = kohMigrateRead.getLegendLordNumber()
	local highStrength = kohMigrateCtrl:getHighStrength()
	kohMigrateCtrl = i18n("migrant_move_rule1", nil)
	i18n("migrant_move_rule1", nil).var2 = kidStr
	i18n("migrant_move_rule1", nil).var3 = legendNum
	i18n("migrant_move_rule1", nil).var4 = SoraDConvertNumberWithUnit(highStrength)
	table.insert(textConfig, i18n("migrant_move_rule2", i18n("migrant_move_rule1", nil)))
	local ruleStr3 = i18n("migrant_move_rule3")
	local classType = kohMigrateCtrl:getKingdomClassType()
	local classMax = kohMigrateCtrl:getKingdomClassMax()
	if classType >= classMax then
		ruleStr3 = ruleStr3 .. "\n" .. i18n("migrant_move_rule12")
	end
	table.insert(textConfig, ruleStr3)
	table.insert(textConfig, i18n("migrant_move_rule4"))
	table.insert(textConfig, i18n("migrant_move_rule5"))
	table.insert(textConfig, i18n("migrant_move_rule6"))
	self.textConfig = textConfig
	local _fields = fguiHelper.get_fields(self.fields.ScrollView_info)
	_fields.List:setNumItems(#self.textConfig)
	_fields.List:resizeToFit(#self.textConfig)
end
function kohMigrateHelpViewPanel:onItemRenderer(index, obj)
	local text = self.textConfig[index + 1]
	obj:setString(text)
end
return kohMigrateHelpViewPanel

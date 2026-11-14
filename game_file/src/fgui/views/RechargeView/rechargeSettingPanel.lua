local rechargeRead = include("rechargeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeSettingPanel = class("rechargeSettingPanel", baseFguiPanel)
function rechargeSettingPanel:ctor(...)
	self.isLRU = true
	rechargeSettingPanel.super.ctor(self, ...)
	print("rechargeSettingPanel:ctor", self.viewName)
end
function rechargeSettingPanel:onInit()
	print("=======rechargeSettingPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("recharge_setting_text_06"))
	self.fields.Text_tip:setString(i18n("recharge_setting_text_07"))
end
function rechargeSettingPanel:endShow()
	print("=======rechargeSettingPanel:endShow")
	self.tag = 1
	self.labelType = rechargeRead.getLabelTypeCfg()
	local _ENV, tabsetArray = rechargeRead.getLabelTypeCfg(), rechargeRead.getLabelTypeCfg()
	for _, v in ipairs(self.labelType) do
		_ENV = nil
		;(nil).title = i18n(v.typeName)
		;(nil).tag = v.type
		table.insert(tabsetArray, nil)
	end
	_ENV = ipairs(self.labelType)
	ipairs(self.labelType).defaultClick = self.tag
	ipairs(self.labelType).tabsetArray = tabsetArray
	ipairs(self.labelType).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(ipairs(self.labelType))
end
function rechargeSettingPanel:onClickTab(tag)
	self.tag = tag
	self.categoryList = rechargeRead.getCategoryList(self.tag)
	self.fields.List:setNumItems(#self.categoryList)
end
function rechargeSettingPanel:itemRenderer_List(index, obj)
	obj:initData(self.categoryList[index + 1])
end
return rechargeSettingPanel

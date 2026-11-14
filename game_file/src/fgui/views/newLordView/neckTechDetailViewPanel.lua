local necklaceTechRead = include("necklaceTechRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local neckTechDetailViewPanel = class("neckTechDetailViewPanel", baseFguiPanel)
function neckTechDetailViewPanel:ctor(...)
	self.isLRU = true
	neckTechDetailViewPanel.super.ctor(self, ...)
	print("neckTechDetailViewPanel:ctor", self.viewName)
end
function neckTechDetailViewPanel:onInit()
	print("=======neckTechDetailViewPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Text_power:setString(i18n("garden_text_18"))
	self.view:fixChildrenPos()
end
function neckTechDetailViewPanel:endShow()
	print("=======neckTechDetailViewPanel:endShow")
	self.techID = self.param.techID
	self.cfg = necklaceTechRead.getTechCfg(self.techID)
	self.fields.Panel_bg:setString(i18n(self.cfg.techName))
	self.ListData = necklaceTechRead.getTechGroupCfg(self.techID)
	self.fields.List:setNumItems(#self.ListData)
end
function neckTechDetailViewPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Text_lv"):setString(data.lv)
	obj:getChild("Text_power"):setString(string.formatnumberthousands(data.fighting))
	local val = data.attribute[2] / 10 .. "%"
	_ENV = string.formatnumberthousands(data.fighting)
	string.formatnumberthousands(data.fighting).value = val
	obj:getChild("Text_attr"):setString(i18n("common_text_1952", string.formatnumberthousands(data.fighting)))
end
return neckTechDetailViewPanel

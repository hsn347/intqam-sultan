local manorTechRead = include("manorTechRead")
local collegeDesRead = include("collegeDesRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorTechAttrPanel = class("ManorTechAttrPanel", baseFguiPanel)
function ManorTechAttrPanel:ctor(...)
	self.isLRU = true
	ManorTechAttrPanel.super.ctor(self, ...)
	print("ManorTechAttrPanel:ctor", self.viewName)
end
function ManorTechAttrPanel:onInit()
	print("=======ManorTechAttrPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_attr:setString(i18n("hero_title_01"))
	self.fields.Text_power:setString(i18n("garden_text_18"))
	self.view:fixChildrenPos()
end
function ManorTechAttrPanel:endShow()
	print("=======ManorTechAttrPanel:endShow")
	self.techID = self.param.techID
	self.cfg = manorTechRead.getTechShowCfg(self.techID)
	self.fields.Panel_bg:setString(i18n(self.cfg.techName))
	self.ListData = collegeDesRead.getTechGroupCfg(self.techID)
	self.fields.List:setNumItems(#self.ListData)
end
function ManorTechAttrPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("bg"):setVisible(index % 2 == 1)
	obj:getChild("Text_lv"):setString(data.technologyLevel)
	obj:getChild("Text_power"):setString(string.formatnumberthousands(data.fighting))
	local val = data.buffNumType == 1 and data.powerNum / 10 .. "%" or data.powerNum
	_ENV = string.formatnumberthousands(data.fighting)
	string.formatnumberthousands(data.fighting).value = val
	obj:getChild("Text_attr"):setString(i18n("common_text_1952", string.formatnumberthousands(data.fighting)))
end
return ManorTechAttrPanel

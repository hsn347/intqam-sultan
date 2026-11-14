local buffDesRead = include("buffDesRead")
local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local neckTechAttrPandectViewPanel = class("neckTechAttrPandectViewPanel", baseFguiPanel)
function neckTechAttrPandectViewPanel:ctor(...)
	self.isLRU = true
	neckTechAttrPandectViewPanel.super.ctor(self, ...)
	print("neckTechAttrPandectViewPanel:ctor", self.viewName)
end
function neckTechAttrPandectViewPanel:onInit()
	print("=======neckTechAttrPandectViewPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("magic_lamp_title_09"))
	self.fields.Text_none:setString(i18n("hero_appoint_11"))
	self.fields.Text_none:setVisible(false)
end
function neckTechAttrPandectViewPanel:endShow()
	print("=======neckTechAttrPandectViewPanel:endShow")
	self.ListData = necklaceTecCtrl:getTechnoAttrPandect()
	self.fields.List:setNumItems(#self.ListData)
	self.fields.Text_none:setVisible(#self.ListData == 0)
end
function neckTechAttrPandectViewPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Text_attr"):setString(buffDesRead.getTitleBase(data.buffType))
	obj:getChild("Text_value"):setString(buffDesRead.getTitleValueWithValue(data.buffType, data.buffValue))
end
return neckTechAttrPandectViewPanel

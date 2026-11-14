local djRead = include("djRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjLvPopPanel = class("DjLvPopPanel", baseFguiPanel)
function DjLvPopPanel:ctor(...)
	self.isLRU = true
	DjLvPopPanel.super.ctor(self, ...)
	print("DjLvPopPanel:ctor", self.viewName)
end
function DjLvPopPanel:onInit()
	print("=======DjLvPopPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("Anchor_text_127"))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_val:setString(i18n("Anchor_text_128"))
	self.fields.line:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_val:fixPos()
end
function DjLvPopPanel:endShow()
	print("=======DjLvPopPanel:endShow")
	self.ListData = djRead.getAnchorLvCfg()
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:setScrollEnable(#self.ListData > 10)
end
function DjLvPopPanel:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	obj:fixChildrenPos()
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("Text_val"):setString(string.formatnumberthousands(data.valueAnchor))
	obj:getChild("title"):setString(i18n(data.nameAnchor))
	obj:getChild("title"):setColor(djRead.getColorByLv(data.lvAnchor, 3))
end
return DjLvPopPanel

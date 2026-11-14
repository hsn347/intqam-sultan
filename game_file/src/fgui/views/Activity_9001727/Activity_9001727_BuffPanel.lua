local activity_9001727_Read = include("activity_9001727_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001727_BuffPanel = class("Activity_9001727_BuffPanel", baseFguiPanel)
function Activity_9001727_BuffPanel:ctor(...)
	self.isLRU = true
	Activity_9001727_BuffPanel.super.ctor(self, ...)
	print("Activity_9001727_BuffPanel:ctor", self.viewName)
end
function Activity_9001727_BuffPanel:onInit()
	print("=======Activity_9001727_BuffPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Panel_bg:setString(i18n("Battle_Towers_23"))
	self.fields.Text_lv:setString(i18n("AlbarqDecree_text_06"))
	self.fields.Text_Tips:setString(i18n("AlbarqDecree_text_04"))
	self.fields.Text_lv:fixPos()
	for i = 1, 2 do
		self.fields["icon_buff" .. i]:fixPos()
		self.fields["line_h" .. i]:fixPos()
	end
end
function Activity_9001727_BuffPanel:endShow()
	print("=======Activity_9001727_BuffPanel:endShow")
	self.ListData = activity_9001727_Read.getBuffCfg()
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:setScrollEnable(#self.ListData >= 12)
	if #self.ListData < 12 then
		self.fields.List:setHeight(#self.ListData * 38)
	end
	for i = 1, 2 do
		self.fields["line_h" .. i]:setHeight(math.min(510, self.fields.List:getHeight() + 64))
		self.fields["icon_buff" .. i]:setIcon(self.ListData[1].EffectIcon[i])
	end
end
function Activity_9001727_BuffPanel:itemRenderer_List(index, obj)
	obj:fixChildrenPos()
	local data = self.ListData[index + 1]
	obj:getChild("bg"):setVisible(index % 2 == 0)
	obj:getChild("lv"):setString(data.albarqStage[1] .. "~" .. data.albarqStage[2])
	for i = 1, 2 do
		obj:getChild("Text_val" .. i):setString(data.PrivilegeEffect[i].buffValue / 10 .. "%")
	end
end
return Activity_9001727_BuffPanel

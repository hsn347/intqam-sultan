local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceBuildConditionPanel = class("AllianceBuildConditionPanel", baseFguiPanel)
function AllianceBuildConditionPanel:ctor(...)
	AllianceBuildConditionPanel.super.ctor(self, ...)
	print("AllianceBuildConditionPanel:ctor", self.viewName)
end
function AllianceBuildConditionPanel:onInit()
	print("=======AllianceBuildConditionPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2126"))
	self.scrollInfo = self.fields.ScrollView_info
	self.scrollInfo:setItemRenderer(handler(self, self.onItemRenerer))
	self.labelDes = self.fields.Text_des
end
function AllianceBuildConditionPanel:onShow()
	print("=======AllianceBuildConditionPanel:onShow")
	local buildSingle = self.param and self.param.buildSingle
	if buildSingle then
		self:initData(buildSingle)
	end
end
function AllianceBuildConditionPanel:initData(buildSingle)
	self.buildSingle = buildSingle
	_ENV = nil
	;(nil).build = i18n("common_text_2126")
	self.labelDes:setString(i18n("common_text_2170", nil))
	self:initScroll()
end
function AllianceBuildConditionPanel:initScroll()
	self.tableData = self.buildSingle:getCondOfSetBuilding()
	self.scrollInfo:setNumItems(#self.tableData)
end
function AllianceBuildConditionPanel:onItemRenerer(index, obj)
	local data = self.tableData[index + 1]
	obj:initData(data)
end
return AllianceBuildConditionPanel

local activity_9001639_Ctrl = SoraDGetCtrl("activity_9001639_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001639_RecordPanel = class("Activity_9001639_RecordPanel", baseFguiPanel)
function Activity_9001639_RecordPanel:ctor(...)
	Activity_9001639_RecordPanel.super.ctor(self, ...)
	print("Activity_9001639_RecordPanel:ctor", self.viewName)
end
function Activity_9001639_RecordPanel:onInit()
	print("=======Activity_9001639_RecordPanel:onInit")
	self.fields.Panel_bg:setString(i18n("eidal_market_text5"))
	self.fields.Text_none:setString(i18n("datepalm_tree_text44"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_tip:setString(i18n("eidal_market_text6"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001639_RecordPanel:onItemRenderer(index, obj)
	obj:initData(self.record[index + 1])
end
function Activity_9001639_RecordPanel:onShow()
	print("=======Activity_9001639_RecordPanel:onShow")
	if not activity_9001639_Ctrl:getRecord() then
		_ENV = activity_9001639_Ctrl:getRecord()
	end
	self.record = activity_9001639_Ctrl:getRecord()
	self.fields.List:setNumItems(#self.record)
	self.fields.Text_none:setVisible(#self.record == 0)
end
return Activity_9001639_RecordPanel

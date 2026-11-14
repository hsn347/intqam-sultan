local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_RecordPanel = class("Activity_9001680_RecordPanel", baseFguiPanel)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
function Activity_9001680_RecordPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_RecordPanel.super.ctor(self, ...)
	print("Activity_9001680_RecordPanel:ctor", self.viewName)
end
function Activity_9001680_RecordPanel:onInit()
	print("=======Activity_9001680_RecordPanel:onInit")
	self.view:fixChildrenPos()
	self.fields.list:setVirtual()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Panel_bg:setTitle(i18n("minecraft_text_47"))
end
function Activity_9001680_RecordPanel:endShow()
	print("=======Activity_9001680_RecordPanel:endShow")
	self:updateView()
end
function Activity_9001680_RecordPanel:updateView()
	self.recordList = activity_9001680_Ctrl:getRecords()
	dump(self.recordList, "recordList")
	self.fields.list:setNumItems(#self.recordList)
	self.fields.list:scrollToView(#self.recordList - 1, false, false)
end
function Activity_9001680_RecordPanel:onItemRenderer(index, obj)
	obj:initData(self.recordList[index + 1])
end
return Activity_9001680_RecordPanel

local activity_9001680_Read = include("activity_9001680_Read")
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_TaskPanel = class("Activity_9001680_TaskPanel", baseFguiPanel)
function Activity_9001680_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_TaskPanel.super.ctor(self, ...)
	print("Activity_9001680_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
end
function Activity_9001680_TaskPanel:onInit()
	print("=======Activity_9001680_TaskPanel:onInit")
	self.fields.list:setItemRenderer(handler(self, self.itemRenderer_list))
	self.fields.Panel_bg:setString(i18n("common_text_675"))
end
function Activity_9001680_TaskPanel:endShow()
	print("=======Activity_9001680_TaskPanel:endShow")
	self:initData()
end
function Activity_9001680_TaskPanel:itemRenderer_list(index, obj)
	local data = self.tasks[index + 1]
	obj:initData(data)
end
function Activity_9001680_TaskPanel:initData()
	self.tasks, _ENV = nil, nil
	for i, v in ipairs(activity_9001680_Read.getTasks()) do
		local taskType = v.taskType or 1
		local progress, received = activity_9001680_Ctrl:getTaskStatus(taskType, v.index)
		_ENV = activity_9001680_Read.getTasks()
		activity_9001680_Read.getTasks().index = v.index
		activity_9001680_Read.getTasks().config = v
		activity_9001680_Read.getTasks().progress = progress
		activity_9001680_Read.getTasks().received = received
		table.insert(self.tasks, activity_9001680_Read.getTasks())
	end
	table.sort(self.tasks, function(a, b)
		if a.received ~= b.received then
			return not a.received
		else
			return a.index < b.index
		end
	end)
	self.fields.list:setNumItems(#self.tasks)
end
return Activity_9001680_TaskPanel

local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local NebulaCelebrationMainTask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCelebration/NebulaCelebrationMainTask", NebulaCelebrationMainTask)
function NebulaCelebrationMainTask:onInit()
	self.fields.Label_time:setTimeUpdateListener(function(timeNumber)
		self = nil
		;(nil).time = SoraDConvertSecondToString(timeNumber)
		self.fields.Label_time:setString(i18n("Nebula_Celebration_text17", nil))
	end)
	self.fields.Label_normalTask:setString(i18n("Nebula_Celebration_title07"))
	self.fields.List_daily:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_normal:setItemRenderer(handler(self, self.onItemRenderer1))
end
function NebulaCelebrationMainTask:onItemRenderer(index, obj)
	local taskId = self.dailyList[index + 1]
	obj:initData(taskId, 1)
end
function NebulaCelebrationMainTask:onItemRenderer1(index, obj)
	local taskId = self.normalList[index + 1]
	obj:initData(taskId, 2)
end
function NebulaCelebrationMainTask:onShow()
end
function NebulaCelebrationMainTask:sort(taskType, a, b)
	local claimedA = nebulaCelebrationCtrl:isTaskClaimed(a, taskType)
	local claimedB = nebulaCelebrationCtrl:isTaskClaimed(b, taskType)
	if claimedA == claimedB then
		local finishedA = nebulaCelebrationCtrl:isTaskFinished(a, taskType)
		local finishedB = nebulaCelebrationCtrl:isTaskFinished(b, taskType)
		if finishedA == finishedB then
			return a < b
		else
			return finishedA
		end
	else
		return claimedB
	end
end
function NebulaCelebrationMainTask:updateUI()
	self.fields.Label_time:beginTime(serviceFunctions.getTodayRemainTime())
	self.dailyList = nebulaCelebrationCtrl:getTaskList(1)
	table.sort(self.dailyList, handlerEx(self, self.sort, 1))
	self.normalList = nebulaCelebrationCtrl:getTaskList(2)
	table.sort(self.normalList, handlerEx(self, self.sort, 2))
	self.fields.List_daily:setNumItems(#self.dailyList)
	self.fields.List_normal:setNumItems(#self.normalList)
end
return NebulaCelebrationMainTask

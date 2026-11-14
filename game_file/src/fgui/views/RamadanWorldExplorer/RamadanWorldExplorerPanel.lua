local ramadanWorldExplorerCtrl = SoraDGetCtrl("ramadanWorldExplorerCtrl")
local ramadanWorldExplorerRead = include("ramadanWorldExplorerRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanWorldExplorerPanel = class("RamadanWorldExplorerPanel", baseFguiPanel)
function RamadanWorldExplorerPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RamadanWorldExplorerPanel:ctor", self.viewName)
end
function RamadanWorldExplorerPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanWorldExplorerPanel:onInit()
	print("=======RamadanWorldExplorerPanel:onInit")
	self.rewardNums = #ramadanWorldExplorerRead.getProcessReward()
	self.activityID = gActivityTimeActivityID.RAMADAN_WORLD_EXPLORER
	self.fields.Com_title:initData(i18n("activity_name_9001414"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Activity_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n_html("common_text_607", nil)
	end)
	self.fields.Activity_time:initActivityTime(self.activityID)
	self.fields.TaskReset_time:fixPos()
	self.fields.TaskReset_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n_html("ramadan_world_explorer_text_0002", nil)
	end)
	self.fields.TaskReset_time:setTimeEndListener(handler(self, self.initResetTaskTime))
	self.fields.RewardList:setItemRenderer(handler(self, self.onBoxItemRenderer))
	self.fields.textTips:setString(i18n("ramadan_world_explorer_text_0003"))
	self.fields.TaskList:setItemRenderer(handler(self, self.onTaskItemRenderer))
	self.fields.Progress:setMax(ramadanWorldExplorerRead.getMaxProgress())
	local columnGap = (640 - (self.rewardNums + 1) * 100) / self.rewardNums
	self.fields.RewardList:setColumnGap(columnGap)
end
function RamadanWorldExplorerPanel:onShow()
	print("=======RamadanWorldExplorerPanel:onShow")
	self:updateView()
end
function RamadanWorldExplorerPanel:updateView()
	self:initResetTaskTime()
	self.tasks = ramadanWorldExplorerCtrl:getTaskList()
	local isHasTask = #self.tasks > 0
	self.fields.textTips:setVisible(not isHasTask)
	self.fields.TaskList:setVisible(isHasTask)
	self.fields.TaskList:setNumItems(#self.tasks)
	local nowFinishNum = ramadanWorldExplorerCtrl:getFinishTaskNum()
	self.fields.Progress:setValue(self:getPercentValue(nowFinishNum) * ramadanWorldExplorerRead.getMaxProgress())
	print(self:getPercentValue(nowFinishNum), nowFinishNum)
	self.fields.RewardList:setNumItems(self.rewardNums)
end
function RamadanWorldExplorerPanel:getPercentValue(nowNum)
	local list = ramadanWorldExplorerRead.getProcessReward()
	local fontNum, total
	for i, v in ipairs(list) do
		if nowNum < v.plan then
			fontNum = list[i - 1] and list[i - 1].plan or 0
			total = v.plan - fontNum
			print(fontNum, total, (nowNum - fontNum) / total, (i - 1) * 1 / self.rewardNums)
			return (i - 1) * 1 / self.rewardNums + (nowNum - fontNum) / total * 1 / self.rewardNums
		end
	end
	fontNum = list[#list - 1].plan
	total = list[#list].plan - fontNum
	return (#list - 1) * 1 / self.rewardNums + (nowNum - fontNum) / total * 1 / self.rewardNums
end
function RamadanWorldExplorerPanel:initResetTaskTime()
	local endTime = ramadanWorldExplorerCtrl:getTaskResetTime()
	print(endTime - serviceFunctions.systemTime(), "endTime - serviceFunctions.systemTime()")
	self.fields.TaskReset_time:beginTime(endTime - serviceFunctions.systemTime())
end
function RamadanWorldExplorerPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ramadan_world_explorer_text_0001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RamadanWorldExplorerPanel:onTaskItemRenderer(index, target)
	target:initData(self.tasks[index + 1])
end
function RamadanWorldExplorerPanel:onBoxItemRenderer(index, target)
	target:initData(index + 1)
end
return RamadanWorldExplorerPanel

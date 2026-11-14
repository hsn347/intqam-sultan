local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_Task", Com_Task)
function Com_Task:onInit()
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_Task:onItemRender(index, obj)
	local item = self.data.taskReward[index + 1]
	obj:initData(item.id, item.count)
end
function Com_Task:onShow()
end
function Com_Task:initData(data)
	self.data = data
	self.fields.Award_Scroll:setNumItems(#self.data.taskReward)
	self.fields.Award_Scroll:setScrollEnable(#self.data.taskReward > 5)
	local scedule = 0
	if self.data.taskType == 1 then
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#6DDE00", self.data.parameter)
		self.fields.Task_Des:setString(i18n("balloon_hunter_043", nil))
		scedule = activity_9001703_Ctrl:getGameTimes()
	elseif self.data.taskType == 2 then
		_ENV = i18n("balloon_hunter_043", nil)
		i18n("balloon_hunter_043", nil).num = fguiHelper.getColorString("#6DDE00", self.data.parameter)
		self.fields.Task_Des:setString(i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil)))
		scedule = activity_9001703_Ctrl:getMaxKillMonsterNum()
	elseif self.data.taskType == 3 then
		_ENV = i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil))
		i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil)).num = fguiHelper.getColorString("#6DDE00", self.data.parameter)
		self.fields.Task_Des:setString(i18n("balloon_hunter_045", i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil))))
		scedule = activity_9001703_Ctrl:getTotalKillMonsterNum()
	end
	_ENV = i18n("balloon_hunter_045", i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil)))
	i18n("balloon_hunter_045", i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil))).num = fguiHelper.getColorString(scedule < self.data.parameter and "#BE2828" or "#6DDE00", math.min(scedule, self.data.parameter))
	i18n("balloon_hunter_045", i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil))).maxnum = self.data.parameter
	self.fields.Task_Scedule:setString(i18n("reurn_text_04", i18n("balloon_hunter_045", i18n("balloon_hunter_044", i18n("balloon_hunter_043", nil)))))
	self.controllers.status:setSelectedIndex(self.data.status)
	self.fields.Button_Task:setTitle(self.data.status == gBtnTargetStatusDef.GO and i18n("common_text_2139") or i18n("common_text_1146"))
end
function Com_Task:onClickTask()
	SoraDPlaySound()
	if self.data.status == gBtnTargetStatusDef.GET then
		activity_9001703_Ctrl:reqTaskReward(self.data.taskId)
	end
end
return Com_Task

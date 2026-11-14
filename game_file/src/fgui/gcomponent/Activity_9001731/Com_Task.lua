local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_Task", Com_Task)
function Com_Task:onInit()
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self.fields.Lab_got:setTitle(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_Task:onShow()
end
function Com_Task:initData(data)
	self.data = data
	self.fields.Award_Scroll:setNumItems(#self.data.taskReward)
	self.fields.Award_Scroll:setScrollEnable(#self.data.taskReward > 5)
	local scedule = activity_9001731_Ctrl:getTaskProgress(self.data.taskId) or 0
	if self.data.taskType == 1 then
		activity_9001731_Ctrl = nil
		;(nil).num = fguiHelper.getColorString("#6DDE00", self.data.parameter)
		self.fields.Task_Des:setString(i18n("Ludo_test_033", nil))
	elseif self.data.taskType == 2 then
		activity_9001731_Ctrl = i18n("Ludo_test_033", nil)
		i18n("Ludo_test_033", nil).num = fguiHelper.getColorString("#6DDE00", self.data.parameter)
		self.fields.Task_Des:setString(i18n("Ludo_test_034", i18n("Ludo_test_033", nil)))
	elseif self.data.taskType == 3 then
		activity_9001731_Ctrl = i18n("Ludo_test_034", i18n("Ludo_test_033", nil))
		i18n("Ludo_test_034", i18n("Ludo_test_033", nil)).num = fguiHelper.getColorString("#6DDE00", self.data.parameter)
		self.fields.Task_Des:setString(i18n("Ludo_test_035", i18n("Ludo_test_034", i18n("Ludo_test_033", nil))))
	end
	activity_9001731_Ctrl = i18n("Ludo_test_035", i18n("Ludo_test_034", i18n("Ludo_test_033", nil)))
	i18n("Ludo_test_035", i18n("Ludo_test_034", i18n("Ludo_test_033", nil))).num = fguiHelper.getColorString(scedule < self.data.parameter and "#BE2828" or "#6DDE00", math.min(scedule, self.data.parameter))
	i18n("Ludo_test_035", i18n("Ludo_test_034", i18n("Ludo_test_033", nil))).maxnum = self.data.parameter
	self.fields.Task_Scedule:setString(i18n("reurn_text_04", i18n("Ludo_test_035", i18n("Ludo_test_034", i18n("Ludo_test_033", nil)))))
	self.controllers.status:setSelectedIndex(self.data.status)
	self.fields.Button_Task:setTitle(self.data.status == gBtnTargetStatusDef.GO and i18n("PrideRebate_text_13") or i18n("common_text_1146"))
end
function Com_Task:onItemRender(index, obj)
	local item = self.data.taskReward[index + 1]
	obj:initData(item.id, item.count)
end
function Com_Task:onClickTask()
	SoraDPlaySound()
	if self.data.status == gBtnTargetStatusDef.GET then
		activity_9001731_Ctrl:reqQuest(self.data.taskId)
	end
end
return Com_Task

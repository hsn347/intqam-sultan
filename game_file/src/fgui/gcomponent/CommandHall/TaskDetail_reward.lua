local commandHallRead = include("commandHallRead")
local baseComponent = require("fgui.base.baseComponent")
local TaskDetail_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommandHall/TaskDetail_reward", TaskDetail_reward)
function TaskDetail_reward:onInit()
	self.fields.Button_detail:addClickListener(function(...)
		SoraDPlaySound()
		if self.ctype == 1 then
			SoraDShowHelpMsgTip(i18n("commandhall_text_12"))
		elseif self.ctype == 2 then
			SoraDShowHelpMsgTip(i18n("commandhall_text_13"))
		end
	end)
end
function TaskDetail_reward:onShow()
	if not SoraDFIsRA() then
		self.fields.Text_title:fixPos()
		self.fields.Button_detail:fixPos()
		self.fields.Load_title:fixPos()
	end
end
function TaskDetail_reward:initData1(data)
	local taskID = data.taskID
	local taskType = data.taskType
	if taskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		self:updateTextTitle(i18n("commandhall_text_11"))
		local rewards = commandHallRead.getTaskKillReward(taskID)
		self.fields.List_reward:setItemRenderer(function(index, obj)
			local data = rewards[index + 1]
			obj:initData(data.id, data.count)
		end)
		self.fields.List_reward:setNumItems(#rewards)
		self.ctype = 1
	end
end
function TaskDetail_reward:initData2(data)
	local taskID = data.taskID
	local taskType = data.taskType
	if taskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		self:updateTextTitle(i18n("common_text_3343"))
		self.fields.Button_detail:setVisible(true)
		self.ctype = 2
	else
		self:updateTextTitle(i18n("commandhall_text_42"))
		self.fields.Button_detail:setVisible(false)
	end
	local rewards = commandHallRead.getTaskVictoryReward(taskID)
	self.fields.List_reward:setItemRenderer(function(index, obj)
		local data = rewards[index + 1]
		obj:initData(data.id, data.count)
	end)
	self.fields.List_reward:setNumItems(#rewards)
end
function TaskDetail_reward:updateTextTitle(title)
	self.fields.Text_title:setString(title)
	fguiHelper.setTextWidthHeight(self.fields.Text_title, cc.size(self:getWidth() - 54, 30))
end
return TaskDetail_reward

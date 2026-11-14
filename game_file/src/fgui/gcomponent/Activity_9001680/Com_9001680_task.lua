local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001680/Com_9001680_task", Com_9001680_task)
function Com_9001680_task:onInit()
	self.fields.Award_Scroll:setVirtual()
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.itemRenderer_Award_Scroll))
	self.fields.Button_Task:setTitle(i18n("common_text_1146"))
	self.fields.Button_Task:addClickListener(handler(self, self.onClick_Button_Task))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_9001680_task:onShow()
end
function Com_9001680_task:itemRenderer_Award_Scroll(index, obj)
	obj:initData(self.data.config.task_reward[index * 2 + 1], self.data.config.task_reward[index * 2 + 2])
end
function Com_9001680_task:onClick_Button_Task(context)
	SoraDPlaySound()
	activity_9001680_Ctrl:reqGoldMinerTaskReward(self.data.config.index)
end
function Com_9001680_task:initData(data)
	self.data = data
	_ENV = nil
	;(nil).num = data.config.task_dec.num
	self.fields.Task_Des:setString(i18n(data.config.task_dec[1], nil))
	_ENV = i18n(data.config.task_dec[1], nil)
	i18n(data.config.task_dec[1], nil).count = data.progress
	_ENV, i18n(data.config.task_dec[1], nil).total = data.config.task_times, data.config.task_times
	if data.progress >= data.config.task_times then
		_ENV = data.progress
		data.progress.color = "#d7c39b"
		if data.progress then
			goto lbl_39
		end
	end
	_ENV = data.progress
	_ENV, data.config.task_times.count, data.progress.color = data.progress, data.progress, "#be2828"
	::lbl_39::
	_ENV, data.config.task_times.total, data.progress.color = data.progress, data.progress, "#d7c39b"
	data.config.task_times.__default, data.progress.color = data.progress, "#d7c39b"
	self.fields.Task_Scedule:setString(i18n_html("common_text_3683", i18n(data.config.task_dec[1], nil)))
	self.controllers.status:setSelectedIndex(data.received and 3 or data.progress >= data.config.task_times and 1 or 0)
	self.fields.Award_Scroll:setNumItems(#data.config.task_reward / 2)
end
return Com_9001680_task

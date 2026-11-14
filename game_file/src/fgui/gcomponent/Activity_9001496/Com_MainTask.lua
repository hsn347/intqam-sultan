local activity_9001496_Read = include("activity_9001496_Read")
local activity_9001496_Ctrl = SoraDGetCtrl("activity_9001496_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_MainTask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001496/Com_MainTask", Com_MainTask)
function Com_MainTask:onInit()
	self.rechargePrice = 0
	self.activityID = gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY
	self.rechargeMax = activity_9001496_Read.getRechargePriceMax()
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.List_task:setItemRenderer(handler(self, self.onNormalItemRederer))
	self.fields.List_task:setVirtual()
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	local imgBg = activity_9001496_Read.getActivityViewImageBg()
	self.fields.Image_bg:setURL(imgBg)
	self.fields.Text_rechargeDes:setString(i18n("activity_ui_text_9001496"))
end
function Com_MainTask:onShow()
end
function Com_MainTask:showTask(...)
	self:updateRechargePrice()
	self:updateTaskList()
end
function Com_MainTask:updateTaskList(...)
	activity_9001496_Ctrl, self.taskList = activity_9001496_Ctrl:getTaskList(), activity_9001496_Ctrl:getTaskList()
	activity_9001496_Ctrl:getTaskList()[gBtnTargetStatusDef.GET] = 1
	activity_9001496_Ctrl:getTaskList()[gBtnTargetStatusDef.GO] = 2
	local activity_9001496_Ctrl:getTaskList()[gBtnTargetStatusDef.GOT], stateSort = 3, activity_9001496_Ctrl:getTaskList()
	table.sort(self.taskList, function(a, b)
		if a.btnState ~= b.btnState then
			return stateSort[a.btnState] < stateSort[b.btnState]
		end
		return a.cfg.index < b.cfg.index
	end)
	self.fields.List_task:setNumItems(#self.taskList)
end
function Com_MainTask:onMsgUpdateRechargePrice(...)
	self:updateRechargePrice()
	if self:checkNeedUpdateTaskList() then
		self:updateTaskList()
	end
end
function Com_MainTask:checkNeedUpdateTaskList(...)
	for i, task in ipairs(self.taskList) do
		if task.statePrice == gBtnTargetStatusDef.GO and self.rechargePrice >= task.cfg.price then
			return true
		end
	end
	return false
end
function Com_MainTask:updateRechargePrice(...)
	self.rechargePrice = activity_9001496_Ctrl:getRechargePrice()
	if self.rechargePrice >= self.rechargeMax then
		self.controllers.recharge:setSelectedIndex(1)
	else
		self.controllers.recharge:setSelectedIndex(0)
		self.fields.Text_recharge2:setString(tostring(self.rechargePrice))
	end
end
function Com_MainTask:onNormalItemRederer(index, obj)
	local data = self.taskList[index + 1]
	_UPVALUE0_ = nil
	;(nil).rechargePrice = self.rechargePrice
	obj:initData(data, nil)
end
return Com_MainTask

local newServerReturnltCtrl = include("newServerReturnltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local riseOfSultanCtrl = SoraDGetCtrl("riseOfSultanCtrl")
local newServerReturnltCtrl = include("newServerReturnltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_riseOfSultan = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_riseOfSultan", Com_riseOfSultan)
function Com_riseOfSultan:onInit()
	self.fields.Button_detail:fixPos()
	riseOfSultanCtrl:riseOfSultanInit()
	self.activityID = gActivityTimeActivityID.SUDAN_RISING_ACTIVITY
	self:setActivityTime()
	self.fields.Button_detail:addClickListener(handler(self, self.onClickDetail))
	self.fields.List_sultantask:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_riseOfSultan:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_RISE_OF_SULTAN_REFRESH", handler(self, self.onUpdateView))
end
function Com_riseOfSultan:onUpdateTask(target, data)
	if data.activityID == gActivityTimeActivityID.SUDAN_RISING_ACTIVITY then
		self.taskTypeList = newServerReturnltCtrl.getRiseOfSultanTaskListByIndex(riseOfSultanCtrl:getClassTypeIndex())
		self.taskList = riseOfSultanCtrl:getTaskList(self.taskTypeList)
		self.fields.List_sultantask:setNumItems(#self.taskList)
	end
end
function Com_riseOfSultan:onUpdateView()
	self:setActivityTime()
	self.taskTypeList = newServerReturnltCtrl.getRiseOfSultanTaskListByIndex(riseOfSultanCtrl:getClassTypeIndex())
	self.taskList = riseOfSultanCtrl:getTaskList(self.taskTypeList)
	self.fields.List_sultantask:setNumItems(table.nums(self.taskList))
end
function Com_riseOfSultan:onClickGetAward(taskID)
	riseOfSultanCtrl:riseOfSultanReward(taskID)
end
function Com_riseOfSultan:onClickDetail()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("newstart_text_60")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Com_riseOfSultan:initData()
end
function Com_riseOfSultan:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.onClickGetAward), nil)
end
function Com_riseOfSultan:setActivityTime()
	local timeEnd = serviceFunctions.systemTime()
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SUDAN_RISING_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		local week = 604800
		if leftTime <= week then
			local proxy = uiManager:getOrCreateProxy("NewServerReturn")
			proxy:initActivityTime(self.fields.Label_time, self.activityID)
		elseif riseOfSultanCtrl:getNextTaskResetTime() == 0 then
			local nextTime = leftTime
			while week < nextTime do
				nextTime = nextTime - week
			end
			self.fields.Label_time:setTimeLast(function(strTime)
				_ENV = nil
				_ENV, _ENV, (nil).time = nil, nil, strTime
				_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
				;(nil).__default, (nil).color = nil, "#FFC864"
				return i18n_html("hero_ceremony_text_07", nil, nil)
			end)
			self.fields.Label_time:beginTime(nextTime)
		else
			local time = "hero_ceremony_text_07"
			self.fields.Label_time:setTimeLast(function(strTime)
				_ENV = nil
				_ENV, _ENV, (nil).time = nil, nil, strTime
				_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
				;(nil).__default, (nil).color = nil, "#FFC864"
				return i18n_html("hero_ceremony_text_07", nil, nil)
			end)
			self.fields.Label_time:beginTime(riseOfSultanCtrl:getNextTaskResetTime() - timeEnd)
		end
	end
end
function Com_riseOfSultan:onShow()
end
return Com_riseOfSultan

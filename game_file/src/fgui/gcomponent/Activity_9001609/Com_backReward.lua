local activity_9001609_Ctrl = SoraDGetCtrl("activity_9001609_Ctrl")
local activity_9001609_Read = include("activity_9001609_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_backReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001609/Com_backReward", Com_backReward)
function Com_backReward:onInit()
	self.fields.List_target:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_help:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.icon:fix()
	self.fields.bar:setMax(100)
	self.fields.bar:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_backReward:onShow()
end
function Com_backReward:onItemRenderer(index, obj)
	obj:initData(self.data[index + 1], self.taskType)
end
function Com_backReward:initData(data, taskType)
	self.data = data
	self.taskType = taskType
	self.viewCfg = activity_9001609_Read.getTaskViewCfg(self.taskType)
	self.fields.icon:setSpriteFrame(self.viewCfg.taskBg)
	self.fields.Text_tip:setString(i18n(self.viewCfg.taskDes))
	local val = 0
	if self.taskType == 1 then
		val = activity_9001609_Ctrl:getBackersCount()
	elseif self.taskType == 2 then
		val = activity_9001609_Ctrl:getBackersTotalRecharge()
	elseif self.taskType == 3 then
		val = activity_9001609_Ctrl:getBackersCountReachDailyPoint()
	end
	local activity_9001609_Read, stageList = activity_9001609_Ctrl:getBackersCountReachDailyPoint(), activity_9001609_Ctrl:getBackersCountReachDailyPoint()
	for k, v in ipairs(self.data) do
		table.insert(stageList, v.taskTarget)
	end
	local percent = SoraDGetStageValue(val, stageList)
	self.fields.bar:setValue(percent)
	self.fields.List_target:setNumItems(#self.data)
end
function Com_backReward:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n(self.viewCfg.taskFAQ)
	uiManager:show("RuleView", nil)
end
return Com_backReward

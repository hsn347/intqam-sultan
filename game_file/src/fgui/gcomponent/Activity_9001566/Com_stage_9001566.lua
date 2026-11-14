local activity_9001566_Read = include("activity_9001566_Read")
local activity_9001566_Ctrl = SoraDGetCtrl("activity_9001566_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_stage_9001566 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001566/Com_stage_9001566", Com_stage_9001566)
function Com_stage_9001566:onInit()
	self.fields.List:setPivot(SoraDFPosX(0, 1), 1, false)
	self.fields.Bar_Score:setPivot(SoraDFPosX(0, 1), 1, false)
	self:fixChildrenPos()
	self.fields.Bar_Score:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.scrollBar = self:getScrollPane()
end
function Com_stage_9001566:onShow()
end
function Com_stage_9001566:initData(activityID, eventType)
	self.activityID = activityID
	self.eventType = eventType
	self.stageConfig = activity_9001566_Read.getTaskStageList(activityID, eventType)
	self:setScrollEnable(#self.stageConfig > 4)
	self.fields.Bar_Score:setMax(100)
	self.fields.List:setNumItems(#self.stageConfig)
	self.fields.List:resizeToFit(#self.stageConfig)
end
function Com_stage_9001566:setBarValue(myScore)
	self.fields.List:setNumItems(#self.stageConfig)
	activity_9001566_Ctrl = self.fields.List.setNumItems
	local self.fields.List.setNumItems[1], temp = 0, self.fields.List.setNumItems
	table.insertto(temp, self.stageConfig)
	local percent = SoraDGetStagePercent(myScore, temp)
	self.fields.Bar_Score:setPercent(percent / 100)
	local rewardIndex
	for i, stage in ipairs(self.stageConfig) do
		_ENV = nil
		;(nil).activityId = self.activityID
		;(nil).eventType = self.eventType
		;(nil).idx = i
		local isReceive = activity_9001566_Ctrl:checkRewardInfo(nil)
		if stage <= myScore and not isReceive then
			rewardIndex = i
			break
		end
	end
	if rewardIndex then
		self.scrollBar:setPercX(SoraDFPosX(100 - rewardIndex / #self.stageConfig * 100, 100) / 100, true)
	else
		self.scrollBar:setPercX(SoraDFPosX(100, 100), true)
	end
end
function Com_stage_9001566:onItemRederer(index, obj)
	obj:initData(self.activityID, self.eventType, index + 1)
end
return Com_stage_9001566

local activity_9001614_Ctrl = SoraDGetCtrl("activity_9001614_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_stage_9001614 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001614/Com_stage_9001614", Com_stage_9001614)
function Com_stage_9001614:onInit()
	self.fields.List:setPivot(SoraDFPosX(0, 1), 1, false)
	self.fields.Bar_Score:setPivot(SoraDFPosX(0, 1), 1, false)
	self:fixChildrenPos()
	self.fields.Bar_Score:fixChildrenPos()
	self.fields.Bar_Score:getChildByName("nl"):fix()
	self.fields.Bar_Score:getChildByName("nr"):fix()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.scrollBar = self:getScrollPane()
end
function Com_stage_9001614:onShow()
end
function Com_stage_9001614:initData(targetList, stageList)
	self.targetList = targetList
	self.stageConfig = stageList
	self:setScrollEnable(#self.stageConfig > 5)
	self.fields.Bar_Score:setMax(100)
	self.fields.List:setNumItems(#self.stageConfig)
	self.fields.List:resizeToFit(#self.stageConfig)
end
function Com_stage_9001614:setBarValue(myScore)
	self.fields.List:setNumItems(#self.stageConfig)
	activity_9001614_Ctrl = self.fields.List.setNumItems
	local self.fields.List.setNumItems[1], temp = 0, self.fields.List.setNumItems
	table.insertto(temp, self.stageConfig)
	local percent = SoraDGetStagePercent(myScore, temp)
	self.fields.Bar_Score:setPercent(percent / 100)
	local rewardIndex
	for i, stage in ipairs(self.stageConfig) do
		local status = activity_9001614_Ctrl:getBoxStatus(i)
		if status == gBtnTargetStatusDef.GET then
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
function Com_stage_9001614:onItemRederer(index, obj)
	obj:initData(self.targetList[index + 1], index + 1)
end
return Com_stage_9001614

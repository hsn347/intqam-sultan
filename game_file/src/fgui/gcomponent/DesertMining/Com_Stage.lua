local baseComponent = require("fgui.base.baseComponent")
local Com_Stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertMining/Com_Stage", Com_Stage)
fgui.register_extension("ui://HappyEgg/Com_Stage", Com_Stage)
function Com_Stage:onInit()
	self.fields.List:setPivot(SoraDFPosX(0, 1), 1, false)
	self.fields.Bar_Score:setPivot(SoraDFPosX(0, 1), 1, false)
	self:fixChildrenPos()
	self.fields.Bar_Score:getChild("bar"):fix()
	self.fields.Bar_Score:getChild("bar"):fixPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.scrollBar = self:getScrollPane()
end
function Com_Stage:onShow()
end
function Com_Stage:initData(data)
	self.stageConfig = data
	self:setScrollEnable(#self.stageConfig > 5)
	self.fields.Bar_Score:setMax(100)
	self.fields.List:setNumItems(#self.stageConfig)
	self.fields.List:resizeToFit(#self.stageConfig)
end
function Com_Stage:setBarValue(myScore, modeleCtr)
	self.fields.List:setNumItems(#self.stageConfig)
	local val = 0
	local index = 1
	local rewardIndex
	for k, v in ipairs(self.stageConfig) do
		if not rewardIndex and modeleCtr:getStageStatus(v.stage, v.num) == gBtnTargetStatusDef.GET then
			rewardIndex = k
		end
		if myScore <= v.num then
			index = k
			break
		end
	end
	local tempPre = 100 / #self.stageConfig
	if index == 1 then
		val = myScore / self.stageConfig[index].num * tempPre
	else
		val = (index - 1) * tempPre + (myScore - self.stageConfig[index - 1].num) * tempPre / (self.stageConfig[index].num - self.stageConfig[index - 1].num)
	end
	print("val=======", myScore, index, val)
	self.fields.Bar_Score:setValue(math.min(val, 100))
	if rewardIndex then
		self.scrollBar:setPercX(SoraDFPosX(100 - rewardIndex / #self.stageConfig * 100, 100) / 100, true)
	else
		self.scrollBar:setPercX(SoraDFPosX(100 - val, 100) / 100, true)
	end
end
function Com_Stage:onItemRederer(index, target)
	target:initData(self.stageConfig[index + 1], index + 1)
end
return Com_Stage

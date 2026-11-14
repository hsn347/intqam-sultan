local outStandingsRead = include("outStandingsRead")
local outStandingsCtrl = SoraDGetCtrl("outStandingsCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001157/Com_Stage", Com_Stage)
function Com_Stage:onInit()
	self.fields.Bar_Score:setMax(100)
	self.fields.List:setPivot(SoraDFPosX(0, 1), 1, false)
	self.fields.Bar_Score:setPivot(SoraDFPosX(0, 1), 1, false)
	self:fixChildrenPos()
	self.fields.Bar_Score:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.scrollBar = self:getScrollPane()
end
function Com_Stage:onShow()
end
function Com_Stage:initData(data, classType, basicTag)
	self.stageConfig = data
	self.basicTag = basicTag
	self.classType = classType
	self:setScrollEnable(#self.stageConfig > 4)
	self.fields.List:setNumItems(#self.stageConfig)
	self.fields.List:resizeToFit(#self.stageConfig)
end
function Com_Stage:setBarValue(myScore)
	self.fields.List:setNumItems(#self.stageConfig)
	local val = 0
	local index = 1
	local rewardIndex
	local percent = SoraDGetStagePercent(myScore, self.stageConfig)
	local basicTag = self.basicTag
	for k, v in ipairs(self.stageConfig) do
		local isReceive = outStandingsCtrl:judgeReceiveRewardsByIndex(basicTag + outStandingsRead.getTypeCount(outStandingsCtrl:getBasicType()))
		basicTag = basicTag + 1
		if v <= myScore and not isReceive then
			rewardIndex = k
			break
		end
	end
	self.fields.Bar_Score:setValue(math.max(percent, 0.01))
	if rewardIndex then
		self.scrollBar:setPercX(SoraDFPosX(100 - rewardIndex / #self.stageConfig * 100, 100) / 100, true)
	else
		self.scrollBar:setPercX(SoraDFPosX(100, 100), true)
	end
end
function Com_Stage:onItemRederer(index, target)
	target:initData(self.stageConfig[index + 1], self.basicTag + index, index + 1, self.classType)
end
return Com_Stage

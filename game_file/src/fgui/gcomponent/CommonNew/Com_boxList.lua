local NORMAL_BOX_NUM = 5
local baseComponent = require("fgui.base.baseComponent")
local Com_boxList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_boxList", Com_boxList)
fgui.register_extension("ui://CommonNew/Com_boxList2", Com_boxList)
function Com_boxList:onInit()
	self.stageData, _ENV = nil, nil
	self.fields.List:setItemRenderer(handler(self, self.onBoxItemRenderer))
	self.scrollBar = self:getScrollPane()
	if not SoraDFIsRA() then
		self.fields.List:setPivot(SoraDFPosX(0, 1), 1, false)
		self.fields.bar:setPivot(SoraDFPosX(0, 1), 1, false)
		self:fixChildrenPos()
		self.fields.bar:getChild("bar"):fixPos()
	end
end
function Com_boxList:onShow()
end
function Com_boxList:onBoxItemRenderer(index, obj)
	local stage = index + 1
	local data = self.stageData[stage]
	if not data then
		return
	end
	obj:initData(stage, data.point, data.state, handler(self, self.clickBoxHandle))
end
function Com_boxList:clickBoxHandle(stage)
	local data = self.stageData[stage]
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).stage = data.stage
	;(nil).point = data.point
	;(nil).rewards = data.rewards
	;(nil).state = data.state
	;(nil).score = self.score
	uiManager:show("CommonStageReward", nil)
end
function Com_boxList:initData(params)
	self.activityID = params.activityID
	self.stageMax = params.stageMax
	self.fields.List:setNumItems(self.stageMax)
	self.fields.List:resizeToFit(self.stageMax)
	self:setScrollEnable(self.stageMax > NORMAL_BOX_NUM)
end
function Com_boxList:updateData(params)
	if not params.stageData then
		_ENV = params.stageData
	end
	self.stageData = params.stageData
	local _ENV, stageList = params.stageData, params.stageData
	for __, v in ipairs(self.stageData) do
		table.insert(stageList, v.point)
	end
	local score = params.score or 0
	self.score = score
	local percent = SoraDGetStageValue(score, stageList)
	self.fields.bar:setValue(percent)
	self.fields.List:setNumItems(self.stageMax)
	self:updateScrollBar()
end
function Com_boxList:updateScrollBar(...)
	local rewardIndex = 0
	for i, v in ipairs(self.stageData) do
		if v.state == gBtnTargetStatusDef.GET then
			rewardIndex = i
			break
		end
	end
	if rewardIndex == 0 then
		for i, v in ipairs(self.stageData) do
			if v.state == gBtnTargetStatusDef.GO then
				rewardIndex = i
				break
			end
		end
	end
	local percX = 1 - rewardIndex / self.stageMax
	self.scrollBar:setPercX(SoraDFPosX(percX, 1), true)
end
function Com_boxList:updateLoader(url)
	self.fields.Load_place:setURL(url)
	self.fields.Load_place:setVisible(true)
	self.scrollBar:setPercX(SoraDFPosX(1, 1), true)
	return self.fields.Load_place:getComponent()
end
return Com_boxList

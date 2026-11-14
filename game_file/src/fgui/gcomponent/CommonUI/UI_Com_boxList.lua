local NORMAL_BOX_NUM = 5
local BOX_GAP = 40
local BOX_WIDTH = 80
local COM_WIDTH = 640
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_boxList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_boxList", UI_Com_boxList)
function UI_Com_boxList:onInit()
	self.stageData, _ENV, self.scrollBar = self:getScrollPane(), self:getScrollPane(), self:getScrollPane()
	self.fields.bar:hideTitle()
	self.fields.List:setItemRenderer(handler(self, self.onBoxItemRenderer))
end
function UI_Com_boxList:onShow()
end
function UI_Com_boxList:onBoxItemRenderer(index, obj)
	local stage = index + 1
	local data = self.stageData[stage]
	if not data then
		return
	end
	obj:initData(stage, data.point, data.state, handler(self, self.clickBoxHandle))
end
function UI_Com_boxList:clickBoxHandle(stage)
	local data = self.stageData[stage]
	if self.handler then
		self.handler(data)
	else
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).stage = data.stage
		;(nil).point = data.point
		;(nil).rewards = data.rewards
		;(nil).state = data.state
		;(nil).score = self.score
		;(nil).otherData = self.otherData
		uiManager:show("CommonStageReward", nil)
	end
end
function UI_Com_boxList:initData(params)
	self.activityID = params.activityID
	self.stageMax = params.stageMax
	self.gap = params.gap or BOX_GAP
	self.handler = params.handler
	if self.stageMax > NORMAL_BOX_NUM then
		self:setScrollEnable(true)
		self.fields.List:setColumnGap(self.gap)
		self.fields.List:setWidth(BOX_WIDTH * self.stageMax + (self.stageMax - 1) * self.gap)
		self.fields.bar:setWidth(self.fields.List:getWidth() + self.gap)
	else
		self:setScrollEnable(false)
		self.fields.bar:setWidth(COM_WIDTH - BOX_WIDTH / 2)
		self.gap = (COM_WIDTH - BOX_WIDTH / 2 - BOX_WIDTH * self.stageMax) / self.stageMax
		self.fields.List:setColumnGap(self.gap)
		self.fields.List:setWidth(BOX_WIDTH * self.stageMax + (self.stageMax - 1) * self.gap)
	end
	self.fields.bar:setPositionX(SoraDFPosX(BOX_WIDTH / 2, BOX_WIDTH / 2))
	self.fields.List:setPositionX(SoraDFPosX(0, self.gap + BOX_WIDTH / 2))
	self.fields.List:setNumItems(self.stageMax)
end
function UI_Com_boxList:updateData(params)
	if not params.stageData then
		_ENV = params.stageData
	end
	self.stageData = params.stageData
	if not params.otherData then
		_ENV = params.otherData
	end
	self.otherData = params.otherData
	local _ENV, stageList = params.otherData, params.otherData
	for __, v in ipairs(self.stageData) do
		table.insert(stageList, v.point)
	end
	local score = params.score or 0
	self.score = score
	local percent = SoraDGetStageValue(score, stageList)
	self.fields.bar:setValue(percent)
	self.fields.List:setNumItems(self.stageMax)
	if self.stageMax > NORMAL_BOX_NUM and not params.noAni then
		self:updateScrollBar()
	end
end
function UI_Com_boxList:updateScrollBar(...)
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
function UI_Com_boxList:setBarColor(color)
	self.fields.bar:setBarColor(color)
end
return UI_Com_boxList

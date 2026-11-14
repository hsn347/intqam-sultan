local NORMAL_BOX_NUM = 5
local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_BoxList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001729/Com_BoxList", Com_BoxList)
function Com_BoxList:onInit()
	self.stageData, _ENV = nil, nil
	self.fields.List_box:setItemRenderer(handler(self, self.itemRenderer_List_box))
	self.scrollBar = self:getScrollPane()
	if not SoraDFIsRA() then
		self.fields.List_box:setPivot(SoraDFPosX(0, 1), 1, false)
		self.fields.bar:setPivot(SoraDFPosX(0, 1), 1, false)
		self:fixChildrenPos()
		self.fields.bar:getChild("bar"):fixPos()
	end
end
function Com_BoxList:onShow()
end
function Com_BoxList:itemRenderer_List_box(index, obj)
	local stage = index + 1
	local data = self.stageData[stage]
	if not data then
		return
	end
	obj:initData(stage, data.point, data.state, handler(self, self.clickBoxHandle))
	obj:initItem(data.rewards[1].id, data.rewards[1].count)
end
function Com_BoxList:clickBoxHandle(stage, context)
	local state = activity_9001729_Ctrl:getStageRewardState(stage)
	if state == gBtnTargetStatusDef.GO or state == gBtnTargetStatusDef.NONE then
		local data = self.stageData[stage]
		local obj = self.fields.List_box:getChildren()[stage]
		activity_9001729_Ctrl = nil
		;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
		;(nil).id = data.rewards[1].id
		;(nil).num = data.rewards[1].count
		;(nil).pos = context.inputEvent.position
		SoraDSendMessage(nil)
	elseif state == gBtnTargetStatusDef.GOT then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
	else
		local activity_9001729_Ctrl = SoraDGetCtrl("activity_9001729_Ctrl")
		activity_9001729_Ctrl:reqStageRewardMsg(self.stageData[stage].rewardId)
	end
end
function Com_BoxList:initData(params)
	self.activityID = params.activityID
	self.stageMax = params.stageMax
	self.fields.List_box:setNumItems(self.stageMax)
	self.fields.List_box:resizeToFit(self.stageMax)
	self:setScrollEnable(self.stageMax > NORMAL_BOX_NUM)
end
function Com_BoxList:updateData(params)
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
	self.fields.List_box:setNumItems(self.stageMax)
	self:updateScrollBar()
end
function Com_BoxList:updateScrollBar(...)
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
return Com_BoxList

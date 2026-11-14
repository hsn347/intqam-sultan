local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local NebulaCelebrationMainTaskSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaCelebration/NebulaCelebrationMainTaskSingle", NebulaCelebrationMainTaskSingle)
function NebulaCelebrationMainTaskSingle:onInit()
	self:fixChildrenPos()
	self.fields.Text_not:setString(i18n("PrideRebate_text_13"))
	self.fields.Button_receive:setString(i18n("common_text_1146"))
	self.fields.Label_got:setString(i18n("common_text_1892"))
	self.fields.Button_go:setString(i18n("common_text_678"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickReceive))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaCelebrationMainTaskSingle:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function NebulaCelebrationMainTaskSingle:onClickReceive()
	SoraDPlaySound()
	nebulaCelebrationCtrl:sendReqClaimReward(self.taskCfg.qeustID)
end
function NebulaCelebrationMainTaskSingle:onClickGo()
	SoraDPlaySound()
	local taskInfo = self.taskCfg
	print("任务跳转：", taskInfo.qeustID)
	local guideId = taskInfo.guideId
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskInfo.taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function NebulaCelebrationMainTaskSingle:onShow()
end
function NebulaCelebrationMainTaskSingle:initData(taskId, taskType)
	local taskCfg = eventQuestRead.getTaskConfig(taskId)
	self.taskCfg = taskCfg
	local des = taskCfg.taskDes
	eventQuestRead, eventQuestRead = nil, nil
	;(nil).num, (nil).color = nil, "#E2AF27"
	self.fields.Text_desc:setString(i18n_html(des[1], des, nil))
	local finished = nebulaCelebrationCtrl:isTaskFinished(taskId, taskType)
	local claimed = nebulaCelebrationCtrl:isTaskClaimed(taskId, taskType)
	if finished then
		self.controllers.cStatus:setSelectedIndex(claimed and 2 or 1)
	else
		local hasGoWay = eventQuestRead.isNeedShowGo(taskId)
		self.controllers.cStatus:setSelectedIndex(hasGoWay and 3 or 0)
	end
	local progress = nebulaCelebrationCtrl:getTaskProgress(taskId, taskType)
	local strProgress = progress
	if progress < taskCfg.aim then
		strProgress = fguiHelper.getColorString("#FF0000", progress)
	end
	eventQuestRead = i18n_html(des[1], des, nil)
	i18n_html(des[1], des, nil).count = strProgress
	i18n_html(des[1], des, nil).total = taskCfg.aim
	self.fields.Text_progress:setString(i18n("Nebula_Celebration_text18", i18n_html(des[1], des, nil)))
	self.rewards = eventQuestRead.getReward(taskId)
	self.fields.List_item:setNumItems(#self.rewards)
	local listWidth = self.fields.List_item:getWidth()
	local itemWidth = self.fields.List_item:getChildAt(0):getWidth()
	local gap = self.fields.List_item:getColumnGap()
	local itemCount = self.fields.List_item:getNumItems()
	local showWidth = itemWidth * itemCount + gap * (itemCount - 1)
	self.fields.List_item:getScrollPane():setTouchEffect(listWidth < showWidth)
end
return NebulaCelebrationMainTaskSingle

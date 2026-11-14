local eventQuestRead = include("eventQuestRead")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001721/Com_Task", Com_Task)
function Com_Task:onInit()
	self.fields.Award_Scroll:setItemRenderer(handler(self, self.itemRenderer_Award_Scroll))
	self.fields.Button_Task:addClickListener(handler(self, self.onClick_Button_Task))
	self.fields.txt_got:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_Task:onShow()
end
function Com_Task:initData(data)
	self.taskID = data.taskID
	self.status = data.taskStatus
	eventQuestRead, eventQuestRead, self.activityID = nil, data.activityID, data.activityID
	;(nil).color = "#E2AF27"
	eventQuestRead, data.activityID.num, (nil).i = nil, nil, "true"
	data.activityID.__default, (nil).color = nil, "#D7C39B"
	local styles = data.activityID
	self.fields.Task_Des:setString(eventQuestRead.getDesEx(self.taskID, styles))
	self.rewards = data.award
	self.fields.Award_Scroll:setNumItems(#self.rewards)
	self.fields.Award_Scroll:setScrollEnable(#self.rewards > 5)
	local aim = eventQuestRead.getAim(self.taskID)
	eventQuestRead = eventQuestRead.getDesEx(self.taskID, styles)
	eventQuestRead.getDesEx(self.taskID, styles).var1 = fguiHelper.getColorString(aim > data.progress and "#BE2828" or "#6DDE00", math.min(data.progress, aim))
	eventQuestRead.getDesEx(self.taskID, styles).var2 = aim
	self.fields.Task_Scedule:setString(i18n("%{var1}/%{var2}", eventQuestRead.getDesEx(self.taskID, styles)))
	self.controllers.status:setSelectedIndex(math.max(self.status - 1, 0))
	self.isShowGo = eventQuestRead.checkIsAct(self.taskID)
	if self.status == gBtnTargetStatusDef.GET then
		self.fields.Button_Task:setTitle(i18n("common_text_1146"))
		self.fields.Button_Task:setBtnColorIndex(gBtnColorDef.GREEN)
	else
		self.fields.Button_Task:setTitle(self.isShowGo and i18n("common_text_477") or i18n("common_text_2139"))
		self.fields.Button_Task:setBtnColorIndex(gBtnColorDef.YELLOW)
	end
end
function Com_Task:itemRenderer_Award_Scroll(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_Task:onClick_Button_Task()
	SoraDPlaySound()
	if self.status == gBtnTargetStatusDef.GET then
		activityTaskComponentCtrl:reqRuestClaimReward(self.taskID, self.activityID)
	elseif self.status == gBtnTargetStatusDef.GO and self.isShowGo then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local guideId = eventQuestRead.getGuideId(self.taskID)
		if guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_Task

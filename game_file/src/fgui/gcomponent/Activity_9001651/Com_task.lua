local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activity_9001651_Ctrl = SoraDGetCtrl("activity_9001651_Ctrl")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001651/Com_task", Com_task)
function Com_task:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRender))
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function Com_task:onShow()
end
function Com_task:onItemRender(index, obj)
	local item = self.data.award[index + 1]
	obj:initData(item.id, item.count)
end
function Com_task:initData(data, parent)
	self.data = data
	self.parent = parent
	local desCfg = eventQuestRead.getDes(self.data.taskID)
	local str = clone(desCfg)
	for i, v in pairs(str) do
		if tolua.type(i) == "string" then
			eventQuestRead = nil
			;(nil).color = "#E2AF27"
			;(nil).i = "true"
			str[i] = SoraDWrapHtmlTagByStyle(v, nil)
		end
	end
	eventQuestRead = str
	str.color = "#F0E6D2"
	self.fields.Text_des:setString(SoraDWrapHtmlTagByStyle(i18n(str), str))
	local aim = eventQuestRead.getAim(self.data.taskID)
	local progress = activity_9001651_Ctrl:getTaskProgress(self.data.taskID)
	eventQuestRead = SoraDWrapHtmlTagByStyle(i18n(str), str)
	SoraDWrapHtmlTagByStyle(i18n(str), str).var = fguiHelper.getColorString(aim <= progress and "#D7C39B" or "#E02B2B", progress)
	SoraDWrapHtmlTagByStyle(i18n(str), str).var1 = aim
	self.fields.Text_pro:setString(i18n("alliance_stronghold_text_070", SoraDWrapHtmlTagByStyle(i18n(str), str)))
	self.fields.List_reward:setNumItems(#self.data.award)
	if self.data.taskStatus == gBtnTargetStatusDef.GOT then
		self.fields.Btn_go:setBtnColorIndex(0)
		self.fields.Btn_go:setString(i18n("common_text_1892"))
		self.fields.Btn_go:setEnabled(false)
		self.fields.Btn_go:setVisible(true)
	elseif self.data.taskStatus == gBtnTargetStatusDef.GET then
		self.fields.Btn_go:setBtnColorIndex(0)
		self.fields.Btn_go:setString(i18n("common_text_1146"))
		self.fields.Btn_go:setEnabled(true)
		self.fields.Btn_go:setVisible(true)
	else
		self.fields.Btn_go:setBtnColorIndex(2)
		self.fields.Btn_go:setString(i18n("common_text_477"))
		self.fields.Btn_go:setEnabled(true)
		self.fields.Btn_go:setVisible(0 < string.len(self.data.guideId))
	end
end
function Com_task:btnGoClick()
	SoraDPlaySound()
	if self.data.taskStatus == gBtnTargetStatusDef.GET then
		activity_9001651_Ctrl:sendQuestRewardMsg(self.data.taskID)
		SoraDShowLoading(self.parent)
	else
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(self.data.guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(self.data.taskDes))
		end
		if self.data.guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.data.guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_task

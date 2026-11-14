local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001604_TaskPanel = class("Activity_9001604_TaskPanel", baseFguiPanel)
local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
local constantRead = include("constantRead")
function Activity_9001604_TaskPanel:ctor(...)
	Activity_9001604_TaskPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001604_TaskPanel:ctor", self.viewName)
end
function Activity_9001604_TaskPanel:onInit()
	self.questLimit = constantRead.getConstValue("RAMADAN_MOBILIZE_TASK_LIMIT", 8)
	print("=======Activity_9001604_TaskPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_02"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_name:fixPos()
	self.fields.task_icon:fixPos()
	self:initData(self.param.index, self.param.data)
end
function Activity_9001604_TaskPanel:onShow()
	print("=======Activity_9001604_TaskPanel:onShow")
end
function Activity_9001604_TaskPanel:initData(index, data)
	dump(data, "Activity_9001604_TaskPanel:initData")
	self.data = data
	local str = clone(self.data.des)
	_ENV = "(%s/%s)"
	;("(%s/%s)").color = "#f0e6d2"
	self.fields.Text_name:setString(i18n(data.taskName) .. SoraDWrapHtmlTagByStyle(string.format("(%s/%s)", string.formatnumberthousands(data.progress), string.formatnumberthousands(data.aim)), "(%s/%s)"))
	self.fields.icon:setURL(data.taskIcon)
	local str = clone(self.data.taskDes)
	self.taskDes = i18n(str)
	for i, v in pairs(str) do
		if tolua.type(i) == "string" then
			_ENV = string.formatnumberthousands(data.aim)
			string.formatnumberthousands(data.aim).color = "#E2AF27"
			str[i] = SoraDWrapHtmlTagByStyle(v, string.formatnumberthousands(data.aim))
		end
	end
	_ENV = str
	str.color = self.desBgColor
	self.fields.Text_progress:setString(SoraDWrapHtmlTagByStyle(i18n(str), str))
	self.fields.Button_get:setVisible(true)
	self.fields.text_reward:setString(i18n("common_text_4458"))
	if not data.isMy then
		self.fields.Button_get:setTitle(i18n("alliance_btn_02"))
	elseif data.progress >= data.aim then
		self.fields.Button_get:setTitle(i18n("common_text_3628"))
	else
		self.fields.Button_get:setVisible(self.data.guideId ~= nil and self.data.guideId ~= "")
		self.fields.Button_get:setTitle(i18n("common_text_477"))
	end
	self.rewards = data.reward
	self.fields.List_reward:setNumItems(table.nums(self.rewards))
end
function Activity_9001604_TaskPanel:onClickGet()
	SoraDPlaySound()
	if not self.data.isMy then
		local lastQuestCount = self.questLimit - activity_9001604_Ctrl:getQuestCount()
		if lastQuestCount <= 0 then
			SoraDShowMsgTip(i18n("Ramadan_League_text_07"))
			return
		end
		local myTaskID = activity_9001604_Ctrl:getMyTaskID()
		dump(myTaskID, "myTaskID")
		if myTaskID == nil or myTaskID == 0 then
			activity_9001604_Ctrl:reqAccept(self.data.taskIdx)
			self:close()
		else
			SoraDShowMsgTip(i18n("Ramadan_League_text_14"))
			return
		end
	elseif self.data.progress >= self.data.aim then
		activity_9001604_Ctrl:reqCommit()
		self:close()
	else
		local guideId = self.data.guideId
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local tbParam = mildGuideManager:splitGuideParam(guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(self.taskDes))
		end
		if guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
function Activity_9001604_TaskPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
return Activity_9001604_TaskPanel

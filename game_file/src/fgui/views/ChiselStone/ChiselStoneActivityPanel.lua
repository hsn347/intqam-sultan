local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local chiselStoneCtrl = SoraDGetCtrl("chiselStoneCtrl")
local chiselStoneRead = include("chiselStoneRead")
local basePanel = require("fgui.base.baseFguiPanel")
local ChiselStoneActivityPanel = class("ChiselStoneActivityPanel", basePanel)
function ChiselStoneActivityPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function ChiselStoneActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ChiselStone"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
	end
	return self._packageList
end
function ChiselStoneActivityPanel:onInit()
	self.curChooseDay = 1
	self.curChooseTab = 1
	self.curTaskConfig = chiselStoneCtrl:getTaskList(self.curChooseDay, self.curChooseTab)
	self.fields.com_Title:initData(i18n("activity_name_9001359"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.text_Tips:setString(i18n("digging_task_02"))
	self:initActivityTime()
	self.fields.day_List_Tab:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickDayItem))
	self.fields.day_List_Tab:setItemRenderer(handler(self, self.onDayItemRender))
	self:updateCurDay()
	if IsArClient then
		self.fields.day_List_Tab:scrollToView(0)
	end
	self.fields.task_List_Tab:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickTabItem))
	self.fields.scroll_Task:setItemRenderer(handler(self, self.onTaskItemRender))
	self.fields.scroll_Task:setNumItems(chiselStoneRead.getTaskNumByDayLabel(self.curChooseDay, self.curChooseTab))
	self:updateTaskTab()
end
function ChiselStoneActivityPanel:updateTaskTab()
	local index = 1
	for i = 0, 4, 2 do
		local object = self.fields.task_List_Tab:getChildAt(i)
		object:setTag(index)
		object:setString(i18n(chiselStoneRead.getTabNameByDayLabel(self.curChooseDay, index)))
		object:setReddot(chiselStoneCtrl:getReddotNumByLabel(self.curChooseDay, index))
		index = index + 1
	end
end
function ChiselStoneActivityPanel:onShow()
	chiselStoneCtrl:sendReqInitDataMsg()
	self.fields.day_List_Tab:setSelectedIndex(0)
	self.fields.task_List_Tab:setSelectedIndex(0)
end
function ChiselStoneActivityPanel:initActivityTime()
	self.fields.label_Time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("common_text_4415", nil)
	end)
	local curDay = chiselStoneCtrl:getCurDay()
	if curDay <= 7 then
		self.fields.label_Time:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).time = strTime
			return i18n("digging_task_01", nil)
		end)
	end
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CHISEL_STONE_ACTIVITY)
	dump(timer, "timer")
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		if curDay <= 7 then
			leftTime = serviceFunctions.getTodayRemainTime() + (7 - curDay) * 3600 * 24
		end
		if 0 < leftTime then
			self.fields.label_Time:beginTime(leftTime)
		else
			self:close()
		end
	end
end
function ChiselStoneActivityPanel:updateCurDay()
	local curDay = chiselStoneCtrl:getCurDay()
	self.fields.day_List_Tab:setNumItems(7)
	self.fields.text_Tips:setVisible(7 < curDay)
end
function ChiselStoneActivityPanel:updatTaskScroll()
	self.curTaskConfig = chiselStoneCtrl:getTaskList(self.curChooseDay, self.curChooseTab)
	self.fields.scroll_Task:setNumItems(chiselStoneRead.getTaskNumByDayLabel(self.curChooseDay, self.curChooseTab))
end
function ChiselStoneActivityPanel:updateRed()
	for i = 0, 6 do
		self.fields.day_List_Tab:getChildAt(i):setReddot(chiselStoneCtrl:getReddotNumByDay(i + 1))
	end
	local index = 1
	for i = 0, 4, 2 do
		self.fields.task_List_Tab:getChildAt(i):setReddot(chiselStoneCtrl:getReddotNumByLabel(self.curChooseDay, index))
		index = index + 1
	end
end
function ChiselStoneActivityPanel:onDayItemRender(index, object)
	_ENV = nil
	;(nil).count = index + 1
	object:setString(i18n("common_text_523", nil))
	object:setContentSize(cc.size(147, 67))
	object:setReddot(chiselStoneCtrl:getReddotNumByDay(index + 1))
	local isUnlock = chiselStoneCtrl:getCurDay() >= index + 1
	object:getController("lock"):setSelectedIndex(isUnlock and 1 or 0)
end
function ChiselStoneActivityPanel:onTaskItemRender(index, object)
	local config = self.curTaskConfig[index + 1]
	dump(config, "config")
	object:initData(config)
	object:setHandler(handler(self, self.onClickGetAward), handler(self, self.onClickGo))
end
function ChiselStoneActivityPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("digging_task_03")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ChiselStoneActivityPanel:onClickDayItem(target)
	print("onClickDayItem")
	SoraDPlaySound()
	local newChooseDay = self.fields.day_List_Tab:getSelectedIndex() + 1
	if newChooseDay ~= 4 then
		self.fields.day_List_Tab:getScrollPane():setPercX(SoraDFPosX(4 < newChooseDay and 0 or 1, 1), true)
	end
	local isUnlock = newChooseDay <= chiselStoneCtrl:getCurDay()
	if not isUnlock then
		_ENV = 1
		;(1).day = newChooseDay
		SoraDShowMsgTip(i18n("digging_task_04", 1))
		self.fields.day_List_Tab:setSelectedIndex(self.curChooseDay - 1)
		return
	end
	if newChooseDay == self.curChooseDay then
		return
	end
	self.curChooseDay = newChooseDay
	self:updateTaskTab()
	self.fields.task_List_Tab:setSelectedIndex(0)
	self.curChooseTab = 1
	self:updatTaskScroll()
end
function ChiselStoneActivityPanel:onClickTabItem(target)
	SoraDPlaySound()
	local target = self.fields.task_List_Tab:getChildAt(self.fields.task_List_Tab:getSelectedIndex())
	print("onClickTabItem", target:getTag())
	local newChooseTab = target:getTag()
	if target:getTag() == self.curChooseTab then
		return
	end
	self.curChooseTab = newChooseTab
	self:updatTaskScroll()
end
function ChiselStoneActivityPanel:onClickGetAward(taskID)
	SoraDShowLoading()
	chiselStoneCtrl:reqChiselStoneReward(taskID)
end
function ChiselStoneActivityPanel:onClickGo(guideId, taskDes)
	dump(guideId, "guideId")
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(guideId)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(taskDes))
	end
	if guideId then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return ChiselStoneActivityPanel

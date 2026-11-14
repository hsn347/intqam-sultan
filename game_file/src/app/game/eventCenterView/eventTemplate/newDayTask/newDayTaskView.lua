local newDayTaskCtrl = SoraDGetCtrl("newDayTaskCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local newDayTaskView = class("newDayTaskView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("newDayTaskView")
end)
function newDayTaskView:ctor(properties)
	self.activityID = gActivityTimeActivityID.CHANGE_DAY_ACTIVITY
	self.itemId = 836501
	self.nodeTaskSingle = SoraDGetChildByName(self, "Node_TaskSingle")
	self.scrollAward = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	self.scrollAward = include("commonAutoScrollList").new(self.scrollAward)
	self.scrollAward:setSingleCreate(handler(self, self.createTaskSingle))
	self.scrollAward:setSingleCCS("newDayTaskSingle")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.nodeTime = SoraDGetChildByName(self.nodeHead, "Node_time")
	self.textTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.nodeItm = SoraDGetChildByName(self.nodeHead, "Node_Itm")
	self.imgIcon = SoraDGetChildByName(self.nodeItm, "Image_Icon")
	self.imgRed = SoraDGetChildByName(self.nodeItm, "Image_redPoint")
	self.btnItem = SoraDGetChildByName(self.nodeItm, "Button_Item")
	self.btnItem = include("commonBtnInstance").new(self.btnItem)
	self.btnItem:setHandle(handler(self, self.btnItemClick))
	self.btnItem:setItemInfo(self, self.itemId, 1)
	self.textNum = SoraDGetChildByName(self.nodeItm, "Text_Num")
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_eventStartWorkBonus")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001320"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.textResetTip = SoraDGetChildByName(self, "Text_ResetTip")
	self.textResetTip:setString(i18n("ramadan_text_20"))
	self.Node_Bottom = SoraDGetChildByName(self, "Node_Bottom")
	self.Node_Bottom:setVisible(false)
	self:initData()
end
function newDayTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
end
function newDayTaskView:initData(target, data)
	self:initActivityTime()
	self:updataScroll()
	self:updateRedPoint()
end
function newDayTaskView:initItemInfo(target, data)
	self.itemNum = backpackCtrl:getItemCount(self.itemId)
	backpackCtrl = nil
	;(nil).num = self.itemNum
	self.textNum:setString(i18n("common_text_063", nil))
end
function newDayTaskView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTime, 10)
end
function newDayTaskView:updataScroll(target, data)
	self:initItemInfo()
	SoraDCloseLoading(self)
	local taskList = newDayTaskCtrl:getQuestData(self.activityID)
	if next(taskList) then
		self.textResetTip:setVisible(newDayTaskCtrl:isResetEveryday())
	end
	_ENV = newDayTaskCtrl:isResetEveryday()
	newDayTaskCtrl:isResetEveryday().scroll = self.scrollAward
	newDayTaskCtrl:isResetEveryday().view = self
	newDayTaskCtrl:isResetEveryday().activityID = self.activityID
	self.scrollAward:updateScrollView(cc.size(640, 154), taskList, 1, newDayTaskCtrl:isResetEveryday())
end
function newDayTaskView:updateRedPoint(target, data)
	self:initItemInfo()
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNum(gActivityTimeActivityID.EXCHANGE_MALL_NEW_DAY_TASK)
	self.imgRed:setVisible(ret)
end
function newDayTaskView:createTaskSingle()
	local target = self.nodeTaskSingle:clone()
	local single = include("newDayTaskSingle").new(target)
	return single
end
function newDayTaskView:btnItemClick(target, eventType)
	local panel = SoraDCreatePanel("newDayTaskPopView")
	panel:panelScaleAct()
	panel:show()
end
function newDayTaskView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("changeDay_text_01"))
	end
end
function newDayTaskView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return newDayTaskView

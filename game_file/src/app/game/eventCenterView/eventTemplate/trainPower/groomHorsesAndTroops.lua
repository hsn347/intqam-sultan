local publicRead = include("publicRead")
local groomHorsesCtrl = SoraDGetCtrl("groomHorsesCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local groomHorsesAndTroops = class("groomHorsesAndTroops", function(target)
	if target == nil then
		return SoraDCreateBasePanel("groomHorsesAndTroops")
	end
	return target
end)
function groomHorsesAndTroops:ctor()
	self:initControls()
	self:initTaskScroll()
end
function groomHorsesAndTroops:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initTaskScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.initTaskScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initTaskScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function groomHorsesAndTroops:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.Top_Size_ScrollView = include("commonAutoScrollList").new(self.Top_Size_ScrollView)
	self.Top_Size_ScrollView:setSingleCCS("groomHorsesAndTroopsItem")
	self.ccs_title:setTitle(i18n("activity_name_9001348"))
	self.btnHelpTip:addTouchEventListener(handler(self, self.buttonHelpCallBack))
	self.activityID = gActivityTimeActivityID.GROOM_HORSES_AND_TROOPS
	self.Image_event:loadTexture("bg_activity_9001348.png", ccui.TextureResType.plistType)
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_time = SoraDChangeTextToHtml(self.text_time)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.text_time:setTimeLast(function(ticket)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, ticket
		_ENV, (nil).time, (nil).color = nil, nil, "#5AB440"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("lost_ruins_text_21", nil, nil)
	end)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.text_time:beginTime(leftTime)
	end
	self.Text_reset:setString(i18n("task_text_02"))
	local startTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local endTime = activityShowCtrl:getEndTimeSecond(self.activityID)
	self.text_last_time:setString(string.format("%s-%s", os.date("!%Y.%m.%d", startTime), os.date("!%Y.%m.%d", endTime)))
end
function groomHorsesAndTroops:buttonHelpCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "train_text_02"
		;("train_text_02").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("train_text_02"), "train_text_02")
	end
end
function groomHorsesAndTroops:initTaskScroll()
	SoraDCloseLoading(self)
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	dump(self.taskList, "slkdjfdsljkfd")
	_ENV = nil
	;(nil).scroll = self.Top_Size_ScrollView
	;(nil).view = self
	;(nil).activityID = self.activityID
	;(nil).mainView = self
	self.Top_Size_ScrollView:updateScrollView(cc.size(640, 154), self.taskList, 1, nil)
	if next(self.taskList) then
		self.Text_reset:setVisible(self.taskList[1].type == 1)
	end
end
function groomHorsesAndTroops:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return groomHorsesAndTroops

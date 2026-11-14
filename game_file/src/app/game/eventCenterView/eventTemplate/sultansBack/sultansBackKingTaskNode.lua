local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackKingTaskNode = class("sultansBackKingTaskNode", function(target)
	local target = SoraDCreateBasePanel("sultansBackKingTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackKingTaskNode:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackKingTaskNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.SULTAN_BACK_RETURN_ACTIVITY
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.btnQuestion = SoraDGetChildByName(self.topNode, "Button_Question")
	self.btnQuestion:addTouchEventListener(handler(self, self.btnQuestionClick))
	self.nodeTime = SoraDGetChildByName(self.topNode, "Node_time")
	self.textTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_Size_item")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCreate(handler(self, self.createTaskSingle))
	self.nodeTaskSingle = SoraDGetChildByName(self, "Node_TaskSingle")
	self.nodeCommonTabBtn = SoraDGetExtendChildFromCCSByName(self.topNode, "CCS_commonTabBtnEX")
	self.nodeCommonTabBtn:setNewStyle()
	self.nodeCommonTabBtn:setContentSize(cc.size(640, 50))
end
function sultansBackKingTaskNode:initData()
	self:initActivityTime()
	_ENV = self.initActivityTime
	self.initActivityTime.tabNum = 4
	_ENV, _ENV, self.initActivityTime.defaultClick = nil, self, 1
	;(nil).title = i18n("king_tri_text_29")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 1
	_ENV, self[1], (nil).fontSize = nil, nil, 22
	;(nil).title = i18n("friend_return_text_06")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 2
	_ENV, self[2], (nil).fontSize = nil, nil, 22
	;(nil).title = i18n("king_tri_text_27")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 3
	_ENV, self[3], (nil).fontSize = nil, nil, 22
	;(nil).title = i18n("common_text_4025")
	;(nil).handle = handler(self, self.btnTabClick)
	;(nil).tag = 4
	self.initActivityTime.tabsetArray, self[4], (nil).fontSize = self, nil, 22
	local param = self.initActivityTime
	self.nodeCommonTabBtn:initView(param)
	self:initRedPoint()
end
function sultansBackKingTaskNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
end
function sultansBackKingTaskNode:initRedPoint()
	for i = 1, 4 do
		local num = sultansBackCtrl:getKingTaskRednumByType(self.activityID, i)
		self.nodeCommonTabBtn:setRedPointState(i, 0 < num)
	end
end
function sultansBackKingTaskNode:initActivityTime()
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
function sultansBackKingTaskNode:btnQuestionClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("friend_return_text_04"))
	end
end
function sultansBackKingTaskNode:btnTabClick(tag, name)
	self.taskType = tag
	self:updataScroll()
end
function sultansBackKingTaskNode:updataScroll(target, data)
	SoraDCloseLoading(self.parentView)
	local taskList = sultansBackCtrl:getQuestData(self.activityID, self.taskType)
	self.scrollItem:jumpToTop()
	_ENV = nil
	;(nil).scroll = self.scrollItem
	;(nil).view = self.parentView
	self.scrollItem:updateScrollView(cc.size(640, 154), taskList, 1, nil)
end
function sultansBackKingTaskNode:updateRedPoint(target, data)
	local activityID = data.activityID or data.eventID
	if activityID == self.activityID then
		local num = sultansBackCtrl:getKingTaskRednumByType(self.activityID, self.taskType)
		self.nodeCommonTabBtn:setRedPointState(self.taskType, 0 < num)
	end
end
function sultansBackKingTaskNode:setParentView(parent)
	self.parentView = parent
end
function sultansBackKingTaskNode:createTaskSingle()
	local target = self.nodeTaskSingle:clone()
	local single = include("sultansBackTaskSingle").new(target)
	return single
end
return sultansBackKingTaskNode

local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local shiningStarLightTaskNode = class("shiningStarLightTaskNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	target = target or SoraDCreateBasePanel("shiningStarLightTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function shiningStarLightTaskNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self.nodeTimer, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.scroll = SoraDGetChildByName(self, "ScrollView_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("shiningStarLightTaskSingle")
	self:initActivityTime()
end
function shiningStarLightTaskNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updataScroll))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updataScroll))
end
function shiningStarLightTaskNode:initData(view)
	self.parentView = view
	self:updataScroll()
end
function shiningStarLightTaskNode:updataScroll()
	SoraDCloseLoading(self.parentView)
	if not shiningStarLightCtrl:getQuestData() then
		_ENV = shiningStarLightCtrl:getQuestData()
	end
	self.taskList = shiningStarLightCtrl:getQuestData()
	dump(self.taskList, "self.taskList", 10)
	self.scroll:jumpToTop()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self.parentView
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, nil)
end
function shiningStarLightTaskNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("lucky_text_02", nil)
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 10, SoraDFIsRA())
end
function shiningStarLightTaskNode:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return shiningStarLightTaskNode

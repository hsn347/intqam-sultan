local gametop = gModuleMgr.getObject("gametop")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local starRhapsodyDef = include("starRhapsodyDef")
local eventQuestRead = include("eventQuestRead")
local starRhapsodyTaskView = class("starRhapsodyTaskView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("starRhapsodyTaskView")
	end
	return target
end)
function starRhapsodyTaskView:ctor()
	self.activityID = gActivityTimeActivityID.STAR_RHAPSODY
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.title:setTitle(i18n(starRhapsodyDef.isStar and "starlight_title_03" or "starlight_title_02"))
	self.scrollViewTask = SoraDGetChildByName(self, "Top_Size_ScrollView_task")
	self.scroll = include("commonAutoScrollList").new(self.scrollViewTask)
	self.scroll:setSingleCCS("starRhapsodyTaskSingle")
	self:initView()
end
function starRhapsodyTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function starRhapsodyTaskView:initView()
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	self:initScrollList()
end
function starRhapsodyTaskView:updateTaskData(target, data)
	SoraDCloseLoading(self)
	self:initView()
end
function starRhapsodyTaskView:initScrollList()
	self.scroll:jumpToTop()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).mainView = self
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, nil)
end
function starRhapsodyTaskView:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
return starRhapsodyTaskView

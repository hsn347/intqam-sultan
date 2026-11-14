local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local ancientReelUtil = include("ancientReelUtil")
local eventQuestRead = include("eventQuestRead")
local ancientReelMainTaskView = class("ancientReelMainTaskView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "ancientReelMainTaskView"
;("ancientReelMainTaskView").TASK_VIEW_TYPE_WEEK = 1
local ("ancientReelMainTaskView").TASK_VIEW_TYPE_SEASON, TASK_VIEW_TYPE = 2, "ancientReelMainTaskView"
function ancientReelMainTaskView:ctor()
	self.activityID = gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_task")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("ancientReelMainTaskSingle")
	_ENV = self.scroll.setSingleCCS
	_ENV = "ancientReelMainTaskSingle"
	;("ancientReelMainTaskSingle").title = "Button_week"
	self.scroll.setSingleCCS[TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK], ("ancientReelMainTaskSingle").titleText = "ancientReelMainTaskSingle", "summoned_text_27"
	_ENV = "ancientReelMainTaskSingle"
	;("ancientReelMainTaskSingle").title = "Button_season"
	self.scroll.setSingleCCS[TASK_VIEW_TYPE.TASK_VIEW_TYPE_SEASON], ("ancientReelMainTaskSingle").titleText = "ancientReelMainTaskSingle", "summoned_text_28"
	local tableData = self.scroll.setSingleCCS
	for i, v in ipairs(tableData) do
		local btnScore = SoraDGetChildByName(self, v.title)
		btnScore:setTag(i)
		btnScore:setPressedActionEnabled(false)
		btnScore:setTitleText(i18n(v.titleText))
		btnScore:addTouchEventListener(handler(self, self.OnBtnChangeClick))
		v.button = btnScore
	end
	self.tableData = tableData
	self.showViewType = nil
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	local strTitle = ancientReelCtrl:getActivitySeasonEndTitle()
	self.txtActivieyTime:setString(strTitle)
	self.nodeTaskInfo = SoraDGetChildByName(self, "Node_task_info")
	self.txtTaskDay = SoraDGetChildByName(self, "Text_task_day")
	self.txtTaskExp = SoraDGetChildByName(self, "Text_task_exp")
	self.nodeTodayRedTask = SoraDGetChildByName(SoraDGetChildByName(self, "Button_week"), "Node_red_exchange")
	self.nodeSeasonRedTask = SoraDGetChildByName(SoraDGetChildByName(self, "Button_season"), "Node_red_exchange")
end
function ancientReelMainTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateTaskData))
end
function ancientReelMainTaskView:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
function ancientReelMainTaskView:initShowBtn(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		local btn = v.button
		btn:setTouchEnabled(not show)
		btn:setBright(show)
		if show then
			btn:setTitleColor(cc.c3b(255, 200, 100))
		else
			btn:setTitleColor(cc.c3b(100, 80, 40))
		end
		self:switchPanel()
	end
end
function ancientReelMainTaskView:updateTaskData(target, data)
	self:switchPanel()
end
local showRedPacketTip = function(node, num)
	if 0 < num then
		node:setVisible(true)
		local txt = SoraDGetChildByName(node, "Text_num")
		txt:setString(num)
	else
		node:setVisible(false)
	end
end
function ancientReelMainTaskView:updateRedPacketTip()
	local numToday = 0
	local numSeason = 0
	for _, v in ipairs(self.taskList) do
		if v.taskStatus == _G.gBtnTargetStatusDef.GET then
			if v.type == TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK then
				numToday = numToday + 1
			else
				numSeason = numSeason + 1
			end
		end
	end
	showRedPacketTip(self.nodeTodayRedTask, numToday)
	showRedPacketTip(self.nodeSeasonRedTask, numSeason)
end
function ancientReelMainTaskView:switchPanel()
	local serverData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskShowList, activityTaskComponentCtrl, self.taskList = eventQuestRead.getSortList(self.activityID, serverData), eventQuestRead.getSortList(self.activityID, serverData), eventQuestRead.getSortList(self.activityID, serverData)
	for _, v in ipairs(self.taskList) do
		if v.type == self.showViewType then
			table.insert(self.taskShowList, v)
		end
	end
	dump(self.taskShowList, "taskShowList", 10)
	self:initScrollList()
	self:showTaskInfo(self.showViewType == TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK)
	self:updateRedPacketTip()
end
function ancientReelMainTaskView:showTaskInfo(show)
	self.nodeTaskInfo:setVisible(show)
	if show then
		self.txtActivieyTime:setPositionY(20)
		local activityDay = ancientReelCtrl:getActivityDay()
		local curExp, maxExp = ancientReelUtil:getTaskExp(self.taskShowList)
		ancientReelCtrl = nil
		;(nil).num = activityDay
		local strDay = i18n("summoned_text_43", nil)
		ancientReelCtrl = nil
		;(nil).cur = string.formatnumberthousands(curExp)
		;(nil).max = string.formatnumberthousands(maxExp)
		local strExp = i18n("summoned_text_44", nil)
		self.txtTaskDay:setString(strDay)
		self.txtTaskExp:setString(strExp)
		_ENV = strExp
		strExp[1] = self.txtTaskDay
		strExp[2] = self.txtTaskExp
		ancientReelUtil = self.txtTaskExp
		self.txtTaskExp[1] = 10
		_G.SoraDAlignNodeArrayOnCenterX(320, strExp, SoraDFIsRA(), self.txtTaskExp)
	else
		self.txtActivieyTime:setPositionY(0)
	end
end
function ancientReelMainTaskView:init()
	self:initShowBtn(TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK)
end
function ancientReelMainTaskView:initScrollList()
	local view = self:getParent():getParent()
	SoraDCloseLoading(view)
	self.scroll:jumpToTop()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = view
	;(nil).mainView = self
	;(nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(640, 170), self.taskShowList, 1, nil)
end
return ancientReelMainTaskView

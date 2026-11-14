local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsUtil = include("royalSummonsUtil")
local royalSummonsMainTaskView = class("royalSummonsMainTaskView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "royalSummonsMainTaskView"
;("royalSummonsMainTaskView").TASK_VIEW_TYPE_WEEK = 1
local ("royalSummonsMainTaskView").TASK_VIEW_TYPE_SEASON, TASK_VIEW_TYPE = 2, "royalSummonsMainTaskView"
function royalSummonsMainTaskView:ctor()
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_task")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("royalSummonsMainTaskSingle")
	_ENV = self.scroll.setSingleCCS
	_ENV = "royalSummonsMainTaskSingle"
	;("royalSummonsMainTaskSingle").title = "Button_week"
	self.scroll.setSingleCCS[TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK], ("royalSummonsMainTaskSingle").titleText = "royalSummonsMainTaskSingle", "summoned_text_27"
	_ENV = "royalSummonsMainTaskSingle"
	;("royalSummonsMainTaskSingle").title = "Button_season"
	self.scroll.setSingleCCS[TASK_VIEW_TYPE.TASK_VIEW_TYPE_SEASON], ("royalSummonsMainTaskSingle").titleText = "royalSummonsMainTaskSingle", "summoned_text_28"
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
	local strTitle = royalSummonsCtrl:getActivitySeasonEndTitle()
	self.txtActivieyTime:setString(strTitle)
	self.nodeTaskInfo = SoraDGetChildByName(self, "Node_task_info")
	self.txtTaskDay = SoraDGetChildByName(self, "Text_task_day")
	self.txtTaskExp = SoraDGetChildByName(self, "Text_task_exp")
	self.nodeTodayRedTask = SoraDGetChildByName(SoraDGetChildByName(self, "Button_week"), "Node_red_exchange")
	self.nodeSeasonRedTask = SoraDGetChildByName(SoraDGetChildByName(self, "Button_season"), "Node_red_exchange")
	self:updateRedPacketTip()
end
function royalSummonsMainTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_TASK", handler(self, self.updateTaskData))
end
function royalSummonsMainTaskView:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
function royalSummonsMainTaskView:initShowBtn(showViewType)
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
function royalSummonsMainTaskView:updateTaskData(target, data)
	SoraDCloseLoading(self)
	self:switchPanel()
	self:updateRedPacketTip()
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
function royalSummonsMainTaskView:updateRedPacketTip()
	local num, numToday, numSeason = royalSummonsCtrl:getTaskNum()
	showRedPacketTip(self.nodeTodayRedTask, numToday)
	showRedPacketTip(self.nodeSeasonRedTask, numSeason)
end
function royalSummonsMainTaskView:switchPanel()
	local royalSummonsRead = include("royalSummonsRead")
	self.taskList = royalSummonsRead:getTaskByType(self.showViewType, royalSummonsCtrl:getClassType())
	for _, v in ipairs(self.taskList) do
		v.taskStatus = royalSummonsUtil:getTaskStatus(v.taskID)
	end
	table.sort(self.taskList, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	self:initScrollList()
	self:showTaskInfo(self.showViewType == TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK)
end
function royalSummonsMainTaskView:showTaskInfo(show)
	self.nodeTaskInfo:setVisible(show)
	if show then
		self.txtActivieyTime:setPositionY(20)
		local activityDay = royalSummonsCtrl:getActivityDay()
		local curExp, maxExp = royalSummonsUtil:getTaskExp(self.taskList)
		royalSummonsCtrl = nil
		;(nil).num = activityDay
		local strDay = i18n("summoned_text_43", nil)
		royalSummonsCtrl = nil
		;(nil).cur = string.formatnumberthousands(curExp)
		royalSummonsCtrl, royalSummonsCtrl, (nil).max = maxExp, string.formatnumberthousands(maxExp), string.formatnumberthousands(maxExp)
		royalSummonsCtrl, string.formatnumberthousands(maxExp).cur, maxExp.color = maxExp, maxExp, "#ffffff"
		royalSummonsCtrl, string.formatnumberthousands(maxExp).max, maxExp.color = maxExp, maxExp, "#ffffff"
		string.formatnumberthousands(maxExp).__default, maxExp.color = maxExp, "#c5dafc"
		local strExp = i18n_html("summoned_text_44", nil, (string.formatnumberthousands(maxExp)))
		self.txtTaskDay:setString(strDay)
		self.txtTaskExp = SoraDChangeTextToHtml(self.txtTaskExp)
		self.txtTaskExp:setString(strExp)
		_ENV = strExp
		strExp[1] = self.txtTaskDay
		strExp[2] = self.txtTaskExp
		royalSummonsUtil = self.txtTaskExp
		self.txtTaskExp[1] = 10
		_G.SoraDAlignNodeArrayOnCenterX(320, strExp, SoraDFIsRA(), self.txtTaskExp)
	else
		self.txtActivieyTime:setPositionY(0)
	end
end
function royalSummonsMainTaskView:init()
	self:initShowBtn(TASK_VIEW_TYPE.TASK_VIEW_TYPE_WEEK)
end
function royalSummonsMainTaskView:initScrollList()
	self.scroll:jumpToTop()
	local view = self:getParent():getParent()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = view
	;(nil).mainView = self
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, nil)
end
return royalSummonsMainTaskView

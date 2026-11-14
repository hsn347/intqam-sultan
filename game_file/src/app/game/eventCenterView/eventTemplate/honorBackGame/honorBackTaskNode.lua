local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local honorBackTaskNode = class("honorBackTaskNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackTaskNode")
	end
	return target
end)
function honorBackTaskNode:ctor()
	self.taskConfig = honorBackCtrl:getTaskConfig()
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setSingleCCS("honorBackTaskItem")
	local item = SoraDCreatePanel("honorBackTaskItem")
	self.itemSize = item:getItemSize()
	self.oldSize = self.Panel_cut:getContentSize()
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_HONORBACK)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
		SoraDToCenter(self.Node_time, 10, SoraDFIsRA())
	end
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_btns")
	self.Image_activity = SoraDGetChildByName(self, "Image_activity")
	self.Image_activity:ignoreContentAdaptWithSize(true)
	self.Image_activity:setAnchorPoint(cc.p(0.5, 0.5))
	self.Image_activity:setPosition(320, 100)
end
function honorBackTaskNode:btn_onClick_btns(tag, name)
	print("==tag==", tag)
	local taskType = self.taskConfig[self.honorType][tag]
	self.eventDatas = friendsCallbackRead.getTaskTypeConfig(taskType)
	self:updateScrollData()
end
function honorBackTaskNode:setSize(size)
	self.Panel_cut:setContentSize(size)
	self.Top_Node:setPositionY(size.height)
	local sSize = self.scroll:getContentSize()
	self.scroll:setContentSize(cc.size(sSize.width, sSize.height + size.height - self.oldSize.height))
end
function honorBackTaskNode:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK", function(target, data)
		self:updateScrollData()
	end)
end
function honorBackTaskNode:initData(honorType, btnType)
	self.honorType = honorType
	local defaultClick = 1
	if btnType then
		defaultClick = btnType
	else
		for i, taskType in ipairs(self.taskConfig[self.honorType]) do
			local showRed = honorBackCtrl:checkRedStateByTaskType(taskType)
			if showRed then
				defaultClick = i
				break
			end
		end
	end
	local _ENV, tabsetArray = (for generator), ipairs(self.taskConfig[self.honorType])
	if honorType == gHonorBackType.BackTask then
		_ENV, _ENV = ipairs(self.taskConfig[self.honorType])
		ipairs(self.taskConfig[self.honorType]).title = i18n("king_road_name_01")
		_ENV, gHonorBackType.BackTask[1], ipairs(self.taskConfig[self.honorType]).handle = ipairs(self.taskConfig[self.honorType])
		ipairs(self.taskConfig[self.honorType]).title = i18n("epicbattle_btn_02")
		_ENV, gHonorBackType.BackTask[2], ipairs(self.taskConfig[self.honorType]).handle = ipairs(self.taskConfig[self.honorType])
		ipairs(self.taskConfig[self.honorType]).title = i18n("task_name_01")
		_ENV, gHonorBackType.BackTask[3], ipairs(self.taskConfig[self.honorType]).handle = ipairs(self.taskConfig[self.honorType])
		ipairs(self.taskConfig[self.honorType]).title = i18n("returnnew_title_020")
		tabsetArray, gHonorBackType.BackTask[4], ipairs(self.taskConfig[self.honorType]).handle = gHonorBackType.BackTask, ipairs(self.taskConfig[self.honorType])
		SoraChangeSpriteImage(self.Image_activity, "bg_activity_9001114_1.png")
	else
		_ENV, _ENV = self.Image_activity, SoraChangeSpriteImage
		self.Image_activity.title = i18n("spice_name_08")
		_ENV, SoraChangeSpriteImage[1], self.Image_activity.handle = self.Image_activity, self.Image_activity, handler(self, self.btn_onClick_btns)
		self.Image_activity.title = i18n("returnnew_title_022")
		_ENV, SoraChangeSpriteImage[2], self.Image_activity.handle = self.Image_activity, self.Image_activity, handler(self, self.btn_onClick_btns)
		self.Image_activity.title = i18n("buildDes_name_114")
		_ENV, SoraChangeSpriteImage[3], self.Image_activity.handle = self.Image_activity, self.Image_activity, handler(self, self.btn_onClick_btns)
		self.Image_activity.title = i18n("returnnew_title_024")
		tabsetArray, SoraChangeSpriteImage[4], self.Image_activity.handle = SoraChangeSpriteImage, self.Image_activity, handler(self, self.btn_onClick_btns)
		SoraChangeSpriteImage(self.Image_activity, "bg_activity_show_King_Back.png")
	end
	_ENV = "bg_activity_show_King_Back.png"
	;("bg_activity_show_King_Back.png").tabNum = #tabsetArray
	;("bg_activity_show_King_Back.png").defaultClick = defaultClick
	;("bg_activity_show_King_Back.png").tabsetArray = tabsetArray
	self.ccs_tab:initView("bg_activity_show_King_Back.png")
	self:updateScrollData()
end
function honorBackTaskNode:updateTaskData()
	table.sort(self.eventDatas, function(a, b)
		local aState = honorBackCtrl:getTaskState(a.taskID)
		local bState = honorBackCtrl:getTaskState(b.taskID)
		if aState == bState then
			return a.taskID < b.taskID
		end
		honorBackCtrl = a.taskID < b.taskID
		;(a.taskID < b.taskID)[gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE] = 1
		;(a.taskID < b.taskID)[gFriendCallbackTaskStatus.TASK_STATUS_DOING] = 2
		local (a.taskID < b.taskID)[gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE], priorityTab = 3, a.taskID < b.taskID
		return priorityTab[aState] < priorityTab[bState]
	end)
end
function honorBackTaskNode:updateScrollData()
	self:updateTaskData()
	_ENV = nil
	;(nil).view = self.Panel_cut
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(self.itemSize, self.eventDatas, 1, nil)
	self.scroll:jumpToTop()
	for i, taskType in ipairs(self.taskConfig[self.honorType]) do
		local showRed = honorBackCtrl:checkRedStateByTaskType(taskType)
		self.ccs_tab:setRedPointState(i, showRed)
	end
end
return honorBackTaskNode

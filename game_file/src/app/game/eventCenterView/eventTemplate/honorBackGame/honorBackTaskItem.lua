local gametop = gModuleMgr.getObject("gametop")
local friendsCallbackRead = include("friendsCallbackRead")
local honorBackCtrl = gametop.playertop_:getModule("honorBackCtrl")
local publicRead = include("publicRead")
local honorBackTaskItem = class("honorBackTaskItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("honorBackTaskItem")
	end
	return target
end)
local colorRed = cc.c3b(204, 8, 8)
local colorYellow = cc.c3b(200, 140, 0)
function honorBackTaskItem:getItemSize(...)
	return self.panel_content:getContentSize()
end
function honorBackTaskItem:ctor(...)
	SoraDGetAllChildFromWidget(self, self)
	self.text_progress = SoraDChangeTextToHtml(self.text_progress)
	self.text_title = SoraDChangeTextToHtml(self.text_title)
	self.btn_operate:setTitleText(i18n("common_text_1146"))
	self.btn_operate:addTouchEventListener(handler(self, self.btnOperateClick))
	self.Image_received:setVisible(false)
	self.tbInUse, _ENV = self.Image_received.setVisible, self.Image_received.setVisible
end
function honorBackTaskItem:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_TASK", function(target, data)
		SoraDCloseLoading(self.btn_operate)
	end)
end
function honorBackTaskItem:initData(data, otherData)
	SoraDCloseLoading(self.btn_operate)
	self.taskData = data
	self.view = otherData.view
	self.scroll = otherData.scroll
	local _ENV, _ENV, _ENV, tab = nil, self.btn_operate, otherData.scroll, otherData.scroll
	self.btn_operate.__default, (nil).color = nil, "#C8AA96"
	local styles = self.btn_operate
	for k, v in pairs(data.name) do
		if type(k) == "string" then
			_ENV, tab[k] = string.formatnumberthousands(v), string.formatnumberthousands(v)
			styles[k], string.formatnumberthousands(v).color = string.formatnumberthousands(v), "#FFC864"
		end
	end
	self.text_title:setString(i18n_html(data.name[1], tab, styles))
	local curNum = honorBackCtrl:getTaskCurNum(data.taskID) or 0
	local curNumStr = string.formatnumberthousands(curNum)
	local questStr = string.formatnumberthousands(data.Quest)
	if curNum < data.Quest then
		self.text_progress:setColor(display.COLOR_WHITE)
		_ENV = "common_text_3780"
		;("common_text_3780").color = "#C8AA96"
		local str = SoraDWrapHtmlTagByStyle(i18n("common_text_3780"), "common_text_3780")
		_ENV = i18n_html(data.name[1], tab, styles)
		i18n_html(data.name[1], tab, styles).member = curNumStr
		_ENV, _ENV, i18n_html(data.name[1], tab, styles).total = i18n_html(data.name[1], tab, styles)
		_ENV, i18n_html(data.name[1], tab, styles).member, i18n_html(data.name[1], tab, styles).color = i18n_html(data.name[1], tab, styles)
		i18n_html(data.name[1], tab, styles).__default, i18n_html(data.name[1], tab, styles).color = i18n_html(data.name[1], tab, styles)
		str = str .. i18n_html("common_text_155", i18n_html(data.name[1], tab, styles))
		self.text_progress:setString(str)
	else
		self.text_progress:setColor(cc.c3b(200, 170, 150))
		_ENV = cc.c3b(200, 170, 150)
		cc.c3b(200, 170, 150).member = curNumStr
		cc.c3b(200, 170, 150).total = questStr
		self.text_progress:setString(i18n("common_text_3780") .. i18n("common_text_155", cc.c3b(200, 170, 150)))
	end
	for i, v in ipairs(self.tbInUse) do
		v:setVisible(false)
	end
	local itemWidth = 100
	for i, v in ipairs(data.Reward) do
		if 4 < i then
			break
		end
		local item = self.tbInUse[i]
		if not item then
			item = SoraDCreatePanel("commonItemAward")
			item:setScale(0.9)
			item:setPosition(SoraDFSign(-itemWidth * (i - 1)), 0)
			item:setOwnView(self.view)
			item:addTo(self.Node_items)
			self.tbInUse[i] = item
		end
		item:setVisible(true)
		item:initData(v.id, v.count)
	end
	local taskstatus = honorBackCtrl:getTaskState(data.taskID)
	if taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
		self.btn_operate:setVisible(true)
		self.Image_received:setVisible(false)
		SoraChangeButtonImage(self.btn_operate, "btn_green_normal_01.png")
		self.btn_operate:setTitleText(i18n("common_text_1146"))
	elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE then
		self.btn_operate:setVisible(false)
		self.Image_received:setVisible(true)
	elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_DOING then
		SoraChangeButtonImage(self.btn_operate, "btn_blue_normal_01.png")
		self.btn_operate:setTitleText(i18n("common_text_477"))
		self.Image_received:setVisible(false)
		local taskType = data.Type
		if taskType then
			if taskType == gCallbackConditionType.CALL_BACK_NUM or taskType == gCallbackConditionType.LOGIN_DAY or taskType == gCallbackConditionType.USE_GOLD or taskType == gCallbackConditionType.USE_SPEED_UP or taskType == gCallbackConditionType.USE_HERO_BOX then
				self.btn_operate:setVisible(false)
			else
				self.btn_operate:setVisible(true)
			end
		else
			self.btn_operate:setVisible(false)
		end
	end
end
function honorBackTaskItem:btnOperateClick(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		local taskstatus = honorBackCtrl:getTaskState(self.taskData.taskID)
		local taskID = self.taskData.taskID
		if taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE then
			SoraDShowLoading(sender)
			_ENV = nil
			;(nil).taskID = taskID
			honorBackCtrl:reqCommitTask(nil)
		elseif taskstatus == gFriendCallbackTaskStatus.TASK_STATUS_DOING and self.taskData.Type then
			local qData = friendsCallbackRead.getTaskCondition(self.taskData.Type)
			if qData.questType then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				local qtype = qData.questType
				mildGuideManager:starMildByNewPlayerQuestID(qtype, qData)
				SoraDShowMsgTip(i18n(self.taskData.name))
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return honorBackTaskItem

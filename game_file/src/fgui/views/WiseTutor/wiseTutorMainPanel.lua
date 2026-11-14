local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local wiseTutorRead = include("wiseTutorRead")
local publicUtil = include("publicUtil")
local eventQuestRead = include("eventQuestRead")
local basePanel = require("fgui.base.baseFguiPanel")
local wiseTutorMainPanel = class("wiseTutorMainPanel", basePanel)
function wiseTutorMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function wiseTutorMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "fonts"
	end
	return self._packageList
end
function wiseTutorMainPanel:onInit()
	self.view:fixChildrenPos()
	self.fields.Com_title:initData(i18n("activity_name_9001368"), handler(self, self.onClickClose))
	self.tag = 1
	self.fields.Scroll_Task:setItemRenderer(handler(self, self.onTaskItemRederer))
	self.fields.Scroll_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.Scroll_Award:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onAwardScrolling))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Button_People:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_Active:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_Active:setTitleText(i18n("Battle_Towers_03"))
	self.fields.Button_GetAward:addClickListener(handler(self, self.onClickGetAllAward))
	self.fields.Button_GetAward:setTitleText(i18n("summoned_btn_01"))
	self.fields.Button_AllAward:addClickListener(handler(self, self.onClickAwardPreview))
	self.fields.Button_AllAward:setTitleText(i18n("Battle_Towers_17"))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_normal:setString(i18n("Battle_Towers_05"))
	self.fields.Text_high:setString(i18n("Battle_Towers_06"))
	self.fields.Usm_Unlock:setVisible(false)
	self.fields.Text_Active = SoraDCreateTimerLabel(self, self.fields.Text_Active)
	self.fields.Text_Active:setTimeLast(function(time)
		return i18n("Battle_Towers_04") .. "\n" .. time
	end)
	self.fields.Button_OpenB:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_OpenS:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_OpenS:setString(i18n("Battle_Towers_03"))
	self.fields.Labe_Time:setTimeEndListener(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end)
	_ENV = self.fields.Labe_Time.setTimeEndListener
	_ENV, _ENV, self.fields.Labe_Time.setTimeEndListener.defaultClick = function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end, self.tag, self.tag
	;(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end).title = i18n("Battle_Towers_01")
	_ENV, self.tag[1], (function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end).tag = function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end, function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end, 1
	;(function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end).title = i18n("Battle_Towers_02")
	self.fields.Labe_Time.setTimeEndListener.tabsetArray, self.tag[2], (function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end).tag = self.tag, function()
		if self then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end, 2
	local self.fields.Labe_Time.setTimeEndListener.callback, param = handler(self, self.onClickTab), self.fields.Labe_Time.setTimeEndListener
	self.fields.Com_Tab:initView(param)
end
function wiseTutorMainPanel:onShow()
	wiseTutorCtrl:resetGiftData()
	self:updatTaskScroll()
	self:updateReward()
	self:onUpdateLvInfo()
	self:updatRed()
	self:updateUnLockEffect()
	self:updateTips()
	self:updateNum()
	wiseTutorCtrl:sendReqInitDataMsg()
end
function wiseTutorMainPanel:updateNum()
	local itemInfo = wiseTutorRead.getUnlockItem(wiseTutorCtrl:getLevelIndex())
	local member = publicUtil.getCount(itemInfo[1])
	local total = itemInfo[2]
	self.fields.Button_OpenB:initData(member, total)
	wiseTutorRead = wiseTutorCtrl:getLevelIndex()
	wiseTutorCtrl:getLevelIndex().member = member
	wiseTutorRead, wiseTutorRead, wiseTutorCtrl:getLevelIndex().total = wiseTutorCtrl:getLevelIndex()
	wiseTutorRead, wiseTutorCtrl:getLevelIndex().member, wiseTutorCtrl:getLevelIndex().color = wiseTutorCtrl:getLevelIndex()
	wiseTutorCtrl:getLevelIndex().__default, wiseTutorCtrl:getLevelIndex().color = wiseTutorCtrl:getLevelIndex()
	self.fields.text_Num:setString(i18n_html("common_text_155", wiseTutorCtrl:getLevelIndex()))
	self.fields.ProgressBarNum:setValue(publicUtil.getCount(itemInfo[1]))
	self.fields.ProgressBarNum:setMax(itemInfo[2])
	self.fields.Button_OpenS:setReddot(member >= total)
end
function wiseTutorMainPanel:updateTips()
	local str = self:getTipsStr()
	self.fields.text_Tips:setString(str)
	_ENV = self.fields.text_Tips.setString
	self.fields.text_Tips.setString.fontName = ""
	self.fields.text_Tips.setString.fontSize = 20
	self.fields.text_Tips.setString.fontAlignmentH = cc.TEXT_ALIGNMENT_LEFT
	self.fields.text_Tips.setString.fontAlignmentV = cc.VERTICAL_TEXT_ALIGNMENT_TOP
	self.fields.text_Tips.setString.fontDimensions = cc.size(284, 0)
	local self.fields.text_Tips.setString.isHtml, txtContentInfo = false, self.fields.text_Tips.setString
	local measureSize = cc.Device:measureText(str, txtContentInfo)
	self.fields.text_Tips:setHeight(measureSize.height)
end
function wiseTutorMainPanel:updateReward()
	self.lvRewardList = wiseTutorRead.getLvRewardList(wiseTutorCtrl:getLevelIndex())
	self.controllers.c2:setSelectedIndex(wiseTutorCtrl:isUnLock() and 0 or 1)
	self.fields.Scroll_Award:setNumItems(#self.lvRewardList)
	self.fields.Scroll_Award:getScrollPane():setPercY(self:getScrollPercentY())
	self:onAwardScrolling()
end
function wiseTutorMainPanel:updatTaskScroll()
	self.taskList = wiseTutorCtrl:getTaskList()
	self.fields.Scroll_Task:setNumItems(#self.taskList)
end
function wiseTutorMainPanel:initActivityTime()
	self.fields.Labe_Time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4415", nil, nil)
	end)
	local state, leftTime = wiseTutorCtrl:getStateInfo()
	if state == gActivityState.OPEN then
		if 0 < leftTime then
			self.fields.Labe_Time:beginTime(leftTime)
			self.fields.Text_Active:beginTime(leftTime)
		else
			_ENV = self.fields.Text_Active
			self.fields.Text_Active.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
			SoraDSendMessage(self.fields.Text_Active)
		end
	else
		_ENV = self.fields.Text_Active
		self.fields.Text_Active.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage(self.fields.Text_Active)
	end
end
function wiseTutorMainPanel:onUpdateLvInfo()
	self.nowLv = wiseTutorCtrl:getLevel()
	self.fields.ProgressBar_Level:initData(wiseTutorCtrl:getExp(), self.nowLv)
	self.fields.ProgressBar_Level:setPositionX(320 - self.fields.ProgressBar_Level:getContentSize().width / 2)
	if wiseTutorCtrl:getLvRewardStatusAndNum() > 0 then
		self.fields.Button_GetAward:setTouchable(true)
		self.fields.Button_GetAward:setBright(true)
	else
		self.fields.Button_GetAward:setTouchable(false)
		self.fields.Button_GetAward:setBright(false)
	end
end
function wiseTutorMainPanel:updatRed()
	local rewardRedNum = wiseTutorCtrl:getLvRewardStatusAndNum()
	local taskRedNum = wiseTutorCtrl:getTaskStatusAndNum()
	local isCanLock = wiseTutorCtrl:getLockStatusAndNum()
	rewardRedNum = rewardRedNum + (isCanLock and 1 or 0)
	self.fields.Com_Tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_Tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
	self.fields.Button_Active:setReddot(isCanLock)
end
function wiseTutorMainPanel:updateUnLockEffect(playAnimation)
	if playAnimation then
		uiManager:show("wiseTutorunlock")
		self.fields.n58:setVisible(false)
	else
		self.fields.n58:setVisible(not wiseTutorCtrl:isUnLock())
	end
end
function wiseTutorMainPanel:onTaskItemRederer(index, obj)
	local taskID = self.taskList[index + 1]
	wiseTutorCtrl = nil
	;(nil).taskID = taskID
	;(nil).progress = wiseTutorCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = wiseTutorCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	obj:initData(nil)
	obj:setHandler(handler(self, self.onClickGetTaskAward))
end
function wiseTutorMainPanel:onAwardItemRederer(index, obj)
	local index = self.lvRewardList[index + 1]
	obj:initData(index)
end
function wiseTutorMainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initActivityTime()
end
function wiseTutorMainPanel:onClickGetTaskAward(taskID)
	print(taskID, "taskID")
	SoraDPlaySound()
	SoraDShowLoading()
	wiseTutorCtrl:reqPalaceOfWisdomTask(taskID)
end
function wiseTutorMainPanel:onClickGetAllAward()
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	SoraDShowLoading()
	wiseTutorCtrl:reqPalaceOfWisdomReward()
end
function wiseTutorMainPanel:onClickAwardPreview()
	SoraDPlaySound()
	uiManager:show("wiseTutorAwardPreview")
end
function wiseTutorMainPanel:onClickActive()
	SoraDPlaySound()
	uiManager:show("wiseTutorBlessLight")
end
function wiseTutorMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Battle_Towers_19")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function wiseTutorMainPanel:onAwardScrolling(data)
	self.fields.Next_Reward:initData(self:getMaxShowIndex())
end
function wiseTutorMainPanel:getScrollPercentY()
	local maxLv = wiseTutorRead.getMaxExpLv(wiseTutorCtrl:getLevelIndex())
	local nowLv = wiseTutorCtrl:getLevel()
	local sSize = self.fields.Scroll_Award:getContentSize()
	local scrollToIdx = math.min(maxLv, math.max(1, nowLv))
	local scrollHeight = -sSize.height + self.fields.Scroll_Award:getInnerContainerSize().height
	local scrollPercent = (100 * (scrollToIdx - 1) - sSize.height / 2 + 50) / scrollHeight
	if 1 < scrollPercent then
		scrollPercent = 1
	end
	return scrollPercent
end
function wiseTutorMainPanel:getMaxShowIndex()
	local singleHeight = 100
	local contentHeight = self.fields.Scroll_Award:getContentSize().height
	local posY = self.fields.Scroll_Award:getScrollPane():getPosY()
	local index = math.ceil((posY + contentHeight) / singleHeight)
	local data
	print(tolua.type(data), posY, contentHeight, index, math.ceil(index / 5) * 5)
	return math.min(wiseTutorRead.getMaxExpLv(wiseTutorCtrl:getLevelIndex()), math.ceil(index / 5) * 5)
end
function wiseTutorMainPanel:getTipsStr()
	if wiseTutorCtrl:isMaxLevel() then
		return i18n("Battle_Towers_36")
	elseif not wiseTutorCtrl:isUnLock() then
		return i18n("Battle_Towers_34")
	elseif wiseTutorCtrl:isBuffEffect() then
		return i18n("Battle_Towers_35")
	end
end
function wiseTutorMainPanel:onHide()
	wiseTutorCtrl:resetGiftData()
end
return wiseTutorMainPanel

local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArtisanHouseMainPanel = class("ArtisanHouseMainPanel", baseFguiPanel)
function ArtisanHouseMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ArtisanHouseMainPanel:ctor", self.viewName)
end
function ArtisanHouseMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
		self._packageList, self._packageList[4] = self._packageList, "fonts"
		self._packageList, self._packageList[5] = self._packageList, "WiseTutor"
	end
	return self._packageList
end
function ArtisanHouseMainPanel:onInit()
	print("=======ArtisanHouseMainPanel:onInit")
	self.functionCol = self:initFunc()
	self.tag = 1
	_UPVALUE6_ = self
	self[1] = "Text_high"
	self[2] = "Text_normal"
	self[3] = "Text_lv"
	self[4] = "Button_GetAward"
	self[5] = "Button_help"
	self[6] = "Button_AllAward"
	for i, v in ipairs(self) do
		self.fields[v]:fixPos()
	end
	_UPVALUE5_ = ipairs(self)
	ipairs(self)[1] = "n1"
	ipairs(self)[2] = "n2"
	ipairs(self)[3] = "n3"
	ipairs(self)[4] = "n4"
	ipairs(self)[5] = "n5"
	for i, v in ipairs(ipairs(self)) do
		self.fields[v]:fix(false)
	end
	self.fields.Com_title:initData(i18n("activity_name_9001399"), handler(self, self.onClickClose))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_normal:setString(i18n("Artisan_House_04"))
	self.fields.Text_high:setString(i18n("Artisan_House_05"))
	if self.fields.Text_high:getWidth() > 180 then
		self.fields.Text_high:setFontSize(16)
	end
	self.fields.Scroll_Task:setItemRenderer(handler(self, self.onTaskItemRederer))
	self.fields.Scroll_Award:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onAwardScrolling))
	self.fields.Text_Active = SoraDCreateTimerLabel(self, self.fields.Text_Active)
	self.fields.Text_Active:setTimeLast(function(time)
		return i18n("Battle_Towers_04") .. "\n" .. time
	end)
	self.fields.touch:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_Active:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_Active:setTitleText(i18n("Artisan_House_03"))
	self.fields.Button_GetAward:addClickListener(handler(self, self.onClickGetAllAward))
	self.fields.Button_GetAward:setTitleText(i18n("summoned_btn_01"))
	self.fields.Button_AllAward:addClickListener(handler(self, self.onClickAwardPreview))
	self.fields.Button_AllAward:setTitleText(i18n("Battle_Towers_17"))
	_ENV = self.fields.Button_AllAward.setTitleText
	_ENV, _ENV, self.fields.Button_AllAward.setTitleText.defaultClick = i18n("Battle_Towers_17")
	i18n("Battle_Towers_17").title = i18n("Artisan_House_01")
	_ENV, self.tag[1], i18n("Battle_Towers_17").tag = i18n("Battle_Towers_17")
	i18n("Battle_Towers_17").title = i18n("Artisan_House_02")
	self.fields.Button_AllAward.setTitleText.tabsetArray, self.tag[2], i18n("Battle_Towers_17").tag = self.tag, i18n("Battle_Towers_17")
	local self.fields.Button_AllAward.setTitleText.callback, param = handler(self, self.onClickTab), self.fields.Button_AllAward.setTitleText
	self.fields.Com_Tab:initView(param)
	if artisanHouseCtrl:isDataInit() then
		self:initData()
	end
end
function ArtisanHouseMainPanel:initData()
	self:updateActive()
	self:updateGetButton()
	self:updateReward()
	self:updateRed()
	self:updatTaskScroll()
end
function ArtisanHouseMainPanel:updateReward()
	self.controllers.c2:setSelectedIndex(artisanHouseCtrl:isUnLock() and 0 or 1)
	self.fields.Scroll_Award:initData()
	self:setScrollPercentY()
	self:onAwardScrolling()
end
function ArtisanHouseMainPanel:setScrollPercentY()
	local maxLv = artisanHouseltCtrl.getMaxExpLv(artisanHouseCtrl:getLevelIndex())
	local nowLv = artisanHouseCtrl:getLevel()
	local nowLv = artisanHouseCtrl:getLevel()
	if maxLv <= nowLv then
		nowLv = maxLv - 1
	end
	local pane = self.fields.Scroll_Award:getScrollPane()
	local list = self.fields.Scroll_Award:getChildAt(1)
	local offset = list:getChildAt(nowLv):getPositionY()
	self.fields.Scroll_Award:getScrollPane():setPosY(offset)
	self.fields.Scroll_Award:getScrollPane():updatePositionImmediately()
end
function ArtisanHouseMainPanel:updatTaskScroll()
	self.taskList = artisanHouseCtrl:getTaskList()
	dump(self.taskList, "ArtisanHouseMainPanel:updatTaskScroll")
	self.fields.Scroll_Task:setNumItems(#self.taskList)
end
function ArtisanHouseMainPanel:onTaskItemRederer(index, obj)
	local taskID = self.taskList[index + 1]
	artisanHouseCtrl = nil
	;(nil).taskID = taskID
	;(nil).progress = artisanHouseCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = artisanHouseCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	obj:initData(nil)
	obj:setHandler(handler(self, self.onClickGetTaskAward))
end
function ArtisanHouseMainPanel:updateGetButton()
	self.nowLv = artisanHouseCtrl:getLevel()
	local maxValue = artisanHouseltCtrl.getNextExp(artisanHouseCtrl:getLevel(), artisanHouseCtrl:getLevelIndex())
	self.fields.ProgressBar_Level:setValue(artisanHouseCtrl:getExp(), maxValue)
	artisanHouseCtrl = artisanHouseCtrl:getLevelIndex()
	artisanHouseCtrl:getLevelIndex().lv = self.nowLv
	self.fields.ProgressBar_Level:setTitle(i18n("common_text_101", artisanHouseCtrl:getLevelIndex()))
	local maxLv = artisanHouseltCtrl.getMaxExpLv(artisanHouseCtrl:getLevelIndex())
	if self.nowLv == maxLv and artisanHouseCtrl:getExp() == maxValue then
		self.fields.ProgressBar_Level:setMax()
	end
	if artisanHouseCtrl:getLvRewardStatusAndNum() > 0 then
		self.fields.Button_GetAward:setTouchable(true)
		self.fields.Button_GetAward:setBright(true)
	else
		self.fields.Button_GetAward:setTouchable(false)
		self.fields.Button_GetAward:setBright(false)
	end
end
function ArtisanHouseMainPanel:updateActive()
	self.controllers.c2:setSelectedIndex(artisanHouseCtrl:isUnLock() and 0 or 1)
end
function ArtisanHouseMainPanel:updateRed()
	local rewardRedNum = artisanHouseCtrl:getLvRewardStatusAndNum()
	local taskRedNum = artisanHouseCtrl:getTaskStatusAndNum()
	local isCanLock = artisanHouseCtrl:getLockStatusAndNum()
	rewardRedNum = rewardRedNum + (isCanLock and 1 or 0)
	self.fields.Com_Tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_Tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
	self.fields.Button_Active:setReddot(isCanLock)
end
function ArtisanHouseMainPanel:updateTask()
	self:updatTaskScroll()
end
function ArtisanHouseMainPanel:initFunc()
	_ENV = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).reward = function()
		self:initData()
		local param = self.param
		param.normalTitle = "Artisan_House_07"
		param.specialTitle = "Artisan_House_08"
		uiManager:show("wiseTutorGainAward", param):setOwnerKey(self)
	end
	;(nil).upgradeLv = function()
		self:initData()
	end
	;(nil).upgradeLock = function()
		uiManager:show("ArtisanHouseUnlock"):setOwnerKey(self)
		self:updateReward()
		self:updateGetButton()
		self:updateRed()
	end
	;(nil).unlock = function()
		uiManager:show("ArtisanHouseUnlock"):setOwnerKey(self)
		self:updateReward()
		self:updateGetButton()
		self:updateRed()
	end
	;(nil).noReward = function()
		SoraDShowMsgTip(i18n("alliance_stronghold_text_008"))
	end
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	;(nil).alreadyUnlock = function()
		SoraDShowMsgTip(i18n("Artisan_House_15"))
	end
	local (nil).taskReturn, functionCol = function()
		SoraDCloseLoading(self:displayObject())
	end, nil
	return functionCol
end
function ArtisanHouseMainPanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "ArtisanHouseMainPanel:refreshView")
	self.param = data.param
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function ArtisanHouseMainPanel:onAwardScrolling()
	self.fields.Next_Reward:initData(self:getMaxShowIndex())
end
function ArtisanHouseMainPanel:getMaxShowIndex()
	local singleHeight = 95
	local contentHeight = self.fields.Scroll_Award:getContentSize().height
	local posY = self.fields.Scroll_Award:getScrollPane():getPosY()
	local index = math.ceil((posY + contentHeight) / singleHeight)
	return math.min(artisanHouseltCtrl.getMaxExpLv(artisanHouseCtrl:getLevelIndex()), math.ceil(index / 5) * 5)
end
function ArtisanHouseMainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initActivityTime()
end
function ArtisanHouseMainPanel:onClickGetAllAward()
	SoraDPlaySound()
	artisanHouseCtrl:reqPalaceOfCraftsmanReward()
end
function ArtisanHouseMainPanel:onClickAwardPreview()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.title, param = i18n("Battle_Towers_17"), SoraDPlaySound
	uiManager:show("ArtisanHouseAwardPreview", param):setOwnerKey(self)
end
function ArtisanHouseMainPanel:onClickGetTaskAward(taskID)
	print(taskID, "taskID")
	SoraDPlaySound()
	SoraDShowLoading(self:displayObject())
	artisanHouseCtrl:reqPalaceOfCraftsmanTask(taskID)
end
function ArtisanHouseMainPanel:initActivityTime()
	self.fields.Label_Time:setUbbOn()
	self.fields.Label_Time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY)
	if eventTime then
		self.fields.Label_Time:beginTime(eventTime.timerNode.timer:getRemainTime())
		self.fields.Text_Active:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function ArtisanHouseMainPanel:onClickActive()
	SoraDPlaySound()
	uiManager:show("ArtisanHouseBlessLight"):setOwnerKey(self)
end
function ArtisanHouseMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("activity_name_9001399")
	;(nil).content = i18n("Artisan_House_10")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ArtisanHouseMainPanel:onShow()
	print("=======ArtisanHouseMainPanel:onShow")
end
function ArtisanHouseMainPanel:onHide()
	print("=======ArtisanHouseMainPanel:onHide")
end
function ArtisanHouseMainPanel:onDispose()
	print("=======ArtisanHouseMainPanel:onDispose")
end
return ArtisanHouseMainPanel

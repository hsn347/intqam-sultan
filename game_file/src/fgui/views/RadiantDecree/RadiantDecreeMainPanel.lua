local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeMainPanel = class("RadiantDecreeMainPanel", baseFguiPanel)
function RadiantDecreeMainPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantDecreeMainPanel:ctor", self.viewName)
end
function RadiantDecreeMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE5_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "Activity2112"
		self._packageList, self._packageList[3] = self._packageList, "fonts"
		self._packageList, self._packageList[4] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[5] = self._packageList, "ThemTake"
	end
	return self._packageList
end
function RadiantDecreeMainPanel:onInit()
	print("=======RadiantDecreeMainPanel:onInit")
	radiantDecreeCtrl:sendReqInitDataMsg()
	self.activityID = gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY
	self.functionCol = self:initFunc()
	self.tag = 1
	if display.height > 1300 then
		self.controllers.c3:setSelectedIndex(1)
	end
	self:fixChildrenPos()
	_UPVALUE10_ = self
	self[1] = "Text_high"
	self[2] = "Text_normal"
	self[3] = "Text_lv"
	self[4] = "Button_GetAward"
	self[5] = "Button_AllAward"
	self[6] = "Button_view"
	self[7] = "n1"
	self[8] = "n2"
	self[9] = "n8"
	self[10] = "n7"
	for i, v in ipairs(self) do
		self.fields[v]:fixPos()
	end
	_UPVALUE4_ = ipairs(self)
	ipairs(self)[1] = "Button_levelLock"
	ipairs(self)[2] = "mask"
	ipairs(self)[3] = "n5"
	ipairs(self)[4] = "n6"
	for i, v in ipairs(ipairs(self)) do
		self.fields[v]:fixPos()
	end
	_UPVALUE2_ = ipairs(ipairs(self))
	ipairs(ipairs(self))[1] = "bg"
	ipairs(ipairs(self))[2] = "n192"
	for i, v in ipairs(ipairs(ipairs(self))) do
		self.fields[v]:fix(false)
	end
	self.fields.Com_title:initData(i18n("activity_name_9001442"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_normal:setString(i18n("GloriousDecree_04"))
	self.fields.Text_high:setString(i18n("GloriousDecree_20"))
	if self.fields.Text_high:getWidth() > 180 then
		self.fields.Text_high:setFontSize(16)
	end
	self.fields.Scroll_Task:setVirtual()
	self.fields.Scroll_Task:setItemRenderer(handler(self, self.onTaskItemRederer))
	self.fields.Scroll_Award:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onAwardScrolling))
	self.fields.Text_Active = SoraDCreateTimerLabel(self, self.fields.Text_Active)
	self.fields.Text_Active:setTimeLast(function(time)
		return i18n("common_text_2943") .. "\n" .. time
	end)
	self.fields.Button_Active:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_GetAward:addClickListener(handler(self, self.onClickGetAllAward))
	self.fields.Button_GetAward:setTitleText(i18n("summoned_btn_01"))
	self.fields.Button_AllAward:addClickListener(handler(self, self.onClickAwardPreview))
	self.fields.Button_AllAward:setTitleText(i18n("Battle_Towers_17"))
	self.fields.Button_levelLock:addClickListener(handler(self, self.onClickActive))
	self.fields.Button_view:setTitleText(i18n("GloriousDecree_32"))
	self.fields.Button_view:addClickListener(handler(self, self.onClickShowBuff))
	_ENV = self.fields.Button_view.addClickListener
	_ENV, _ENV, self.fields.Button_view.addClickListener.defaultClick = handler(self, self.onClickShowBuff)
	handler(self, self.onClickShowBuff).title = i18n("GloriousDecree_01")
	_ENV, self.tag[1], handler(self, self.onClickShowBuff).tag = handler(self, self.onClickShowBuff)
	handler(self, self.onClickShowBuff).title = i18n("GloriousDecree_02")
	self.fields.Button_view.addClickListener.tabsetArray, self.tag[2], handler(self, self.onClickShowBuff).tag = self.tag, handler(self, self.onClickShowBuff)
	local self.fields.Button_view.addClickListener.callback, param = handler(self, self.onClickTab), self.fields.Button_view.addClickListener
	self.fields.Com_Tab:initView(param)
	if radiantDecreeCtrl:isDataInit() then
		self:initData()
	end
end
function RadiantDecreeMainPanel:onClickShowBuff()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.title, param = i18n("Battle_Towers_23"), SoraDPlaySound
	uiManager:show("RadiantDecreeBuffPreview", param):setOwnerKey(self)
end
function RadiantDecreeMainPanel:initData()
	self:updateActive()
	self:updateGetButton()
	self:updateReward()
	self:updateRed()
end
function RadiantDecreeMainPanel:updateReward()
	self.fields.Scroll_Award:initData()
	self:setScrollPercentY()
	self:onAwardScrolling()
end
function RadiantDecreeMainPanel:setScrollPercentY()
	local maxLv = radiantDecreeRead.getMaxExpLv(radiantDecreeCtrl:getLevelIndex())
	local nowLv = radiantDecreeCtrl:getLevel()
	if maxLv <= nowLv then
		nowLv = maxLv - 1
	end
	local pane = self.fields.Scroll_Award:getScrollPane()
	local list = self.fields.Scroll_Award:getChildAt(0)
	if nowLv < list:getChildrenCount() then
		local offset = list:getChildAt(nowLv):getPositionY() - self.fields.Scroll_Award:getSize().height / 2 - 47.5
		pane:setPosY(offset)
	end
	pane:updatePositionImmediately()
end
function RadiantDecreeMainPanel:updatTaskScroll()
	self.taskList = radiantDecreeCtrl:getTaskList()
	self.fields.Scroll_Task:setNumItems(#self.taskList)
end
function RadiantDecreeMainPanel:onTaskItemRederer(index, obj)
	local taskID = self.taskList[index + 1]
	radiantDecreeCtrl = nil
	;(nil).taskID = taskID
	;(nil).progress = radiantDecreeCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = radiantDecreeCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	obj:initData(nil)
	obj:setHandler(handler(self, self.onClickGetTaskAward))
end
function RadiantDecreeMainPanel:updateGetButton()
	self.nowLv = radiantDecreeCtrl:getLevel()
	self.fields.ProgressBar_Level:setValue()
	radiantDecreeCtrl = nil
	;(nil).lv = self.nowLv
	self.fields.ProgressBar_Level:setTitle(i18n("common_text_101", nil))
	if radiantDecreeCtrl:getLvRewardStatusAndNum() > 0 then
		self.fields.Button_GetAward:setTouchable(true)
		self.fields.Button_GetAward:setBright(true)
	else
		self.fields.Button_GetAward:setTouchable(false)
		self.fields.Button_GetAward:setBright(false)
	end
end
function RadiantDecreeMainPanel:updateActive()
	local showNum = radiantDecreeCtrl:getShowNum()
	_UPVALUE3_ = radiantDecreeCtrl
	radiantDecreeCtrl[1] = "GloriousDecree_20"
	radiantDecreeCtrl[2] = "GloriousDecree_21"
	local radiantDecreeCtrl[3], config = "GloriousDecree_03", radiantDecreeCtrl
	self.fields.Button_Active:setTitleText(i18n(config[showNum]))
	self.controllers.c2:setSelectedIndex(showNum)
end
function RadiantDecreeMainPanel:updateRed()
	local rewardRedNum = radiantDecreeCtrl:getLvRewardStatusAndNum()
	local taskRedNum = radiantDecreeCtrl:getTaskStatusAndNum()
	local isCanLock = radiantDecreeCtrl:getLockStatusAndNum()
	rewardRedNum = rewardRedNum + (isCanLock and 1 or 0)
	self.fields.Com_Tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_Tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
	self.fields.Button_Active:setReddot(isCanLock)
end
function RadiantDecreeMainPanel:updateTask()
	self:updatTaskScroll()
end
function RadiantDecreeMainPanel:initFunc()
	_ENV = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).reward = function()
		self:initData()
		local param = self.param
		param.normalTitle = "GloriousDecree_07"
		param.specialTitle = "GloriousDecree_08"
		uiManager:show("wiseTutorGainAward", param):setOwnerKey(self)
	end
	;(nil).upgradeLv = function()
		self:initData()
	end
	;(nil).upgradeLock = function()
		_ENV = nil
		;(nil).isStatue = false
		uiManager:show("RadiantDecreeUnlock", nil):setOwnerKey(self)
	end
	;(nil).unlockStatue = function()
		_ENV = nil
		;(nil).isStatue = true
		uiManager:show("RadiantDecreeUnlock", nil):setOwnerKey(self)
	end
	;(nil).unlock = function()
		uiManager:show("RadiantDecreeUnlock"):setOwnerKey(self)
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
	;(nil).unlockRefresh = function()
		self:unlockSuccess()
	end
	local (nil).taskReturn, functionCol = function()
		SoraDCloseLoading(self:displayObject())
	end, nil
	return functionCol
end
function RadiantDecreeMainPanel:unlockSuccess()
	if radiantDecreeCtrl:isUnLock() and not radiantDecreeCtrl:isUnLockStatue() then
		self.fields.Button_levelLock:setCallback(function()
			self:initData()
			self.fields.Button_levelLock:setVisible(false)
		end)
		_ENV = self.fields.Button_levelLock
		self.fields.Button_levelLock[1] = ffa.delay(0.5)
		self.fields.Button_levelLock[2] = ffa.callFunc(function()
			self.fields.Button_levelLock:getTransition("t0"):play()
		end)
		self.fields.Button_levelLock[3] = ffa.callFunc(function()
			self.fields.Button_levelLock:getTransition("t0"):play()
		end)
		local seq = ffa.seq(self.fields.Button_levelLock)
		self:runAction(seq)
	else
		self:initData()
	end
end
function RadiantDecreeMainPanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "RadiantDecreeMainPanel:refreshView")
	self.param = data.param
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function RadiantDecreeMainPanel:onAwardScrolling()
	self.fields.Next_Reward:initData(radiantDecreeRead.getMaxExpLvIndex(self:getMaxShowIndex(), radiantDecreeCtrl:getLevelIndex()))
end
function RadiantDecreeMainPanel:getMaxShowIndex()
	local singleHeight = 95
	local contentHeight = self.fields.Scroll_Award:getContentSize().height
	local posY = self.fields.Scroll_Award:getScrollPane():getPosY()
	local index = math.ceil((posY + contentHeight) / singleHeight)
	return math.min(radiantDecreeRead.getMaxExpLv(radiantDecreeCtrl:getLevelIndex()), math.ceil(index / 5) * 5)
end
function RadiantDecreeMainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 2 then
		self:updateTask()
	end
	self:initActivityTime()
end
function RadiantDecreeMainPanel:onClickGetAllAward()
	SoraDPlaySound()
	radiantDecreeCtrl:reqRadiantDecreeReward()
end
function RadiantDecreeMainPanel:onClickAwardPreview()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.title, param = i18n("Battle_Towers_17"), SoraDPlaySound
	uiManager:show("RadiantDecreeAwardPreview", param):setOwnerKey(self)
end
function RadiantDecreeMainPanel:onClickGetTaskAward(taskID)
	print(taskID, "taskID")
	SoraDPlaySound()
	SoraDShowLoading(self:displayObject())
	radiantDecreeCtrl:reqRadiantDecreeTask(taskID)
end
function RadiantDecreeMainPanel:initActivityTime()
	self.fields.Label_Time:setUbbOn()
	self.fields.Label_Time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Label_Time:beginTime(eventTime.timerNode.timer:getRemainTime())
		self.fields.Text_Active:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function RadiantDecreeMainPanel:onClickActive()
	SoraDPlaySound()
	uiManager:show("RadiantDecreeBlessLight"):setOwnerKey(self)
end
function RadiantDecreeMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("activity_name_9001442")
	;(nil).content = i18n("GloriousDecree_15")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RadiantDecreeMainPanel:onShow()
	print("=======RadiantDecreeMainPanel:onShow")
end
function RadiantDecreeMainPanel:onHide()
	print("=======RadiantDecreeMainPanel:onHide")
end
function RadiantDecreeMainPanel:onDispose()
	print("=======RadiantDecreeMainPanel:onDispose")
end
return RadiantDecreeMainPanel

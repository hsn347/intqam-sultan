local activityCommonDecreeRead = include("activityCommonDecreeRead")
local activityCommonDecreeCtrl = SoraDGetCtrl("activityCommonDecreeCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001732_MainPanel = class("Activity_9001732_MainPanel", baseFguiPanel)
function Activity_9001732_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001732_MainPanel.super.ctor(self, ...)
	print("Activity_9001732_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001732
	self.rewardConfig = activityCommonDecreeRead.getNormalRewardConfig(self.activityID)
end
function Activity_9001732_MainPanel:onInit()
	print("=======Activity_9001732_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.Button_lock1:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_lock1:addClickListener(handler(self, self.onClickBtnLock1))
	self.fields.Button_lock2:setTitle(i18n("Braque_text_07"))
	self.fields.Button_lock2:addClickListener(handler(self, self.onClickBtnLock2))
	self.fields.Button_get:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_get:addClickListener(handler(self, self.onClick_Button_get))
	self.fields.Text_tip:setString(i18n("decoration_battlepass_text_02"))
	local _fields = fguiHelper.get_fields(self.fields.Com_lv)
	_fields.Button_add:addClickListener(handler(self, self.onClickBtnTask))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	local _fields = fguiHelper.get_fields(self.fields.Com_rewardTitle)
	_fields.Text_level:setString(i18n("common_text_748"))
	_fields.Text_reward1:setString(i18n("warmongering_text_7"))
	_fields.Text_reward2:setString(i18n("StarlitNight_text_07"))
	_fields.Text_reward3:setString(i18n("Braque_text_05"))
	local _fields = fguiHelper.get_fields(self.fields.Com_giftbox)
	_fields.Image_box:addClickListener(handler(self, self.onClickBtnBox))
	_fields.Text_name:setString(i18n("Bubble_island_rebuild_text_07"))
	_fields.Text_des:setString(i18n("Bubble_island_rebuild_text_09"))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	_fields.bar:setValue(0)
	local expMax = activityCommonDecreeRead.getMaxExp(self.activityID)
	_fields.bar:setMax(expMax)
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskItemRenderer))
	self.fields.List_task:setVirtual()
	if not SoraDFIsRA() then
		self.fields.Com_rewardTitle:fixChildrenPos()
		self.fields.Com_giftbox:fixChildrenPos()
		self.fields.Com_lockMask1:fixPos()
		self.fields.Com_lockMask2:fixPos()
		self.fields.Button_lock1:fixPos()
		self.fields.Button_lock2:fixPos()
	end
end
function Activity_9001732_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("decoration_battlepass_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001732_MainPanel:endShow()
	print("=======Activity_9001732_MainPanel:endShow")
	self.unlock = activityCommonDecreeCtrl:getUnlockList(self.activityID)
	self.gotRewardLv = activityCommonDecreeCtrl:getRewardLvList(self.activityID)
	self.tag = 1
	_ENV = self.activityID
	_ENV, _ENV, self.activityID.defaultClick = nil, self.tag, self.tag
	_ENV, self.tag[1], (nil).title = nil, nil, i18n("activity_name_9001732")
	self.activityID.tabsetArray, self.tag[2], (nil).title = self.tag, nil, i18n("common_text_4498")
	self.activityID.callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(self.activityID)
	self:updateTabRedNum()
end
function Activity_9001732_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Com_title:setTimeShow(self.tag == 2)
	self:updateUI()
	self.fields.List_reward:jumpToTop()
	self.fields.List_task:jumpToTop()
end
function Activity_9001732_MainPanel:updateUI()
	if self.tag == 1 then
		self:updateLockMask()
		self:updateExp()
		self:updateBtnGet()
		self:updateRewardList()
		self:updateGiftBoxRedNum()
	else
		self:updateTaskList()
	end
end
function Activity_9001732_MainPanel:onTaskItemRenderer(index, obj)
	local data = self.taskData[index + 1]
	obj:initData(self.activityID, data)
end
function Activity_9001732_MainPanel:onRewardItemRenderer(index, obj)
	local level = index + 1
	local cfg = self.rewardConfig[level]
	obj:initData(level, cfg, self.unlock, self.gotRewardLv, self.curLv)
end
function Activity_9001732_MainPanel:onClickBtnLock1(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).rewardType = 2
	uiManager:show("CommonBuyGift", nil)
end
function Activity_9001732_MainPanel:onClickBtnLock2(context)
	SoraDPlaySound()
	if not activityCommonDecreeCtrl:getIsAdvanceRewardUnlock(self.activityID) then
		SoraDShowMsgTip(i18n("decoration_battlepass_text_03"))
		return
	end
	_ENV = i18n("decoration_battlepass_text_03")
	i18n("decoration_battlepass_text_03").activityID = self.activityID
	i18n("decoration_battlepass_text_03").rewardType = 3
	uiManager:show("CommonBuyGift", i18n("decoration_battlepass_text_03"))
end
function Activity_9001732_MainPanel:onClick_Button_get(context)
	SoraDPlaySound()
	if not self:checkBtnGetState() then
		SoraDShowMsgTip(i18n("eidalfitr_market_text_02"))
		return
	end
	activityCommonDecreeCtrl:reqStageReward(self.activityID)
end
function Activity_9001732_MainPanel:onClickBtnBox(...)
	SoraDPlaySound()
	local cfg = activityCommonDecreeRead.getSpecialRewardCfg(self.activityID)
	local rewards = cfg.normalReward
	local itemList = backpackltCtrl:getShowItems(rewards[1] and rewards[1].id) or rewards
	_ENV = nil
	;(nil).title = i18n("Bubble_island_rebuild_text_07")
	;(nil).rewards = itemList
	;(nil).tip = i18n("Bubble_island_rebuild_text_15")
	;(nil).tipAlign = cc.TEXT_ALIGNMENT_CENTER
	uiManager:show("CommonPopBox3", nil)
end
function Activity_9001732_MainPanel:onClickBtnTask()
	SoraDPlaySound()
	self.fields.Com_title:setTabIndex(2, true)
end
function Activity_9001732_MainPanel:checkBtnGetState(...)
	return activityCommonDecreeCtrl:getRewardLvRedNum(self.activityID)
end
function Activity_9001732_MainPanel:updateLockMask(...)
	if self.unlock[2] then
		self.fields.Com_lockMask1:setVisible(false)
		self.fields.Button_lock1:setVisible(false)
	end
	if self.unlock[3] then
		self.fields.Com_lockMask2:setVisible(false)
		self.fields.Button_lock2:setVisible(false)
	end
end
function Activity_9001732_MainPanel:updateExp(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_lv)
	local exp = activityCommonDecreeCtrl:getExp(self.activityID)
	local lv, _exp = activityCommonDecreeRead.getLvByExp(self.activityID, exp)
	self.curLv = lv
	_fields.Label_lv:setString(tostring(lv))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	_fields.bar:setValue(_exp)
	local expMax = activityCommonDecreeRead.getLvExpMax(self.activityID, lv + 1)
	_fields.bar:setMax(expMax)
	local _fields = fguiHelper.get_fields(self.fields.Com_giftbox)
	if self.curLv < activityCommonDecreeRead.getMaxLv(self.activityID) then
		_fields.Text_des:setString(i18n("Bubble_island_rebuild_text_09"))
		_fields.bar:setValue(0)
	else
		_fields.Text_des:setString(i18n("Bubble_island_rebuild_text_10"))
		_fields.bar:setValue(_exp)
	end
end
function Activity_9001732_MainPanel:updateBtnGet(...)
	if self:checkBtnGetState() then
		self.fields.Button_get:setGrayed(false)
	else
		self.fields.Button_get:setGrayed(true)
	end
end
function Activity_9001732_MainPanel:updateRewardList(...)
	self.fields.List_reward:setNumItems(#self.rewardConfig)
end
function Activity_9001732_MainPanel:updateGiftBoxRedNum(...)
	local rewardLv = math.max(#self.rewardConfig, self.gotRewardLv[1])
	local redNum = math.max(0, self.curLv - rewardLv)
	self.fields.Com_giftbox:setReddot(0 < redNum, redNum)
end
function Activity_9001732_MainPanel:updateTabRedNum(...)
	local isRed, redNum = activityCommonDecreeCtrl:getRewardLvRedNum(self.activityID)
	self.fields.Com_title:setBtnRedDot(1, isRed, redNum)
	local isRed, redNum = activityCommonDecreeCtrl:getTaskRedNum(self.activityID)
	self.fields.Com_title:setBtnRedDot(2, isRed, redNum)
end
function Activity_9001732_MainPanel:updateTaskList()
	self.taskData = activityCommonDecreeCtrl:getTaskList(self.activityID)
	self.fields.List_task:setNumItems(#self.taskData)
end
function Activity_9001732_MainPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "init" then
		self:updateUI()
	elseif subMsg == "stageReward" then
		self.gotRewardLv = activityCommonDecreeCtrl:getRewardLvList(self.activityID)
		self:updateBtnGet()
		self:updateRewardList()
		self:updateGiftBoxRedNum()
	elseif subMsg == "questReward" then
		self:updateTaskList()
	elseif subMsg == "buyGift" then
		self.unlock = activityCommonDecreeCtrl:getUnlockList(self.activityID)
		self:updateUI()
	end
	self:updateTabRedNum()
end
return Activity_9001732_MainPanel

local activity_9001710_Read = include("activity_9001710_Read")
local activity_9001710_Ctrl = SoraDGetCtrl("activity_9001710_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001710_MainPanel = class("Activity_9001710_MainPanel", baseFguiPanel)
function Activity_9001710_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001710_MainPanel.super.ctor(self, ...)
	print("Activity_9001710_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY
end
function Activity_9001710_MainPanel:onInit()
	print("=======Activity_9001710_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("activity_name_9001710"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_buff:setString(i18n("Battle_Towers_23"))
	self.fields.Button_buff:addClickListener(handler(self, self.onBuffClick))
	self.fields.Button_all:setString(i18n("Smelt_text_08"))
	self.fields.Button_all:addClickListener(handler(self, self.onAllRewardClick))
	self.fields.Button_claim:setString(i18n("summoned_btn_01"))
	self.fields.Button_claim:addClickListener(handler(self, self.onClaimAllClick))
	self.fields.Button_unlock:setString(i18n("CrescentDecree_text_08"))
	self.fields.Button_unlock:addClickListener(handler(self, self.onUnlockClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onRewardItemRender))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskItemRender))
	self.fields.Bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_normal:setString(i18n("cityUp_title_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self.fields.Text_lv:fixPos()
	self.fields.Text_normal:fixPos()
	self.fields.Text_adv:fixPos()
	self.fields.Text_expLv:fixPos()
	self.fields.Button_all:fixPos()
	self.fields.Button_claim:fixPos()
	self.fields.Button_unlock:fixPos()
	self.fields.shadow:fixPos()
end
function Activity_9001710_MainPanel:onRewardItemRender(index, obj)
	obj:initData(self.rewardData[index + 1])
end
function Activity_9001710_MainPanel:onTaskItemRender(index, obj)
	obj:initData(self.taskData[index + 1])
end
function Activity_9001710_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("CrescentDecree_text_02")
	uiManager:show("RuleView", nil)
end
function Activity_9001710_MainPanel:endShow()
	print("=======Activity_9001710_MainPanel:endShow")
	local dir1 = SoraDFIsRA() and 1 or 0
	local dir2 = SoraDFIsRA() and 1 or -1
	self.fields.line2:setWidth(self.fields.List:getHeight() + 44)
	self.fields.line2:setPosition(cc.p(self.fields.shadow:getPositionX() + self.fields.shadow:getWidth() * dir1, self.fields.shadow:getPositionY() - 42))
	self.fields.line1:setWidth(self.fields.List:getHeight() + 44)
	self.fields.line1:setPosition(cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()))
	self.tag = 1
	_ENV = cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY())
	_ENV, _ENV, cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).defaultClick = cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY())
	cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).title = i18n("activity_name_9001710")
	_ENV, self.tag[1], cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).tag = cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY())
	cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).title = i18n("CrescentDecree_text_03")
	cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).tabsetArray, self.tag[2], cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).tag = self.tag, cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY())
	cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()).callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(cc.p(self.fields.line2:getPositionX() + 200 * dir2, self.fields.line2:getPositionY()))
end
function Activity_9001710_MainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Com_title:setTimeShow(self.tag == 2)
	self:updateUI()
	self.fields.List:jumpToTop()
	self.fields.List_task:jumpToTop()
end
function Activity_9001710_MainPanel:updateUI()
	SoraDCloseLoading(self)
	if self.tag == 1 then
		local isUnlock = activity_9001710_Ctrl:isAdvUnlock()
		self.fields.Button_unlock:setVisible(not isUnlock)
		self.fields.shadow:setVisible(not isUnlock)
		local crescentNum = activity_9001710_Ctrl:getCrescentNum()
		self.fields.Button_claim:setEnabled(0 < crescentNum)
		self.fields.Button_claim:setReddot(0 < crescentNum)
		self:updateRewardList()
		self:updateProgress()
	else
		self:updateTaskList()
	end
	self:updateRed()
end
function Activity_9001710_MainPanel:updateRed()
	local crescentNum = activity_9001710_Ctrl:getCrescentNum()
	self.fields.Com_title:setBtnRedDot(1, 0 < crescentNum, 1)
	local questNum = activity_9001710_Ctrl:getQuestNum()
	self.fields.Com_title:setBtnRedDot(2, 0 < questNum, questNum)
end
function Activity_9001710_MainPanel:updateProgress()
	local lv, exp = activity_9001710_Ctrl:getLv()
	self.fields.Text_expLv:setString(lv)
	local maxExp = activity_9001710_Read.getRewardExpByLv(lv + 1)
	self.fields.Bar:setMax(maxExp)
	self.fields.Bar:setValue(exp)
	if lv >= activity_9001710_Read.getRewardMaxLv() then
		self.fields.Bar:setValue(maxExp)
		self.fields.Bar:setBarTitle(i18n("hero_text_41"))
	end
end
function Activity_9001710_MainPanel:updateRewardList()
	self.rewardData = activity_9001710_Read.getRewardCfg()
	self.fields.List:setNumItems(#self.rewardData)
end
function Activity_9001710_MainPanel:updateTaskList()
	self.taskData = activity_9001710_Ctrl:getTaskList()
	self.fields.List_task:setNumItems(#self.taskData)
end
function Activity_9001710_MainPanel:onBuffClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001710_Buff")
end
function Activity_9001710_MainPanel:onAllRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001710_Reward")
end
function Activity_9001710_MainPanel:onClaimAllClick()
	SoraDPlaySound()
	SoraDShowLoading(self)
	activity_9001710_Ctrl:reqGetReward()
end
function Activity_9001710_MainPanel:onUnlockClick()
	SoraDPlaySound()
	local quality, lv, starLv = SoraDGetBuildQuality()
	local cityltCtrl = include("cityltCtrl")
	local castleMaxStarLv = cityltCtrl.getMaxbuildStarLv(BUILDID.CASTLE)
	local braveStatueMaxStarLv = cityltCtrl.getMaxbuildStarLv(BUILDID.STAR_BRAVE_STATUE)
	if castleMaxStarLv <= SoraDGetBuildStarLv() and starLv >= braveStatueMaxStarLv then
		_ENV = nil
		;(nil).content = i18n("common_text_4951")
		;(nil).confirmFunc = function()
			uiManager:show("Activity_9001710_Gift")
		end
		;(nil).cancel = true
		uiManager:show("MessageBox", nil)
	else
		uiManager:show("Activity_9001710_Gift")
	end
end
return Activity_9001710_MainPanel

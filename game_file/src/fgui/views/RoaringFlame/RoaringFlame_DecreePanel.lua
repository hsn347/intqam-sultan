local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_DecreePanel = class("RoaringFlame_DecreePanel", baseFguiPanel)
function RoaringFlame_DecreePanel:ctor(...)
	RoaringFlame_DecreePanel.super.ctor(self, ...)
	print("RoaringFlame_DecreePanel:ctor", self.viewName)
end
function RoaringFlame_DecreePanel:onInit()
	print("=======RoaringFlame_DecreePanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.tag = 1
	self.lvList = roaringFlameWarRead.getDecreeLvList()
	self.buffList = roaringFlameWarRead.getBattlePassShow()
	self.taskList, _ENV, self.taskType = roaringFlameWarRead.getBattlePassShow(), roaringFlameWarRead.getBattlePassShow(), 1
	self.fields.Com_title:initData(i18n("flames_dunes_text14"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_reward:setString(i18n("flames_dunes_text17"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_add:setString(i18n("ice_carnival_text05"))
	self.fields.Button_add:setBtnColorIndex(gBtnColorDef.GREEN)
	self.fields.Button_add:addClickListener(handler(self, self.btnOneKeyClick))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_normal:setString(i18n("Braque_text_03"))
	self.fields.Text_adv:setString(i18n("Braque_text_05"))
	self.fields.Btn_unlock:setString(i18n("Braque_text_07"))
	self.fields.Btn_unlock:addClickListener(handler(self, self.btnUnlockClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffRenderer))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onTaskRenderer))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("digging_task_01", nil)
	end)
	self.fields.Button_reward:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_normal:fixPos()
	self.fields.Text_adv:fixPos()
	self.fields.Btn_unlock:fixPos()
	self.fields.nbg:fix()
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.sheer:fixPos()
end
function RoaringFlame_DecreePanel:onItemRenderer(index, obj)
	obj:initData(self.lvList[index + 1])
end
function RoaringFlame_DecreePanel:onBuffRenderer(index, obj)
	obj:initData(self.buffList[index + 1])
end
function RoaringFlame_DecreePanel:onTaskRenderer(index, obj)
	obj:initData(self.taskList[index + 1])
end
function RoaringFlame_DecreePanel:onShow()
	print("=======RoaringFlame_DecreePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("flames_dunes_text14")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("brightWar_text_202")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("summoned_text_28")
	;(nil).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
end
function RoaringFlame_DecreePanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
	self.fields.List_task:jumpToTop()
end
function RoaringFlame_DecreePanel:setTabRedPoint()
	local ret = roaringFlameWarCtrl:isHaveDecreeReward()
	self.fields.com_Tab:setBtnRedDot(1, ret)
	local retWeek, retWeekNum = roaringFlameWarCtrl:isHaveDecreeTaskReward(1)
	self.fields.com_Tab:setBtnRedDot(2, retWeek, retWeekNum)
	local retSeason, retSeasonNum = roaringFlameWarCtrl:isHaveDecreeTaskReward(2)
	self.fields.com_Tab:setBtnRedDot(3, retSeason, retSeasonNum)
end
function RoaringFlame_DecreePanel:initView()
	SoraDCloseLoading(self)
	if self.tag == 1 then
		local isActive = roaringFlameWarCtrl:isSeniorRewardLock()
		self.fields.Text_des:setString(isActive and i18n("flames_dunes_text16") or i18n("flames_dunes_text15"))
		self.fields.List_buff:setNumItems(#self.buffList)
		local lv, exp, nextExp = roaringFlameWarCtrl:getDecreeLvExp()
		self.fields.Com_bar:initData(lv, exp, nextExp)
		self.fields.List:setNumItems(#self.lvList)
		self.fields.Btn_unlock:setVisible(not isActive)
		self.fields.sheer:setVisible(not isActive)
		self.fields.Com_extra:initData(roaringFlameWarRead.getDecreeLvAddCfg(), true)
		local ret = roaringFlameWarCtrl:isHaveDecreeReward()
		self.fields.Button_add:setEnabled(ret)
		self.fields.Button_add:setReddot(ret)
	elseif self.tag == 2 then
		self.taskType = 1
		self.fields.Label_time:beginTime(serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime())
		self.taskList = self:sortTaskId(self.taskType)
		self.fields.List_task:setNumItems(#self.taskList)
	elseif self.tag == 3 then
		self.taskType = 2
		local finishTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.FINISH)
		self.fields.Label_time:beginTime(finishTime - serviceFunctions.systemTime())
		self.taskList = self:sortTaskId(self.taskType)
		self.fields.List_task:setNumItems(#self.taskList)
	end
	self:setTabRedPoint()
	local ret = roaringFlameWarCtrl:isHaveDecreeCampReward()
	self.fields.Button_reward:setReddot(ret)
end
function RoaringFlame_DecreePanel:sortTaskId(taskType)
	local roaringFlameWarRead, sortList
	local taskList = roaringFlameWarRead.getTaskList(taskType)
	local questData = taskType == 1 and roaringFlameWarCtrl:getWeeklyQuestData() or roaringFlameWarCtrl:getSeasonQuestData()
	for k, v in ipairs(taskList) do
		local isCalimed = questData.claimedQuest and questData.claimedQuest[tostring(v)]
		if isCalimed then
			roaringFlameWarRead = nil
			;(nil).taskID = v
			;(nil).status = 2
			;(nil).index = roaringFlameWarRead.getIndexByTaskID(v)
			table.insert(sortList, nil)
		else
			local isDone = questData.finishedQuest and questData.finishedQuest[tostring(v)]
			roaringFlameWarRead = roaringFlameWarRead.getIndexByTaskID(v)
			roaringFlameWarRead.getIndexByTaskID(v).taskID = v
			roaringFlameWarRead.getIndexByTaskID(v).status = isDone and 0 or 1
			roaringFlameWarRead.getIndexByTaskID(v).index = roaringFlameWarRead.getIndexByTaskID(v)
			roaringFlameWarRead.getIndexByTaskID(v).progress = questData.questProgress and questData.questProgress[tostring(v)] or 0
			table.insert(sortList, (roaringFlameWarRead.getIndexByTaskID(v)))
		end
	end
	table.sort(sortList, function(a, b)
		if a.status == b.status then
			return a.index < b.index
		end
		return a.status < b.status
	end)
	return sortList
end
function RoaringFlame_DecreePanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_CampReward")
end
function RoaringFlame_DecreePanel:btnOneKeyClick()
	SoraDPlaySound()
	roaringFlameWarCtrl:reqDecreeReward()
	SoraDShowLoading(self)
end
function RoaringFlame_DecreePanel:btnUnlockClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_DecreeGift")
end
function RoaringFlame_DecreePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule01")
	;(nil).content = i18n("flames_dunes_second_rule02")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_DecreePanel

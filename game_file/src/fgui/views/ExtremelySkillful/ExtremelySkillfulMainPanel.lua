local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulMainPanel = class("ExtremelySkillfulMainPanel", baseFguiPanel)
function ExtremelySkillfulMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulMainPanel:ctor", self.viewName)
end
function ExtremelySkillfulMainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
	end
	return self._packageList
end
function ExtremelySkillfulMainPanel:onInit()
	print("=======ExtremelySkillfulMainPanel:onInit")
	self.taskList, _ENV = print, print
	self.activityID = gActivityTimeActivityID.EXTREMELY_SKILLFUIL
	self.fields.Com_title:initData(i18n("activity_name_9001488"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_UPVALUE4_ = self.fields.Com_title
	self.fields.Com_title[1] = "Mask"
	self.fields.Com_title[2] = "Mask1"
	self.fields.Com_title[3] = "Button_unLockH"
	self.fields.Com_title[4] = "Button_unLockM"
	for i, v in ipairs(self.fields.Com_title) do
		self.fields[v]:fixPos()
	end
	self.fields.n22:getChildByName("Text_Level"):setString(i18n("common_text_748"))
	self.fields.n22:getChildByName("Text_Normal"):setString(i18n("MarvelousWorkmanship_05"))
	self.fields.n22:getChildByName("Text_Middle"):setString(i18n("MarvelousWorkmanship_06"))
	self.fields.n22:getChildByName("Text_Hight"):setString(i18n("MarvelousWorkmanship_07"))
	self.fields.Label_Time:initActivityTime(self.activityID)
	self.fields.Button_PreEffect:addClickListener(handler(self, self.onClickPreEffect))
	self.fields.Button_unLockH:addClickListener(handler(self, self.onClickUnlockH))
	self.fields.Button_unLockM:addClickListener(handler(self, self.onClickUnlockM))
	self.fields.Button_AllAward:addClickListener(handler(self, self.onClickAllAward))
	self.fields.Button_GetAward:addClickListener(handler(self, self.onClickAwardPreview))
	self.fields.Button_Lock:addClickListener(handler(self, self.onClickLock))
	self.fields.Button_GetAward:setTitleText(i18n("Battle_Towers_17"))
	self.fields.Button_AllAward:setTitleText(i18n("summoned_btn_01"))
	self.fields.Button_unLockH:setTitleText(i18n("MarvelousWorkmanship_04"))
	self.fields.Button_unLockM:setTitleText(i18n("MarvelousWorkmanship_03"))
	self.fields.Button_PreEffect:setTitleText(i18n("GloriousDecree_32"))
	self.fields.n22:fixChildrenPos()
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemAwardRederer))
	self.fields.List_Task:setItemRenderer(handler(self, self.onItemTaskRederer))
	_ENV = self.fields.List_Task.setItemRenderer
	_ENV, _ENV, self.fields.List_Task.setItemRenderer.defaultClick = handler(self, self.onItemTaskRederer)
	handler(self, self.onItemTaskRederer).title = i18n("activity_name_9001488")
	_ENV, self.tag[1], handler(self, self.onItemTaskRederer).tag = handler(self, self.onItemTaskRederer)
	handler(self, self.onItemTaskRederer).title = i18n("MarvelousWorkmanship_02")
	self.fields.List_Task.setItemRenderer.tabsetArray, self.tag[2], handler(self, self.onItemTaskRederer).tag = self.tag, handler(self, self.onItemTaskRederer)
	local self.fields.List_Task.setItemRenderer.callback, param = handler(self, self.onClickTab), self.fields.List_Task.setItemRenderer
	self.fields.Com_tab:initView(param)
	self.controllers.c3:setSelectedIndex(SoraDFIsRA() and 0 or 1)
end
function ExtremelySkillfulMainPanel:onShow()
	print("=======ExtremelySkillfulMainPanel:onShow")
	SoraDShowLoading(self)
	ExtremelySkillfulCtrl:sendReqInitDataMsg()
end
function ExtremelySkillfulMainPanel:updateView()
	if ExtremelySkillfulCtrl:getUnlockFurtherEx() then
		self.controllers.c2:setSelectedIndex(2)
	elseif ExtremelySkillfulCtrl:getUnlockFurther() then
		self.fields.Button_Lock:setTitleText(i18n("MarvelousWorkmanship_04"))
		self.controllers.c2:setSelectedIndex(1)
	else
		self.fields.Button_Lock:setTitleText(i18n("MarvelousWorkmanship_03"))
		self.controllers.c2:setSelectedIndex(0)
	end
	self.fields.Com_PreView:updateBuffDes()
	self.fields.ProgressBar_Level:updateData()
	self.fields.Button_AllAward:setEnabled(0 < ExtremelySkillfulCtrl:getLvRewardStatusAndNum())
end
function ExtremelySkillfulMainPanel:updatRed()
	local rewardRedNum = ExtremelySkillfulCtrl:getLvRewardStatusAndNum()
	local taskRedNum = ExtremelySkillfulCtrl:getTaskStatusAndNum()
	local isCanLock = ExtremelySkillfulCtrl:getLockStatusAndNum()
	rewardRedNum = rewardRedNum + (isCanLock and 1 or 0)
	self.fields.Com_tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
	self.fields.Button_Lock:setReddot(isCanLock)
end
function ExtremelySkillfulMainPanel:updateReward()
	self.lvRewardList = extremelySkillfulRead.getLvRewardList(ExtremelySkillfulCtrl:getGroupIndex())
	self.fields.List_Award:setNumItems(#self.lvRewardList)
	self.fields.List_Award:getScrollPane():setPercY(self:getScrollPercentY())
end
function ExtremelySkillfulMainPanel:updateTask()
	self.taskList = ExtremelySkillfulCtrl:getTaskList()
	self.fields.List_Task:setNumItems(#self.taskList)
end
function ExtremelySkillfulMainPanel:onItemAwardRederer(index, target)
	target:initData(self.lvRewardList[index + 1])
end
function ExtremelySkillfulMainPanel:onItemTaskRederer(index, target)
	local taskID = self.taskList[index + 1]
	ExtremelySkillfulCtrl = nil
	;(nil).taskID = taskID
	;(nil).progress = ExtremelySkillfulCtrl:getTaskProgress(taskID)
	;(nil).taskStatus = ExtremelySkillfulCtrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	target:initData(nil)
	target:setHandler(handler(self, self.onClickGetTaskAward))
end
function ExtremelySkillfulMainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 2 then
		self:updateTask()
	else
		self:updateReward()
	end
end
function ExtremelySkillfulMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("MarvelousWorkmanship_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ExtremelySkillfulMainPanel:onClickPreEffect()
	SoraDPlaySound()
	uiManager:show("ExtremelySkillfulBuff")
end
function ExtremelySkillfulMainPanel:onClickLock()
	SoraDPlaySound()
	if ExtremelySkillfulCtrl:getUnlockFurtherEx() then
	elseif ExtremelySkillfulCtrl:getUnlockFurther() then
		_ENV = nil
		;(nil).type = 2
		uiManager:show("ExtremelySkillfulBlessLight", nil)
	else
		_ENV = nil
		;(nil).type = 1
		uiManager:show("ExtremelySkillfulBlessLight", nil)
	end
end
function ExtremelySkillfulMainPanel:onClickUnlockH()
	SoraDPlaySound()
	if not ExtremelySkillfulCtrl:getUnlockFurther() then
		SoraDShowMsgTip(i18n("MarvelousWorkmanship_27"))
	elseif not ExtremelySkillfulCtrl:getUnlockFurtherEx() then
		_ENV = i18n("MarvelousWorkmanship_27")
		i18n("MarvelousWorkmanship_27").type = 2
		uiManager:show("ExtremelySkillfulBlessLight", i18n("MarvelousWorkmanship_27"))
	end
end
function ExtremelySkillfulMainPanel:onClickUnlockM()
	SoraDPlaySound()
	if not ExtremelySkillfulCtrl:getUnlockFurther() then
		_ENV = nil
		;(nil).type = 1
		uiManager:show("ExtremelySkillfulBlessLight", nil)
	end
end
function ExtremelySkillfulMainPanel:onClickAllAward()
	SoraDPlaySound()
	SoraDShowLoading(self)
	ExtremelySkillfulCtrl:reqMarvelousWorkmanshipReward()
end
function ExtremelySkillfulMainPanel:onClickAwardPreview()
	SoraDPlaySound()
	uiManager:show("ExtremelySkillfulAwardPreview")
end
function ExtremelySkillfulMainPanel:onClickGetTaskAward(taskID)
	print(taskID, "taskID")
	SoraDPlaySound()
	SoraDShowLoading(self)
	ExtremelySkillfulCtrl:reqMarvelousWorkmanshipTask(taskID)
end
function ExtremelySkillfulMainPanel:getScrollPercentY()
	local maxLv = extremelySkillfulRead.getMaxExpLv(ExtremelySkillfulCtrl:getGroupIndex())
	local nowLv = ExtremelySkillfulCtrl:getLevel()
	local sSize = self.fields.List_Award:getContentSize()
	local scrollToIdx = math.min(maxLv, math.max(1, nowLv))
	local scrollHeight = -sSize.height + self.fields.List_Award:getInnerContainerSize().height
	local scrollPercent = (100 * (scrollToIdx - 1) - sSize.height / 2 + 50) / scrollHeight
	if 1 < scrollPercent then
		scrollPercent = 1
	end
	return scrollPercent
end
return ExtremelySkillfulMainPanel

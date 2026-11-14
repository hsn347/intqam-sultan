local eventQuestRead = include("eventQuestRead")
local activity_9001571_Read = include("activity_9001571_Read")
local activityTimeRead = include("activityTimeRead")
local activity_9001571_Ctrl = SoraDGetCtrl("activity_9001571_Ctrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001571_MainPanel = class("Activity_9001571_MainPanel", baseFguiPanel)
function Activity_9001571_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001571_MainPanel:ctor", self.viewName)
end
function Activity_9001571_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001571_MainPanel:onInit()
	print("=======Activity_9001571_MainPanel:onInit")
	self.lvRewardList, _ENV = print, print
	self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001571
	self.fields.Com_title:initData(i18n("activity_name_9001571"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_view:setString(i18n("Back_battlefield_02"))
	self.fields.Button_view:addClickListener(handler(self, self.onClickBuffPreview))
	self.fields.Button_GetAward:setString(i18n("summoned_btn_01"))
	self.fields.Button_GetAward:addClickListener(handler(self, self.onClickAllAward))
	self.fields.Button_Add:addClickListener(handler(self, self.jumpToRechargeView))
	self.fields.Button_Active:setString(i18n("Back_battlefield_07"))
	self.fields.Button_Active:addClickListener(handler(self, self.onClickUnlock))
	self.fields.ProgressBar_Level:fixChildrenPos()
	self.fields.Label_lv = self.fields.ProgressBar_Level:getChildByName("Label_lv")
	self.fields.Text_Title1:setString(i18n("Braque_text_03"))
	self.fields.Text_Title2:setString(i18n("Braque_text_05"))
	self.fields.Text_Tip:setString(i18n("Back_battlefield_08"))
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemAwardRederer))
	self.fields.List_Award:setVirtual()
	self.fields.List_Task:setItemRenderer(handler(self, self.onItemTaskRederer))
	self.fields.Touch_hero:addClickListener(handler(self, self.jumpToHeroView))
end
function Activity_9001571_MainPanel:onShow()
	print("=======Activity_9001571_MainPanel:onShow")
	if activity_9001571_Ctrl:getGroupID() <= 0 then
		SoraDShowLoading(self)
		activity_9001571_Ctrl:reqHeroOrderChangeRewardGroup(1)
	else
		self:onInitView()
	end
end
function Activity_9001571_MainPanel:onInitView()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, nil, 1
	;(nil).title = i18n("activity_name_9001571")
	_ENV, (nil)[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("Back_battlefield_06")
	;(nil).tabsetArray, (nil)[2], (nil).tag = nil, nil, 2
	local (nil).callback, param = handler(self, self.onClickTab), nil
	self.fields.Com_tab:initView(param)
	SoraDShowLoading(self)
	activity_9001571_Ctrl:sendReqInitDataMsg()
end
function Activity_9001571_MainPanel:updateTask()
	self.taskList = activity_9001571_Ctrl:getTaskList()
	dump(self.taskList, "self.taskList")
	self.fields.List_Task:setNumItems(#self.taskList)
end
function Activity_9001571_MainPanel:updateView()
	self.fields.Label_lv:setString(self.curLv)
	self.controllers.c2:setSelectedIndex(activity_9001571_Ctrl:isRewardUnlock() and 1 or 0)
	self.curLv = activity_9001571_Ctrl:getLevel()
	local maxValue = activity_9001571_Read.getNextExp(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID(), self.curLv)
	self.fields.ProgressBar_Level:setMax(maxValue)
	self.fields.ProgressBar_Level:setValue(activity_9001571_Ctrl:getExp())
	self.fields.Button_GetAward:setEnabled(0 < activity_9001571_Ctrl:getLvRewardStatusAndNum())
	local nextCoreIndex = self:getNextCoreLv()
	self.fields.Com_PreAward:initPreData(self.lvRewardList[nextCoreIndex])
	self:initHeadSpine()
end
function Activity_9001571_MainPanel:getNextCoreLv()
	for i = self.curLv + 1, #self.lvRewardList do
		if self.lvRewardList[i].core then
			return i
		end
	end
	return #self.lvRewardList
end
function Activity_9001571_MainPanel:updateReward()
	self:updateView()
	self.lvRewardList = activity_9001571_Read.getLvAwardList(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID())
	dump(self.lvRewardList, "lvRewardList")
	local lvRewardMax = #self.lvRewardList
	self.fields.List_Award:setNumItems(lvRewardMax)
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	print("#self.lvRewardList-1,self.curLv-1", lvRewardMax - 1, self.curLv - 1)
	self.fields.List_Award:scrollToView(math.min(lvRewardMax - 1, math.max(0, self.curLv - 1)))
end
function Activity_9001571_MainPanel:updatRed()
	local rewardRedNum = activity_9001571_Ctrl:getLvRewardStatusAndNum()
	local taskRedNum = activity_9001571_Ctrl:getTaskStatusAndNum()
	self.fields.Com_tab:setBtnRedDot(1, 0 < rewardRedNum, rewardRedNum)
	self.fields.Com_tab:setBtnRedDot(2, 0 < taskRedNum, taskRedNum)
end
function Activity_9001571_MainPanel:initHeadSpine()
	local heroID = activity_9001571_Read.getHeroIDByGroupID(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID())
	local dressID = heroltCtrl:getHeroDress(heroID)[1]
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Spine:setVisible(not isUsm)
	self.fields.Usm:setVisible(isUsm)
	if isUsm then
		if cfg.maxChunkSize then
			self.fields.Usm:setMaxChunkSize(cfg.maxChunkSize)
		end
		self.fields.Usm:setEffectPath(spineCfg)
		self.fields.Usm:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm:setScale(cfg.detail[1])
		self.fields.Usm:setUsmAP(cc.p(0.5, 0))
		self.fields.Usm:setUsmPos(cc.p(cfg.detail[2], cfg.detail[3]))
	else
		self.fields.Spine:setEffectPath(spineCfg)
		self.fields.Spine:setScale(cfg.detail[1])
		local posy = cfg.detail[3]
		if dressID == 173601 then
			posy = posy - 100
		end
		self.fields.Spine:setSpinePos(cc.p(cfg.detail[2], posy))
	end
	local viewBg, isNewBg = heroltCtrl:getDressViewBg(dressID)
	self.fields.bg:setSpriteFrame(viewBg)
	local viewBgWidth = self.fields.bg:getWidth()
	print("viewBgWidth", viewBgWidth, self:getWidth())
	if viewBgWidth < 852 then
		self.fields.bg:setScale(self:getWidth() / viewBgWidth)
	else
		self.fields.bg:setScale(1)
	end
end
function Activity_9001571_MainPanel:onItemAwardRederer(index, target)
	target:initData(self.lvRewardList[index + 1], index, self.curLv)
end
function Activity_9001571_MainPanel:onItemTaskRederer(index, target)
	local taskID = self.taskList[index + 1]
	activity_9001571_Ctrl = nil
	;(nil).taskID = taskID
	;(nil).progress = activity_9001571_Ctrl:getTaskProgress(taskID)
	;(nil).taskStatus = activity_9001571_Ctrl:getTaskState(taskID)
	;(nil).taskDes = eventQuestRead.getDes(taskID)
	;(nil).award = eventQuestRead.getReward(taskID)
	;(nil).aim = eventQuestRead.getAim(taskID)
	;(nil).guideId = eventQuestRead.getGuideId(taskID)
	;(nil).isAct = eventQuestRead.isNeedShowGo(taskID) and 1 or 0
	;(nil).activityID = self.activityID
	target:initData(nil)
end
function Activity_9001571_MainPanel:onClickUnlock()
	SoraDPlaySound()
	uiManager:show("Activity_9001571_BuyGift")
end
function Activity_9001571_MainPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 2 then
		self:updateTask()
	else
		self:updateReward()
	end
end
function Activity_9001571_MainPanel:onClickAllAward()
	SoraDPlaySound()
	SoraDShowLoading(self)
	activity_9001571_Ctrl:reqHeroOrderReceive()
end
function Activity_9001571_MainPanel:onClickBuffPreview()
	SoraDPlaySound()
	uiManager:show("Activity_9001571_Choose")
end
function Activity_9001571_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Back_battlefield_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Activity_9001571_MainPanel:jumpToHeroView()
	local heroID = activity_9001571_Read.getHeroIDByGroupID(activity_9001571_Ctrl:getClassType(), activity_9001571_Ctrl:getGroupID())
	SoraDShowHeroDetailView(heroID)
end
function Activity_9001571_MainPanel:jumpToRechargeView()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeID = activityTimeRead.getRechargeId(self.activityID)
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(12, activityTimeRead.getRechargeId(self.activityID))
		panel:show()
	end
end
return Activity_9001571_MainPanel

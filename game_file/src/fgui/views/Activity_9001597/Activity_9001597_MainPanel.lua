local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001597_MainPanel = class("Activity_9001597_MainPanel", baseFguiPanel)
local activity_9001597_Read = include("activity_9001597_Read")
local constantRead = include("constantRead")
local publicRead = include("publicRead")
local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Activity_9001597_MainPanel:ctor(...)
	Activity_9001597_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001597_MainPanel:ctor", self.viewName)
end
function Activity_9001597_MainPanel:onInit()
	print("=======Activity_9001597_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.CALENDAR_ACTIVITY_9001597
	self.fields.Com_title:initData(i18n("activity_name_9001597"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.text_reward:setTitle(i18n("Ramadan_2024_text32"))
	self.fields.text_rewarddes:setString(i18n("Ramadan_2024_text33"))
	self.fields.list2:setVirtual()
	self.fields.list2:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_rank:setTitle(i18n("common_text_851"))
	self.fields.btn_rule:setTitle(i18n("Ramadan_2024_text31"))
	self.fields.btn_rank:addClickEventListener(handler(self, self.onRankClick))
	self.fields.btn_rule:addClickEventListener(handler(self, self.onRuleClick))
	self.fields.button_go:addClickEventListener(handler(self, self.onGoClick))
	self.isJoinAlliance = activity_9001597_Ctrl:getIsJoinAlliance()
	if not SoraDFIsRA() then
		self.fields.Bar_score:fixPos()
		self.fields.Bar_score:fixChildrenPos(false, true)
		self.fields.List_box:fixPos()
		self.fields.btn_rank:fixPos()
		self.fields.btn_rule:fixPos()
		self.fields.Com_add_1:fixPos()
		self.fields.Com_add_2:fixPos()
	end
	self.boxInfo = activity_9001597_Read.getBoxCfgs()
	self.showRewards = activity_9001597_Read.getShowReward(1)
	self.itemID1 = constantRead.getConstValue("RAMADAN_2024_ORDINARY_SALUTE", 867701)
	self.itemID2 = constantRead.getConstValue("RAMADAN_2024_LUXURY_Salute", 867801)
	self.fields.Com_add_1:setIcon(publicRead.getIcon(self.itemID1))
	self.fields.Com_add_1:initData(self.itemID1)
	self.fields.Com_add_2:setIcon(publicRead.getIcon(self.itemID2))
	self.fields.Com_add_2:initData(self.itemID2)
	activity_9001597_Ctrl:sendReqInitDataMsg()
end
function Activity_9001597_MainPanel:onShow()
	print("=======Activity_9001597_MainPanel:onShow")
	dump(self.showRewards, "self.showRewards")
	self.fields.list2:setNumItems(#self.showRewards)
	self:updateView()
end
function Activity_9001597_MainPanel:updateView()
	self:initProgress()
	self.fields.Com_add_1:setTitle(backpackCtrl:getItemCount(self.itemID1))
	self.fields.Com_add_2:setTitle(backpackCtrl:getItemCount(self.itemID2))
	local titleStr = ""
	local tipStr = ""
	self.isCanBuild = activity_9001597_Ctrl:getIsCanBuild()
	if not self.isCanBuild then
		titleStr = i18n("activity_name_9001596")
		tipStr = i18n("Ramadan_2024_text35")
	else
		titleStr = i18n("Ramadan_2024_text37")
		tipStr = i18n("Ramadan_2024_text36")
	end
	self.fields.button_go:setTitle(titleStr)
	self.fields.text_desc:setString(tipStr)
end
function Activity_9001597_MainPanel:initProgress()
	local fields = self.fields
	local personScore = activity_9001597_Ctrl:getBoxRewardNum()
	fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	local passIndex = 0
	fields.List_box:setNumItems(#self.boxInfo)
	local singlePassPercent = 1 / #self.boxInfo * 100
	for i, v in ipairs(self.boxInfo) do
		if personScore >= v.score then
			passIndex = passIndex + 1
		end
	end
	if personScore < self.boxInfo[1].score then
		fields.Bar_score:setPercent(0)
	elseif passIndex < #self.boxInfo then
		local littlePercent = (personScore - self.boxInfo[passIndex].score) / (self.boxInfo[passIndex + 1].score - self.boxInfo[passIndex].score) * singlePassPercent
		fields.Bar_score:setPercent((singlePassPercent * passIndex + littlePercent) / 100)
		dump((singlePassPercent * passIndex + littlePercent) / 100, "singlePassPercent * (passIndex) + littlePercent)/100")
	else
		fields.Bar_score:setPercent(1)
	end
	if self.isJoinAlliance then
		local num = string.format("<font color='#ffdf2d'>%s</font>", personScore)
		self.fields.text_value:setString(i18n("Ramadan_2024_text28") .. num)
	else
		self.fields.text_value:setString(i18n("Ramadan_2024_text29"))
	end
end
function Activity_9001597_MainPanel:onBoxRenderer(index, obj)
	local boxInfo = self.boxInfo[index + 1]
	obj:initData(boxInfo, index + 1)
	obj:setClickHandler(handler(self, self.buttonGetRewardCallBack))
end
function Activity_9001597_MainPanel:onItemRenderer(index, obj)
	local item = self.showRewards[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001597_MainPanel:buttonGetRewardCallBack(button, index)
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = index
	;(nil).data = self.boxInfo[index]
	uiManager:show("Activity_9001597_Reward", nil)
end
function Activity_9001597_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_2024_text27")
	uiManager:show("RuleView", nil)
end
function Activity_9001597_MainPanel:onRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001597_Rank")
end
function Activity_9001597_MainPanel:onRuleClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("Ramadan_2024_text30"))
end
function Activity_9001597_MainPanel:onGoClick()
	SoraDPlaySound()
	if not self.isCanBuild then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_BUILD_SALYUT_ACTIVITY, false) then
			self:close()
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.RAMADAN_BUILD_SALYUT_ACTIVITY, 7)
		else
			SoraDShowMsgTip(i18n("Ramadan_2024_text25"))
		end
	else
		self.buildData = activity_9001597_Ctrl:getBuildData()
		if self.buildData == nil then
			_ENV = activity_9001597_Ctrl
			activity_9001597_Ctrl.x = 608
			activity_9001597_Ctrl.y = 608
			SoraDGotoWorldMapPoint(activity_9001597_Ctrl)
		else
			_ENV = activity_9001597_Ctrl
			activity_9001597_Ctrl.x = self.buildData.x
			activity_9001597_Ctrl.y = self.buildData.y
			SoraDGotoWorldMapPoint(activity_9001597_Ctrl)
		end
		SoraDRemoveAllPanelFromManager()
	end
end
return Activity_9001597_MainPanel

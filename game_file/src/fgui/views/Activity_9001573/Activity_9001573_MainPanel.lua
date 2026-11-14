local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_MainPanel = class("Activity_9001573_MainPanel", baseFguiPanel)
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local activity_9001573_Read = include("activity_9001573_Read")
function Activity_9001573_MainPanel:ctor(...)
	Activity_9001573_MainPanel.super.ctor(self, ...)
	print("Activity_9001573_MainPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.debug = true
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001573
end
function Activity_9001573_MainPanel:onInit()
	self.view:fixChildrenPos()
	print("=======Activity_9001573_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001573"), handler(self, self.onClickClose), function()
		_ENV = nil
		;(nil).content = i18n("Celestial_defense_text_001")
		uiManager:show("RuleView", nil)
	end)
	self.fields.btn_team:setTitle(i18n("alliance_office_name_01"))
	self.fields.btn_team:addClickEventListener(handler(self, self.onTeamClick))
	self.fields.btn_builds:setTitle(i18n("Celestial_defense_build_001"))
	self.fields.btn_builds:addClickEventListener(handler(self, self.onBuildsClick))
	self.fields.btn_lvTower:setTitle(i18n("Celestial_defense_text_042"))
	self.fields.btn_lvTower:addClickEventListener(handler(self, self.onLvTowerClick))
	self.fields.btn_rank:setTitle(i18n("pyramid_btn_29"))
	self.fields.btn_rank:addClickEventListener(handler(self, self.onRankClick))
	self.fields.btn_reward:setTitle(i18n("atlantiswar_text_0019"))
	self.fields.btn_reward:addClickEventListener(handler(self, self.onRewardClick))
	self.timeLabel = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.timeLabel:setTimeEndListener(function()
		self:runAction(ffa.seq(ffa.delay(0.5), ffa.callFunc(function()
			self:initData()
		end)))
	end)
end
function Activity_9001573_MainPanel:onShow()
	print("=======Activity_9001573_MainPanel:onShow")
	self:initData()
end
function Activity_9001573_MainPanel:initData()
	self.status = activity_9001573_Ctrl:getStatus()
	local showStatusStr = ""
	local lastTime = activity_9001573_Ctrl:getStatusLastTime()
	if activity_9001573_Ctrl:getIsInPrepare(self.status) then
		showStatusStr = i18n("Celestial_defense_text_002")
	elseif activity_9001573_Ctrl:getIsInBattle(self.status) then
		showStatusStr = i18n("Celestial_defense_text_003")
	elseif self.status == gNebulaDefenceWarStage.OVER then
		showStatusStr = i18n("Celestial_defense_text_004")
	end
	self.fields.txt_timeDes:setString(showStatusStr)
	self.timeLabel:beginTime(lastTime)
	self.fields.btn_reward:setReddot(activity_9001573_Ctrl:getReceiveStatusAndNum())
end
function Activity_9001573_MainPanel:onTeamClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001573_Team")
end
function Activity_9001573_MainPanel:onBuildsClick()
	SoraDPlaySound()
	if activity_9001573_Ctrl:getIsInBattle() then
		uiManager:show("Activity_9001573_Builds")
	elseif activity_9001573_Ctrl:getIsInPrepare() then
		local lastTime = activity_9001573_Ctrl:getStatusLastTime()
		_ENV = nil
		;(nil).time = SoraDConvertSecondToString(lastTime)
		SoraDShowMsgTip(i18n("Celestial_defense_text_005", nil))
	else
		SoraDShowMsgTip(i18n("Celestial_defense_text_083"))
	end
end
function Activity_9001573_MainPanel:onLvTowerClick()
	if activity_9001573_Ctrl:getIsInBattle() then
		SoraDGotoWorldMapPoint(cc.p(600, 604), true)
		SoraDRemoveAllPrePanelFromManager(self)
	else
		local lastTime = activity_9001573_Ctrl:getStatusLastTime()
		activity_9001573_Ctrl = nil
		;(nil).time = SoraDConvertSecondToString(lastTime)
		SoraDShowMsgTip(i18n("Celestial_defense_text_006", nil))
	end
end
function Activity_9001573_MainPanel:onRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001573_Rank")
end
function Activity_9001573_MainPanel:onRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001573_Reward")
end
return Activity_9001573_MainPanel

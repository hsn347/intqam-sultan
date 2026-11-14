local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaWarRead = include("nebulaWarRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorMainPanel = class("NebulaEmperorMainPanel", baseFguiPanel)
function NebulaEmperorMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaEmperorMainPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
end
function NebulaEmperorMainPanel:onInit()
	print("=======NebulaEmperorMainPanel:onInit")
	local handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handlerHelp)
	local __, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local areaIcon = nebulaWarRead.getAreaIcon(regionId)
	self.fields.Load_region:setURL(areaIcon)
	local areaName = nebulaWarRead.getAreaName(regionId)
	_ENV = nil
	;(nil).name = areaName
	self.fields.Text_region:setString(i18n("emperorannounce_text_1", nil))
	local curSeason = nebulaEmperorCtrl:getCurSeason()
	self.fields.Text_season:setString("S" .. curSeason)
	self.fields.Effect_season:setSeason(curSeason)
	nebulaEmperorUtil, _UPVALUE7_, self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time), self.fields, SoraDCreateTimerLabel(nil, self.fields.Text_time)
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[1] = self.fields.Button_team, self.fields.Button_team
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[2] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[3] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[4] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[5] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[6] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[7] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[8] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[9] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[10] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, SoraDCreateTimerLabel(nil, self.fields.Text_time)[11] = self.fields.Button_team, i18n("technology_name_24011")
	nebulaEmperorUtil, self.fields.Button_team[1] = self.fields.Button_title, self.fields.Button_title
	nebulaEmperorUtil, self.fields.Button_team[2] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[3] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[4] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[5] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[6] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[7] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[8] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[9] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_team[10] = self.fields.Button_title, i18n("nebulaemperor_text_19")
	nebulaEmperorUtil, self.fields.Button_title[1] = self.fields.Button_donate, self.fields.Button_donate
	nebulaEmperorUtil, self.fields.Button_title[2] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[3] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[4] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[5] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[6] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[7] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[8] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_title[9] = self.fields.Button_donate, i18n("common_text_284")
	nebulaEmperorUtil, self.fields.Button_donate[1] = self.fields.Button_reward, self.fields.Button_reward
	nebulaEmperorUtil, self.fields.Button_donate[2] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_donate[3] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_donate[4] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_donate[5] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_donate[6] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_donate[7] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_donate[8] = self.fields.Button_reward, i18n("common_text_2078")
	nebulaEmperorUtil, self.fields.Button_reward[1] = self.fields.Button_gift, self.fields.Button_gift
	nebulaEmperorUtil, self.fields.Button_reward[2] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaEmperorUtil, self.fields.Button_reward[3] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaEmperorUtil, self.fields.Button_reward[4] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaEmperorUtil, self.fields.Button_reward[5] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaEmperorUtil, self.fields.Button_reward[6] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaEmperorUtil, self.fields.Button_reward[7] = self.fields.Button_gift, i18n("nebulaemperor_text_245")
	nebulaEmperorUtil, self.fields.Button_gift[1] = self.fields.Button_rank, self.fields.Button_rank
	nebulaEmperorUtil, self.fields.Button_gift[2] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_gift[3] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_gift[4] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_gift[5] = self.fields.Button_rank, i18n("common_text_2193")
	nebulaEmperorUtil, self.fields.Button_gift[6] = self.fields.Button_rank, i18n("common_text_2193")
	self.fields.Button_rank[1] = self.fields.Button_energy
	self.fields.Button_rank[2] = i18n("nebulaemperor_text_22")
	self.fields.Button_rank[3] = i18n("nebulaemperor_text_22")
	self.fields.Button_rank[4] = i18n("nebulaemperor_text_22")
	self.fields.Button_rank[5] = i18n("nebulaemperor_text_22")
	self.fields[1] = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields[2] = self.fields.Button_team
	self.fields[3] = self.fields.Button_title
	self.fields[4] = self.fields.Button_donate
	self.fields[5] = self.fields.Button_reward
	self.fields[6] = self.fields.Button_gift
	local self.fields[7], config = self.fields.Button_rank, self.fields
	for __, cfg in ipairs(config) do
		local widget = cfg[1]
		local title = cfg[2]
		if title then
			widget:setString(title)
		end
		widget:addClickListener(handler(self, self.onClickOperateBtn))
	end
	self.fields.Button_enter:addClickListener(handler(self, self.onClickBtnEnter))
	if worldMapDefine.isInNebulaEmperor() then
		self.fields.Button_enter:setString(i18n("remains_btn_09"))
	else
		self.fields.Button_enter:setString(i18n("common_text_3318"))
	end
	self:showEnterAction()
	if not SoraDFIsRA() then
		self.fields.Load_region:fixPos()
	end
end
function NebulaEmperorMainPanel:onShow()
	print("=======NebulaEmperorMainPanel:onShow")
	self:updateActivityState()
	self:updateBtnEnergyState()
	nebulaEmperorCtrl:reqInWarPlayerCount()
end
function NebulaEmperorMainPanel:updateActivityState(...)
	local curState = activityShowCtrl:getParamCurState(self.activityID)
	if curState ~= ACTIVITY_STATE.PREPARE and curState ~= ACTIVITY_STATE.ACTIVE then
		return
	end
	if curState == ACTIVITY_STATE.PREPARE then
		self.controllers.c_state:setSelectedIndex(0)
		activityShowCtrl = nil
		;(nil).time = ""
		self.fields.Text_begin:setString(i18n("nebulaemperor_text_2", nil))
	else
		self.controllers.c_state:setSelectedIndex(1)
		activityShowCtrl = i18n("nebulaemperor_text_2", nil)
		i18n("nebulaemperor_text_2", nil).time = ""
		self.fields.Text_begin:setString(i18n("nebulaemperor_text_3", i18n("nebulaemperor_text_2", nil)))
	end
	local remainTime = activityShowCtrl:getRemainTime(self.activityID) or 999999
	if remainTime and 0 < remainTime then
		self.fields.Text_time:beginTime(remainTime)
	end
	self:updateBtnDonateState()
end
function NebulaEmperorMainPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_team then
		nebulaEmperorUtil.openTeamView()
	elseif sender == self.fields.Button_title then
		if nebulaEmperorUtil.isWarTest() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_238"))
			return
		end
		uiManager:show("NebulaEmperorTitle")
	elseif sender == self.fields.Button_donate then
		uiManager:show("NebulaEmperorDonate")
	elseif sender == self.fields.Button_reward then
		uiManager:show("NebulaEmperorReward")
	elseif sender == self.fields.Button_gift then
		nebulaEmperorUtil.openGiftView()
	elseif sender == self.fields.Button_rank then
		uiManager:show("NebulaEmperorRank")
	elseif sender == self.fields.Button_energy then
		uiManager:show("NebulaEmperorEnergy")
	end
end
function NebulaEmperorMainPanel:onClickBtnEnter(...)
	SoraDPlaySound()
	if worldMapDefine.isInNebulaEmperor() then
		nebulaEmperorUtil.gotoQuitBattleField()
	else
		nebulaEmperorUtil.checkEnterBattleField(function()
			nebulaEmperorCtrl:reqEnterBattlefield()
			SoraDShowLoading(self:displayObject())
		end)
	end
end
function NebulaEmperorMainPanel:updatePlayerCount(count)
	_ENV = nil
	;(nil).num = count
	self.fields.Text_enter:setString(i18n("nebulaemperor_text_4", nil))
end
function NebulaEmperorMainPanel:updateBtnDonateState(...)
	local red = nebulaEmperorCtrl:getDonateStatusAndNum()
	self.fields.Button_donate:setReddot(red)
end
function NebulaEmperorMainPanel:updateBtnEnergyState(...)
	local red = nebulaEmperorCtrl:getEnergyStatusAndNum()
	self.fields.Button_energy:setRedVisible(red)
end
function NebulaEmperorMainPanel:showEnterAction(...)
	local needShow = false
	local dailyRemindManager = include("dailyRemindManager")
	local ctype = dailyRemindManager.REMIND_TYPE.nebulaEmperorEnter
	if dailyRemindManager.checkNeedRemindOnce(ctype, self.activityID) then
		dailyRemindManager.addRemindOnceToManager(ctype, self.activityID)
		needShow = true
	end
	self.fields.Effect_season:setVisible(false)
	if needShow then
		self.transitions.t0:play()
		self.fields.Usm_bg:setMaxChunkSize(126368)
		self.fields.Usm_bg:setPrepareCallback(function(target)
			target:start()
			self = nil
			;(nil).frame = 30
			target:addFrameEventData(nil)
			target:setFrameEventCallback(function(event)
				self.fields.Effect_season:showAction()
			end)
		end)
	else
		self.fields.Usm_bg:setEffectPath("xydwzjm.usm")
		self.fields.Image_bg:setVisible(true)
		self.fields.Effect_season:showAction()
	end
end
return NebulaEmperorMainPanel

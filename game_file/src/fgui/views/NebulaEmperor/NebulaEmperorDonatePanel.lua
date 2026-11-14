local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local NEBULA_ALL_STAR_STATE = nebulaAllStarRead.NEBULA_ALL_STAR_STATE
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaEmperorDonatePanel = class("NebulaEmperorDonatePanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function NebulaEmperorDonatePanel:ctor(...)
	NebulaEmperorDonatePanel.super.ctor(self, ...)
	print("NebulaEmperorDonatePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
end
function NebulaEmperorDonatePanel:onInit()
	print("=======NebulaEmperorDonatePanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
	self.donateMax = self:getRead().getDonateGoldMax()
	local handlerHelp
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("donate")
	else
		handlerHelp = nebulaEmperorUtil.getHandler_onClickHelp()
	end
	local handlerHelp = nebulaAllStarUtil.getHandler_onClickHelp("donate")
	self.fields.Com_title:initData(i18n("common_text_284"), handler(self, self.onClickClose), handlerHelp)
	self:initTimeLabel()
	local _fields = fguiHelper.get_fields(self.fields.Com_donate1)
	self._fields1 = _fields
	_fields.Text_des:setString(i18n("nebulaemperor_text_82"))
	local cfg = self:getRead().getDonateSkillConfig()
	_fields.Text_skill:setString(i18n(cfg.name))
	_fields.Load_skill:setURL(cfg.icon)
	_fields.Load_skill:addClickListener(handler(self, self.onClickSkill))
	local _fields = fguiHelper.get_fields(self.fields.Com_donate2)
	self._fields2 = _fields
	_fields.Text_des:setString(i18n("nebulaemperor_text_85"))
	_fields.Com_boxList:setActivityID(self.activityID)
	local _fields = fguiHelper.get_fields(self.fields.Com_donate3)
	self._fields3 = _fields
	_fields.Button_donate:setString(i18n("common_text_284"))
	_fields.Button_donate:addClickListener(handler(self, self.onClickBtnDonate))
	if self:checkDonateState() and SoraDGetBuildStarLv() >= self:getRead().getNeedLv() then
		_fields.Com_slider:setSliderCallBack(function(curValue)
			_fields.Button_donate:setBright(0 < curValue)
		end)
	else
		_fields.Com_slider:setSliderCallBack(nil)
		_fields.Button_donate:setBright(false)
	end
	if not SoraDFIsRA() then
		self._fields1.Label_donate:fixChildrenPos()
		self._fields1.Text_exp:fixChildrenPos()
		self._fields1.Image_exp:setFillClockwise(false)
		self._fields2.Label_donate:fixChildrenPos()
		self._fields3.Label_donate:fixChildrenPos()
		self._fields3.Com_slider:setInpuBoxFixPos()
	end
end
function NebulaEmperorDonatePanel:initTimeLabel(...)
	local timeLabel = self.fields.Com_title:getLabelTime()
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		local curState = nebulaAllStarCtrl:getActivityCurState()
		if curState >= NEBULA_ALL_STAR_STATE.ENTER_ROOM then
			timeLabel:setString(i18n("nebulaemperor_text_88"))
			return
		end
		timeLabel:initActivityTimeStyle(self.activityID, "nebulaemperor_text_80")
		local stateTime = nebulaAllStarCtrl:getStateBeginTime(NEBULA_ALL_STAR_STATE.ENTER_ROOM)
		local leftTime = stateTime - serviceFunctions.systemTime()
		if 0 < leftTime then
			timeLabel:setTimeEndListener(function()
				timeLabel:setString(i18n("nebulaemperor_text_88"))
			end)
			timeLabel:beginTime(leftTime)
		else
			timeLabel:setString(i18n("nebulaemperor_text_88"))
		end
	elseif self:checkDonateState() then
		timeLabel:initActivityTimeStyle(self.activityID, "nebulaemperor_text_80")
		timeLabel:setTimeEndListener(function()
			timeLabel:setString(i18n("nebulaemperor_text_88"))
		end)
	else
		timeLabel:setString(i18n("nebulaemperor_text_88"))
	end
end
function NebulaEmperorDonatePanel:onShow()
	print("=======NebulaEmperorDonatePanel:onShow")
	self:updateDonateGold()
	SoraDShowLoading(self:displayObject())
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		nebulaAllStarCtrl:reqDonateData()
	else
		nebulaEmperorCtrl:reqInitData()
	end
end
function NebulaEmperorDonatePanel:onClickBtnDonate(...)
	SoraDPlaySound()
	if not self:checkDonateState() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_88"))
		return
	end
	local starLv = self:getRead().getNeedLv()
	if starLv > SoraDGetBuildStarLv() then
		_ENV = i18n("nebulaemperor_text_88")
		i18n("nebulaemperor_text_88").lv = starLv
		SoraDShowMsgTip(i18n("nebulaemperor_text_241", i18n("nebulaemperor_text_88")))
		return
	end
	if self.donateInfo.todayGold >= self.donateMax then
		SoraDShowMsgTip(i18n("nebulaemperor_text_89"))
		return
	end
	if not SoraDEnoughGold(1) then
		return
	end
	local goldNum = self._fields3.Com_slider:getSliderCurValue()
	if goldNum <= 0 then
		SoraDShowMsgTip(i18n("nebulaemperor_text_90"))
		return
	end
	local needGoldMax = self:getRead().getDonateRewardNeedGoldMax()
	if needGoldMax > self.donateInfo.totalGold then
		self:getCtrl():reqDonateGold(goldNum)
		SoraDShowLoading(self:displayObject())
		return
	end
	SoraDShowMsgBox(i18n("nebulaemperor_text_225"), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
			self:getCtrl():reqDonateGold(goldNum)
			SoraDShowLoading(self:displayObject())
		end
	end)
end
function NebulaEmperorDonatePanel:updateDonateGold(...)
	self.donateInfo = self:getCtrl():getDonateInfo()
	self:updateRegionDonateGold()
	local totalGold = self.donateInfo.totalGold
	_ENV = nil
	;(nil).num = string_fnt(totalGold)
	self._fields2.Label_donate:setString(i18n("nebulaemperor_text_84", nil))
	self:updateDonateReward()
	local _ENV, style = self.updateDonateReward, self.updateDonateReward
	local donateRemain = self.donateMax - self.donateInfo.todayGold
	if donateRemain <= 0 then
		_ENV, _ENV = i18n("nebulaemperor_text_84", nil)
		_ENV, self.donateInfo.todayGold.num, i18n("nebulaemperor_text_84", nil).color = i18n("nebulaemperor_text_84", nil)
		style, self.donateInfo.todayGold.max, i18n("nebulaemperor_text_84", nil).color = self.donateInfo.todayGold, i18n("nebulaemperor_text_84", nil)
	end
	_ENV = i18n("nebulaemperor_text_84", nil)
	i18n("nebulaemperor_text_84", nil).num = string_fnt(self.donateInfo.todayGold)
	i18n("nebulaemperor_text_84", nil).max = string_fnt(self.donateMax)
	local str = i18n_html("nebulaemperor_text_87", i18n("nebulaemperor_text_84", nil))
	self._fields3.Label_donate:setString(str)
	local maxValue = math.max(0, math.min(SoraDGetGold(), donateRemain))
	self._fields3.Com_slider:setMaxValue(maxValue)
	self._fields3.Com_slider:setMinValue(0)
	self._fields3.Com_slider:setSliderCurValue(0)
end
function NebulaEmperorDonatePanel:onClickSkill(...)
	SoraDPlaySound()
	local donateLv = self:getRead().getDonateLv(self.donateInfo.donateGold)
	_ENV = nil
	;(nil).donateLv = donateLv
	;(nil).activityID = self.activityID
	uiManager:show("NebulaEmperorDonateSkill", nil)
end
function NebulaEmperorDonatePanel:updateDonateReward(...)
	local totalGold = self.donateInfo.totalGold
	self._fields2.Com_boxList:updateTotalGold(totalGold)
end
function NebulaEmperorDonatePanel:updateRegionDonateGold(...)
	self.donateInfo = self:getCtrl():getDonateInfo()
	_ENV = nil
	;(nil).num = string_fnt(self.donateInfo.donateGold)
	self._fields1.Label_donate:setString(i18n("nebulaemperor_text_81", nil))
	local donateLv = self:getRead().getDonateLv(self.donateInfo.donateGold)
	_ENV = i18n("nebulaemperor_text_81", nil)
	i18n("nebulaemperor_text_81", nil).lv = donateLv
	self._fields1.Text_lv:setString(i18n("common_text_100", i18n("nebulaemperor_text_81", nil)))
	local textColor = cc.c3b(255, 242, 207)
	if donateLv == 0 then
		textColor = cc.c3b(255, 6, 0)
	elseif donateLv == donateLvMax then
		textColor = cc.c3b(0, 255, 18)
	end
	self._fields1.Text_lv:setColor(textColor)
	if self:getRead().isDonateLvMax(donateLv) then
		self._fields1.Image_exp:setFillAmount(1)
		self._fields1.Text_exp:setString(i18n("common_text_339"))
	else
		local needGold = self:getRead().getDonateNeedGold(donateLv)
		local nextGold = self:getRead().getDonateNeedGold(donateLv + 1)
		local value = self.donateInfo.donateGold - needGold
		local total = nextGold - needGold
		local percent = value / total
		self._fields1.Image_exp:setFillAmount(percent)
		_ENV = i18n("common_text_339")
		i18n("common_text_339").member = value
		i18n("common_text_339").total = total
		self._fields1.Text_exp:setString(i18n("common_text_155", i18n("common_text_339")))
	end
end
function NebulaEmperorDonatePanel:getCtrl(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarCtrl
	else
		return nebulaEmperorCtrl
	end
end
function NebulaEmperorDonatePanel:getRead(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarRead
	else
		return nebulaEmperorRead
	end
end
function NebulaEmperorDonatePanel:checkDonateState(...)
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		return nebulaAllStarUtil.checkDonateState()
	else
		return nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.PREPARE)
	end
end
return NebulaEmperorDonatePanel

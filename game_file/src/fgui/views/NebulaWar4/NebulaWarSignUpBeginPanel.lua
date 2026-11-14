local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local constantRead = include("constantRead")
local buildLogic = include("buildLogic")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarSignUpBeginPanel = class("NebulaWarSignUpBeginPanel", baseFguiPanel)
function NebulaWarSignUpBeginPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarSignUpBeginPanel:ctor", self.viewName)
	self.myTeam = nebulaActivityCtrl:getMyTeamInfo()
end
function NebulaWarSignUpBeginPanel:onInit()
	print("=======NebulaWarSignUpBeginPanel:onInit")
	self.fields.Panel_bg:setString(i18n("nebula_war_text_0505"))
	local time = constantRead.getConstValue("NEBULA_WARS_ENROLL_CD_TIME", 3600)
	local num = nebulaWarUtil.getSuperTeamNumMax()
	_ENV = i18n("nebula_war_text_0505")
	i18n("nebula_war_text_0505").time = math.ceil(time / 60)
	i18n("nebula_war_text_0505").num = num
	self.fields.Text_des:setString(i18n("nebula_war_text_0509", i18n("nebula_war_text_0505")))
	self.fields.Button_sign:addClickListener(handler(self, self.onClickBtnSign))
	self.fields.Text_num1:setString(i18n("nebula_war_text_0510"))
	self.fields.Text_time1:setString(i18n("pyramid_text_106"))
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	local time = nebulaWarUtil.getSuperTeamSignUpRemainTime()
	if 0 < time then
		self.fields.Text_time:beginTime(time)
	end
	self.fields.Text_time:setTimeEndListener(function()
		self:closePanel()
	end)
	self.fields.Text_signCD = SoraDCreateTimerLabel(nil, self.fields.Text_signCD)
	self.fields.Text_signCD:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("nebula_war_text_0511", nil)
	end)
	self.fields.Text_signCD:setTimeEndListener(function()
		self:updateBtnState()
	end)
	self.fields.Text_signCD:setVisible(false)
	self:updateBtnState()
end
function NebulaWarSignUpBeginPanel:onShow()
	print("=======NebulaWarSignUpBeginPanel:onShow")
	self.myTeam:reqSignUpNum()
	SoraDShowLoading(self:displayObject())
end
function NebulaWarSignUpBeginPanel:updateBtnState(...)
	self.fields.Text_signCD:setVisible(false)
	local Button_sign = self.fields.Button_sign
	if self.myTeam:isTeamLeader() and self.myTeam:getIsSignUpSuperTeam() then
		Button_sign:setString(i18n("nebula_war_text_0395"))
		Button_sign:setBright(true)
		Button_sign:setBtnColorIndex(0)
	else
		Button_sign:setBtnColorIndex(2)
		if not self.myTeam:isTeamLeader() then
			Button_sign:setString(i18n("pyramid_text_109"))
			Button_sign:setBright(false)
		elseif 0 < self.myTeam:getSignUpCDRemainTime() then
			Button_sign:setString("")
			Button_sign:setBright(false)
			self.fields.Text_signCD:setVisible(true)
			local time = self.myTeam:getSignUpCDRemainTime()
			self.fields.Text_signCD:beginTime(time)
		else
			Button_sign:setString(i18n("pyramid_text_109"))
			Button_sign:setBright(true)
		end
	end
end
function NebulaWarSignUpBeginPanel:onClickBtnSign(...)
	SoraDPlaySound()
	if self.myTeam:isTeamLeader() and self.myTeam:getIsSignUpSuperTeam() then
		self:cancelSignUp()
		return
	end
	if not nebulaWarUtil.checkSuperTeamSignUpState() then
		SoraDShowMsgTip(i18n("nebula_war_text_0512"))
		return
	end
	if not self.myTeam:isTeamLeader() then
		SoraDShowMsgTip(i18n("alliance_mapmark_text_008"))
		return
	end
	local time = self.myTeam:getSignUpCDRemainTime()
	if 0 < time then
		_ENV = i18n("alliance_mapmark_text_008")
		i18n("alliance_mapmark_text_008").time = SoraDConvertSecondToString(time)
		SoraDShowMsgTip(i18n("nebula_war_text_0513", i18n("alliance_mapmark_text_008")))
		return
	end
	self.myTeam:reqSignUpSuperTeam()
	SoraDShowLoading(self:displayObject())
end
function NebulaWarSignUpBeginPanel:cancelSignUp(...)
	SoraDShowMsgBox(i18n("nebula_war_text_0515"), i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			if not nebulaWarUtil.checkSuperTeamSignUpState() then
				SoraDShowMsgTip(i18n("nebula_war_text_0512"))
				return
			end
			self.myTeam:reqCancelSuperTeam()
			SoraDShowLoading(self:displayObject())
		end
	end)
end
function NebulaWarSignUpBeginPanel:updateSignUpNum(num)
	self.fields.Text_num:setString(tostring(num))
end
return NebulaWarSignUpBeginPanel

local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceProsperityDonatePanel = class("AllianceProsperityDonatePanel", baseFguiPanel)
function AllianceProsperityDonatePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceProsperityDonatePanel:ctor", self.viewName)
end
function AllianceProsperityDonatePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceProsperityDonatePanel:onInit()
	print("=======AllianceProsperityDonatePanel:onInit")
	self.fields.LoadingBar_progress:fixChildrenPos()
	self.prePercent = 0
	self.needExitEffect = false
	self.fields.Panel_bg:setString(i18n("common_text_284"))
	local addValue = constantRead.getConstValue("ADD_PROSPERITY_EVERY_TIME", 10)
	_ENV = i18n("common_text_284")
	i18n("common_text_284").num = addValue
	self.fields.Text_tips:setString(i18n("alliance_prosperity_text_18", i18n("common_text_284")))
	self.fields.Text_time:setTimeEndListener(function()
		self:refreshTime()
	end)
	self.fields.LoadingBar_progress:setMax(100)
	for i = 1, 3 do
		self.fields["Com_Donate" .. i]:setDonateType(i)
		self.fields["Com_Donate" .. i]:setHandle(handler(self, self.donateBtnCallBack))
	end
end
function AllianceProsperityDonatePanel:onShow()
	print("=======AllianceProsperityDonatePanel:onShow")
	self:initData()
end
function AllianceProsperityDonatePanel:initData()
	self:refreshProsperity()
	self:refreshPopularity()
	local remainCount = allianceScience:getProsperityRemainCount()
	local maxNum = constantRead.getConstValue("PROSPERITY_DONATE_MAX_NUM", 10)
	allianceScience = nil
	;(nil).num = remainCount
	;(nil).maxnum = maxNum
	self.fields.Text_count:setString(i18n("alliance_prosperity_text_16", nil))
	for i = 1, 3 do
		self.fields["Com_Donate" .. i]:initData()
	end
	if remainCount <= 0 then
		for i = 1, 3 do
			self.fields["Com_Donate" .. i]:btnStateChange(false, true)
		end
	end
	self:refreshTime()
end
function AllianceProsperityDonatePanel:refreshTime()
	self.isLock = allianceScience:isDonatePopularityLock()
	if self.isLock then
		self.fields.Text_time:setTitleColor(display.COLOR_RED)
	else
		self.fields.Text_time:setTitleColor(cc.c3b(105, 179, 229))
	end
	self.fields.Node_time:setVisible(false)
	local remianTime = allianceScience:getDonatePopularityRemainTime()
	if 0 < remianTime then
		self.fields.Text_time:beginTime(remianTime)
		self.fields.Node_time:setVisible(true)
	end
end
function AllianceProsperityDonatePanel:donateBtnCallBack(id, donateType)
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local curtime = serviceFunctions.systemTime()
	local needtime = constantRead.getConstValue("ALLIANCE_PROSPERITY_DONATE_TIME", 14400)
	if needtime >= curtime - jointime then
		SoraDShowMsgTip(i18n("alliance_prosperity_text_17"))
		return
	end
	if self.isLock then
		memberMgr = "common_text_656"
		;("common_text_656").speedUpName = i18n("common_text_655")
		;("common_text_656").isBySelf = false
		;("common_text_656").isAllianceTech = true
		;("common_text_656").timeHandler = function()
			if tolua.isnull(self) then
				if speedUpBox then
					speedUpBox:close()
				end
				return 0
			end
			return self.fields.Text_time:getTimeNumber()
		end
		local speedUpBox = SoraDShowSpeedUpBox(nil, handler(self, self.speedUpCallBack), i18n("common_text_656"), "common_text_656")
	elseif self.isLock == false then
		SoraDShowLoading(self)
		for i = 1, 3 do
			self.fields["Com_Donate" .. i]:btnStateChange(false, true)
		end
		allianceScience:reqDonatePopularity(donateType)
	end
end
function AllianceProsperityDonatePanel:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		allianceScience:reqCleanDonatePopularityCD()
		SoraDShowLoading(self)
	end
end
function AllianceProsperityDonatePanel:refreshProsperity()
	local prosperity = allianceScience:getProsperity()
	allianceScience = nil
	;(nil).num = string.formatnumberthousands(prosperity)
	self.fields.Text_des:setString(i18n("alliance_prosperity_text_14", nil))
end
function AllianceProsperityDonatePanel:refreshPopularity()
	local percent = allianceScience:getPopularity() / 100
	self.fields.LoadingBar_progress:setValue(percent)
	allianceScience = nil
	;(nil).value = percent
	self.fields.LoadingBar_progress:getChild("Text_curPoint"):setString(i18n("alliance_prosperity_text_15", nil))
	if percent >= self.prePercent then
		self.prePercent = percent
	else
		self.needExitEffect = true
	end
end
function AllianceProsperityDonatePanel:onHide()
	if self.needExitEffect then
		_ENV = nil
		;(nil).msg = "MESSAGE_ALLIANCE_POPULARITY_FULL"
		SoraDSendMessage(nil)
	end
end
return AllianceProsperityDonatePanel

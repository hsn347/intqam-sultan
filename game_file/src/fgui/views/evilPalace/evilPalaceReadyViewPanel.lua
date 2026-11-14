local monsterpalaceCtrl = SoraDGetCtrl("monsterpalaceCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local evilPalaceReadyViewPanel = class("evilPalaceReadyViewPanel", baseFguiPanel)
function evilPalaceReadyViewPanel:ctor(...)
	evilPalaceReadyViewPanel.super.ctor(self, ...)
	print("evilPalaceReadyViewPanel:ctor", self.viewName)
end
function evilPalaceReadyViewPanel:onInit()
	print("=======evilPalaceReadyViewPanel:onInit")
	self.activityID = gActivityTimeActivityID.MONSTERPALACE_ACTIVITY
	self.boolRightBtn = false
	self.fields.Com_title:initData(i18n("common_text_3263"), handler(self, self.onClickClose))
	self.fields.Button_exchange:setString(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self.Text_addition = SoraDCreateTimerLabel(self, self.fields.Text_addition)
	self.Text_addition:setTimeLast(function(ticket)
		return string.format([[
%s
%s]], i18n("magic_underground_text_01"), ticket)
	end)
	self.Text_rightCD = SoraDCreateTimerLabel(self, self.fields.Text_rightCD)
	self.Text_rightCD:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_606", nil)
	end)
	self.Text_rightTimeOutCD = SoraDCreateTimerLabel(self, self.fields.Text_rightTimeOutCD)
	self.Text_rightTimeOutCD:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.fields.Icon_word:setSpriteFrame(SoraDFIsRA() and "frame_9001040_ar.png" or "frame_9001040_en.png")
	self.fields.Button_exchange:fixPos()
	self.fields.icon_add:fixPos()
	self.Text_addition:fixPos()
end
function evilPalaceReadyViewPanel:onShow()
	print("=======evilPalaceReadyViewPanel:onShow")
	self:req4Info()
	self:refreshTimerLabel()
end
function evilPalaceReadyViewPanel:endShow()
	SoraDGetCtrl("guideCtrl"):updateGuideModule(gGuideModule.MP_OPT)
end
function evilPalaceReadyViewPanel:req4Info()
	SoraDShowLoading(self)
	monsterpalaceCtrl:entranceinfoReq()
end
function evilPalaceReadyViewPanel:refreshTimerLabel()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MONSTERPALACE_ENHANCE) then
		self.controllers.c1:setSelectedIndex(1)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local endtime = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.MONSTERPALACE_ENHANCE)
		self.Text_addition:beginTime(endtime - serviceFunctions.systemTime())
	else
		self.controllers.c1:setSelectedIndex(0)
		self.Text_addition:endTime()
	end
end
function evilPalaceReadyViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	self.eliteTimer = monsterpalaceCtrl:getEliteQueuetimer()
	self.initInfo = monsterpalaceCtrl:getInitInfo()
	self:initView()
end
function evilPalaceReadyViewPanel:initView()
	self.fields.Com_bottom:initData(self.initInfo)
	if MONSTERPALACE_ELITE_STATUS_OPEN == self.initInfo.elitestatus then
		self.boolRightBtn = true
		if self.eliteTimer then
			local ticket = self.eliteTimer.timerNode.timer:getRemainTime()
			self.Text_rightTimeOutCD:beginTime(ticket)
		end
		self.Text_rightCD:setVisible(false)
		self.fields.sheer:setVisible(false)
	elseif MONSTERPALACE_ELITE_STATUS_CLOSE == self.initInfo.elitestatus then
		self.boolRightBtn = false
		if self.eliteTimer then
			local ticket = self.eliteTimer.timerNode.timer:getRemainTime()
			self.Text_rightCD:beginTime(ticket)
		end
		self.Text_rightCD:setVisible(true)
		self.fields.sheer:setVisible(true)
	end
	self:checkTips()
end
function evilPalaceReadyViewPanel:checkTips(target, data)
	self.fields.Button_exchange:setRedVisible(monsterpalaceCtrl:judgeIsEnough())
	self.fields.Com_bottom:setRed()
end
function evilPalaceReadyViewPanel:btnExchangeClick()
	SoraDPlaySound()
	uiManager:show("evilPalaceExchangeView")
end
function evilPalaceReadyViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_leftChallenge" then
		return self.fields.Com_bottom:getTarget("Button_leftChallenge")
	else
		return self.fields[itemName]
	end
end
return evilPalaceReadyViewPanel

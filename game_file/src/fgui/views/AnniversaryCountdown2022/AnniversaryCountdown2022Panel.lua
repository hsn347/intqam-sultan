local annivCountdown2022Ctrl = SoraDGetCtrl("annivCountdown2022Ctrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AnniversaryCountdown2022Panel = class("AnniversaryCountdown2022Panel", baseFguiPanel)
_ENV = "AnniversaryCountdown2022Panel"
;("AnniversaryCountdown2022Panel").COUNTDOWN = 1
;("AnniversaryCountdown2022Panel").WELFARE = 2
local ("AnniversaryCountdown2022Panel").BAG, viewType = 3, "AnniversaryCountdown2022Panel"
function AnniversaryCountdown2022Panel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AnniversaryCountdown2022Panel:ctor", self.viewName)
end
function AnniversaryCountdown2022Panel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AnniversaryCountdown2022"
		self._packageList, self._packageList[2] = self._packageList, "NebulaWonderland"
		self._packageList, self._packageList[3] = self._packageList, "Activity2112"
	end
	return self._packageList
end
function AnniversaryCountdown2022Panel:onInit()
	print("=======AnniversaryCountdown2022Panel:onInit")
	annivCountdown2022Ctrl:sendReqInitDataMsg()
	self.activityID = gActivityTimeActivityID.ANNIVERSARY_2022_ACTIVITY
	self:initTime()
	self.fields.Com_title:initData(i18n("activity_name_9001452"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = i18n("activity_name_9001452")
	_ENV, _ENV, i18n("activity_name_9001452").defaultClick = self, self:getDefaultClick(), self:getDefaultClick()
	_ENV, self:getDefaultClick()[1], self.title = self, self, i18n("goldenyears_text_02")
	_ENV, self:getDefaultClick()[2], self.title = self, self, i18n("goldenyears_text_03")
	i18n("activity_name_9001452").tabsetArray, self:getDefaultClick()[3], self.title = self:getDefaultClick(), self, i18n("goldenyears_text_04")
	i18n("activity_name_9001452").callback = handler(self, self.onClickTabBtn)
	self.fields.Panel_tab:initView((i18n("activity_name_9001452")))
	_ENV = self.fields.Panel_tab.initView
	function self.fields.Panel_tab.initView.countdown()
		self.fields.Com_countdown:initData()
	end
	function self.fields.Panel_tab.initView.sign()
		self.fields.Com_sign:initData()
	end
	self.funcMap, self.fields.Panel_tab.initView.giftBag = self.fields.Panel_tab.initView, function()
		self.fields.Com_giftBag:initData()
	end
end
function AnniversaryCountdown2022Panel:initData()
	self.fields.Com_countdown:initData()
	self.fields.Com_sign:initData()
	self.fields.Com_giftBag:initData()
	self:refreshRedPoint()
end
function AnniversaryCountdown2022Panel:refreshPage(data)
	self:refreshRedPoint()
	self.funcMap[data.subMsg]()
end
function AnniversaryCountdown2022Panel:getDefaultClick(...)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		return viewType.COUNTDOWN
	end
	local state = annivCountdown2022Ctrl:getCountDownRewardState()
	if state == 2 then
		return viewType.COUNTDOWN
	end
	return viewType.WELFARE
end
function AnniversaryCountdown2022Panel:onClickTabBtn(index)
	if index ~= viewType.COUNTDOWN and not activityShowCtrl:isActivityOpen(self.activityID) then
		self.fields.Panel_tab:setToTab(viewType.COUNTDOWN)
		SoraDShowMsgTip(i18n("common_text_608"))
		return
	end
	self.controllers.c_viewtype:setSelectedIndex(index - 1)
	self.curTabIndex = index
	self.fields.Com_giftBag:initData()
end
function AnniversaryCountdown2022Panel:refreshRedPoint()
	local state = annivCountdown2022Ctrl:getCountDownRewardState()
	local isRed = state == 2
	self.fields.Panel_tab:setBtnRedDot(viewType.COUNTDOWN, isRed, state == 2 and 1 or 0)
	local retNum = annivCountdown2022Ctrl:getSignNum()
	isRed = 0 < retNum
	self.fields.Panel_tab:setBtnRedDot(viewType.WELFARE, isRed, retNum)
end
function AnniversaryCountdown2022Panel:initTime(...)
	self:refreshTime()
	self.fields.Label_time:setTimeUpdateListener(function()
		self.fields.Com_countdown:refreshLeftDay()
	end)
	self.fields.Label_time:setTimeEndListener(function()
		self:refreshTime()
	end)
end
function AnniversaryCountdown2022Panel:refreshTime()
	local txt_time = self.fields.txt_time
	local isOpen = activityShowCtrl:isActivityOpen(self.activityID)
	local timeKey = isOpen and "common_text_607" or "common_text_606"
	if not isOpen then
		self:refreshLeftDay(leftTime)
	end
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		self.fields.Label_time:initActivityTimeStyle(self.activityID, timeKey)
	end
end
function AnniversaryCountdown2022Panel:refreshLeftDay()
	self.fields.Com_countdown:refreshLeftDay()
end
function AnniversaryCountdown2022Panel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("anniversary_2022_text_03")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return AnniversaryCountdown2022Panel

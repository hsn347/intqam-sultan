local gametop = gModuleMgr.getObject("gametop")
local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ThirtyDaySign2021MainViewPanel = class("ThirtyDaySign2021MainViewPanel", baseFguiPanel)
function ThirtyDaySign2021MainViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ThirtyDaySign2021MainViewPanel:ctor", self.viewName)
end
function ThirtyDaySign2021MainViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ThirtyDaySign2021"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ThirtyDaySign2021MainViewPanel:onInit()
	print("=======ThirtyDaySign2021MainViewPanel:onInit")
	self:fixSizeAndPos()
	self.fields.fill:fix()
	local lang = SoraDGetDefaultLanguage()
	self.lang = lang
	self.fields.ay:setVisible(lang == "ar")
	self.fields.yy:setVisible(lang ~= "ar")
	self.fields.topBgAr:setVisible(lang == "ar")
	self.fields.topBg:setVisible(lang ~= "ar")
	self.fields.Com_title:initData(i18n("common_text_2878"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = "common_text_2880"
	;("common_text_2880").sd = "10"
	;("common_text_2880").ed = "20"
	self.fields.Text_serverTime:setString(i18n("common_text_2880"), "common_text_2880")
	local startDate = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY)
	local endDate = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY)
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).sd = _pq(os.date("%Y-%m-%d", endDate))
	handler(self, self.onClickHelp).ed = _pq(os.date("%Y-%m-%d", startDate))
	local str1 = i18n("common_text_2880", handler(self, self.onClickHelp))
	_ENV = _pq(os.date("%Y-%m-%d", startDate))
	_pq(os.date("%Y-%m-%d", startDate)).sd = _pq(os.date("%Y-%m-%d", startDate))
	_pq(os.date("%Y-%m-%d", startDate)).ed = _pq(os.date("%Y-%m-%d", endDate))
	local str2 = i18n("common_text_2880", (_pq(os.date("%Y-%m-%d", startDate))))
	if SoraDFIsRA() then
		self.fields.Text_serverTime:setString(str1)
	else
		self.fields.Text_serverTime:setString(str2)
	end
	self:initData(1)
	local i = 1
	_UPVALUE3_ = self
	self[1] = "common_text_2882"
	self[2] = "common_text_2883"
	local self[3], noteTipNumsPool = "common_text_2884", self
	self.fields.Text_tip:setString(i18n(noteTipNumsPool[1]))
	i = i + 1
	self.transitions.t0:setHook("End", function()
		self.fields.Text_tip:setString(i18n(noteTipNumsPool[i]))
	end)
	self:bottomTipLoop()
	self:setEffect()
end
function ThirtyDaySign2021MainViewPanel:setEffect()
	self.fields.Usm_main:setBlendFunc(gl.ONE, gl.ONE)
end
function ThirtyDaySign2021MainViewPanel:fixSizeAndPos()
	if display.width / display.height < 0.5633802816901409 then
		if display.width / display.height < 0.47176046176046177 then
			self.fields.bg:setScale(1)
			self.fields.List_day:setScale(1)
			self.fields.bg:setPositionY(285)
			self.fields.Text_accuTimes:setPositionY(311)
			self.fields.topBg:setPositionY(77)
			self.fields.topBgAr:setPositionY(77)
			self.fields.Usm_main:setScale(1)
		else
			self.fields.bg:setPositionY(244)
		end
	elseif display.width / display.height > 0.6666666666666666 then
		self.fields.bg:setScale(0.795)
		self.fields.List_day:setScale(0.795)
		local offset = self.fields.bg:getHeight() * 0.20499999999999996 * 0.20499999999999996
		self.fields.bg:setPositionY(self.fields.bg:getPositionY() + offset)
		self.fields.Text_accuTimes:setPositionY(self.fields.Text_accuTimes:getPositionY() + offset)
		self.fields.topBg:setPositionY(self.fields.topBg:getPositionY() + offset)
		self.fields.topBgAr:setPositionY(self.fields.topBgAr:getPositionY() + offset)
	end
end
function ThirtyDaySign2021MainViewPanel:initData(flag)
	if flag and flag == 1 then
		if self.lang == "en" then
			self.fields.point:setPositionX(self.fields.fill:getPositionX())
			self.fields.point:setPositionY(self.fields.fill:getPositionY())
			self.rightOriginX = self.fields.point:getPositionX() - 2
			self.rightOriginY = self.fields.fill:getPositionY()
		else
			self.rightOriginX = self.fields.point:getPositionX() - 2
			self.rightOriginY = self.fields.fill:getPositionY()
		end
	end
	self:setProcessBar()
	_ENV = self.fields.fill:getPositionY()
	self.fields.fill:getPositionY().day = signRewardCtrl:getTotalSignDay()
	self.fields.Text_accuTimes:setString(i18n("common_text_2879", self.fields.fill:getPositionY()))
	self.fields.List_accuDay:setItemRenderer(handler(self, self.onItemRedererCumuDay))
	self.fields.List_accuDay:setNumItems(#signRewardCtrl:getCumuDayArray())
	self.fields.List_day:setItemRenderer(handler(self, self.onItemRedererDay))
	self.fields.List_day:setNumItems(signRewardCtrl:getTotalDay())
	if 1 <= signRewardCtrl:getCurDay() and signRewardCtrl:getCurDay() <= 30 then
		self.fields.List_day:scrollToView(signRewardCtrl:getCurDay() - 1)
	end
end
_UPVALUE23_, ThirtyDaySign2021MainViewPanel.setProcessBar = function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end, function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[1] = 17
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[2] = 36
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[3] = 45
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[4] = 47
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[5] = 42
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[6] = 30
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[7] = 3
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[8] = 3
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[9] = 30
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[10] = 42
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[11] = 47
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[12] = 45
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[13] = 36
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[14] = 17
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[15] = 3
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[16] = 17
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[17] = 36
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[18] = 45
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[19] = 47
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[20] = 42
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[21] = 30
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[22] = 3
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[23] = 3
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[24] = 30
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[25] = 42
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[26] = 47
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[27] = 45
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[28] = 36
;(function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[29] = 17
local (function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end)[30], pointOffsetArray = 3, function(self)
	local day = signRewardCtrl:getTotalSignDay()
	local totalDay = signRewardCtrl:getTotalDay()
	self.fields.fill:setFillAmount(day / totalDay)
	self:setHighlightPoint(day, totalDay)
end
function ThirtyDaySign2021MainViewPanel:setHighlightPoint(day, totalDay)
	if day == 0 then
		return
	end
	if self.lang == "en" then
		self.fields.point:setPositionX(self.rightOriginX + self.fields.fill:getWidth() * (day / totalDay) - 3)
		self.fields.point:setPositionY(self.rightOriginY + pointOffsetArray[day])
	else
		self.fields.point:setPositionX(self.rightOriginX - self.fields.fill:getWidth() * (day / totalDay) + 13)
		self.fields.point:setPositionY(self.rightOriginY + pointOffsetArray[day])
	end
end
function ThirtyDaySign2021MainViewPanel:onItemRedererCumuDay(index, object)
	object:initData(index + 1)
end
function ThirtyDaySign2021MainViewPanel:onItemRedererDay(index, object)
	object:initData(index + 1)
end
function ThirtyDaySign2021MainViewPanel:refreshDay(target, data)
	self:setProcessBar()
	_ENV = nil
	;(nil).day = signRewardCtrl:getTotalSignDay()
	self.fields.Text_accuTimes:setString(i18n("common_text_2879", nil))
	local obj = self.fields.List_day:getChildAt(data.blockDay - 1)
	obj:showEffect()
end
function ThirtyDaySign2021MainViewPanel:refreshCumuDay(target, data)
	self.fields.List_accuDay:setItemRenderer(handler(self, self.onItemRedererCumuDay))
	self.fields.List_accuDay:setNumItems(#signRewardCtrl:getCumuDayArray())
end
function ThirtyDaySign2021MainViewPanel:onClickItem(context)
	local item = context:getGObjectData()
	item:onClickDay()
end
function ThirtyDaySign2021MainViewPanel:bottomTipLoop()
	self.transitions.t0:play(-1, 0)
end
function ThirtyDaySign2021MainViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_2881")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function ThirtyDaySign2021MainViewPanel:onShow()
	print("=======ThirtyDaySign2021MainViewPanel:onShow")
end
function ThirtyDaySign2021MainViewPanel:onHide()
	print("=======ThirtyDaySign2021MainViewPanel:onHide")
end
function ThirtyDaySign2021MainViewPanel:onDispose()
	print("=======ThirtyDaySign2021MainViewPanel:onDispose")
end
return ThirtyDaySign2021MainViewPanel

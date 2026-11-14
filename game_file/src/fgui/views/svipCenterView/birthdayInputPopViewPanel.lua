local publicRead = include("publicRead")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local MIN_YEAR = 1900
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local birthdayInputPopViewPanel = class("birthdayInputPopViewPanel", baseFguiPanel)
_ENV = "birthdayInputPopViewPanel"
;("birthdayInputPopViewPanel")[1] = 31
;("birthdayInputPopViewPanel")[2] = 29
;("birthdayInputPopViewPanel")[3] = 31
;("birthdayInputPopViewPanel")[4] = 30
;("birthdayInputPopViewPanel")[5] = 31
;("birthdayInputPopViewPanel")[6] = 30
;("birthdayInputPopViewPanel")[7] = 31
;("birthdayInputPopViewPanel")[8] = 31
;("birthdayInputPopViewPanel")[9] = 30
;("birthdayInputPopViewPanel")[10] = 31
;("birthdayInputPopViewPanel")[11] = 30
local ("birthdayInputPopViewPanel")[12], dayList = 31, "birthdayInputPopViewPanel"
THIRTY_DAYS_TIME = 2592000
function birthdayInputPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("birthdayInputPopViewPanel:ctor", self.viewName)
end
function birthdayInputPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function birthdayInputPopViewPanel:onInit()
	print("=======birthdayInputPopViewPanel:onInit")
	self:initControls()
	self:initData()
end
function birthdayInputPopViewPanel:onShow()
	print("=======birthdayInputPopViewPanel:onShow")
end
function birthdayInputPopViewPanel:initControls()
	self.txtInputTitle = self.fields.txtInputTitle
	self.btnConfirm = self.fields.btnConfirm
	self.txtMonth = self.fields.txtMonth
	self.txtDay = self.fields.txtDay
	self.txtYear = self.fields.txtYear
	self.txtRemainTime = self.fields.txtRemainTime
	self.fields.Panel_bg:setTitle(i18n("privilege_text_129"))
	self.txtInputTitle:setString(i18n("privilege_text_28"))
	self.btnConfirm:setTitleText(i18n("common_text_204"))
	self.txtMonth:setString(i18n("common_text_4486"))
	self.txtDay:setString(i18n("common_text_4487"))
	self.txtYear:setString(i18n("common_text_4954"))
	self.btnConfirm:addTouchEventListener(handler(self, self.btnConfirmClick))
	self.editBoxYear = self.fields.editBoxYear
	self.editBoxYear:addEventListener(fgui.UIEventType.Changed, handler(self, self.onEditBoxChange))
	self.editBoxYear:addEventListener(fgui.UIEventType.Submit, handler(self, self.onEditBoxSubmit))
	self.editBoxMonth = self.fields.editBoxMonth
	self.editBoxMonth:addEventListener(fgui.UIEventType.Changed, handler(self, self.onEditBoxChange))
	self.editBoxMonth:addEventListener(fgui.UIEventType.Submit, handler(self, self.onEditBoxSubmit))
	self.editBoxDay = self.fields.editBoxDay
	self.editBoxDay:addEventListener(fgui.UIEventType.Changed, handler(self, self.onEditBoxChange))
	self.editBoxDay:addEventListener(fgui.UIEventType.Submit, handler(self, self.onEditBoxSubmit))
	self.txtRemainTime = SoraDCreateTimerLabel(self, self.txtRemainTime)
	self.txtRemainTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("privilege_text_31", nil)
	end)
	self.txtRemainTime:setTimeEndListener(function()
		self:initData()
	end)
	local remainTime = exaltedPrivilegeCtrl:getBirthdaySettingTime() - serviceFunctions.systemTime() + THIRTY_DAYS_TIME
	if 0 < remainTime then
		self.txtRemainTime:beginTime(remainTime)
	else
		self.txtRemainTime:setVisible(false)
	end
end
function birthdayInputPopViewPanel:initData()
	local gold = lordInfoCtrl:getBaseInfo().gold
	if not exaltedPrivilegeCtrl:getBirthdayInfo() then
		local lordInfoCtrl, birthdayInfo = exaltedPrivilegeCtrl:getBirthdayInfo(), exaltedPrivilegeCtrl:getBirthdayInfo()
	end
	dump(birthdayInfo, "birthdayInfo====")
	if next(birthdayInfo) then
		self.editBoxDay:setPromptHolder(birthdayInfo.day or "")
		self.editBoxMonth:setPromptHolder(birthdayInfo.month or "")
		self.editBoxYear:setPromptHolder(birthdayInfo.year or "")
	else
		self.editBoxDay:setPromptHolder("")
		self.editBoxMonth:setPromptHolder("")
		self.editBoxYear:setPromptHolder("")
	end
	local remainTime = exaltedPrivilegeCtrl:getBirthdaySettingTime() - serviceFunctions.systemTime() + THIRTY_DAYS_TIME
	if 0 < remainTime then
		self.controllers.c1:setSelectedIndex(1)
		self:updateBtnConfirm(not birthdayInfo.year)
		self.btnConfirm:setBright(false)
		self.txtRemainTime:setVisible(true)
		self.txtInputTitle:setVisible(false)
		self.txtRemainTime:beginTime(remainTime)
	else
		self.controllers.c1:setSelectedIndex(0)
		if next(birthdayInfo) then
			self:updateBtnConfirm(not birthdayInfo.year)
			self.txtRemainTime:setVisible(false)
			self.txtInputTitle:setVisible(true)
			self.btnConfirm:setBright(false)
		else
			self:updateBtnConfirm(true)
			self.txtRemainTime:setVisible(false)
			self.txtInputTitle:setVisible(true)
			self.btnConfirm:setBright(true)
		end
	end
end
function birthdayInputPopViewPanel:updateBtnConfirm(isFree)
	if isFree then
		self.btnConfirm:setFreeTitle(i18n("common_text_204"), 1)
	else
		self.btnConfirm:setCostNum(200)
		self.btnConfirm:setTitle(i18n("common_text_243"))
	end
end
function birthdayInputPopViewPanel:onEditBoxChange(context)
	local getInput = function(ocx)
		local oldInput = ocx:getText()
		local newInput = math.floor(tonumber(oldInput) or 0)
		return newInput
	end
	local editBox = context:getSender()
	local newInput = getInput(editBox)
	if editBox == self.editBoxMonth then
		if newInput <= 0 then
			newInput = 1
		elseif 12 < newInput then
			newInput = 12
		end
		if self.newDayInput and self.newDayInput > dayList[tonumber(newInput)] then
			self.newDayInput = dayList[tonumber(newInput)]
		end
		self.newMonthInput = newInput
	elseif editBox == self.editBoxDay then
		if newInput <= 0 then
			newInput = 1
		end
		if self.newMonthInput and newInput > dayList[tonumber(self.newMonthInput)] then
			newInput = dayList[tonumber(self.newMonthInput)]
		end
		self.newDayInput = math.min(newInput, 31)
	elseif editBox == self.editBoxYear then
		local curVal = os.date("!*t", serviceFunctions.systemTime())
		if newInput < MIN_YEAR then
			newInput = MIN_YEAR
		elseif newInput > curVal.year then
			newInput = curVal.year
		end
		self.newYearInput = newInput
	end
end
function birthdayInputPopViewPanel:onEditBoxSubmit(context)
	SoraDDelayCallOnce("birthdayInputPopView", function()
		if self.editBoxDay and self.editBoxMonth and self.editBoxYear then
			if not exaltedPrivilegeCtrl:getBirthdayInfo() then
				local self, birthdayInfo = exaltedPrivilegeCtrl:getBirthdayInfo(), exaltedPrivilegeCtrl:getBirthdayInfo()
			end
			local dayText = self.newDayInput or tonumber(self.editBoxDay:getText()) or birthdayInfo.day or ""
			local monthText = self.newMonthInput or tonumber(self.editBoxMonth:getText()) or birthdayInfo.month or ""
			local yearText = self.newYearInput or tonumber(self.editBoxYear:getText()) or birthdayInfo.year or ""
			self.editBoxMonth:setText(monthText)
			self.editBoxDay:setText(dayText)
			self.editBoxYear:setText(yearText)
			self.editBoxDay:setPromptHolder("")
			self.editBoxMonth:setPromptHolder("")
			self.editBoxYear:setPromptHolder("")
			print("输入完成...", dayText, monthText, yearText)
			if dayText ~= "" and monthText ~= "" and yearText ~= "" then
				self.btnConfirm:setBright(true)
			end
			local isFree = not birthdayInfo.year
			if tonumber(dayText) ~= birthdayInfo.day or tonumber(monthText) ~= birthdayInfo.month then
				isFree = false
			end
			self:updateBtnConfirm(isFree)
		end
	end)
end
function birthdayInputPopViewPanel:btnConfirmClick(button, type)
	SoraDPlaySound()
	if not exaltedPrivilegeCtrl:getBirthdayInfo() then
		local _ENV, birthdayInfo = exaltedPrivilegeCtrl:getBirthdayInfo(), exaltedPrivilegeCtrl:getBirthdayInfo()
	end
	local remainTime = exaltedPrivilegeCtrl:getBirthdaySettingTime() - serviceFunctions.systemTime() + THIRTY_DAYS_TIME
	local gold = lordInfoCtrl:getBaseInfo().gold
	local tempMonth = self.editBoxMonth:getText()
	local tempDay = self.editBoxDay:getText()
	local tempYear = self.editBoxYear:getText()
	dump(birthdayInfo, "birthdayInfo")
	local isFirstSetYear = not birthdayInfo.year and tonumber(tempMonth) == birthdayInfo.month and tonumber(tempDay) == birthdayInfo.day
	if gold < 200 and not isFirstSetYear then
		SoraDShowMsgTip(i18n("artifact_text_20"))
		return
	end
	if 0 < remainTime and not isFirstSetYear then
		SoraDShowMsgTip(i18n("privilege_text_32"))
		return
	elseif next(birthdayInfo) then
		if tempMonth == "" or tempDay == "" or tempYear == "" then
			SoraDShowMsgTip(i18n("privilege_text_179"))
			return
		elseif tonumber(tempMonth) == birthdayInfo.month and tonumber(tempDay) == birthdayInfo.day and tonumber(tempYear) == birthdayInfo.year then
			SoraDShowMsgTip(i18n("privilege_text_179"))
			return
		end
	elseif tempMonth == "" or tempDay == "" or tempYear == "" then
		SoraDShowMsgTip(i18n("privilege_text_29"))
		return
	end
	self.editBoxDay:setPromptHolder("")
	self.editBoxMonth:setPromptHolder("")
	self.editBoxYear:setPromptHolder("")
	local msg = isFirstSetYear and i18n("privilege_text_145") or i18n("privilege_text_30")
	SoraDShowMsgBox(msg, i18n("common_text_054"), nil, function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			exaltedPrivilegeCtrl:reqSetBirthday(tonumber(tempMonth), tonumber(tempDay), tonumber(tempYear))
		end
	end)
end
return birthdayInputPopViewPanel

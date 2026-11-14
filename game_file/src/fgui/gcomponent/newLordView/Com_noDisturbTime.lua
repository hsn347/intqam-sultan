local gametop = gModuleMgr.getObject("gametop")
local noticeCtrl = gametop.playertop_:getModule("noticeCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_noDisturbTime = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_noDisturbTime", Com_noDisturbTime)
_ENV = fgui.register_extension
fgui.register_extension.sNoDistrubTime = "System:GameMessageView:NoDisturbStart~integer"
local fgui.register_extension.eNoDistrubTime, localSettings = "System:GameMessageView:NoDisturbEnd~integer", fgui.register_extension
function Com_noDisturbTime:onInit()
	self.fields.n45:fixPos()
	self.fields.Text_startTimeFlag:fixPos()
	self.fields.Text_endTimeFlag:fixPos()
	self.fields.Text_Time_1:fixPos()
	self.fields.Text_Time_2:fixPos()
	self.fields.n26:fixPos()
	self.fields.n27:fixPos()
	self.fields.n34:fixPos()
	self.fields.n35:fixPos()
	self.fields.Text_startTimeFlag:setString(i18n("common_text_942"))
	self.fields.Text_endTimeFlag:setString(i18n("common_text_943"))
	self.fields.Text_Time_1:setString(":")
	self.fields.Text_Time_2:setString(":")
	for i = 1, 4 do
		self.fields["Panel_time" .. i]:addClickListener(handlerEx(self, self.txtFieldActive, i))
	end
	local sNoDistrubTime = SoraDTimeToDate(SoraDConfigGet(localSettings.sNoDistrubTime))
	local eNoDistrubTime = SoraDTimeToDate(SoraDConfigGet(localSettings.eNoDistrubTime))
	self.fields.TextField_sHour:setString(string.format("%.2d", sNoDistrubTime.hour))
	self.fields.TextField_sMin:setString(string.format("%.2d", sNoDistrubTime.min))
	self.fields.TextField_eHour:setString(string.format("%.2d", eNoDistrubTime.hour))
	self.fields.TextField_eMin:setString(string.format("%.2d", eNoDistrubTime.min))
	_UPVALUE4_ = self.fields.TextField_eMin.setString
	self.textFieldList, self.fields.TextField_eMin.setString[1] = self.fields.TextField_eMin.setString, self.fields.TextField_sHour
	self.textFieldList, self.fields.TextField_eMin.setString[2] = self.fields.TextField_eMin.setString, self.fields.TextField_sMin
	self.textFieldList, self.fields.TextField_eMin.setString[3] = self.fields.TextField_eMin.setString, self.fields.TextField_eHour
	self.textFieldList, self.fields.TextField_eMin.setString[4] = self.fields.TextField_eMin.setString, self.fields.TextField_eMin
end
function Com_noDisturbTime:onShow()
end
function Com_noDisturbTime:formatHour(hour)
	local mHour = tonumber(hour) or 0
	if 23 < mHour or mHour < 0 then
		mHour = 0
	end
	return mHour
end
function Com_noDisturbTime:formatMin(min)
	local mMin = tonumber(min) or 0
	if 59 < mMin or mMin < 0 then
		mMin = 0
	end
	return mMin
end
function Com_noDisturbTime:txtFieldActive(k)
	SoraDPlaySound()
	local low = 0
	local high = 59
	local per = 1
	if k % 2 ~= 0 then
		low = 0
		high = 23
		per = 1
	end
	_ENV = nil
	;(nil).perCount = per
	;(nil).low = low
	;(nil).high = high
	;(nil).flag = self.textFieldList[k]:getName()
	;(nil).handl = handler(self, self.returnFromInput)
	uiManager:show("gameMessageTimeInput", nil)
end
function Com_noDisturbTime:returnFromInput(arg, flag)
	if self.fields[flag] then
		self.fields[flag]:setString(string.format("%.2d", arg))
	end
end
function Com_noDisturbTime:onHide(...)
	local sNoDistrubTime = SoraDTimeToDate(SoraDConfigGet(localSettings.sNoDistrubTime))
	local eNoDistrubTime = SoraDTimeToDate(SoraDConfigGet(localSettings.eNoDistrubTime))
	sNoDistrubTime.hour = self:formatHour(self.fields.TextField_sHour:getText())
	sNoDistrubTime.min = self:formatMin(self.fields.TextField_sMin:getText())
	eNoDistrubTime.hour = self:formatHour(self.fields.TextField_eHour:getText())
	eNoDistrubTime.min = self:formatMin(self.fields.TextField_eMin:getText())
	dump(sNoDistrubTime, "sNoDistrubTime")
	dump(eNoDistrubTime, "eNoDistrubTime")
	SoraDConfigSet(localSettings.sNoDistrubTime, SoraDDateToTime(sNoDistrubTime))
	SoraDConfigSet(localSettings.eNoDistrubTime, SoraDDateToTime(eNoDistrubTime))
	noticeCtrl:setNotDisturbTime(string.format("%.2d", sNoDistrubTime.hour), string.format("%.2d", sNoDistrubTime.min), string.format("%.2d", eNoDistrubTime.hour), string.format("%.2d", eNoDistrubTime.min))
end
return Com_noDisturbTime

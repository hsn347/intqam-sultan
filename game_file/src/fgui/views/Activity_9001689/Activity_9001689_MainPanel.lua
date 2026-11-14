local constantRead = include("constantRead")
local activityTimeRead = include("activityTimeRead")
local activity_9001689_Ctrl = SoraDGetCtrl("activity_9001689_Ctrl")
local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001689_MainPanel = class("Activity_9001689_MainPanel", baseFguiPanel)
function Activity_9001689_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001689_MainPanel.super.ctor(self, ...)
	print("Activity_9001689_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE_BRIBE
end
function Activity_9001689_MainPanel:onInit()
	print("=======Activity_9001689_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(activityTimeRead.getActivityShowName(self.activityID), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
end
function Activity_9001689_MainPanel:endShow()
	print("=======Activity_9001689_MainPanel:endShow")
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self:initView()
end
function Activity_9001689_MainPanel:initView()
	local status, leftTime = activity_9001688_Ctrl:getCycleState()
	self.fields.Button_go:setString(status == 0 and i18n("daily_salute_text10") or i18n("daily_salute_text13"))
	self.fields.Text_time:setTimeLast(function(strTime)
		if status == 0 then
			status = nil
			;(nil).time = strTime
			if i18n("daily_salute_text12", nil) then
				goto lbl_16
			end
		end
		status = nil
		;(nil).time = strTime
		::lbl_16::
		return (i18n("daily_salute_text11", nil))
	end)
	self.fields.Text_time:beginTime(leftTime)
	local times = activity_9001689_Ctrl:getRemainTimes()
	activity_9001688_Ctrl = i18n("daily_salute_text29")
	i18n("daily_salute_text29").num = fguiHelper.getColorString("#70C723", times)
	self.fields.Lab_status:setString(fguiHelper.getColorString("#FFD43E", i18n("daily_salute_text29")) .. "\n" .. i18n("daily_salute_text30", i18n("daily_salute_text29")))
	local ret, num = activity_9001689_Ctrl:getReceiveStatusAndNum()
	self.fields.Button_go:setReddot(ret)
end
function Activity_9001689_MainPanel:btnGoClick()
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(activity_9001689_Ctrl:getBuildPos())
	SoraDRemoveAllPanelFromManager()
end
function Activity_9001689_MainPanel:onClickHelp()
	SoraDPlaySound()
	local num1 = constantRead.getConstValue("DAILY_SALUTE_BRIBE_PICKUP_NUM")
	local num2 = constantRead.getConstValue("DAILY_SALUTE_BRIBE_NUM")
	_ENV = nil
	_ENV = nil
	;(nil).num1 = num1
	;(nil).num2 = num2
	;(nil).content = i18n("daily_salute_text05", nil)
	uiManager:show("RuleView", nil)
end
return Activity_9001689_MainPanel

local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001610_Ctrl = SoraDGetCtrl("activity_9001610_Ctrl")
local activity_9001610_Read = include("activity_9001610_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001610 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001610/Com_Activity_9001610", Com_Activity_9001610)
function Com_Activity_9001610:onInit()
	self.signArray, _ENV, self.totalArray, _ENV, self.activityID = gActivityTimeActivityID.HONOR_BACK_SIGN, gActivityTimeActivityID.HONOR_BACK_SIGN, gActivityTimeActivityID.HONOR_BACK_SIGN, gActivityTimeActivityID.HONOR_BACK_SIGN, gActivityTimeActivityID.HONOR_BACK_SIGN
	self.fields.Text_title:setString(i18n("common_text_2876"))
	self.fields.Text_tip:setString(i18n("common_text_2882"))
	self.fields.List_total:setItemRenderer(handler(self, self.onTotalRenderer))
	self.fields.List_total:setAlignCenter(true)
	self.fields.List_day:setItemRenderer(handler(self, self.onDayRenderer))
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Btn_help:fixPos()
end
function Com_Activity_9001610:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001610_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.initData))
end
function Com_Activity_9001610:onShow()
	local startDate = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local endDate = activityShowCtrl:getEndTimeSecond(self.activityID)
	if SoraDFIsRA() then
		activityShowCtrl = nil
		;(nil).sd = _pq(os.date("%Y-%m-%d", endDate))
		;(nil).ed = _pq(os.date("%Y-%m-%d", startDate))
		self.fields.Text_serverTime:setString(i18n("common_text_2880", nil))
	else
		activityShowCtrl = i18n("common_text_2880", nil)
		i18n("common_text_2880", nil).sd = _pq(os.date("%Y-%m-%d", startDate))
		i18n("common_text_2880", nil).ed = _pq(os.date("%Y-%m-%d", endDate))
		self.fields.Text_serverTime:setString(i18n("common_text_2880", i18n("common_text_2880", nil)))
	end
	self:initData()
end
function Com_Activity_9001610:onTotalRenderer(index, obj)
	obj:initData(self.totalArray[index + 1], index + 1)
end
function Com_Activity_9001610:onDayRenderer(index, obj)
	obj:initData(self.signArray[index + 1])
end
function Com_Activity_9001610:initData()
	self:initView()
end
function Com_Activity_9001610:initView()
	local totalSignDays = activity_9001610_Ctrl:getTotalSignDay()
	activity_9001610_Ctrl = nil
	;(nil).day = fguiHelper.getColorString("#00FF00", totalSignDays)
	self.fields.Text_totalDay:setString(i18n("common_text_2879", nil))
	local group = activity_9001610_Ctrl:getGroup()
	self.totalArray = activity_9001610_Read.getCumuDayArray(group)
	self.fields.List_total:setNumItems(#self.totalArray)
	self.signArray = activity_9001610_Read.getRewardConfig(group)
	self.fields.List_day:setNumItems(#self.signArray)
end
function Com_Activity_9001610:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_2024_test51")
	uiManager:show("RuleView", nil)
end
return Com_Activity_9001610

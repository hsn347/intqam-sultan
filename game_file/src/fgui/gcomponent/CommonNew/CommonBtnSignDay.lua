local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityCommonSignRead = include("activityCommonSignRead")
local baseComponent = require("fgui.base.baseComponent")
local CommonBtnSignDay = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001623/CommonBtnSignDay", CommonBtnSignDay)
fgui.register_extension("ui://Activity_9001636/CommonBtnSignDay", CommonBtnSignDay)
fgui.register_extension("ui://Activity_9001659/CommonBtnSignDay", CommonBtnSignDay)
fgui.register_extension("ui://Activity_9001687/CommonBtnSignDay", CommonBtnSignDay)
function CommonBtnSignDay:onInit()
	if self.fields.Text_sign then
		self.fields.Text_sign:setString(i18n("common_text_2875"))
	end
	self:addClickListener(handler(self, self.onClickBtnDay))
end
function CommonBtnSignDay:onShow()
end
function CommonBtnSignDay:onClickBtnDay()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).mode = 2
	;(nil).day = self.day
	uiManager:show("CommonSignPop", nil)
end
function CommonBtnSignDay:initData(data)
	self.activityID = data.activityID
	self.day = data.day
	self:updateTextDay()
	if self.controllers.c_state then
		local state = activityCommonSignCtrl:getSignTypeByDay(self.activityID, self.day)
		local cIndex = 0
		if state == gSignRewardType.NO_SIGN then
			local curDay = activityCommonSignCtrl:getCurDay(self.activityID)
			if curDay == self.day then
				cIndex = 1
			elseif curDay > self.day then
				cIndex = 2
			end
		else
			cIndex = 3
		end
		self.controllers.c_state:setSelectedIndex(cIndex)
	end
	if self.activityID == gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY then
		self.fields.mv_1:setAllFrameName("frame_9001659_ppd_%02d.png", 1)
	end
end
function CommonBtnSignDay:updateTextDay(...)
	if not self.fields.Text_day then
		return
	end
	if self.activityID == gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY then
		_ENV = nil
		;(nil).count = self.day
		self.fields.Text_day:setString(i18n("common_text_523", nil))
	else
		self.fields.Text_day:setString(self.day)
	end
end
return CommonBtnSignDay

local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityCommonSignRead = include("activityCommonSignRead")
local baseComponent = require("fgui.base.baseComponent")
local CommonBtnSignBox = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001623/CommonBtnSignBox", CommonBtnSignBox)
fgui.register_extension("ui://Activity_9001636/CommonBtnSignBox", CommonBtnSignBox)
fgui.register_extension("ui://Activity_9001687/CommonBtnSignBox", CommonBtnSignBox)
fgui.register_extension("ui://Activity_9001688/CommonBtnSignBox", CommonBtnSignBox)
function CommonBtnSignBox:onInit()
	self:addClickListener(handler(self, self.onClickBtnBox))
end
function CommonBtnSignBox:onShow()
end
function CommonBtnSignBox:initData(data)
	self.activityID = data.activityID
	self.day = data.day
	if self.fields.title then
		_ENV = nil
		;(nil).day = self.day
		self.fields.title:setString(i18n("common_text_227", nil))
	end
	if self.controllers.c_state then
		local status = activityCommonSignCtrl:getExtraRewardInfoByDay(self.activityID, self.day)
		local cIndex = 0
		if status == gSignRewardStatus.CAN_RECEIVE then
			cIndex = 1
		elseif status == gSignRewardStatus.CAN_NOT_RECEIVE then
			cIndex = 0
		else
			cIndex = 2
		end
		self.controllers.c_state:setSelectedIndex(cIndex)
		if self.activityID == gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY and cIndex == 2 then
			self.fields.title:setColor(cc.c3b(224, 224, 224))
		end
	end
end
function CommonBtnSignBox:onClickBtnBox()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).mode = 1
	;(nil).day = self.day
	uiManager:show("CommonSignPop", nil)
end
return CommonBtnSignBox

local signRewardCtrl = SoraDGetCtrl("signRewardCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_signDay = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001038/Btn_signDay", Btn_signDay)
function Btn_signDay:onInit()
	self.fields.mv_cool:setAllFrameName("dh_chuanqijunwang_%.2d.png", 1)
	self.fields.Text_sign:setString(i18n("common_text_2875"))
	self.fields.Label_reddot:initData(true)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_signDay:onShow()
end
function Btn_signDay:initData(data)
	self.data = data
	self.fields.Text_Day:setString(self.data.day)
	local state = signRewardCtrl:getSignTypeByDay(self.data.day)
	local cIndex = 0
	if state == gSignRewardType.NO_SIGN then
		local curDay = signRewardCtrl:getCurDay()
		if curDay == self.data.day then
			cIndex = 1
		elseif curDay > self.data.day then
			cIndex = 2
		end
	else
		cIndex = 3
	end
	self.controllers.c1:setSelectedIndex(cIndex)
end
function Btn_signDay:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mode = 2
	;(nil).day = self.data.day
	uiManager:show("Activity_9001038_signPop", nil)
end
return Btn_signDay

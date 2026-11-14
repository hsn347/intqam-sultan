local activity_9001610_Ctrl = SoraDGetCtrl("activity_9001610_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_sign = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001610/Btn_sign", Btn_sign)
function Btn_sign:onInit()
end
function Btn_sign:onShow()
end
function Btn_sign:onInit()
	self.fields.mv_cool:setAllFrameName("dh_chuanqijunwang_%.2d.png", 1)
	self.fields.Text_sign:setString(i18n("common_text_2875"))
	self.fields.Label_reddot:initData(true)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_sign:onShow()
end
function Btn_sign:initData(data)
	self.data = data
	self.fields.title:setString(self.data.day)
	local state = activity_9001610_Ctrl:getSignTypeByDay(self.data.day)
	local cIndex = 0
	if state == gSignRewardType.NO_SIGN then
		local curDay = activity_9001610_Ctrl:getCurDay()
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
function Btn_sign:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mode = 2
	;(nil).day = self.data.day
	uiManager:show("Activity_9001610_signPop", nil)
end
return Btn_sign

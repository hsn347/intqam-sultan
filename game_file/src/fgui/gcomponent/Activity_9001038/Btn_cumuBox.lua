local signRewardCtrl = SoraDGetCtrl("signRewardCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_cumuBox = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001038/Btn_cumuBox", Btn_cumuBox)
function Btn_cumuBox:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_cumuBox:onShow()
end
function Btn_cumuBox:initData(day, index)
	self.day = day
	_ENV = nil
	;(nil).day = self.day
	self.fields.title:setString(i18n("common_text_227", nil))
	local status = signRewardCtrl:getExtraRewardInfoByDay(self.day)
	if status == gSignRewardStatus.CAN_RECEIVE then
		self.fields.title:setColor(cc.c3b(255, 243, 146))
		self.fields.Btn_gift:setState(1)
	elseif status == gSignRewardStatus.CAN_NOT_RECEIVE then
		self.fields.title:setColor(cc.c3b(224, 224, 224))
		self.fields.Btn_gift:setState(0)
	else
		self.fields.title:setColor(cc.c3b(101, 101, 101))
		self.fields.Btn_gift:setState(2)
	end
end
function Btn_cumuBox:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).mode = 1
	;(nil).day = self.day
	uiManager:show("Activity_9001038_signPop", nil)
end
return Btn_cumuBox

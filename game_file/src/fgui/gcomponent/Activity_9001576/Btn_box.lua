local signRewadRead = include("signRewadRead")
local activity_9001576_Ctrl = SoraDGetCtrl("activity_9001576_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001576/Btn_box", Btn_box)
function Btn_box:onInit()
	self.fields.Btn_touch:addClickListener(handler(self, self.btnClick))
end
function Btn_box:onShow()
end
function Btn_box:initData()
	local totalSignDay = activity_9001576_Ctrl:getTotalSignDay()
	local nextCumuCfg = signRewadRead.getSonwComCumuSignCfg(totalSignDay)
	dump(nextCumuCfg, "nextCumuCfg===" .. totalSignDay)
	self.data = nextCumuCfg
	self.status = activity_9001576_Ctrl:getExtraRewardInfoByDay(self.data.day)
	activity_9001576_Ctrl = nil
	;(nil).day = self.data.day
	self.fields.Text_title:setString(i18n("newyear_signin_text_02", nil))
	if self.status == gSignRewardStatus.ALREADY_RECEIVE then
		self.fields.Text_title:setString(i18n("common_text_1892"))
		self.controllers.c_status:setSelectedIndex(1)
	else
		self.controllers.c_status:setSelectedIndex(totalSignDay >= self.data.day and 1 or 0)
	end
end
function Btn_box:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).cfg = self.data
	;(nil).isFinal = true
	uiManager:show("Activity_9001576_signPop", nil)
end
return Btn_box

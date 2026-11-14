local htPointMgr = include("htPointMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_point = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_point", Com_point)
function Com_point:onInit()
	self.fields.trialNumTitle:setString(i18n("common_text_1725"))
	self:addClickListener(handler(self, self.btnClick))
end
function Com_point:onShow()
end
function Com_point:setPoint()
	self.fields.trialNum:setString(htPointMgr.getPoint())
end
function Com_point:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).total = HEROTRIAL_TOTAL_COUNT
	_ENV = nil
	;(nil).vip = VIP_LV8_LIMITED
	;(nil).point = HEROTRIAL_VIP8_GET_POINTS
	_ENV = "\n"
	;("\n").float = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("common_text_1750", nil) .. "\n" .. i18n("common_text_1751", nil), "\n")
end
return Com_point

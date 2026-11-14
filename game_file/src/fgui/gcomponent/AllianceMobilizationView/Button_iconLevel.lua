local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_iconLevel = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceMobilizationView/Button_iconLevel", Button_iconLevel)
function Button_iconLevel:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Button_iconLevel:onShow()
end
function Button_iconLevel:setAniLv(lv)
	self.fields.Node_iconLevel:setEffectPath(string.format("animationMobilizationLv%.2d", lv), true)
	local stageName = mobilizationltCtrl:getMobilizationNameByLv(lv)
	self.fields.title:setString(i18n(stageName))
end
function Button_iconLevel:btnClick()
	SoraDPlaySound()
	SoraDCreatePanel("commonInstruction"):show()
end
return Button_iconLevel

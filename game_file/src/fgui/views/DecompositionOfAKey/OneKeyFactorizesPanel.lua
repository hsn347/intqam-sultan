local equipDesRead = include("equipDesRead")
_ENV = "equipDesRead"
;("equipDesRead")[gQualityDef.PURPLE] = "#E66EDC"
local ("equipDesRead")[gQualityDef.ORANGE], colorDef = "#E68246", "equipDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local OneKeyFactorizesPanel = class("OneKeyFactorizesPanel", baseFguiPanel)
function OneKeyFactorizesPanel:ctor(...)
	self.super.ctor(self, ...)
	print("OneKeyFactorizesPanel:ctor", self.viewName)
end
function OneKeyFactorizesPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function OneKeyFactorizesPanel:onInit()
	print("=======OneKeyFactorizesPanel:onInit")
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onBtnOKClick))
end
function OneKeyFactorizesPanel:onShow()
	print("=======OneKeyFactorizesPanel:onShow")
	_ENV = nil
	;(nil).name = fguiHelper.getColorString(colorDef[self.param.quality], equipDesRead.getQualityName(self.param.quality))
	self.fields.title:setString(i18n("disassemble_fast_4", nil))
end
function OneKeyFactorizesPanel:onBtnOKClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_RESOLVE_SURE_CHOOSE"
	;(nil).quality = self.param.quality
	SoraDSendMessage(nil)
	self:close()
end
return OneKeyFactorizesPanel

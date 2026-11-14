local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampMagicPowerPopPanel = class("MagicLampMagicPowerPopPanel", baseFguiPanel)
function MagicLampMagicPowerPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampMagicPowerPopPanel:ctor", self.viewName)
end
function MagicLampMagicPowerPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampMagicPowerPopPanel:onInit()
	self.isAddToPopManager = true
	print("=======MagicLampMagicPowerPopPanel:onInit")
	self.fields.title:setString(i18n("Magic_draw_text_19"))
	self.fields.Text_tips:setString(i18n("Magic_draw_text_17"))
	self.fields.btn_go:setTitle(i18n("Magic_draw_text_18"))
	self.fields.btn_go:addClickEventListener(handler(self, self.onGoClick))
	self.transitions.t0:play()
end
function MagicLampMagicPowerPopPanel:onShow()
	print("=======MagicLampMagicPowerPopPanel:onShow")
	self:updateView()
end
function MagicLampMagicPowerPopPanel:updateView()
	self.curCfg = self.param.cfg
	self.fields.icon:setURL(self.curCfg.magicPoolView)
end
function MagicLampMagicPowerPopPanel:onGoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).magicPoolID = self.curCfg.magicPoolID
	uiManager:show("MagicLampMaigcPowerMain", nil)
	self:close()
end
return MagicLampMagicPowerPopPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceFirstJoinViewPanel = class("allianceFirstJoinViewPanel", baseFguiPanel)
function allianceFirstJoinViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceFirstJoinViewPanel:ctor", self.viewName)
end
function allianceFirstJoinViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceFirstJoinViewPanel:onInit()
	print("=======allianceFirstJoinViewPanel:onInit")
	_ENV = "=======allianceFirstJoinViewPanel:onInit"
	;("=======allianceFirstJoinViewPanel:onInit").msg = "MESSAGE_MAIN_IPHONEX_UPDATE"
	;("=======allianceFirstJoinViewPanel:onInit").onEnter = true
	SoraDSendMessage("=======allianceFirstJoinViewPanel:onInit")
	self.isHidePrePanel = false
	self.fields.Text_way:setString(i18n("common_text_648"))
	self.fields.Button_join:setString(i18n("common_text_068"))
	self.fields.Button_join:addClickListener(handler(self, self.btnClick))
end
function allianceFirstJoinViewPanel:onShow()
	print("=======allianceFirstJoinViewPanel:onShow")
	self.fields.Usm_bg:setScale(math.max(1, display.height / 1136))
	self.fields.Usm_bg:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_sp:setEffectPath(SoraDFIsRA() and "sp_jrlm_002.usm" or "sp_jrlm_001.usm")
	self.fields.Usm_sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
end
function allianceFirstJoinViewPanel:btnClick()
	SoraDPlaySound()
	self:close()
end
return allianceFirstJoinViewPanel

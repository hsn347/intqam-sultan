local baseFguiPanel = require("fgui.base.baseFguiPanel")
local bulletResultPanel = class("bulletResultPanel", baseFguiPanel)
function bulletResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("bulletResultPanel:ctor", self.viewName)
end
function bulletResultPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function bulletResultPanel:onInit()
	print("=======bulletResultPanel:onInit")
	self.fields.button_1:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_3:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_1:setTitle(i18n("common_text_204"))
	self.fields.button_3:setTitle(i18n("common_text_204"))
	self.fields.button_2:addClickEventListener(handler(self, self.onClickTryAgain))
	self.fields.button_2:setTitle(i18n("common_text_1125"))
end
function bulletResultPanel:onShow()
	print("=======bulletResultPanel:onShow")
	self.isWin = self.proxy.param and self.proxy.param.isWin
	if self.isWin then
		SoraDPlaySound("elimiateGame", 5)
		if display.height > 1136 then
			self.fields.Usm_1:setScale(display.height / 1136)
			self.fields.Usm_2:setScale(display.height / 1136)
			self.fields.Usm_3:setScale(display.height / 1136)
		end
		self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
		self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
		self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
		self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		self.fields.text:setString(i18n("common_text_290"))
	else
		SoraDPlaySound("huntSound", "hunt_lost")
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_1:setEffectPath("sp_sszzsb_001.usm", false)
		self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
		self.fields.text:setString(i18n("shoot_game_text_001"))
	end
	self.controllers.c1:setSelectedIndex(self.isWin and 0 or 1)
end
function bulletResultPanel:closeSelf()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
	;(nil).isWin = self.isWin
	SoraDSendMessage(nil)
	self:close()
end
function bulletResultPanel:onClickTryAgain()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_BULLET_GAME_REPLAY"
	SoraDSendMessage(nil)
	self:close()
end
return bulletResultPanel

local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaTreasureResultPanel = class("NebulaTreasureResultPanel", baseFguiPanel)
local nebulaTreasureCtrl = SoraDGetCtrl("nebulaTreasureCtrl")
function NebulaTreasureResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaTreasureResultPanel:ctor", self.viewName)
end
function NebulaTreasureResultPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaTreasureResultPanel:onInit()
	print("=======NebulaTreasureResultPanel:onInit")
	self.fields.button_1:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_1:setTitle(i18n("common_text_204"))
end
function NebulaTreasureResultPanel:onShow()
	print("=======NebulaTreasureResultPanel:onShow", self.proxy.param.gameType)
	self.isWin = self.proxy.param and self.proxy.param.isWin
	self.gameType = self.proxy.param and self.proxy.param.gameType
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
		self.fields.text:setString(i18n("exitic_pavillion_text_0113"))
		nebulaTreasureCtrl:sendGameWin(self.gameType)
	else
		SoraDPlaySound("huntSound", "hunt_lost")
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_1:setEffectPath("sp_sszzsb_001.usm", false)
		self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
		self.fields.text:setString(i18n("exitic_pavillion_text_0114"))
	end
	self.controllers.c1:setSelectedIndex(self.isWin and 0 or 1)
	local nebulaTreasureCtrl = SoraDGetCtrl("nebulaTreasureCtrl")
end
function NebulaTreasureResultPanel:closeSelf()
	SoraDPlaySound()
	self:close()
end
return NebulaTreasureResultPanel

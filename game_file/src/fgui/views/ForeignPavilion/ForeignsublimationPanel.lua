local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForeignsublimationPanel = class("ForeignsublimationPanel", baseFguiPanel)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
local foreignPavilionRead = include("foreignPavilionRead")
function ForeignsublimationPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = ture
	print("ForeignsublimationPanel:ctor", self.viewName)
end
function ForeignsublimationPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
		self._packageList, self._packageList[2] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function ForeignsublimationPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	self.showType = self.proxy.param.showType
	print("=======ForeignsublimationPanel:onInit")
end
function ForeignsublimationPanel:onShow()
	print("=======ForeignsublimationPanel:onShow")
	local intimacyLv = exoticPavilionCtrl:getCurIntimacyLv()
	local curIntimacyCfg = foreignPavilionRead:getCurIntimacyCfg(intimacyLv)
	self.fields.text_1:setString(i18n(curIntimacyCfg.clothesname))
	self.fields.text_2:setString(i18n(curIntimacyCfg.boxdes))
	self.fields.text_3:setString(i18n(curIntimacyCfg.buffdes[1], curIntimacyCfg.buffdes))
	_ENV = i18n(curIntimacyCfg.buffdes[1], curIntimacyCfg.buffdes)
	i18n(curIntimacyCfg.buffdes[1], curIntimacyCfg.buffdes).var = i18n("exitic_pavillion_text_00" .. 46 + intimacyLv)
	self.fields.text_intimacy:setString(i18n("exitic_pavillion_text_0058", i18n(curIntimacyCfg.buffdes[1], curIntimacyCfg.buffdes)))
	self.controllers.c1:setSelectedIndex(2)
	local oldDressLv = exoticPavilionCtrl:getOldDressLv()
	local curDressLv = exoticPavilionCtrl:getCurDressLv()
	self.fields.role:showInAction(oldDressLv, function()
		if self.showType ~= 0 then
			self.fields.Usm_1:setBlendFunc(gl.ONE, gl.SRC_ALPHA)
			self.fields.Usm_1:setEffectPath("G_ygg_qinmidu.usm", false)
			self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
			self.fields.Usm_2:setEffectPath("ygg_qinmidu.usm", false)
			self.fields.Usm_2:setCompleteCallback(function()
				self.fields.Usm_2:setVisible(false)
			end)
			self:runAction(ffa.seq(ffa.delay(0.2), ffa.callFunc(function()
				self.controllers.c1:setSelectedIndex(1)
			end)))
		end
		self.fields.role:showOutAction(curDressLv, function()
			if self.showType ~= 0 then
				self.controllers.c1:setSelectedIndex(0)
			else
				self.controllers.c1:setSelectedIndex(3)
			end
			self.transitions.closeShow:play()
		end)
	end)
end
function ForeignsublimationPanel:onHide()
	print("=======ForeignsublimationPanel:onHide")
end
function ForeignsublimationPanel:onDispose()
	print("=======ForeignsublimationPanel:onDispose")
end
return ForeignsublimationPanel

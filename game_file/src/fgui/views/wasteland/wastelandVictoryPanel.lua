local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local wastelandVictoryPanel = class("wastelandVictoryPanel", baseFguiPanel)
function wastelandVictoryPanel:ctor(...)
	self.super.ctor(self, ...)
	print("wastelandVictoryPanel:ctor", self.viewName)
end
function wastelandVictoryPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "wasteland"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function wastelandVictoryPanel:onInit()
	print("=======wastelandVictoryPanel:onInit")
	self.fields.Usm_victory:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	_ENV = gl.SRC_ALPHA
	gl.SRC_ALPHA.lv = self.param.level
	local lvStr = i18n("common_text_100", gl.SRC_ALPHA)
	local bossname = wastelandCtrl:getBossConfig(self.param.settingId).name
	_ENV = nil
	;(nil).lv = lvStr
	;(nil).bossname = i18n(bossname)
	self.fields.Text_victory:setString(i18n("wasteland_text_016", nil))
	self:setAutoClose(3.0)
end
function wastelandVictoryPanel:onShow()
	print("=======wastelandVictoryPanel:onShow")
end
function wastelandVictoryPanel:setAutoClose(delay)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(delay)
	;(nil)[2] = ffa.callFunc(function()
		self:close()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:close()
	end)
	self:runAction(ffa.seq(nil))
end
return wastelandVictoryPanel

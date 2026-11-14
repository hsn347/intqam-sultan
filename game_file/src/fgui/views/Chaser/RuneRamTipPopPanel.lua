local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneRamTipPopPanel = class("RuneRamTipPopPanel", baseFguiPanel)
function RuneRamTipPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneRamTipPopPanel:ctor", self.viewName)
end
function RuneRamTipPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneRamTipPopPanel:onInit()
	print("=======RuneRamTipPopPanel:onInit")
	self.fields.bg:setString(i18n("Weapon_Rune_tips_050"))
	self.fields.Text_tip:setString(i18n("Weapon_Rune_tips_067"))
end
function RuneRamTipPopPanel:onShow()
	print("=======RuneRamTipPopPanel:onShow")
	local runeInfo = artifactRuneRead.getRuneInfo(self.param.rid)
	local pool = runeInfo.RemakePool[1]
	local buffStr = artifactRuneRead.getMayRandomBuff(pool)
	self.fields.Text_skillDes:setString(buffStr)
end
return RuneRamTipPopPanel

local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTempleCrownHelpPanel = class("HeroTempleCrownHelpPanel", baseFguiPanel)
function HeroTempleCrownHelpPanel:ctor(...)
	HeroTempleCrownHelpPanel.super.ctor(self, ...)
	print("HeroTempleCrownHelpPanel:ctor", self.viewName)
end
function HeroTempleCrownHelpPanel:onInit()
	print("=======HeroTempleCrownHelpPanel:onInit")
	self.fields.Panel_bg:setString(i18n("hero_palace_text_05"))
	self.fields.Lab_title:setString(i18n("hero_palace_text_06"))
	self.fields.Text_tip:setString(i18n("hero_palace_text_10"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function HeroTempleCrownHelpPanel:onShow()
	print("=======HeroTempleCrownHelpPanel:onShow")
	_ENV = print
	_ENV = nil
	;(nil).quality = heroltCtrl.getQuality2Des(constantRead.getConstValue("HERO_PALACE_HERO_QUALITY_DEMAND"))
	print[1] = i18n("hero_palace_text_07", nil)
	_ENV = nil
	;(nil).lv = constantRead.getConstValue("HERO_PALACE_HERO_LEVEL_DEMAND")
	print[2] = i18n("hero_palace_text_08", nil)
	_ENV = nil
	;(nil).num = constantRead.getConstValue("HERO_PALACE_HERO_STUNTSKILL_NUMBERS_DEMAND")
	;(nil).percent = constantRead.getConstValue("HERO_PALACE_HERO_STUNTSKILL_DEMAND") / 10
	self.conditionStr, print[3] = print, i18n("hero_palace_text_09", nil)
	self.fields.List:setNumItems(#self.conditionStr)
end
function HeroTempleCrownHelpPanel:onItemRenderer(index, obj)
	obj:setTitle(self.conditionStr[index + 1])
end
return HeroTempleCrownHelpPanel

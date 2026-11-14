local baseComponent = require("fgui.base.baseComponent")
local Com_Recover = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://KingdomBattle/Com_Recover", Com_Recover)
function Com_Recover:onInit()
	_ENV = nil
	;(nil).num = ""
	self.fields.Text_recover:setString(i18n("conquestwar_text_83", nil))
	self.fields.Text_tip:setString(i18n("conquestwar_text_84"))
	self.fields.Btn_go:setString(i18n("conquestwar_text_85"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Btn_detail:addClickListener(handler(self, self.btnDetailClick))
	self.fields.Btn_detail:fixPos()
end
function Com_Recover:onShow()
end
function Com_Recover:initData(isKingdomRecovered, isRecovering, kingdomRecoverScore, kingNumForward)
	self.kingNumForward = kingNumForward
	self.controllers.c1:setSelectedIndex(isKingdomRecovered and 1 or 0)
	self.fields.Text_status:setString(isKingdomRecovered and i18n("conquestwar_text_86") or i18n("conquestwar_text_82"))
	self.fields.Text_val:setString(kingdomRecoverScore)
end
function Com_Recover:btnGoClick()
	SoraDPlaySound()
	local toKid = SoraDGetCtrl("lordInfoCtrl"):isInSelfKid() and self.kingNumForward or SoraDGetKid()
	if SoraDGetCtrl("conquestWarCtrl"):isTriggerReinforcements() then
		toKid = self.kingNumForward
	end
	SoraDGotoWorldMapPoint(cc.p(600, 600), true, toKid)
	SoraDRemoveAllPanelFromManager()
end
function Com_Recover:btnDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("conquestwar_text_87")
	;(nil).content = i18n("conquestwar_text_88")
	uiManager:show("RuleView", nil)
end
return Com_Recover

local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local btn_chooes = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceCreateView/btn_chooes", btn_chooes)
function btn_chooes:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function btn_chooes:onShow()
end
function btn_chooes:initData(lid, ownLanguage)
	self.languageID = lid
	self.fields.title:setString(allianceDesRead.getLanguageName(self.languageID))
	self.fields.Check_tick:setSelected(ownLanguage and ownLanguage == lid or false)
end
function btn_chooes:btnClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_SELECT_LANGUAGE"
	;(nil).lid = self.languageID
	SoraDSendMessage(nil)
end
return btn_chooes

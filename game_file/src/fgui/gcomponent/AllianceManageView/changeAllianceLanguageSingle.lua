local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local changeAllianceLanguageSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeAllianceLanguageSingle", changeAllianceLanguageSingle)
function changeAllianceLanguageSingle:onInit()
	self.fields.Check_tick:addClickListener(handler(self, self.btnClick))
end
function changeAllianceLanguageSingle:onShow()
end
function changeAllianceLanguageSingle:initData(langEnum, ownLanguage)
	self.languageID = langEnum
	self.ownLanguage = ownLanguage
	self.fields.title:setString(allianceDesRead.getLanguageName(self.languageID))
	self.fields.Check_tick:setSelected(self.languageID == self.ownLanguage)
end
function changeAllianceLanguageSingle:btnClick()
	SoraDPlaySound()
	if self.languageID == self.ownLanguage then
		self.fields.Check_tick:setSelected(true)
	else
		_ENV = self.fields.Check_tick
		self.fields.Check_tick.msg = "MESSAGE_ALLIANCE_UI_MANAGER_SETTING_LANGUAGE_SELECT"
		self.fields.Check_tick.languageID = self.languageID
		SoraDSendMessage(self.fields.Check_tick)
	end
end
return changeAllianceLanguageSingle

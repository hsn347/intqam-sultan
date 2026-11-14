local baseProxy = require("fgui.base.baseProxy")
local allianceSettingsViewProxy = class("allianceSettingsViewProxy", baseProxy)
function allianceSettingsViewProxy:onRegisterEvent()
	print("=======allianceSettingsViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_MANAGER_SETTING_SELECT", handler(self, self.settingMenuSetBack))
end
function allianceSettingsViewProxy:settingMenuSetBack(target, data)
	self.view:settingMenuSetBack(target, data)
end
return allianceSettingsViewProxy

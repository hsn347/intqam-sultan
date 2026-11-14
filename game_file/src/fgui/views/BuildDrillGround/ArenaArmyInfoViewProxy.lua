local baseProxy = require("fgui.base.baseProxy")
local ArenaArmyInfoViewProxy = class("ArenaArmyInfoViewProxy", baseProxy)
function ArenaArmyInfoViewProxy:onRegisterEvent()
	print("=======ArenaArmyInfoViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_ATTRIBUTE", handler(self.view, self.view.initAttributeData))
end
return ArenaArmyInfoViewProxy

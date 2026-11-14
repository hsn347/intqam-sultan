local baseProxy = require("fgui.base.baseProxy")
local legendaryKingCommanderProxy = class("legendaryKingCommanderProxy", baseProxy)
function legendaryKingCommanderProxy:onRegisterEvent()
	print("=======legendaryKingCommanderProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_LEGEND_TEAM_MY_INFO", handler(self, self.initView))
end
function legendaryKingCommanderProxy:initView()
	self.view:initView()
end
return legendaryKingCommanderProxy

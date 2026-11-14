local baseProxy = require("fgui.base.baseProxy")
local WorldDispatchArmyViewProxy = class("WorldDispatchArmyViewProxy", baseProxy)
function WorldDispatchArmyViewProxy:onRegisterEvent()
	print("=======WorldDispatchArmyViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ARMY_TEAMORGANIZE_BACKDATA", handler(self, self.adaptTeam))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", function(target, data)
		if data.data and data.data.effectType == 19 then
			self.view:updateExpArmyCountRet()
			self.view:updateCountLabel()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ARMY_SELECT_TYPE", handler(self, self.selectArmyType))
end
function WorldDispatchArmyViewProxy:adaptTeam(...)
	self.view:adaptTeam(...)
end
function WorldDispatchArmyViewProxy:selectArmyType(...)
	self.view:selectArmyType(...)
end
function WorldDispatchArmyViewProxy:initData(...)
	self.view:initData(...)
end
return WorldDispatchArmyViewProxy

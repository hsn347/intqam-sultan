local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleSearchProxy = class("kingdomBattleSearchProxy", baseProxy)
function kingdomBattleSearchProxy:onRegisterEvent()
	print("=======kingdomBattleSearchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.onSearchBack))
	SoraDAddMessage(self, "MESSAGE_CONQUESTWAR_REINFORCEMENTS", handler(self, self.onNameSearchBack))
end
function kingdomBattleSearchProxy:onSearchBack(taregt, data)
	self.view:updateList(data.data.uinfolist)
end
function kingdomBattleSearchProxy:onNameSearchBack(taregt, data)
	if data.userList then
		self.view:updateList(data.userList)
	end
end
return kingdomBattleSearchProxy

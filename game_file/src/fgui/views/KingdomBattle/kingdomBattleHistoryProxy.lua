local baseProxy = require("fgui.base.baseProxy")
local kingdomBattleHistoryProxy = class("kingdomBattleHistoryProxy", baseProxy)
function kingdomBattleHistoryProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_HISTORY", handler(self, self.onReqInitBack))
end
function kingdomBattleHistoryProxy:onReqInitBack(target, redata)
	SoraDCloseLoading()
	dump(redata, "kingdomBattleHistoryProxy")
	if redata and redata.data then
		local _ENV, reTbl = redata.data, redata.data
		local totalSize = #redata.data
		for i = 1, totalSize do
			table.insert(reTbl, redata.data[totalSize - i + 1])
		end
		self.view:initScroll(reTbl)
	end
end
return kingdomBattleHistoryProxy

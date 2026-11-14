local baseProxy = require("fgui.base.baseProxy")
local AllianceJoinViewProxy = class("AllianceJoinViewProxy", baseProxy)
function AllianceJoinViewProxy:onRegisterEvent()
	print("=======AllianceJoinViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_ALLIANCE_LIST_SUCCESS", handler(self.view, self.view.refreshAllianceList))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SEARCH_ALLIANCE_LIST_SUCCESS", handler(self.view, self.view.refreshSearchList))
end
return AllianceJoinViewProxy

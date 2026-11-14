local baseProxy = require("fgui.base.baseProxy")
local ShelterSearchProxy = class("ShelterSearchProxy", baseProxy)
function ShelterSearchProxy:onRegisterEvent()
	print("=======ShelterSearchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.updateSearchList))
end
function ShelterSearchProxy:updateSearchList(target, data)
	self.view:updateSearchList(target, data)
end
return ShelterSearchProxy

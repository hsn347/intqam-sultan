local baseProxy = require("fgui.base.baseProxy")
local HeroJailShareProxy = class("HeroJailShareProxy", baseProxy)
function HeroJailShareProxy:onRegisterEvent()
	print("=======HeroJailShareProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_REQ_ALL_CHAT_ROOM_INFO", function(target, data)
		SoraDGetCtrl("contactCtrl"):reqGetData(true, false, false)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.msgCallBack))
end
function HeroJailShareProxy:msgCallBack(target, data)
	SoraDCloseLoading(self.view)
	self.view:sortData()
	self.view:initScroll()
end
return HeroJailShareProxy

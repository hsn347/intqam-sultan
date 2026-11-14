local baseProxy = require("fgui.base.baseProxy")
local defendViewProxy = class("defendViewProxy", baseProxy)
function defendViewProxy:onRegisterEvent()
	print("=======defendViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WALLS_NOTIFY_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_WALLS_NOTIFY_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEDEFEND", handler(self, self.defendHerosChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_SETSINGLEDENFEND", handler(self, self.defendSetSuccessCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_SETLISTDENFEND", handler(self, self.defendSetSuccessCallBack))
	SoraDAddMessage(self, "MESSAGE_WALLS_DEFEND_COMPILE_UPDATE", handler(self, self.onMsgUpdateTeam))
	SoraDAddMessage(self, "MESSAGE_UI_CITYWALL_TEAM_SELECT", handler(self, self.treamSelect))
end
function defendViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function defendViewProxy:defendHerosChange(target, data)
	self.view:defendHerosChange()
end
function defendViewProxy:defendSetSuccessCallBack(target, data)
	self.view:defendSetSuccessCallBack()
end
function defendViewProxy:onMsgUpdateTeam(target, event)
	if event.subMsg == "compileName" then
		self.view:setTream()
	else
		self.view:updateTream()
	end
end
function defendViewProxy:treamSelect(target, data)
	self.view:treamSelect(target, data)
end
return defendViewProxy

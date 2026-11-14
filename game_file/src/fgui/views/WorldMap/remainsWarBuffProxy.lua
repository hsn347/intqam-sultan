local baseProxy = require("fgui.base.baseProxy")
local remainsWarBuffProxy = class("remainsWarBuffProxy", baseProxy)
function remainsWarBuffProxy:onRegisterEvent()
	print("=======remainsWarBuffProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_TEAM_BUFF_LIST", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_PLAYER_BUFF_LIST", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ROME_ATTACK_BACK", handler(self, self.rspRomeAttackBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BUFF_LIST", handler(self, self.initBuff))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BUFF_REFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_UI_OPEN", handler(self, self.switchList))
end
function remainsWarBuffProxy:initView(target, data)
	self.view:initView(target, data)
end
function remainsWarBuffProxy:initBuff(target, data)
	self.view:initBuff(target, data)
end
function remainsWarBuffProxy:rspRomeAttackBack(target, data)
	self.view:rspRomeAttackBack(target, data)
end
function remainsWarBuffProxy:switchList(target, data)
	self.view:switchList(target, data)
end
return remainsWarBuffProxy

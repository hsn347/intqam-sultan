local baseProxy = require("fgui.base.baseProxy")
local ReinforcementsMsgBoxProxy = class("ReinforcementsMsgBoxProxy", baseProxy)
function ReinforcementsMsgBoxProxy:onRegisterEvent()
	print("=======ReinforcementsMsgBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_ARMYHELP_REQDATA", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_ISBETRAYBYUID", handler(self, self.isBetrayBack))
end
function ReinforcementsMsgBoxProxy:initView(...)
	self.view:initView(...)
end
function ReinforcementsMsgBoxProxy:isBetrayBack(...)
	self.view:isBetrayBack(...)
end
return ReinforcementsMsgBoxProxy

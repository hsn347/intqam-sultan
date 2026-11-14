local baseProxy = require("fgui.base.baseProxy")
local SoldierRushHookProxy = class("SoldierRushHookProxy", baseProxy)
function SoldierRushHookProxy:onRegisterEvent()
	print("=======SoldierRushHookProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_AFK_UPDATE", handler(self, self.updateHook))
end
function SoldierRushHookProxy:updateHook(target, data)
	self.view:initData(target, data)
end
return SoldierRushHookProxy

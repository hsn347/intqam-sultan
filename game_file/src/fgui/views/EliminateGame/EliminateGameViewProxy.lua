local baseProxy = require("fgui.base.baseProxy")
local EliminateGameViewProxy = class("EliminateGameViewProxy", baseProxy)
function EliminateGameViewProxy:onRegisterEvent()
	print("=======EliminateGameViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_KO", handler(self, self.onKO))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_DOUBLE", handler(self, self.onDoubleBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_STEP", handler(self, self.onStepBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_HURT", handler(self, self.onHurtBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_OLD_DAMAGE", handler(self, self.onOldDamageBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_USESTEP", handler(self, self.onUseStepBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_ELIMINATEGAME_CLOSE", handler(self, self.onCloseActivity))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.onNewDay))
end
function EliminateGameViewProxy:onKO(...)
	self.view:onKO(...)
end
function EliminateGameViewProxy:onDoubleBack(...)
	self.view:onDoubleBack(...)
end
function EliminateGameViewProxy:onStepBack(...)
	self.view:onStepBack(...)
end
function EliminateGameViewProxy:onHurtBack(...)
	self.view:onHurtBack(...)
end
function EliminateGameViewProxy:onOldDamageBack(...)
	self.view:onOldDamageBack(...)
end
function EliminateGameViewProxy:onOldDamageBack(...)
	self.view:onOldDamageBack(...)
end
function EliminateGameViewProxy:onUseStepBack(...)
	self.view:onUseStepBack(...)
end
function EliminateGameViewProxy:onUseStepBack(...)
	self.view:onUseStepBack(...)
end
function EliminateGameViewProxy:onNewDay(...)
	self.view:updateFreeTip()
end
function EliminateGameViewProxy:onCloseActivity(target, data)
	SoraDRemoveAllPanelFromManager()
	SoraDShowMsgTip(i18n("common_text_1859"))
end
return EliminateGameViewProxy

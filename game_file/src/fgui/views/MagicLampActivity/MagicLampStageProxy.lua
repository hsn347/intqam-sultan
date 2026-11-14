local baseProxy = require("fgui.base.baseProxy")
local MagicLampStageProxy = class("MagicLampStageProxy", baseProxy)
function MagicLampStageProxy:onRegisterEvent()
	print("=======MagicLampStageProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_SCORE_REWARD_UPDATE", handler(self.view, self.view.onMsgUpdateView))
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_SCORE_UPDATE", handler(self.view, self.view.onMsgUpdateScore))
end
return MagicLampStageProxy

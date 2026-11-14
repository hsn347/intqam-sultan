local baseProxy = require("fgui.base.baseProxy")
local ForeignPVictoryProxy = class("ForeignPVictoryProxy", baseProxy)
function ForeignPVictoryProxy:onRegisterEvent()
	print("=======ForeignPVictoryProxy:onRegisterEvent")
end
function ForeignPVictoryProxy:onRemoveView(view)
	_ENV = nil
	;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
	;(nil).isWin = true
	;(nil).isInStory = true
	SoraDSendMessage(nil)
end
return ForeignPVictoryProxy

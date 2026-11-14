local baseProxy = require("fgui.base.baseProxy")
local ForeignPsettlementProxy = class("ForeignPsettlementProxy", baseProxy)
function ForeignPsettlementProxy:onRegisterEvent()
	print("=======ForeignPsettlementProxy:onRegisterEvent")
end
function ForeignPsettlementProxy:onRemoveView(view)
	_ENV = nil
	;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
	;(nil).isWin = view.isWin
	;(nil).gameType = view.gameType
	;(nil).isInStory = view.isInStory
	SoraDSendMessage(nil)
end
return ForeignPsettlementProxy

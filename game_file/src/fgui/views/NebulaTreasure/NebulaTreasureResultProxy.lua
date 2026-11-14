local baseProxy = require("fgui.base.baseProxy")
local NebulaTreasureResultProxy = class("NebulaTreasureResultProxy", baseProxy)
function NebulaTreasureResultProxy:onRegisterEvent()
	print("=======NebulaTreasureResultProxy:onRegisterEvent")
end
function NebulaTreasureResultProxy:onRemoveView(view)
	_ENV = nil
	;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
	;(nil).isWin = view.isWin
	SoraDSendMessage(nil)
end
return NebulaTreasureResultProxy

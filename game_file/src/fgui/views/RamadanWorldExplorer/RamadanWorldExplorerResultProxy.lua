local baseProxy = require("fgui.base.baseProxy")
local RamadanWorldExplorerResultProxy = class("RamadanWorldExplorerResultProxy", baseProxy)
function RamadanWorldExplorerResultProxy:onRegisterEvent()
	print("=======RamadanWorldExplorerResultProxy:onRegisterEvent")
end
function RamadanWorldExplorerResultProxy:onRemoveView(view)
	_ENV = nil
	;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
	;(nil).isWin = view.isWin
	;(nil).gameType = view.gameType
	SoraDSendMessage(nil)
end
return RamadanWorldExplorerResultProxy

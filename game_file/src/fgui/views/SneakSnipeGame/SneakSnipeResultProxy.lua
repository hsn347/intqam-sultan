local baseProxy = require("fgui.base.baseProxy")
local SneakSnipeResultProxy = class("SneakSnipeResultProxy", baseProxy)
function SneakSnipeResultProxy:onRegisterEvent()
	print("=======SneakSnipeResultProxy:onRegisterEvent")
end
function SneakSnipeResultProxy:onRemoveView(view)
	_ENV = nil
	;(nil).msg = "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE"
	;(nil).isWin = view.isWin
	SoraDSendMessage(nil)
end
return SneakSnipeResultProxy

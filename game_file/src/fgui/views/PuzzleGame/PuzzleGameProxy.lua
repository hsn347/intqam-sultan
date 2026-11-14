local baseProxy = require("fgui.base.baseProxy")
local PuzzleGameProxy = class("PuzzleGameProxy", baseProxy)
function PuzzleGameProxy:onRegisterEvent()
	print("=======PuzzleGameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
end
function PuzzleGameProxy:onResultClose()
	self.view:close()
end
return PuzzleGameProxy

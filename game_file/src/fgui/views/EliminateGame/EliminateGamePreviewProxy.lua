local baseProxy = require("fgui.base.baseProxy")
local EliminateGamePreviewProxy = class("EliminateGamePreviewProxy", baseProxy)
function EliminateGamePreviewProxy:onRegisterEvent()
	print("=======EliminateGamePreviewProxy:onRegisterEvent")
end
return EliminateGamePreviewProxy

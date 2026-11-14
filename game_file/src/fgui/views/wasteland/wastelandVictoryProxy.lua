local baseProxy = require("fgui.base.baseProxy")
local wastelandVictoryProxy = class("wastelandVictoryProxy", baseProxy)
function wastelandVictoryProxy:onRegisterEvent()
	print("=======wastelandVictoryProxy:onRegisterEvent")
end
return wastelandVictoryProxy

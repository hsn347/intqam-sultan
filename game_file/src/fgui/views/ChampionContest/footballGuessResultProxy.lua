local baseProxy = require("fgui.base.baseProxy")
local footballGuessResultProxy = class("footballGuessResultProxy", baseProxy)
function footballGuessResultProxy:onRegisterEvent()
	print("=======footballGuessResultProxy:onRegisterEvent")
end
return footballGuessResultProxy

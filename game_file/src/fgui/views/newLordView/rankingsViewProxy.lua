local baseProxy = require("fgui.base.baseProxy")
local rankingsViewProxy = class("rankingsViewProxy", baseProxy)
function rankingsViewProxy:onRegisterEvent()
	print("=======rankingsViewProxy:onRegisterEvent")
end
return rankingsViewProxy

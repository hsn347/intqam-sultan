local baseProxy = require("fgui.base.baseProxy")
local dissolveSoldiersViewProxy = class("dissolveSoldiersViewProxy", baseProxy)
function dissolveSoldiersViewProxy:onRegisterEvent()
	print("=======dissolveSoldiersViewProxy:onRegisterEvent")
end
return dissolveSoldiersViewProxy

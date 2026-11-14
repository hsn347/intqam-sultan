local baseProxy = require("fgui.base.baseProxy")
local EliminateFreeViewProxy = class("EliminateFreeViewProxy", baseProxy)
function EliminateFreeViewProxy:onRegisterEvent()
	print("=======EliminateFreeViewProxy:onRegisterEvent")
end
return EliminateFreeViewProxy

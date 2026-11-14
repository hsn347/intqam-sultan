local baseProxy = require("fgui.base.baseProxy")
local angerDetailViewProxy = class("angerDetailViewProxy", baseProxy)
function angerDetailViewProxy:onRegisterEvent()
	print("=======angerDetailViewProxy:onRegisterEvent")
end
return angerDetailViewProxy

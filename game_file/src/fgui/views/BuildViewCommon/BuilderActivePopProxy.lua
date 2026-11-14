local baseProxy = require("fgui.base.baseProxy")
local BuilderActivePopProxy = class("BuilderActivePopProxy", baseProxy)
function BuilderActivePopProxy:onRegisterEvent()
	print("=======BuilderActivePopProxy:onRegisterEvent")
end
return BuilderActivePopProxy

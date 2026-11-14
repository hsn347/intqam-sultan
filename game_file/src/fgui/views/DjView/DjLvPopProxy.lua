local baseProxy = require("fgui.base.baseProxy")
local DjLvPopProxy = class("DjLvPopProxy", baseProxy)
function DjLvPopProxy:onRegisterEvent()
	print("=======DjLvPopProxy:onRegisterEvent")
end
return DjLvPopProxy

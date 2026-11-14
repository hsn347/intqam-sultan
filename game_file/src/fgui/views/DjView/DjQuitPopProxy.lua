local baseProxy = require("fgui.base.baseProxy")
local DjQuitPopProxy = class("DjQuitPopProxy", baseProxy)
function DjQuitPopProxy:onRegisterEvent()
	print("=======DjQuitPopProxy:onRegisterEvent")
end
return DjQuitPopProxy

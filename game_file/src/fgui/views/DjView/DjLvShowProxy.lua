local baseProxy = require("fgui.base.baseProxy")
local DjLvShowProxy = class("DjLvShowProxy", baseProxy)
function DjLvShowProxy:onRegisterEvent()
	print("=======DjLvShowProxy:onRegisterEvent")
end
return DjLvShowProxy

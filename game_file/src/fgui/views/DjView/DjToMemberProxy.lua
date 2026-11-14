local baseProxy = require("fgui.base.baseProxy")
local DjToMemberProxy = class("DjToMemberProxy", baseProxy)
function DjToMemberProxy:onRegisterEvent()
	print("=======DjToMemberProxy:onRegisterEvent")
end
return DjToMemberProxy

local baseProxy = require("fgui.base.baseProxy")
local bulletUsmPopProxy = class("bulletUsmPopProxy", baseProxy)
function bulletUsmPopProxy:onRegisterEvent()
	print("=======bulletUsmPopProxy:onRegisterEvent")
end
return bulletUsmPopProxy

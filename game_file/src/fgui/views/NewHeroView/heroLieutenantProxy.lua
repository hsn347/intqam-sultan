local baseProxy = require("fgui.base.baseProxy")
local heroLieutenantProxy = class("heroLieutenantProxy", baseProxy)
function heroLieutenantProxy:onRegisterEvent()
	print("=======heroLieutenantProxy:onRegisterEvent")
end
return heroLieutenantProxy

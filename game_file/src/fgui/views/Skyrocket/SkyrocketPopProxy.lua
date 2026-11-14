local baseProxy = require("fgui.base.baseProxy")
local SkyrocketPopProxy = class("SkyrocketPopProxy", baseProxy)
function SkyrocketPopProxy:onRegisterEvent()
	print("=======SkyrocketPopProxy:onRegisterEvent")
end
return SkyrocketPopProxy

local baseProxy = require("fgui.base.baseProxy")
local RuneRenamePopProxy = class("RuneRenamePopProxy", baseProxy)
function RuneRenamePopProxy:onRegisterEvent()
	print("=======RuneRenamePopProxy:onRegisterEvent")
end
return RuneRenamePopProxy

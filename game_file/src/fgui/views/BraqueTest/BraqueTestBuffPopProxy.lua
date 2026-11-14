local baseProxy = require("fgui.base.baseProxy")
local BraqueTestBuffPopProxy = class("BraqueTestBuffPopProxy", baseProxy)
function BraqueTestBuffPopProxy:onRegisterEvent()
	print("=======BraqueTestBuffPopProxy:onRegisterEvent")
end
return BraqueTestBuffPopProxy

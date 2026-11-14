local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeBuffPopProxy = class("RadiantDecreeBuffPopProxy", baseProxy)
function RadiantDecreeBuffPopProxy:onRegisterEvent()
	print("=======RadiantDecreeBuffPopProxy:onRegisterEvent")
end
return RadiantDecreeBuffPopProxy

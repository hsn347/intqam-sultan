local baseProxy = require("fgui.base.baseProxy")
local legendarySearchViewProxy = class("legendarySearchViewProxy", baseProxy)
function legendarySearchViewProxy:onRegisterEvent()
	print("=======legendarySearchViewProxy:onRegisterEvent")
end
return legendarySearchViewProxy

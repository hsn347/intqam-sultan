local baseProxy = require("fgui.base.baseProxy")
local MythicalCreaturesStarProxy = class("MythicalCreaturesStarProxy", baseProxy)
function MythicalCreaturesStarProxy:onRegisterEvent()
	print("=======MythicalCreaturesStarProxy:onRegisterEvent")
end
return MythicalCreaturesStarProxy

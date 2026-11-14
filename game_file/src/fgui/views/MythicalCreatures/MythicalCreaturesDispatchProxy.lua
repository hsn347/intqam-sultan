local baseProxy = require("fgui.base.baseProxy")
local MythicalCreaturesDispatchProxy = class("MythicalCreaturesDispatchProxy", baseProxy)
function MythicalCreaturesDispatchProxy:onRegisterEvent()
	print("=======MythicalCreaturesDispatchProxy:onRegisterEvent")
end
return MythicalCreaturesDispatchProxy

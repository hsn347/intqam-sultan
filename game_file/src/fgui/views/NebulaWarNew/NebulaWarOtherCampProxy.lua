local baseProxy = require("fgui.base.baseProxy")
local NebulaWarOtherCampProxy = class("NebulaWarOtherCampProxy", baseProxy)
function NebulaWarOtherCampProxy:onRegisterEvent()
	print("=======NebulaWarOtherCampProxy:onRegisterEvent")
end
return NebulaWarOtherCampProxy

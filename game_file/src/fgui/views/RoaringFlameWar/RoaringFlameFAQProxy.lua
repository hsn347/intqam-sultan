local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameFAQProxy = class("RoaringFlameFAQProxy", baseProxy)
function RoaringFlameFAQProxy:onRegisterEvent()
	print("=======RoaringFlameFAQProxy:onRegisterEvent")
end
return RoaringFlameFAQProxy

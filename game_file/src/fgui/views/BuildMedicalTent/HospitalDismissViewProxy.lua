local baseProxy = require("fgui.base.baseProxy")
local HospitalDismissViewProxy = class("HospitalDismissViewProxy", baseProxy)
function HospitalDismissViewProxy:onRegisterEvent()
	print("=======HospitalDismissViewProxy:onRegisterEvent")
end
function HospitalDismissViewProxy:initData(...)
	self.view:initData(...)
end
function HospitalDismissViewProxy:setTitle(...)
	self.view:setTitle(...)
end
return HospitalDismissViewProxy

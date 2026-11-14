local baseProxy = require("fgui.base.baseProxy")
local militaryMarshalSettingViewProxy = class("militaryMarshalSettingViewProxy", baseProxy)
function militaryMarshalSettingViewProxy:onRegisterEvent()
	print("=======militaryMarshalSettingViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_UPDATE", handler(self, self.initView))
end
function militaryMarshalSettingViewProxy:initView(target, data)
	self.view:initView(target, data)
end
return militaryMarshalSettingViewProxy

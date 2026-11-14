local baseProxy = require("fgui.base.baseProxy")
local evilPalaceRecordViewProxy = class("evilPalaceRecordViewProxy", baseProxy)
function evilPalaceRecordViewProxy:onRegisterEvent()
	print("=======evilPalaceRecordViewProxy:onRegisterEvent")
end
return evilPalaceRecordViewProxy

local baseProxy = require("fgui.base.baseProxy")
local angerRecordViewProxy = class("angerRecordViewProxy", baseProxy)
function angerRecordViewProxy:onRegisterEvent()
	print("=======angerRecordViewProxy:onRegisterEvent")
end
return angerRecordViewProxy

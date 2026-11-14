local baseProxy = require("fgui.base.baseProxy")
local castleChangeSettingViewProxy = class("castleChangeSettingViewProxy", baseProxy)
function castleChangeSettingViewProxy:onRegisterEvent()
	print("=======castleChangeSettingViewProxy:onRegisterEvent")
end
return castleChangeSettingViewProxy

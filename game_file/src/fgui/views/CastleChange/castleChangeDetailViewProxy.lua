local baseProxy = require("fgui.base.baseProxy")
local castleChangeDetailViewProxy = class("castleChangeDetailViewProxy", baseProxy)
function castleChangeDetailViewProxy:onRegisterEvent()
	print("=======castleChangeDetailViewProxy:onRegisterEvent")
end
return castleChangeDetailViewProxy

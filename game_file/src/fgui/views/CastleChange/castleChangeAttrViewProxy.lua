local baseProxy = require("fgui.base.baseProxy")
local castleChangeAttrViewProxy = class("castleChangeAttrViewProxy", baseProxy)
function castleChangeAttrViewProxy:onRegisterEvent()
	print("=======castleChangeAttrViewProxy:onRegisterEvent")
end
return castleChangeAttrViewProxy

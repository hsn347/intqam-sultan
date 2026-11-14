local baseProxy = require("fgui.base.baseProxy")
local ManorBuffPandectProxy = class("ManorBuffPandectProxy", baseProxy)
function ManorBuffPandectProxy:onRegisterEvent()
	print("=======ManorBuffPandectProxy:onRegisterEvent")
end
return ManorBuffPandectProxy

local baseProxy = require("fgui.base.baseProxy")
local DesertMeteoriteStartProxy = class("DesertMeteoriteStartProxy", baseProxy)
function DesertMeteoriteStartProxy:onRegisterEvent()
	print("=======DesertMeteoriteStartProxy:onRegisterEvent")
end
return DesertMeteoriteStartProxy

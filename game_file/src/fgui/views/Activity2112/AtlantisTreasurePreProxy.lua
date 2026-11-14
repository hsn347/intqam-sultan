local baseProxy = require("fgui.base.baseProxy")
local AtlantisTreasurePreProxy = class("AtlantisTreasurePreProxy", baseProxy)
function AtlantisTreasurePreProxy:onRegisterEvent()
	print("=======AtlantisTreasurePreProxy:onRegisterEvent")
end
return AtlantisTreasurePreProxy

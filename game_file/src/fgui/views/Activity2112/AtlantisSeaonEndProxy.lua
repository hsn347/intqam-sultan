local baseProxy = require("fgui.base.baseProxy")
local AtlantisSeaonEndProxy = class("AtlantisSeaonEndProxy", baseProxy)
function AtlantisSeaonEndProxy:onRegisterEvent()
	print("=======AtlantisSeaonEndProxy:onRegisterEvent")
end
return AtlantisSeaonEndProxy

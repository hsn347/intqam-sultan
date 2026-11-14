local baseProxy = require("fgui.base.baseProxy")
local BanquetTypeViewProxy = class("BanquetTypeViewProxy", baseProxy)
function BanquetTypeViewProxy:onRegisterEvent()
	print("=======BanquetTypeViewProxy:onRegisterEvent")
end
return BanquetTypeViewProxy

local baseProxy = require("fgui.base.baseProxy")
local WorldMapSignRenameProxy = class("WorldMapSignRenameProxy", baseProxy)
function WorldMapSignRenameProxy:onRegisterEvent()
	print("=======WorldMapSignRenameProxy:onRegisterEvent")
end
return WorldMapSignRenameProxy

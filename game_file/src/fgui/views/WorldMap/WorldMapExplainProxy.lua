local baseProxy = require("fgui.base.baseProxy")
local WorldMapExplainProxy = class("WorldMapExplainProxy", baseProxy)
function WorldMapExplainProxy:onRegisterEvent()
	print("=======WorldMapExplainProxy:onRegisterEvent")
end
return WorldMapExplainProxy

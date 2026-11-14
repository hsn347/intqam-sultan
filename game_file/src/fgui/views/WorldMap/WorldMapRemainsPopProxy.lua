local baseProxy = require("fgui.base.baseProxy")
local WorldMapRemainsPopProxy = class("WorldMapRemainsPopProxy", baseProxy)
function WorldMapRemainsPopProxy:onRegisterEvent()
	print("=======WorldMapRemainsPopProxy:onRegisterEvent")
end
return WorldMapRemainsPopProxy

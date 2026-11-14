local baseProxy = require("fgui.base.baseProxy")
local WorldMapEmojiSealProxy = class("WorldMapEmojiSealProxy", baseProxy)
function WorldMapEmojiSealProxy:onRegisterEvent()
	print("=======WorldMapEmojiSealProxy:onRegisterEvent")
end
return WorldMapEmojiSealProxy

local baseProxy = require("fgui.base.baseProxy")
local VideoPlayerProxy = class("VideoPlayerProxy", baseProxy)
function VideoPlayerProxy:onRegisterEvent()
	print("=======VideoPlayerProxy:onRegisterEvent")
end
return VideoPlayerProxy

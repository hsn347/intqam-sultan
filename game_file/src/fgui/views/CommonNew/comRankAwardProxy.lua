local baseProxy = require("fgui.base.baseProxy")
local comRankAwardProxy = class("comRankAwardProxy", baseProxy)
function comRankAwardProxy:onRegisterEvent()
	print("=======comRankAwardProxy:onRegisterEvent")
end
return comRankAwardProxy

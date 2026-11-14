local baseProxy = require("fgui.base.baseProxy")
local kingdomRankingsViewProxy = class("kingdomRankingsViewProxy", baseProxy)
function kingdomRankingsViewProxy:onRegisterEvent()
	print("=======kingdomRankingsViewProxy:onRegisterEvent")
end
return kingdomRankingsViewProxy
